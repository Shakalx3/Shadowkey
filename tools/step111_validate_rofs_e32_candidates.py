#!/usr/bin/env python3
"""Validate EKA2 E32 headers and export tables in a merged ROFS/ROFx tree.

This is a read-only inventory pass. It never modifies firmware inputs or
commits extracted binaries. Header fields follow the S60 3.1 FP1 EKA2 layout
used by the existing Step84/Step86 inspectors (not the legacy EKA1 layout).
"""
from __future__ import annotations

import argparse
import csv
import hashlib
from collections import Counter
import json
import struct
from pathlib import Path

DLL_UID = 0x10000079
EXE_UID = 0x1000007A
HEADER_MIN = 0x7C


def u32(data: bytes, offset: int) -> int:
    return struct.unpack_from("<I", data, offset)[0]


def hx(value: int) -> str:
    return f"0x{value:08X}"


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def inspect_image(data: bytes, relpath: str) -> tuple[dict, list[dict]]:
    errors: list[str] = []
    warnings: list[str] = []
    exports: list[dict] = []

    result = {
        "path": relpath,
        "size": len(data),
        "sha256": sha256(data),
        "status": "INVALID",
        "errors": errors,
        "warnings": warnings,
    }
    if len(data) < 0x14 or data[0x10:0x14] != b"EPOC":
        errors.append("missing EPOC signature")
        return result, exports
    if len(data) < HEADER_MIN:
        errors.append(f"truncated EKA2 E32 header: {len(data)} < {HEADER_MIN}")
        return result, exports

    fields = {
        "uid1": u32(data, 0x00),
        "uid2": u32(data, 0x04),
        "uid3": u32(data, 0x08),
        "header_crc": u32(data, 0x14),
        "module_version": u32(data, 0x18),
        "compression_type": u32(data, 0x1C),
        "tools_version": u32(data, 0x20),
        "flags": u32(data, 0x2C),
        "code_size": u32(data, 0x30),
        "data_size": u32(data, 0x34),
        "entry_point": u32(data, 0x48),
        "code_base": u32(data, 0x4C),
        "data_base": u32(data, 0x50),
        "dll_ref_count": u32(data, 0x54),
        "export_dir_offset": u32(data, 0x58),
        "export_count": u32(data, 0x5C),
        "text_size": u32(data, 0x60),
        "code_offset": u32(data, 0x64),
        "data_offset": u32(data, 0x68),
        "import_offset": u32(data, 0x6C),
        "post_import_region_offset": u32(data, 0x70),
    }
    result.update({k: hx(v) for k, v in fields.items() if k not in {
        "module_version", "compression_type", "code_size", "data_size",
        "dll_ref_count", "export_count", "text_size", "code_offset",
        "data_offset", "import_offset", "post_import_region_offset"
    }})
    result.update({k: v for k, v in fields.items() if k in {
        "module_version", "compression_type", "code_size", "data_size",
        "dll_ref_count", "export_count", "text_size", "code_offset",
        "data_offset", "import_offset", "post_import_region_offset"
    }})
    result["module_kind"] = {
        DLL_UID: "DLL",
        EXE_UID: "EXE",
    }.get(fields["uid1"], "UNKNOWN")
    result["import_ordinal_count"] = 0
    result["iat_matches_imports"] = None
    result["nonzero_exports"] = 0

    if fields["uid1"] not in (DLL_UID, EXE_UID):
        errors.append(f"unsupported UID1 {hx(fields['uid1'])}")
    expected_dll_flag = fields["uid1"] == DLL_UID
    actual_dll_flag = bool(fields["flags"] & 1)
    if expected_dll_flag != actual_dll_flag:
        errors.append(
            f"UID1/flags mismatch: UID1={hx(fields['uid1'])}, flags={hx(fields['flags'])}"
        )

    code_off = fields["code_offset"]
    code_size = fields["code_size"]
    import_off = fields["import_offset"]
    export_off = fields["export_dir_offset"]
    export_count = fields["export_count"]
    compressed = fields["compression_type"] != 0

    if code_size == 0:
        errors.append("zero code size")
    if code_off < HEADER_MIN or code_off > len(data):
        errors.append(f"code offset outside file/header: {hx(code_off)}")
    if fields["text_size"] > code_size:
        errors.append("text size exceeds code size")
    if fields["entry_point"] and (fields["entry_point"] & ~1) >= code_size:
        errors.append("entry point lies outside code-size range")
    if not compressed and code_off <= len(data) and code_size > len(data) - code_off:
        errors.append("uncompressed code range exceeds file")
    if not compressed and import_off and code_off + code_size != import_off:
        warnings.append("code end does not equal import offset")
    if fields["data_size"] and fields["data_offset"] >= len(data):
        errors.append("data offset outside file")
    if fields["data_size"] and not compressed and (
        fields["data_offset"] > len(data)
        or fields["data_size"] > len(data) - fields["data_offset"]
    ):
        errors.append("uncompressed data range exceeds file")
    if compressed:
        warnings.append("compressed image: code/data payload and IAT bytes not decoded")

    if export_count:
        if export_off < HEADER_MIN or export_off > len(data):
            errors.append(f"export directory offset outside file: {hx(export_off)}")
        elif export_count > (len(data) - export_off) // 4:
            errors.append("export directory exceeds file")
        else:
            for ordinal in range(1, export_count + 1):
                raw = u32(data, export_off + (ordinal - 1) * 4)
                offset = raw & ~1
                valid = raw in (0, 0xFFFFFFFF) or offset < code_size
                if raw not in (0, 0xFFFFFFFF):
                    result["nonzero_exports"] += 1
                    if not valid:
                        errors.append(
                            f"export ordinal {ordinal} points outside code: raw={hx(raw)}"
                        )
                file_off = code_off + offset
                sample = (
                    data[file_off:file_off + 12].hex()
                    if not compressed and valid and file_off < len(data)
                    else ""
                )
                exports.append({
                    "path": relpath,
                    "ordinal": ordinal,
                    "raw_offset": hx(raw),
                    "runtime_address": hx((fields["code_base"] + raw) & 0xFFFFFFFF),
                    "thumb": raw & 1,
                    "code_file_offset": hx(file_off),
                    "valid_code_offset": valid,
                    "sample_hex": sample,
                })

    if fields["dll_ref_count"]:
        if import_off < HEADER_MIN or import_off > len(data) - 4:
            errors.append(f"import offset outside file: {hx(import_off)}")
        else:
            import_size = u32(data, import_off)
            if import_size < 4 or import_size > len(data) - import_off:
                errors.append(f"invalid import-table size {hx(import_size)}")
            else:
                import_end = import_off + import_size
                pos = import_off + 4
                import_blocks = []
                for block_index in range(fields["dll_ref_count"]):
                    if pos + 8 > import_end:
                        errors.append(f"import descriptor {block_index} exceeds table")
                        break
                    name_rel, count = struct.unpack_from("<II", data, pos)
                    ordinal_end = pos + 8 + count * 4
                    name_off = import_off + name_rel
                    if ordinal_end > import_end:
                        errors.append(f"ordinal array {block_index} exceeds import table")
                        break
                    if name_off < import_off or name_off >= import_end:
                        errors.append(f"DLL name offset {block_index} outside import table")
                        break
                    name_end = data.find(b"\0", name_off, import_end)
                    if name_end < 0:
                        errors.append(f"unterminated DLL name in import block {block_index}")
                        break
                    name = data[name_off:name_end].decode("ascii", "replace")
                    ordinals = list(struct.unpack_from("<" + "I" * count, data, pos + 8)) if count else []
                    import_blocks.append({"name": name, "ordinals": ordinals})
                    result["import_ordinal_count"] += count
                    pos = ordinal_end
                result["import_blocks"] = import_blocks
                if pos > import_end:
                    errors.append("import descriptor cursor exceeds table")
                if not compressed and not any("code offset" in e for e in errors):
                    iat_start = fields["text_size"]
                    iat_ok = True
                    for block in import_blocks:
                        count = len(block["ordinals"])
                        iat_off = code_off + iat_start
                        if iat_start > code_size or count * 4 > code_size - iat_start:
                            errors.append("IAT array exceeds code segment")
                            iat_ok = False
                            break
                        values = list(struct.unpack_from("<" + "I" * count, data, iat_off)) if count else []
                        if values != block["ordinals"]:
                            errors.append(f"IAT does not match import ordinals for {block['name']}")
                            iat_ok = False
                        iat_start += count * 4
                    result["iat_matches_imports"] = iat_ok
    else:
        result["import_blocks"] = []

    if export_count and import_off and export_off + export_count * 4 > import_off:
        warnings.append("export table extends beyond import-table start")
    if not errors:
        result["status"] = "PARTIAL" if warnings else "VALID"
    result["module_version"] = hx(fields["module_version"])
    result["compression_type"] = hx(fields["compression_type"])
    result["flags"] = hx(fields["flags"])
    result["uid1"] = hx(fields["uid1"])
    result["uid2"] = hx(fields["uid2"])
    result["uid3"] = hx(fields["uid3"])
    result["header_crc"] = hx(fields["header_crc"])
    result["code_base"] = hx(fields["code_base"])
    result["data_base"] = hx(fields["data_base"])
    result["entry_point"] = hx(fields["entry_point"])
    result["export_dir_offset"] = hx(export_off)
    result["import_offset"] = hx(import_off)
    return result, exports


