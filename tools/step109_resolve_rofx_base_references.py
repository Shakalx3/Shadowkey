#!/usr/bin/env python3
"""Resolve ROFx external references against a matching base ROFS image.

An external reference is accepted only when address, full path, size and UID
bytes identify exactly one local base file. Source images remain read-only.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import shutil
import struct
import tempfile
from pathlib import Path

from step106_audit_rofs_tree import Audit
from step108_extract_rofs_local_files import safe_label, safe_parts, validate_rows


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def key_for(path: str) -> tuple[str, ...]:
    return tuple(part.casefold() for part in safe_parts(path))


def audited_image(path: Path, label: str, magic: str) -> tuple[bytes, dict]:
    data = path.read_bytes()
    result = Audit(data, label).run()
    if result.get("status") != "PASS" or result.get("errors"):
        raise ValueError(f"{label}: metadata audit failed: {result.get('errors')}")
    if result.get("invalid_file_ranges", 0):
        raise ValueError(f"{label}: invalid local file ranges")
    if result.get("magic") != magic:
        raise ValueError(f"{label}: expected {magic}, got {result.get('magic')!r}")
    if result.get("source_sha256") != sha256(data):
        raise ValueError(f"{label}: source hash changed during audit")
    return data, result


def read_local(data: bytes, audit: dict, row: dict, label: str) -> bytes:
    if row.get("storage") != "local":
        raise ValueError(f"{label}: {row.get('path')} is not a local extent")
    size = int(row["size"])
    source_offset = int(audit["wrapper_offset"]) + int(row["payload_offset"])
    if size < 0 or source_offset < 0 or source_offset + size > len(data):
        raise ValueError(f"{label}: out-of-bounds extent for {row['path']!r}")
    content = data[source_offset:source_offset + size]
    if len(content) != size:
        raise ValueError(f"{label}: short read for {row['path']!r}")
    return content


def make_entry(name: str, size: int, address: int, uid: bytes = bytes(16)) -> bytes:
    encoded = name.encode("utf-16le")
    if len(uid) != 16 or not encoded or len(encoded) % 2:
        raise ValueError("invalid synthetic entry")
    entry = bytearray(30 + len(encoded))
    struct.pack_into("<H", entry, 0, len(entry))
    entry[2:18] = uid
    struct.pack_into("<I", entry, 20, size)
    struct.pack_into("<I", entry, 24, address)
    entry[29] = len(encoded) // 2
    entry[30:] = encoded
    return bytes(entry)


def make_image(magic: bytes, entries: list[bytes], file_data: bytes,
               adjustment: int = 0) -> bytes:
    header_size = 48
    directory_offset = header_size
    file_block_offset = directory_offset + 12
    file_block_size = sum(len(entry) for entry in entries)
    file_data_offset = file_block_offset + file_block_size
    payload = bytearray(file_data_offset + len(file_data))
    payload[:4] = magic
    payload[4] = header_size
    struct.pack_into("<H", payload, 6, 0x0200)
    struct.pack_into(
        "<IIII", payload, 8,
        header_size + adjustment, 12,
        file_block_offset + adjustment, file_block_size,
    )
    struct.pack_into(">III", payload, 36, len(payload), 0, len(payload))
    struct.pack_into("<H", payload, directory_offset, 12)
    payload[directory_offset + 3] = 12
    struct.pack_into(
        "<II", payload, directory_offset + 4,
        file_block_offset + adjustment, file_block_size,
    )
    pos = file_block_offset
    for entry in entries:
        payload[pos:pos + len(entry)] = entry
        pos += len(entry)
    payload[file_data_offset:] = file_data
    return bytes(payload)


def merge(base_path: Path, extension_path: Path, out_dir: Path,
          report_dir: Path, label: str, max_files: int,
          max_total_bytes: int) -> dict:
    label = safe_label(label)
    base_data, base_audit = audited_image(base_path, "BASE_ROFS", "ROFS")
    ext_data, ext_audit = audited_image(extension_path, "EXTENSION_ROFX", "ROFx")
    base_rows = base_audit.get("file_rows", [])
    ext_rows = ext_audit.get("file_rows", [])
    if len(base_rows) > max_files or len(ext_rows) > max_files:
        raise ValueError(f"file count exceeds max-files={max_files}")
    validate_rows(base_rows)
    validate_rows(ext_rows)

    base_by_address: dict[int, list[dict]] = {}
    base_by_key: dict[tuple[str, ...], dict] = {}
    merged: dict[tuple[str, ...], dict] = {}
    for row in base_rows:
        key = key_for(row["path"])
        base_by_key[key] = row
        if row["storage"] == "local":
            base_by_address.setdefault(int(row["address"]), []).append(row)
            content = read_local(base_data, base_audit, row, "BASE_ROFS")
        elif row["storage"] == "no-data-reference" and int(row["size"]) == 0:
            content = b""
        else:
            raise ValueError(
                f"BASE_ROFS: unsupported storage {row['storage']!r} for {row['path']!r}"
            )
        merged[key] = {
            "path": row["path"], "content": content, "source": "base-rofs",
            "source_address": int(row["address"]), "base_sha256": sha256(content),
        }

    resolved = 0
    unresolved = []
    extension_local = 0
    overrides = 0
    new_files = 0
    extension_keys = set()

    for row in ext_rows:
        path = row["path"]
        key = key_for(path)
        extension_keys.add(key)
        storage = row["storage"]
        if storage == "local":
            content = read_local(ext_data, ext_audit, row, "EXTENSION_ROFX")
            extension_local += 1
            if key in merged:
                overrides += 1
            else:
                new_files += 1
            merged[key] = {
                "path": path, "content": content, "source": "extension-local",
                "source_address": int(row["address"]), "base_sha256": None,
            }
        elif storage == "external-reference":
            address = int(row["address"])
            candidates = [
                base_row for base_row in base_by_address.get(address, [])
                if key_for(base_row["path"]) == key
                and int(base_row["size"]) == int(row["size"])
                and base_row["uid_bytes"] == row["uid_bytes"]
                and base_row["storage"] == "local"
            ]
            if len(candidates) != 1:
                unresolved.append({
                    "path": path, "address": address, "size": int(row["size"]),
                    "uid_bytes": row["uid_bytes"], "candidate_count": len(candidates),
                    "reason": "no unique base file with matching address, path, size and UIDs",
                })
                continue
            base_row = candidates[0]
            content = read_local(base_data, base_audit, base_row, "BASE_ROFS")
            if len(content) != int(row["size"]):
                unresolved.append({
                    "path": path, "address": address,
                    "reason": "resolved base content length differs from extension entry",
                })
                continue
            resolved += 1
            merged[key] = {
                "path": path, "content": content,
                "source": "base-rofs-via-rofx-reference",
                "source_address": address, "base_sha256": sha256(content),
            }
        elif storage == "no-data-reference" and int(row["size"]) == 0:
            content = b""
            if key in merged:
                overrides += 1
            else:
                new_files += 1
            merged[key] = {
                "path": path, "content": content, "source": "extension-empty-reference",
                "source_address": int(row["address"]), "base_sha256": None,
            }
        else:
            unresolved.append({
                "path": path, "address": int(row["address"]),
                "size": int(row["size"]),
                "reason": f"unsupported extension storage {storage!r}",
            })

    validate_rows([{"path": item["path"], "storage": "local"} for item in merged.values()])
    if len(merged) > max_files:
        raise ValueError(f"merged file count exceeds max-files={max_files}")

    out_dir.mkdir(parents=True, exist_ok=True)
    final_root = out_dir / label
    if final_root.exists():
        raise FileExistsError(f"refusing to overwrite existing merged tree: {final_root}")
    stage = Path(tempfile.mkdtemp(prefix=f".{label}.stage-", dir=out_dir))
    manifest_files = []
    e32_rows = []
    total_bytes = 0
    try:
        for key, item in sorted(merged.items()):
            content = item["content"]
            total_bytes += len(content)
            if total_bytes > max_total_bytes:
                raise ValueError(f"merged bytes exceed max-total-bytes={max_total_bytes}")
            dest = stage.joinpath(*safe_parts(item["path"]))
            dest.parent.mkdir(parents=True, exist_ok=True)
            with dest.open("xb") as stream:
                stream.write(content)
            digest = sha256(content)
            manifest_files.append({
                "path": item["path"], "size": len(content), "sha256": digest,
                "source": item["source"], "source_address": item["source_address"],
                "base_sha256": item["base_sha256"],
            })
            if len(content) >= 0x18 and content[0x10:0x14] == b"EPOC":
                uid1, uid2, uid3 = struct.unpack_from("<III", content, 0)
                header_crc = struct.unpack_from("<I", content, 0x14)[0]
                e32_rows.append({
                    "path": item["path"], "size": len(content), "sha256": digest,
                    "uid1": f"0x{uid1:08X}", "uid2": f"0x{uid2:08X}",
                    "uid3": f"0x{uid3:08X}", "header_crc": f"0x{header_crc:08X}",
                    "source": item["source"],
                })
        stage.rename(final_root)
    except Exception:
        shutil.rmtree(stage, ignore_errors=True)
        raise

    base_not_listed = sorted(
        base_by_key[key]["path"] for key in base_by_key if key not in extension_keys
    )
    result = {
        "format": "Step109 verified ROFx external-reference resolution",
        "status": "PASS" if not unresolved else "PARTIAL",
        "base": {
            "path": str(base_path), "sha256": base_audit["source_sha256"],
            "directories": base_audit["directories"],
            "file_entries": base_audit["file_entries"],
            "local_files": base_audit["local_files"],
        },
        "extension": {
            "path": str(extension_path), "sha256": ext_audit["source_sha256"],
            "directories": ext_audit["directories"],
            "file_entries": ext_audit["file_entries"],
            "local_files": ext_audit["local_files"],
            "external_references": ext_audit["external_references"],
        },
        "resolved_external_references": resolved,
        "unresolved_external_references": len(unresolved),
        "extension_local_files": extension_local,
        "extension_overrides": overrides,
        "extension_new_files": new_files,
        "base_files_not_listed_in_extension": len(base_not_listed),
        "base_files_not_listed_sample": base_not_listed[:30],
        "merged_files": len(manifest_files), "merged_bytes": total_bytes,
        "e32_candidates": len(e32_rows), "output_directory": str(final_root),
        "unresolved": unresolved, "files": manifest_files,
        "e32_file_candidates": e32_rows,
        "limits": {
            "external_match": "exact address + case-insensitive path + size + UID bytes",
            "source_images_modified": False, "unresolved_references_guessed": False,
            "raw_binaries_committed": False,
        },
    }

    report_dir.mkdir(parents=True, exist_ok=True)
    (report_dir / "STEP109_ROFX_BASE_REFERENCE_MANIFEST.json").write_text(
        json.dumps(result, indent=2) + "\n", encoding="utf-8"
    )
    fields = ("path", "size", "sha256", "uid1", "uid2", "uid3", "header_crc", "source")
    lines = ["\t".join(fields)]
    for row in e32_rows:
        lines.append("\t".join(str(row[field]) for field in fields))
    (report_dir / "STEP109_MERGED_E32_CANDIDATES.tsv").write_text(
        "\n".join(lines) + "\n", encoding="utf-8"
    )

    md = [
        "# Step109 — ROFx external-reference resolution", "",
        f"- Status: **{result['status']}**",
        f"- Base ROFS files: {base_audit['file_entries']}",
        f"- ROFx entries: {ext_audit['file_entries']}",
        f"- ROFx local files: {extension_local}",
        f"- External references resolved by exact base address: {resolved}",
        f"- External references unresolved: {len(unresolved)}",
        f"- Extension local overrides: {overrides}",
        f"- Extension new files: {new_files}",
        f"- Base files absent from extension tree: {len(base_not_listed)}",
        f"- Merged files: {len(manifest_files)}",
        f"- Merged bytes: {total_bytes}",
        f"- Merged E32-signature candidates: {len(e32_rows)}", "",
        "An external reference is accepted only when address, full path, file size, and UID bytes match exactly one local C0R ROFS entry.",
        "Unresolved references are not guessed. Source firmware images are read-only.", "",
    ]
    if unresolved:
        md += ["## Unresolved reference samples", ""]
        for item in unresolved[:30]:
            md.append(
                f"- {item['path']}: {item.get('reason', 'unresolved')} "
                f"(address=0x{item.get('address', 0):X})"
            )
        md.append("")
    md += [
        "## E32 candidate inventory", "",
        "See STEP109_MERGED_E32_CANDIDATES.tsv. EPOC/UID recognition is only an inventory filter.", "",
        "## Safety", "",
        "- Source images are never modified.",
        "- Output is written to a fresh staging directory; existing output is never overwritten.",
        "- Every local extent is checked against the audited source image.",
        "- External references require an exact unique base-file match.",
        "- No firmware image or system DLL is committed.", "",
    ]
    report = "\n".join(md)
    (report_dir / "STEP109_ROFX_BASE_REFERENCE_RESOLUTION.md").write_text(
        report, encoding="utf-8"
    )
    print(report)
    print(json.dumps({
        "status": result["status"], "resolved_external_references": resolved,
        "unresolved_external_references": len(unresolved),
        "merged_files": len(manifest_files), "merged_bytes": total_bytes,
        "e32_candidates": len(e32_rows), "output_directory": str(final_root),
    }, indent=2))
    return result


def self_test() -> None:
    base_data = make_image(
        b"ROFS", [make_entry("A", 4, 92, bytes(range(16)))], b"BASE"
    )
    adjustment = 0x1000
    local_offset = 48 + 12 + 64
    ext_data = make_image(
        b"ROFx",
        [
            make_entry("A", 4, 92, bytes(range(16))),
            make_entry("B", 3, local_offset + adjustment),
        ],
        b"NEW",
        adjustment,
    )
    with tempfile.TemporaryDirectory() as temp:
        root = Path(temp)
        base = root / "base.rofs"
        ext = root / "ext.rofx"
        base.write_bytes(base_data)
        ext.write_bytes(ext_data)
        good = merge(base, ext, root / "out", root / "reports", "GOOD", 20, 1024)
        tree = root / "out" / "GOOD"
        assert good["status"] == "PASS", good
        assert good["resolved_external_references"] == 1, good
        assert good["merged_files"] == 2, good
        assert (tree / "A").read_bytes() == b"BASE"
        assert (tree / "B").read_bytes() == b"NEW"

        damaged = bytearray(ext_data)
        struct.pack_into("<I", damaged, 60 + 24, 93)
        bad = root / "bad.rofx"
        bad.write_bytes(damaged)
        partial = merge(
            base, bad, root / "out2", root / "reports2",
            "BAD", 20, 1024,
        )
        assert partial["status"] == "PARTIAL", partial
        assert partial["unresolved_external_references"] == 1, partial
    print("Step109 ROFx/base-reference tests: PASS (2/2)")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--base", type=Path)
    parser.add_argument("--extension", type=Path)
    parser.add_argument("--out-dir", type=Path)
    parser.add_argument("--report-dir", type=Path)
    parser.add_argument("--label", default="PPM_OVER_C0R")
    parser.add_argument("--max-files", type=int, default=20000)
    parser.add_argument("--max-total-bytes", type=int, default=512 * 1024 * 1024)
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()
    if args.self_test:
        self_test()
        return 0
    for name in ("base", "extension", "out_dir", "report_dir"):
        if getattr(args, name) is None:
            parser.error(f"--{name.replace('_', '-')} is required unless --self-test is used")
    result = merge(
        args.base, args.extension, args.out_dir, args.report_dir,
        args.label, args.max_files, args.max_total_bytes,
    )
    return 0 if result["status"] == "PASS" else 2


if __name__ == "__main__":
    raise SystemExit(main())
