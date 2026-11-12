#!/usr/bin/env python3
"""Bounded structural inventory of E32 candidates extracted from N95 ROFS/ROFx.

This reads only the extracted local files produced by Step108. It never writes
back to firmware images and emits text metadata only.
"""
from __future__ import annotations

import argparse
import csv
import hashlib
import json
import struct
from collections import Counter
from pathlib import Path

DLL_UID = 0x10000079
EXE_UID = 0x1000007A
MAX_EXPORTS = 131072
MAX_DLL_REFS = 4096
MAX_IMPORTS = 1_000_000


def u32(data: bytes, off: int) -> int:
    if off < 0 or off + 4 > len(data):
        raise ValueError(f"u32 outside file at 0x{off:X}")
    return struct.unpack_from("<I", data, off)[0]


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def parse_candidate(data: bytes, image: str, path: str) -> tuple[dict, list[dict], list[dict]]:
    row = {
        "image": image,
        "path": path,
        "size": len(data),
        "sha256": sha256(data),
        "status": "REJECTED",
        "reason": "",
        "uid1": "",
        "uid2": "",
        "uid3": "",
        "kind": "",
        "flags": "",
        "compression_type": "",
        "code_base": "",
        "code_size": 0,
        "data_size": 0,
        "code_offset": 0,
        "data_offset": 0,
        "text_size": 0,
        "import_offset": 0,
        "import_size": 0,
        "code_reloc_offset": 0,
        "data_reloc_offset": 0,
        "export_dir_offset": 0,
        "export_count": 0,
        "valid_exports": 0,
        "zero_exports": 0,
        "invalid_exports": 0,
        "dll_ref_count": 0,
        "import_count": 0,
        "parsed_import_blocks": 0,
        "iat_matches": True,
        "import_trailing_bytes": 0,
    }
    exports: list[dict] = []
    imports: list[dict] = []
    if len(data) < 0x7C or data[0x10:0x14] != b"EPOC":
        row["reason"] = "missing EPOC signature or truncated 0x7C-byte header"
        return row, exports, imports

    uid1, uid2, uid3 = struct.unpack_from("<III", data, 0)
    row.update(uid1=f"0x{uid1:08X}", uid2=f"0x{uid2:08X}", uid3=f"0x{uid3:08X}")
    if uid1 not in (DLL_UID, EXE_UID):
        row["status"] = "MAGIC_ONLY"
        row["reason"] = f"EPOC marker with unsupported UID1 0x{uid1:08X}"
        return row, exports, imports
    row["kind"] = "DLL" if uid1 == DLL_UID else "EXE"

    try:
        fields = {
            "flags": u32(data, 0x2C),
            "code_size": u32(data, 0x30),
            "data_size": u32(data, 0x34),
            "dll_ref_count": u32(data, 0x54),
            "export_dir_offset": u32(data, 0x58),
            "export_count": u32(data, 0x5C),
            "text_size": u32(data, 0x60),
            "code_offset": u32(data, 0x64),
            "data_offset": u32(data, 0x68),
            "import_offset": u32(data, 0x6C),
            "code_reloc_offset": u32(data, 0x70),
            "data_reloc_offset": u32(data, 0x74),
            "code_base": u32(data, 0x4C),
            "compression_type": u32(data, 0x1C),
        }
        row.update(fields)
        for key in ("flags", "compression_type", "code_base"):
            row[key] = f"0x{row[key]:08X}"

        errors: list[str] = []
        warnings: list[str] = []
        code_off = fields["code_offset"]
        code_size = fields["code_size"]
        import_off = fields["import_offset"]
        export_off = fields["export_dir_offset"]
        export_count = fields["export_count"]
        text_size = fields["text_size"]
        dll_count = fields["dll_ref_count"]

        if code_size == 0 or code_off < 0x7C or code_off > len(data) or code_size > len(data) - code_off:
            errors.append("code segment is empty or outside file")
        if import_off < code_off or import_off > len(data) - 4:
            errors.append("import offset is outside file/code region")
        elif code_off + code_size != import_off:
            warnings.append("code segment does not end at import offset")
        if export_count > MAX_EXPORTS:
            errors.append(f"export count exceeds safety cap {MAX_EXPORTS}")
        export_bytes = export_count * 4
        export_bounded = (
            (export_count == 0 and export_off == 0)
            or (
                export_off >= code_off
                and export_off <= len(data)
                and export_bytes <= len(data) - export_off
            )
        )
        if not export_bounded:
            errors.append("export table is outside file/code region")
        elif export_count and import_off <= len(data) and export_off + export_bytes != import_off:
            warnings.append("export table does not end at import offset")
        if text_size > code_size:
            errors.append("text size exceeds code size")
        if dll_count > MAX_DLL_REFS:
            errors.append(f"DLL reference count exceeds safety cap {MAX_DLL_REFS}")

        if export_bounded:
            valid = zero = invalid = 0
            code_end = code_off + code_size
            code_base = fields["code_base"]
            for ordinal in range(1, export_count + 1):
                raw = u32(data, export_off + (ordinal - 1) * 4)
                if raw in (0, 0xFFFFFFFF):
                    zero += 1
                    exports.append({
                        "image": image, "path": path, "uid3": row["uid3"],
                        "ordinal": ordinal, "raw_offset": f"0x{raw:08X}",
                        "runtime_address": "", "thumb": "", "code_file_offset": "",
                        "valid_code_offset": "sentinel",
                    })
                    continue
                code_rel = raw & ~1
                file_off = code_off + code_rel
                ok = code_rel < code_size and code_off <= file_off < code_end
                if ok:
                    valid += 1
                else:
                    invalid += 1
                exports.append({
                    "image": image, "path": path, "uid3": row["uid3"],
                    "ordinal": ordinal, "raw_offset": f"0x{raw:08X}",
                    "runtime_address": f"0x{(code_base + raw) & 0xFFFFFFFF:08X}",
                    "thumb": raw & 1, "code_file_offset": f"0x{file_off:08X}",
                    "valid_code_offset": str(ok).lower(),
                })
            row.update(valid_exports=valid, zero_exports=zero, invalid_exports=invalid)

        import_end = None
        if not errors and import_off + 4 <= len(data):
            import_size = u32(data, import_off)
            row["import_size"] = import_size
            if import_size < 4 or import_size > len(data) - import_off:
                errors.append("import table size is outside file")
            else:
                import_end = import_off + import_size
                code_reloc = fields["code_reloc_offset"]
                data_reloc = fields["data_reloc_offset"]
                if code_reloc and (code_reloc < import_end or code_reloc > len(data)):
                    warnings.append("code relocation offset is outside post-import region")
                if data_reloc and data_reloc > len(data):
                    warnings.append("data relocation offset is outside file")

                pos = import_off + 4
                total_imports = 0
                parsed_blocks = 0
                iat_matches = True
                code_bytes = data[code_off:code_off + code_size]
                for block_index in range(dll_count):
                    if pos + 8 > import_end:
                        errors.append(f"import descriptor {block_index} exceeds import table")
                        break
                    name_rel, count = struct.unpack_from("<II", data, pos)
                    if count > MAX_IMPORTS or total_imports + count > MAX_IMPORTS:
                        errors.append("import count exceeds safety cap")
                        break
                    ord_end = pos + 8 + count * 4
                    if ord_end > import_end:
                        errors.append(f"ordinal array {block_index} exceeds import table")
                        break
                    name_off = import_off + name_rel
                    if name_off < import_off or name_off >= import_end:
                        errors.append(f"DLL name offset {block_index} is outside import table")
                        break
                    name_end = data.find(b"\0", name_off, import_end)
                    if name_end < 0:
                        errors.append(f"DLL name {block_index} is unterminated")
                        break
                    name = data[name_off:name_end].decode("ascii", "replace")
                    ordinals = struct.unpack_from("<" + "I" * count, data, pos + 8) if count else ()
                    iat_off = text_size + total_imports * 4
                    if iat_off > code_size or count * 4 > code_size - iat_off:
                        errors.append(f"IAT block {block_index} exceeds code segment")
                        break
                    iat_values = struct.unpack_from("<" + "I" * count, code_bytes, iat_off) if count else ()
                    block_match = tuple(iat_values) == tuple(ordinals)
                    if not block_match:
                        iat_matches = False
                        warnings.append(f"IAT values differ from ordinal array for {name}")
                    for index, ordinal in enumerate(ordinals):
                        imports.append({
                            "image": image, "path": path, "dependency": name,
                            "ordinal": ordinal, "iat_file_offset": f"0x{code_off + iat_off + index * 4:08X}",
                            "iat_value_matches": str(block_match).lower(),
                        })
                    total_imports += count
                    parsed_blocks += 1
                    pos = ord_end
                row.update(
                    import_count=total_imports,
                    parsed_import_blocks=parsed_blocks,
                    iat_matches=iat_matches,
                    import_trailing_bytes=import_end - pos,
                )
                if parsed_blocks != dll_count:
                    errors.append("not all DLL import descriptors were parsed")

        if errors:
            row["status"] = "REJECTED"
            row["reason"] = "; ".join(errors + warnings)
        elif warnings:
            row["status"] = "PARTIAL"
            row["reason"] = "; ".join(warnings)
        else:
            row["status"] = "PASS"
            row["reason"] = "bounded E32 header, export table, import table and IAT checks passed"
    except (ValueError, struct.error, OverflowError) as exc:
        row["status"] = "REJECTED"
        row["reason"] = str(exc)
    return row, exports, imports