def candidate_paths(root: Path, list_path: Path | None) -> list[str]:
    if list_path and list_path.exists():
        with list_path.open(newline="", encoding="utf-8") as stream:
            rows = list(csv.DictReader(stream, delimiter="\t"))
        return [row["path"] for row in rows]
    found = []
    for path in sorted(root.rglob("*")):
        if path.is_file():
            try:
                with path.open("rb") as stream:
                    stream.seek(0x10)
                    if stream.read(4) == b"EPOC":
                        found.append(path.relative_to(root).as_posix())
            except OSError:
                continue
    return found


def write_reports(results: list[dict], exports: list[dict], out_dir: Path) -> dict:
    out_dir.mkdir(parents=True, exist_ok=True)
    counts = {state: sum(1 for row in results if row["status"] == state)
              for state in ("VALID", "PARTIAL", "INVALID")}
    kinds = {}
    for row in results:
        kind = row.get("module_kind", "UNKNOWN")
        kinds[kind] = kinds.get(kind, 0) + 1
    error_counts = Counter(message for row in results for message in row.get("errors", []))
    warning_counts = Counter(message for row in results for message in row.get("warnings", []))
    summary = {
        "format": "S60 3.1 FP1 EKA2 E32 candidate validation",
        "candidate_count": len(results),
        "status_counts": counts,
        "module_kind_counts": kinds,
        "error_counts": dict(error_counts.most_common()),
        "warning_counts": dict(warning_counts.most_common()),
        "export_rows": len(exports),
        "valid_export_rows": sum(1 for row in exports if row["valid_code_offset"]),
        "import_ordinal_count": sum(int(row.get("import_ordinal_count", 0)) for row in results),
        "limitations": [
            "header CRC is recorded but not recomputed",
            "compressed code/data payloads are not decompressed",
            "EPOC signature alone is not treated as proof of a valid E32 image",
            "this filesystem inventory is separate from the reconstructed XIP ROM export tables",
        ],
        "modules": results,
    }
    (out_dir / "STEP111_E32_VALIDATION.json").write_text(
        json.dumps(summary, indent=2) + "\n", encoding="utf-8"
    )
    module_fields = [
        "path", "size", "sha256", "module_kind", "uid1", "uid2", "uid3",
        "header_crc", "module_version", "compression_type", "flags",
        "code_size", "data_size", "dll_ref_count", "import_ordinal_count",
        "export_count", "nonzero_exports", "iat_matches_imports", "status",
    ]
    with (out_dir / "STEP111_E32_MODULES.tsv").open("w", newline="", encoding="utf-8") as stream:
        writer = csv.DictWriter(stream, fieldnames=module_fields, delimiter="\t", extrasaction="ignore")
        writer.writeheader()
        writer.writerows(results)
    export_fields = [
        "path", "ordinal", "raw_offset", "runtime_address", "thumb",
        "code_file_offset", "valid_code_offset", "sample_hex",
    ]
    with (out_dir / "STEP111_E32_EXPORTS.tsv").open("w", newline="", encoding="utf-8") as stream:
        writer = csv.DictWriter(stream, fieldnames=export_fields, delimiter="\t")
        writer.writeheader()
        writer.writerows(exports)

    lines = [
        "# Step111 — merged ROFS/ROFx E32 validation",
        "",
        f"- EPOC-signature candidates checked: **{len(results)}**",
        f"- Structurally valid E32 images: **{counts['VALID']}**",
        f"- Valid with warnings / incomplete compressed-payload checks: **{counts['PARTIAL']}**",
        f"- Invalid or signature-only candidates: **{counts['INVALID']}**",
        f"- Export rows parsed: **{len(exports)}**",
        f"- Import ordinals parsed: **{summary['import_ordinal_count']}**",
        "",
        "| UID1 kind | Candidate files |",
        "|---|---:|",
    ]
    for kind, count in sorted(kinds.items()):
        lines.append(f"| {kind} | {count} |")
    lines += ["", "## Most frequent parser findings", ""]
    for message, count in error_counts.most_common(12):
        lines.append(f"- ERROR x{count}: {message}")
    for message, count in warning_counts.most_common(8):
        lines.append(f"- WARNING x{count}: {message}")
    lines += [
        "",
        "Detailed module and export inventories are in STEP111_E32_MODULES.tsv and STEP111_E32_EXPORTS.tsv.",
        "",
        "## Interpretation limits",
        "",
        "- header_crc at offset 0x14 is recorded; it is not a CPU identifier and is not recomputed here.",
        "- Compressed images are structurally inspected, but compressed code/data and their IAT contents are not decoded.",
        "- These are ROFS/ROFx filesystem modules, not the seven XIP ROM modules inventoried separately by Step91.",
        "- No extracted binary is committed; no ROM DLL is modified; no device compatibility is inferred.",
        "",
    ]
    (out_dir / "STEP111_E32_VALIDATION.md").write_text("\n".join(lines), encoding="utf-8")
    print("\n".join(lines))
    return summary


