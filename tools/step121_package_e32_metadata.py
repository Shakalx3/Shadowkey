#!/usr/bin/env python3
"""Create a metadata-only archive of the N95 E32 module/export/import inventory."""
from __future__ import annotations

import argparse
import csv
import hashlib
import json
import zipfile
from collections import Counter
from pathlib import Path

TEXT_SUFFIXES = {".tsv", ".json", ".md", ".txt"}


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def is_metadata_name(name: str) -> bool:
    return Path(name).suffix.lower() in TEXT_SUFFIXES


def is_text_payload(data: bytes) -> bool:
    return b"\0" not in data


def read_tsv(path: Path) -> list[dict[str, str]]:
    with path.open("r", newline="", encoding="utf-8") as stream:
        return list(csv.DictReader(stream, delimiter="\t"))


def require_text(path: Path) -> bytes:
    if not path.is_file():
        raise SystemExit("required metadata file is missing: %s" % path)
    data = path.read_bytes()
    if not is_text_payload(data):
        raise SystemExit("NUL byte found; refusing to package possible binary: %s" % path)
    if not is_metadata_name(path.name):
        raise SystemExit("non-metadata extension refused: %s" % path)
    return data


def self_test() -> None:
    checks = [
        is_metadata_name("modules.tsv"),
        is_metadata_name("summary.json"),
        is_metadata_name("checkpoint.md"),
        not is_metadata_name("system.dll"),
        not is_metadata_name("firmware.bin"),
        not is_metadata_name("image.fpsx"),
        is_text_payload(b"plain text\n"),
        not is_text_payload(b"not-text\0payload"),
    ]
    if not all(checks):
        raise AssertionError("metadata whitelist/content guard self-test failed: %s" % checks)
    print("Step121 metadata packaging self-tests: PASS (8/8)")