def synthetic_e32() -> bytes:
    data = bytearray(0xB6)
    struct.pack_into("<III", data, 0, DLL_UID, 0x1000008D, 0xE0001090)
    data[0x10:0x14] = b"EPOC"
    struct.pack_into("<I", data, 0x1C, 0)       # compression type
    struct.pack_into("<I", data, 0x2C, 0)       # flags
    struct.pack_into("<I", data, 0x30, 0x20)   # code size
    struct.pack_into("<I", data, 0x34, 0)      # data size
    struct.pack_into("<I", data, 0x4C, 0x10000000)
    struct.pack_into("<I", data, 0x54, 1)      # one DLL reference
    struct.pack_into("<I", data, 0x58, 0x98)   # export table
    struct.pack_into("<I", data, 0x5C, 1)      # one export
    struct.pack_into("<I", data, 0x60, 0x10)   # IAT starts at code+0x10
    struct.pack_into("<I", data, 0x64, 0x7C)   # code offset
    struct.pack_into("<I", data, 0x6C, 0x9C)   # import offset
    struct.pack_into("<I", data, 0x70, 0xB6)   # end of import table
    struct.pack_into("<I", data, 0x78, 350)    # priority/reserved tail
    struct.pack_into("<I", data, 0x8C, 7)     # IAT ordinal
    struct.pack_into("<I", data, 0x98, 4)     # one export at code+4
    struct.pack_into("<I", data, 0x9C, 26)    # import table size
    struct.pack_into("<II", data, 0xA0, 16, 1)
    struct.pack_into("<I", data, 0xA8, 7)
    data[0xAC:0xB5] = b"euser.dll\0"
    return bytes(data)