def self_test() -> None:
    def fixture(uid1: int, flags: int, with_import: bool = False) -> bytes:
        code_off = HEADER_MIN
        text_size = 16 if with_import else 20
        code_size = 24 if with_import else 20
        import_off = code_off + code_size
        export_count = 0 if with_import else 1
        export_off = import_off if with_import else import_off - 4
        if with_import:
            name = b"EUSER.DLL\0"
            import_tail = (
                struct.pack("<I", 16 + len(name))
                + struct.pack("<II", 16, 1)
                + struct.pack("<I", 7)
                + name
            )
        else:
            import_tail = struct.pack("<I", 4)
        data = bytearray(import_off + len(import_tail))
        struct.pack_into("<III", data, 0, uid1, 0x1000008D, 0xE0001111)
        data[0x10:0x14] = b"EPOC"
        struct.pack_into("<I", data, 0x14, 0x12345678)
        struct.pack_into("<I", data, 0x18, 0x00010000)
        struct.pack_into("<I", data, 0x1C, 0)
        struct.pack_into("<I", data, 0x2C, flags)
        struct.pack_into("<II", data, 0x30, code_size, 0)
        struct.pack_into("<I", data, 0x48, 0)
        struct.pack_into("<I", data, 0x4C, 0x10000)
        struct.pack_into("<I", data, 0x54, 1 if with_import else 0)
        struct.pack_into("<II", data, 0x58, export_off, export_count)
        struct.pack_into("<I", data, 0x60, text_size)
        struct.pack_into("<III", data, 0x64, code_off, 0, import_off)
        struct.pack_into("<I", data, 0x70, import_off + len(import_tail))
        if not with_import:
            struct.pack_into("<I", data, export_off, 4)
        else:
            struct.pack_into("<I", data, code_off + text_size, 7)
        data[import_off:import_off + len(import_tail)] = import_tail
        return bytes(data)

    good_dll = fixture(DLL_UID, 1)
    parsed, exports = inspect_image(good_dll, "good.dll")
    assert parsed["status"] == "VALID", parsed
    assert len(exports) == 1 and exports[0]["valid_code_offset"], exports

    good_exe = fixture(EXE_UID, 0, with_import=True)
    parsed, exports = inspect_image(good_exe, "good.exe")
    assert parsed["status"] == "VALID", parsed
    assert parsed["import_ordinal_count"] == 1 and parsed["iat_matches_imports"] is True, parsed

    bad_flags = fixture(DLL_UID, 0)
    parsed, _ = inspect_image(bad_flags, "bad-flags.dll")
    assert parsed["status"] == "INVALID", parsed

    bad_export = bytearray(good_dll)
    struct.pack_into("<I", bad_export, u32(bad_export, 0x58), 0xFFFFFFFE)
    parsed, _ = inspect_image(bytes(bad_export), "bad-export.dll")
    assert parsed["status"] == "INVALID", parsed

    truncated = b"\x00" * 0x10 + b"EPOC"
    parsed, _ = inspect_image(truncated, "truncated.dll")
    assert parsed["status"] == "INVALID", parsed
    print("Step111 EKA2 E32 candidate self-tests: PASS (5/5)")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, default=Path("firmware-parsed/step109-merged/PPM_OVER_C0R"))
    parser.add_argument("--candidate-list", type=Path, default=Path("firmware-input/STEP109_MERGED_E32_CANDIDATES.tsv"))
    parser.add_argument("--out-dir", type=Path, default=Path("firmware-input"))
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()

    if args.self_test:
        self_test()
    if not args.root.exists():
        if args.self_test:
            return 0
        parser.error(f"merged tree does not exist: {args.root}")

    paths = candidate_paths(args.root, args.candidate_list)
    if not paths:
        parser.error("no EPOC-signature candidates found")
    results = []
    exports = []
    missing = []
    for relpath in paths:
        candidate = Path(relpath)
        if candidate.is_absolute() or ".." in candidate.parts:
            raise SystemExit(f"unsafe candidate path: {relpath}")
        path = args.root / candidate
        if not path.is_file():
            missing.append(relpath)
            continue
        result, rows = inspect_image(path.read_bytes(), relpath)
        results.append(result)
        exports.extend(rows)
    if missing:
        raise SystemExit(f"candidate list contains missing files: {missing[:10]}")
    summary = write_reports(results, exports, args.out_dir)
    return 0 if summary["candidate_count"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