def package(args: argparse.Namespace) -> dict:
    d109 = args.step109_dir
    d120 = args.step120_dir
    source_paths = {
        "step109/STEP109_E32_MODULES.tsv": d109 / "STEP109_E32_MODULES.tsv",
        "step109/STEP109_E32_EXPORTS.tsv": d109 / "STEP109_E32_EXPORTS.tsv",
        "step109/STEP109_E32_IMPORTS.tsv": d109 / "STEP109_E32_IMPORTS.tsv",
        "step109/STEP109_E32_INVENTORY.md": d109 / "STEP109_E32_INVENTORY.md",
        "step120/STEP120_E32_MODULES.tsv": d120 / "STEP120_E32_MODULES.tsv",
        "step120/STEP120_E32_EXPORTS.tsv": d120 / "STEP120_E32_EXPORTS.tsv",
        "step120/STEP120_E32_IMPORTS.tsv": d120 / "STEP120_E32_IMPORTS.tsv",
        "step120/STEP120_E32_SUMMARY.json": d120 / "STEP120_E32_SUMMARY.json",
        "step120/STEP120_E32_FORMAT_AWARE_INVENTORY.md": d120 / "STEP120_E32_FORMAT_AWARE_INVENTORY.md",
        "reports/STEP117_NATIVE_E32_DECOMPRESSION.md": args.step117_report,
        "reports/STEP118_BULK_E32_VALIDATION.md": args.step118_report,
        "reports/STEP119_E32_IAT_LAYOUT_AUDIT.md": args.step119_report,
        "reports/STEP120_FORMAT_AWARE_INVENTORY.md": args.step120_report,
    }
    entries = {name: require_text(path) for name, path in source_paths.items()}

    modules109 = read_tsv(d109 / "STEP109_E32_MODULES.tsv")
    exports109 = read_tsv(d109 / "STEP109_E32_EXPORTS.tsv")
    imports109 = read_tsv(d109 / "STEP109_E32_IMPORTS.tsv")
    modules120 = read_tsv(d120 / "STEP120_E32_MODULES.tsv")
    exports120 = read_tsv(d120 / "STEP120_E32_EXPORTS.tsv")
    imports120 = read_tsv(d120 / "STEP120_E32_IMPORTS.tsv")
    summary = json.loads(entries["step120/STEP120_E32_SUMMARY.json"].decode("utf-8"))

    if len(modules109) != len(modules120):
        raise SystemExit("Step109/Step120 module row counts differ")
    if len(exports109) != len(exports120):
        raise SystemExit("Step109/Step120 export row counts differ")
    if len(imports109) != len(imports120):
        raise SystemExit("Step109/Step120 import row counts differ")
    if len(modules120) != summary.get("candidate_count"):
        raise SystemExit("Step120 module count disagrees with summary JSON")
    if len(exports120) != summary.get("export_rows"):
        raise SystemExit("Step120 export count disagrees with summary JSON")
    if len(imports120) != summary.get("import_rows"):
        raise SystemExit("Step120 import count disagrees with summary JSON")
    paths109 = {row.get("path", "") for row in modules109}
    paths120 = {row.get("path", "") for row in modules120}
    if paths109 != paths120:
        raise SystemExit("Step109/Step120 module path sets differ")

    step109_status = Counter(row.get("status", "UNKNOWN") for row in modules109)
    step109_formats = Counter(row.get("import_format", "UNKNOWN") for row in modules109)
    step109_export_modes = Counter(row.get("export_address_mode", "UNKNOWN") for row in modules109)
    step120_status = summary.get("status_counts", {})
    step120_formats = summary.get("import_format_counts", {})

    readme = (
        "Shadowkey / Nokia N95 E32 metadata inventory\n"
        "============================================\n\n"
        "This archive contains text metadata only. It does NOT contain firmware images,\n"
        "ROFS/ROFx/UDA payloads, ROM system DLLs, E32 module binaries, or game binaries.\n\n"
        "The Step109 tables contain detailed parsed exports and imports. For ELF imports,\n"
        "the import-list entries are code-relative relocation places; the 32-bit word at\n"
        "each place encodes the imported ordinal in its low 16 bits and the addend in its\n"
        "high 16 bits. There is no separate PE-style IAT for ELF-format images. ELF export\n"
        "entries are absolute linked addresses and are translated using code_base.\n\n"
        "Step120 is an independent format-aware structural cross-check. Structural\n"
        "validity is not a Symbian loader test and does not prove device compatibility.\n\n"
        "Workflow run: %s\nCommit: %s\n\n"
        "Step109 rows: modules=%d exports=%d imports=%d\n"
        "Step109 status counts: %s\nStep109 import formats: %s\n"
        "Step109 export address modes: %s\n"
        "Step120 rows: modules=%d exports=%d imports=%d\n"
        "Step120 status counts: %s\nStep120 import formats: %s\n"
        % (
            args.run_id, args.commit,
            len(modules109), len(exports109), len(imports109),
            dict(step109_status), dict(step109_formats), dict(step109_export_modes),
            len(modules120), len(exports120), len(imports120),
            step120_status, step120_formats
        )
    ).encode("utf-8")
    entries["README.txt"] = readme

    file_manifest = [
        {"path": name, "bytes": len(data), "sha256": sha256(data)}
        for name, data in sorted(entries.items())
    ]
    manifest = {
        "schema_version": 1,
        "workflow_run_id": str(args.run_id),
        "commit": args.commit,
        "metadata_only": True,
        "contains_firmware_or_system_binaries": False,
        "counts": {
            "step109": {
                "modules": len(modules109), "exports": len(exports109), "imports": len(imports109),
                "status_counts": dict(step109_status), "import_format_counts": dict(step109_formats),
                "export_address_mode_counts": dict(step109_export_modes),
            },
            "step120": {
                "modules": len(modules120), "exports": len(exports120), "imports": len(imports120),
                "status_counts": step120_status, "import_format_counts": step120_formats,
            },
        },
        "files": file_manifest,
    }
    manifest_bytes = (json.dumps(manifest, indent=2) + "\n").encode("utf-8")
    entries["manifest.json"] = manifest_bytes
    internal_sums = "".join("%s  %s\n" % (sha256(data), name) for name, data in sorted(entries.items()))
    entries["INTERNAL_SHA256SUMS.txt"] = internal_sums.encode("utf-8")

    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.manifest.parent.mkdir(parents=True, exist_ok=True)
    args.sha256_file.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(args.out, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
        for name, data in sorted(entries.items()):
            if not is_metadata_name(name) or not is_text_payload(data):
                raise SystemExit("archive member is not plain metadata: %s" % name)
            archive.writestr(name, data)

    with zipfile.ZipFile(args.out, "r") as archive:
        for name in archive.namelist():
            if not is_metadata_name(name) or not is_text_payload(archive.read(name)):
                raise SystemExit("metadata archive contains an unexpected/binary member: %s" % name)

    args.manifest.write_bytes(manifest_bytes)
    archive_hash = sha256(args.out.read_bytes())
    manifest_hash = sha256(manifest_bytes)
    args.sha256_file.write_text(
        "%s  %s\n%s  %s\n" % (archive_hash, args.out.name, manifest_hash, args.manifest.name),
        encoding="utf-8"
    )
    manifest["archive_sha256"] = archive_hash
    manifest["archive_bytes"] = args.out.stat().st_size
    return manifest


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--self-test", action="store_true")
    parser.add_argument("--step109-dir", type=Path)
    parser.add_argument("--step120-dir", type=Path)
    parser.add_argument("--step117-report", type=Path)
    parser.add_argument("--step118-report", type=Path)
    parser.add_argument("--step119-report", type=Path)
    parser.add_argument("--step120-report", type=Path)
    parser.add_argument("--out", type=Path)
    parser.add_argument("--manifest", type=Path)
    parser.add_argument("--sha256-file", type=Path)
    parser.add_argument("--run-id", default="unknown")
    parser.add_argument("--commit", default="unknown")
    args = parser.parse_args()
    if args.self_test:
        self_test()
    if not args.out:
        return 0
    required = (
        args.step109_dir, args.step120_dir, args.step117_report, args.step118_report,
        args.step119_report, args.step120_report, args.manifest, args.sha256_file
    )
    if any(value is None for value in required):
        parser.error("all metadata directories/reports/output paths are required when --out is used")
    result = package(args)
    print(json.dumps(result, indent=2))
    print(args.sha256_file.read_text(encoding="utf-8"), end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