def write_tsv(path: Path, rows: list[dict], fields: list[str]) -> None:
    with path.open("w", newline="", encoding="utf-8") as stream:
        writer = csv.DictWriter(stream, fieldnames=fields, delimiter="\t", extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)


def self_test() -> None:
    good = synthetic_e32()
    row, exports, imports = parse_candidate(good, "TEST", "sys/bin/test.dll")
    assert row["status"] == "PASS", row
    assert row["export_count"] == 1 and row["valid_exports"] == 1, row
    assert len(exports) == 1 and len(imports) == 1, (exports, imports)

    bad_iat = bytearray(good)
    struct.pack_into("<I", bad_iat, 0x8C, 9)
    row, _, _ = parse_candidate(bytes(bad_iat), "TEST", "sys/bin/bad.dll")
    assert row["status"] == "PARTIAL" and "IAT values differ" in row["reason"], row

    truncated = good[:0x90]
    row, _, _ = parse_candidate(truncated, "TEST", "sys/bin/truncated.dll")
    assert row["status"] == "REJECTED", row

    false_positive = bytearray(good)
    struct.pack_into("<I", false_positive, 0, 0x12345678)
    row, _, _ = parse_candidate(bytes(false_positive), "TEST", "sys/bin/not-e32.bin")
    assert row["status"] == "MAGIC_ONLY", row
    print("Step109 E32 inventory self-tests: PASS (4/4)")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--tree", action="append", default=[], metavar="LABEL=PATH")
    parser.add_argument("--out-dir", type=Path, default=Path("firmware-input"))
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()
    if args.self_test:
        self_test()

    rows: list[dict] = []
    exports: list[dict] = []
    imports: list[dict] = []
    for spec in args.tree:
        if "=" not in spec:
            parser.error("--tree must be LABEL=PATH")
        label, root_text = spec.split("=", 1)
        if not label or any(c not in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789._-" for c in label):
            parser.error(f"unsafe tree label: {label!r}")
        root = Path(root_text)
        if not root.is_dir():
            raise SystemExit(f"extracted tree does not exist: {root}")
        for file_path in sorted(root.rglob("*")):
            if file_path.is_symlink() or not file_path.is_file():
                continue
            try:
                data = file_path.read_bytes()
            except OSError as exc:
                rows.append({"image": label, "path": file_path.relative_to(root).as_posix(),
                             "size": 0, "sha256": "", "status": "READ_ERROR", "reason": str(exc)})
                continue
            if len(data) < 0x14 or data[0x10:0x14] != b"EPOC":
                continue
            rel = file_path.relative_to(root).as_posix()
            row, exp_rows, imp_rows = parse_candidate(data, label, rel)
            rows.append(row)
            exports.extend(exp_rows)
            imports.extend(imp_rows)

    if not args.tree:
        if args.self_test:
            return 0
        parser.error("provide --tree LABEL=PATH and/or --self-test")

    args.out_dir.mkdir(parents=True, exist_ok=True)
    module_fields = [
        "image", "path", "size", "sha256", "status", "reason", "uid1", "uid2", "uid3",
        "kind", "flags", "compression_type", "code_base", "code_size", "data_size",
        "code_offset", "data_offset", "text_size", "import_offset", "import_size",
        "code_reloc_offset", "data_reloc_offset", "export_dir_offset", "export_count",
        "valid_exports", "zero_exports", "invalid_exports", "dll_ref_count", "import_count",
        "parsed_import_blocks", "iat_matches", "import_trailing_bytes",
    ]
    export_fields = [
        "image", "path", "uid3", "ordinal", "raw_offset", "runtime_address", "thumb",
        "code_file_offset", "valid_code_offset",
    ]
    import_fields = [
        "image", "path", "dependency", "ordinal", "iat_file_offset", "iat_value_matches",
    ]
    write_tsv(args.out_dir / "STEP109_E32_MODULES.tsv", rows, module_fields)
    write_tsv(args.out_dir / "STEP109_E32_EXPORTS.tsv", exports, export_fields)
    write_tsv(args.out_dir / "STEP109_E32_IMPORTS.tsv", imports, import_fields)

    counts = Counter(row.get("status", "UNKNOWN") for row in rows)
    summary = {
        "format": "Step109 bounded ROFS/ROFx E32 inventory",
        "candidate_count": len(rows),
        "status_counts": dict(sorted(counts.items())),
        "structurally_valid_modules": sum(1 for row in rows if row.get("status") == "PASS"),
        "export_rows": len(exports),
        "import_rows": len(imports),
        "module_rows": rows,
        "limits": {
            "source_firmware_modified": False,
            "firmware_or_system_binaries_committed": False,
            "header_crc_verified": False,
            "code_relocations_fully_parsed": False,
            "runtime_loadability_proven": False,
            "rom_xip_export_inventory_is_separate": True,
        },
    }
    (args.out_dir / "STEP109_E32_AUDIT.json").write_text(
        json.dumps(summary, indent=2) + "\n", encoding="utf-8"
    )

    lines = [
        "# Step109 — bounded E32 inventory from N95 ROFS/ROFx",
        "",
        f"- EPOC-signature candidates: **{len(rows)}**",
        f"- Status counts: `{dict(sorted(counts.items()))}`",
        f"- Structurally valid modules: **{summary['structurally_valid_modules']}**",
        f"- Decoded export rows: **{len(exports)}**",
        f"- Decoded import rows: **{len(imports)}**",
        "",
        "## Structurally valid candidates",
        "",
        "| Image | Path | Kind | UID3 | Exports | Imports |",
        "|---|---|---|---:|---:|---:|",
    ]
    for row in rows:
        if row.get("status") == "PASS":
            lines.append(
                f"| {row['image']} | `{row['path']}` | {row['kind']} | "
                f"{row['uid3']} | {row['export_count']} | {row['import_count']} |"
            )
    lines += [
        "",
        "## Interpretation limits",
        "",
        "- EPOC signature plus UID1 is only the candidate gate; full bounds, import descriptors, IAT values and export offsets are checked separately.",
        "- PASS means the inspected E32 tables are structurally bounded and internally consistent under this parser. It is not a signature, checksum, relocation, loader or runtime test.",
        "- PARTIAL means the bounded tables were readable but at least one layout or IAT cross-check did not match.",
        "- REJECTED means a hard structural/bounds check failed. MAGIC_ONLY means the EPOC marker was present but UID1 was not an E32 DLL/EXE UID.",
        "- Header CRC and code/data relocation streams are not validated by this step.",
        "- The seven core system DLL export tables are XIP ROM modules reconstructed separately from C0R SOS+CORE; they are not replaced by this ROFS/ROFx file inventory.",
        "- PPM ROFx external references remain excluded by Step108 and are not resolved against a guessed base image.",
        "- No firmware image or protected system DLL is modified or committed.",
        "",
        "Detailed tables: `STEP109_E32_MODULES.tsv`, `STEP109_E32_EXPORTS.tsv`, `STEP109_E32_IMPORTS.tsv`.",
        "",
    ]
    report = "\n".join(lines)
    (args.out_dir / "STEP109_E32_INVENTORY.md").write_text(report, encoding="utf-8")
    print(report)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
