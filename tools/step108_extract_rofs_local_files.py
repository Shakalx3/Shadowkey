#!/usr/bin/env python3
"""Bounded extraction of local file extents from audited ROFS/ROFx images.

External ROFx references are recorded but never copied from the extension image.
The source firmware images are read-only; output is written to a fresh directory.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
import shutil
import struct
import sys
import tempfile
from pathlib import Path

from step106_audit_rofs_tree import Audit, synthetic_image


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def safe_label(label: str) -> str:
    if not label or any(c not in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789._-" for c in label):
        raise ValueError(f"unsafe image label: {label!r}")
    return label


def safe_parts(path: str) -> tuple[str, ...]:
    if not path or path.startswith("/") or len(path) > 1024:
        raise ValueError(f"unsafe relative path: {path!r}")
    parts = tuple(path.split("/"))
    for part in parts:
        if (not part or part in (".", "..") or ":" in part
                or part.endswith((" ", ".")) or len(part.encode("utf-8")) > 255
                or any(ord(ch) < 0x20 for ch in part)):
            raise ValueError(f"unsafe path component in {path!r}")
    return parts


def validate_rows(rows: list[dict]) -> list[tuple[dict, tuple[str, ...]]]:
    prepared = []
    seen: dict[tuple[str, ...], str] = {}
    file_keys = set()
    for row in rows:
        parts = safe_parts(str(row["path"]))
        key = tuple(p.casefold() for p in parts)
        if key in seen:
            raise ValueError(f"case-insensitive path collision: {seen[key]!r} and {row['path']!r}")
        seen[key] = str(row["path"])
        file_keys.add(key)
        prepared.append((row, parts))
    for row, parts in prepared:
        key = tuple(p.casefold() for p in parts)
        for n in range(1, len(key)):
            if key[:n] in file_keys:
                raise ValueError(f"file/directory path collision at {row['path']!r}")
    return prepared


def extract_one(data: bytes, result: dict, out_dir: Path, label: str,
                max_files: int, max_total_bytes: int) -> dict:
    label = safe_label(label)
    if result.get("status") != "PASS" or result.get("errors"):
        raise ValueError(f"{label}: metadata audit is not PASS; refusing extraction")
    if result.get("invalid_file_ranges", 0):
        raise ValueError(f"{label}: audit reports invalid local file ranges")
    if result.get("source_sha256") != sha256(data):
        raise ValueError(f"{label}: source SHA-256 changed after metadata audit")

    rows = result.get("file_rows", [])
    if len(rows) > max_files:
        raise ValueError(f"{label}: {len(rows)} entries exceed max-files={max_files}")
    prepared = validate_rows(rows)
    wrapper = int(result["wrapper_offset"])
    payload_size = len(data) - wrapper
    local = []
    total = 0
    for row, parts in prepared:
        if row["storage"] != "local":
            continue
        size = int(row["size"])
        payload_offset = int(row["payload_offset"])
        if size < 0 or payload_offset < 0 or payload_offset + size > payload_size:
            raise ValueError(f"{label}: out-of-bounds local extent for {row['path']!r}")
        source_offset = wrapper + payload_offset
        if source_offset + size > len(data):
            raise ValueError(f"{label}: source extent exceeds image for {row['path']!r}")
        total += size
        if total > max_total_bytes:
            raise ValueError(f"{label}: extracted bytes exceed max-total-bytes={max_total_bytes}")
        local.append((row, parts, source_offset, size))

    out_dir.mkdir(parents=True, exist_ok=True)
    final_root = out_dir / label
    if final_root.exists():
        raise FileExistsError(f"refusing to overwrite existing extraction: {final_root}")
    stage = Path(tempfile.mkdtemp(prefix=f".{label}.stage-", dir=out_dir))
    manifest_rows = []
    e32_rows = []
    extracted_bytes = 0
    try:
        for row, parts, source_offset, size in local:
            dest = stage.joinpath(*parts)
            dest.parent.mkdir(parents=True, exist_ok=True)
            chunk = data[source_offset:source_offset + size]
            if len(chunk) != size:
                raise ValueError(f"{label}: short source read for {row['path']!r}")
            digest = sha256(chunk)
            with dest.open("xb") as stream:
                stream.write(chunk)
            extracted_bytes += size
            item = {
                "path": row["path"],
                "size": size,
                "storage": "local",
                "payload_offset": int(row["payload_offset"]),
                "source_offset": source_offset,
                "sha256": digest,
                "extracted": True,
            }
            manifest_rows.append(item)
            if len(chunk) >= 0x18 and chunk[0x10:0x14] == b"EPOC":
                uid1, uid2, uid3 = struct.unpack_from("<III", chunk, 0)
                cpu = struct.unpack_from("<I", chunk, 0x14)[0]
                e32_rows.append({
                    "image": label,
                    "path": row["path"],
                    "size": size,
                    "sha256": digest,
                    "uid1": f"0x{uid1:08X}",
                    "uid2": f"0x{uid2:08X}",
                    "uid3": f"0x{uid3:08X}",
                    "cpu": f"0x{cpu:08X}",
                })
        stage.rename(final_root)
    except Exception:
        shutil.rmtree(stage, ignore_errors=True)
        raise

    skipped = []
    for row, _parts in prepared:
        if row["storage"] != "local":
            skipped.append({
                "path": row["path"],
                "size": int(row["size"]),
                "storage": row["storage"],
                "address": row["address"],
                "extracted": False,
            })
    return {
        "label": label,
        "magic": result.get("magic"),
        "status": "PASS",
        "source_size": len(data),
        "source_sha256": result["source_sha256"],
        "wrapper_offset": wrapper,
        "directories": result["directories"],
        "file_entries": result["file_entries"],
        "local_files": result["local_files"],
        "external_references": result["external_references"],
        "invalid_file_ranges": result["invalid_file_ranges"],
        "extracted_files": len(manifest_rows),
        "extracted_bytes": extracted_bytes,
        "skipped_entries": len(skipped),
        "output_directory": str(final_root),
        "files": manifest_rows,
        "skipped": skipped,
        "e32_candidates": e32_rows,
    }


def write_reports(results: list[dict], report_dir: Path) -> None:
    report_dir.mkdir(parents=True, exist_ok=True)
    manifest = {
        "format": "Step108 bounded local ROFS/ROFx file extraction",
        "source_images": [
            {k: v for k, v in r.items() if k not in ("files", "skipped", "e32_candidates")}
            for r in results
        ],
        "images": results,
        "limits": {
            "local_file_extents_only": True,
            "external_rofx_references_extracted": False,
            "source_images_modified": False,
            "case_insensitive_path_collisions_rejected": True,
        },
    }
    (report_dir / "STEP108_LOCAL_FILE_MANIFEST.json").write_text(
        json.dumps(manifest, indent=2) + "\n", encoding="utf-8"
    )
    fields = ("image", "path", "size", "sha256", "uid1", "uid2", "uid3", "cpu")
    lines = ["\t".join(fields)]
    for result in results:
        for row in result["e32_candidates"]:
            lines.append("\t".join(str(row[k]) for k in fields))
    (report_dir / "STEP108_E32_FILE_CANDIDATES.tsv").write_text(
        "\n".join(lines) + "\n", encoding="utf-8"
    )

    lines = [
        "# Step108 — bounded local ROFS/ROFx extraction",
        "",
        "The metadata audit passed before extraction. Only local file extents were copied.",
        "External ROFx references were recorded and skipped; no base-image data was guessed.",
        "Source images were read-only and were not modified.",
        "",
        "| Image | Format | Directories | File entries | Local extents | External refs | Extracted files | Extracted bytes | E32 signatures |",
        "|---|---|---:|---:|---:|---:|---:|---:|---:|",
    ]
    for result in results:
        lines.append(
            f"| {result['label']} | {result['magic']} | {result['directories']} | "
            f"{result['file_entries']} | {result['local_files']} | {result['external_references']} | "
            f"{result['extracted_files']} | {result['extracted_bytes']} | "
            f"{len(result['e32_candidates'])} |"
        )
    lines += [
        "",
        "## E32 candidates",
        "",
        f"- E32-signature files found: {sum(len(r['e32_candidates']) for r in results)}",
        "- Candidate list: STEP108_E32_FILE_CANDIDATES.tsv",
        "- The EPOC marker and UID fields are an inventory filter, not a full E32 validity or export-table check.",
        "",
        "## Safety and scope",
        "",
        "- Every local extent was bounds-checked against the source payload before copying.",
        "- The complete source SHA-256 was rechecked against the metadata audit.",
        "- Duplicate paths are rejected using case-insensitive comparison.",
        "- File/directory path collisions and unsafe path components are rejected.",
        "- Extraction uses a fresh staging directory and refuses to overwrite an existing output tree.",
        "- UDA is a separate FAT16 user-area image and is not treated as ROFS/ROFx by this tool.",
        "- ROFx external references require the matching base image and remain unresolved here.",
        "- This extraction does not modify firmware and does not imply device compatibility.",
        "",
    ]
    (report_dir / "STEP108_LOCAL_FILE_EXTRACTION.md").write_text(
        "\n".join(lines), encoding="utf-8"
    )
    print("\n".join(lines))


def self_test() -> None:
    import tempfile

    with tempfile.TemporaryDirectory() as temp:
        root = Path(temp)
        raw = synthetic_image(b"ROFS")
        audit = Audit(raw, "test-rofs").run()
        result = extract_one(raw, audit, root / "out", "TEST_ROFS", 10, 1024)
        assert result["extracted_files"] == 1, result
        assert (root / "out" / "TEST_ROFS" / "A").read_bytes() == b"DATA"

        wrapped = b"\x00" * 1024 + synthetic_image(b"ROFS")
        wrapped_audit = Audit(wrapped, "wrapped-rofs").run()
        wrapped_result = extract_one(
            wrapped, wrapped_audit, root / "out", "WRAPPED_ROFS", 10, 1024
        )
        assert (root / "out" / "WRAPPED_ROFS" / "A").read_bytes() == b"DATA"
        assert wrapped_result["wrapper_offset"] == 1024

        external = bytearray(synthetic_image(b"ROFx"))
        struct.pack_into("<I", external, 60 + 24, 48)
        external_bytes = bytes(external)
        external_audit = Audit(external_bytes, "external-rofx").run()
        external_result = extract_one(
            external_bytes, external_audit, root / "out", "EXTERNAL_ROFX", 10, 1024
        )
        assert external_result["extracted_files"] == 0, external_result
        assert external_result["external_references"] == 1, external_result
        assert not (root / "out" / "EXTERNAL_ROFX" / "A").exists()

        try:
            safe_parts("../escape")
        except ValueError:
            pass
        else:
            raise AssertionError("path traversal was accepted")

        try:
            validate_rows([
                {"path": "Dir/File", "storage": "local"},
                {"path": "dir/file", "storage": "external-reference"},
            ])
        except ValueError:
            pass
        else:
            raise AssertionError("case-insensitive path collision was accepted")

    print("Step108 bounded ROFS/ROFx extraction self-tests: PASS (5/5)")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--image", action="append", default=[], metavar="LABEL=PATH")
    parser.add_argument("--out-dir", type=Path, default=Path("firmware-parsed/step108-extracted"))
    parser.add_argument("--report-dir", type=Path, default=Path("firmware-input"))
    parser.add_argument("--max-files", type=int, default=20000)
    parser.add_argument("--max-total-bytes", type=int, default=512 * 1024 * 1024)
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()

    if args.self_test:
        self_test()
    results = []
    for spec in args.image:
        if "=" not in spec:
            parser.error("--image must be LABEL=PATH")
        label, filename = spec.split("=", 1)
        data = Path(filename).read_bytes()
        audit = Audit(data, label).run()
        result = extract_one(
            data, audit, args.out_dir, label, args.max_files, args.max_total_bytes
        )
        results.append(result)
    if results:
        write_reports(results, args.report_dir)
    elif not args.self_test:
        parser.error("provide --self-test and/or --image LABEL=PATH")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
