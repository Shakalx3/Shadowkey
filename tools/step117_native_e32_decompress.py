#!/usr/bin/env python3
"""Probe Symbian-native E32 decompression through the pinned elf2e32 utility.

The Step109 Python parser intentionally does not treat Symbian Deflate as zlib.
This step asks elf2e32's E32 parser to repack one candidate per compression UID
as an uncompressed E32 image, then validates the resulting header and bounds.
"""
from __future__ import annotations

import argparse
import csv
import hashlib
import json
import struct
import subprocess
from collections import Counter
from pathlib import Path

DEFLATE_UID = 0x101F7AFC
BYTEPAIR_UID = 0x102822AA
SUPPORTED = {DEFLATE_UID, BYTEPAIR_UID}
MAX_E32_SIZE = 64 * 1024 * 1024
ELF2E32_REF = "ecfc39742dce03f3a5f4d83db18e8c1f395f3c47"


def u32(data: bytes, offset: int) -> int:
    if offset < 0 or offset + 4 > len(data):
        raise ValueError(f"u32 outside file at 0x{offset:X}")
    return struct.unpack_from("<I", data, offset)[0]


def parse_header(data: bytes) -> dict:
    if len(data) < 0x80 or data[0x10:0x14] != b"EPOC":
        raise ValueError("not a complete E32 image header")
    fields = {
        "uid1": u32(data, 0x00),
        "uid2": u32(data, 0x04),
        "uid3": u32(data, 0x08),
        "compression": u32(data, 0x1C),
        "flags": u32(data, 0x2C),
        "code_size": u32(data, 0x30),
        "data_size": u32(data, 0x34),
        "export_dir_offset": u32(data, 0x58),
        "export_count": u32(data, 0x5C),
        "code_offset": u32(data, 0x64),
        "data_offset": u32(data, 0x68),
        "import_offset": u32(data, 0x6C),
        "code_reloc_offset": u32(data, 0x70),
        "data_reloc_offset": u32(data, 0x74),
        "uncompressed_size": u32(data, 0x7C),
    }
    if fields["code_offset"] < 0x80 or fields["code_offset"] > len(data):
        raise ValueError("iCodeOffset is outside file")
    if fields["uncompressed_size"] > MAX_E32_SIZE:
        raise ValueError("iUncompressedSize exceeds safety limit")
    if fields["code_offset"] + fields["uncompressed_size"] > MAX_E32_SIZE:
        raise ValueError("expanded E32 size exceeds safety limit")
    return fields


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def validate_flat(source: bytes, output: bytes, expected_compression: int) -> dict:
    before = parse_header(source)
    after = parse_header(output)
    if before["compression"] != expected_compression:
        raise ValueError(
            f"TSV/header compression mismatch: 0x{expected_compression:08X} "
            f"!= 0x{before['compression']:08X}"
        )
    if after["compression"] != 0:
        raise ValueError(
            f"elf2e32 output is still compressed: 0x{after['compression']:08X}"
        )
    for key in ("uid1", "uid2", "uid3"):
        if before[key] != after[key]:
            raise ValueError(f"{key} changed during repack")
    if before["code_offset"] != after["code_offset"]:
        raise ValueError("iCodeOffset changed during repack")

    body_size = after["uncompressed_size"]
    if body_size == 0:
        body_size = after["code_size"] + after["data_size"]
    expected_size = after["code_offset"] + body_size
    aligned_size = (expected_size + 3) & ~3
    if len(output) not in (expected_size, aligned_size):
        raise ValueError(
            f"output length mismatch: got {len(output)}, expected "
            f"{expected_size} (or aligned {aligned_size})"
        )
    if after["code_size"] > len(output) - after["code_offset"]:
        raise ValueError("uncompressed code section exceeds output")
    if after["data_size"] and (
        after["data_offset"] > len(output)
        or after["data_size"] > len(output) - after["data_offset"]
    ):
        raise ValueError("uncompressed data section exceeds output")
    if after["import_offset"] and after["import_offset"] > len(output):
        raise ValueError("import table offset exceeds output")
    if after["export_dir_offset"] and after["export_dir_offset"] > len(output):
        raise ValueError("export directory offset exceeds output")

    return {
        "header_size": after["code_offset"],
        "uncompressed_size": body_size,
        "expected_size": expected_size,
        "output_size": len(output),
        "uid1": f"0x{after['uid1']:08X}",
        "uid2": f"0x{after['uid2']:08X}",
        "uid3": f"0x{after['uid3']:08X}",
        "code_size": after["code_size"],
        "data_size": after["data_size"],
        "export_count": after["export_count"],
        "import_offset": f"0x{after['import_offset']:08X}",
    }


def parse_trees(specs: list[str]) -> dict[str, Path]:
    result: dict[str, Path] = {}
    for spec in specs:
        if "=" not in spec:
            raise ValueError("--tree must be LABEL=PATH")
        label, path_text = spec.split("=", 1)
        if not label or any(
            c not in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789._-"
            for c in label
        ):
            raise ValueError(f"unsafe tree label: {label!r}")
        root = Path(path_text).resolve()
        if not root.is_dir():
            raise ValueError(f"source tree does not exist: {root}")
        if label in result:
            raise ValueError(f"duplicate tree label: {label}")
        result[label] = root
    return result


def select_rows(rows: list[dict], limit_per_compression: int) -> list[dict]:
    selected: list[dict] = []
    counts: Counter[int] = Counter()
    for row in rows:
        if row.get("status") != "COMPRESSED_UNDECODED":
            continue
        try:
            compression = int(row.get("compression_type", "0"), 16)
        except ValueError:
            continue
        if compression not in SUPPORTED:
            continue
        if limit_per_compression and counts[compression] >= limit_per_compression:
            continue
        counts[compression] += 1
        selected.append(row)
    return selected


def self_test() -> None:
    header_size = 0x9C
    body = bytes(range(16))
    image = bytearray(header_size + len(body))
    struct.pack_into("<III", image, 0, 0x10000079, 0x1000008D, 0xE000BEEF)
    image[0x10:0x14] = b"EPOC"
    struct.pack_into("<I", image, 0x1C, 0)
    struct.pack_into("<I", image, 0x2C, 0x02000001)
    struct.pack_into("<II", image, 0x30, len(body), 0)
    struct.pack_into("<I", image, 0x64, header_size)
    struct.pack_into("<I", image, 0x7C, len(body))
    image[header_size:] = body
    fields = parse_header(bytes(image))
    assert fields["compression"] == 0
    assert fields["code_offset"] == header_size
    assert validate_flat(bytes(image), bytes(image), 0)["output_size"] == len(image)
    assert len(select_rows([
        {"status": "COMPRESSED_UNDECODED", "compression_type": "0x101F7AFC"},
        {"status": "COMPRESSED_UNDECODED", "compression_type": "0x102822AA"},
        {"status": "PASS", "compression_type": "0x101F7AFC"},
    ], 1)) == 2
    print("Step117 native E32 decompression self-tests: PASS (3/3)")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--elf2e32", type=Path)
    parser.add_argument("--modules-tsv", type=Path)
    parser.add_argument("--tree", action="append", default=[], metavar="LABEL=PATH")
    parser.add_argument("--out-root", type=Path, default=Path("firmware-parsed/step117-native"))
    parser.add_argument("--report", type=Path, default=Path("firmware-input/STEP117_NATIVE_E32_DECOMPRESSION.md"))
    parser.add_argument("--limit-per-compression", type=int, default=1,
                        help="maximum candidates per compression UID; 0 means all")
    parser.add_argument("--timeout", type=int, default=120)
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()

    if args.self_test:
        self_test()
    if args.modules_tsv is None:
        return 0
    if args.elf2e32 is None or not args.elf2e32.is_file():
        parser.error("--elf2e32 must point to the built elf2e32 executable")
    if args.limit_per_compression < 0 or args.timeout <= 0:
        parser.error("limit must be non-negative and timeout must be positive")

    trees = parse_trees(args.tree)
    if not args.modules_tsv.is_file():
        raise SystemExit(f"Step109 module table is missing: {args.modules_tsv}")
    with args.modules_tsv.open(newline="", encoding="utf-8") as stream:
        rows = list(csv.DictReader(stream, delimiter="\t"))
    chosen = select_rows(rows, args.limit_per_compression)

    args.out_root.mkdir(parents=True, exist_ok=True)
    results: list[dict] = []
    for row in chosen:
        label = row["image"]
        relative = Path(row["path"])
        if label not in trees:
            results.append({
                "image": label, "path": row["path"], "compression": row.get("compression_type", ""),
                "status": "MISSING_TREE", "reason": f"no --tree mapping for {label}",
            })
            continue
        if relative.is_absolute() or ".." in relative.parts:
            results.append({
                "image": label, "path": row["path"], "compression": row.get("compression_type", ""),
                "status": "UNSAFE_PATH", "reason": "candidate path escapes its source tree",
            })
            continue

        source_path = trees[label] / relative
        output_path = args.out_root / label / relative
        output_path.parent.mkdir(parents=True, exist_ok=True)
        if source_path.is_symlink() or not source_path.is_file():
            results.append({
                "image": label, "path": row["path"], "compression": row.get("compression_type", ""),
                "status": "MISSING_SOURCE", "reason": str(source_path),
            })
            continue

        try:
            source = source_path.read_bytes()
            if len(source) > MAX_E32_SIZE:
                raise ValueError("compressed input exceeds safety limit")
            before = parse_header(source)
            compression = int(row["compression_type"], 16)
            if before["compression"] != compression:
                raise ValueError("Step109 compression UID does not match source header")
            if row.get("sha256") and sha256(source) != row["sha256"]:
                raise ValueError("source SHA-256 differs from Step109 inventory")
            if output_path.exists():
                output_path.unlink()

            command = [
                str(args.elf2e32.resolve()),
                f"--e32input={source_path.resolve()}",
                f"--output={output_path.resolve()}",
                "--compressionmethod=none",
            ]
            completed = subprocess.run(
                command, capture_output=True, text=True, timeout=args.timeout, check=False
            )
            if completed.returncode != 0:
                raise RuntimeError(
                    f"elf2e32 exit {completed.returncode}: "
                    f"{(completed.stderr or completed.stdout).strip()[:1200]}"
                )
            if not output_path.is_file():
                raise RuntimeError("elf2e32 returned success but produced no output")
            output = output_path.read_bytes()
            if len(output) > MAX_E32_SIZE:
                raise ValueError("decompressed output exceeds safety limit")
            validated = validate_flat(source, output, compression)
            results.append({
                "image": label,
                "path": row["path"],
                "compression": f"0x{compression:08X}",
                "status": "DECOMPRESSED",
                "input_size": len(source),
                "output_size": len(output),
                "output_sha256": sha256(output),
                "details": validated,
                "stdout": (completed.stdout or "").strip()[:500],
                "stderr": (completed.stderr or "").strip()[:500],
            })
        except Exception as exc:
            if output_path.exists():
                output_path.unlink()
            results.append({
                "image": label,
                "path": row["path"],
                "compression": row.get("compression_type", ""),
                "status": "FAILED",
                "reason": str(exc),
            })

    counts = Counter(item["status"] for item in results)
    by_compression = Counter(item.get("compression", "") for item in results)
    lines = [
        "# Step117 — Symbian-native E32 decompression probe",
        "",
        f"- Upstream tool: fedor4ever/elf2e32 at {ELF2E32_REF}",
        "- Invocation: elf2e32 --e32input=<candidate> --output=<flat-image> --compressionmethod=none",
        "- The Step109 Python zlib decoder is retained as a bounded structural pre-pass; it is not the Symbian E32 Deflate implementation.",
        f"- Candidate rows selected: **{len(chosen)}**",
        f"- Result counts: {dict(sorted(counts.items()))}",
        f"- Compression counts: {dict(sorted(by_compression.items()))}",
        "",
        "## Candidate results",
        "",
        "| Tree | Path | Compression UID | Result | Input bytes | Output bytes | Output SHA-256 / reason |",
        "|---|---|---:|---|---:|---:|---|",
    ]
    for item in results:
        detail = item.get("output_sha256") or item.get("reason", "")
        lines.append(
            f"| {item.get('image','')} | {item.get('path','')} | "
            f"{item.get('compression','')} | **{item.get('status','')}** | "
            f"{item.get('input_size','')} | {item.get('output_size','')} | {detail} |"
        )
    lines.extend([
        "",
        "## Interpretation limits",
        "",
        "- DECOMPRESSED means the upstream E32 parser produced a bounded, uncompressed E32 image and the UID/header-size checks passed.",
        "- The subsequent Step109 parser checks export/import bounds and IAT consistency for the decompressed sample.",
        "- This does not validate header CRC, relocation streams, Symbian loader acceptance, or physical-device compatibility.",
        "- Firmware inputs are read-only; output is written only under the temporary workflow workspace.",
        "",
    ])
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text("\n".join(lines), encoding="utf-8")
    (args.report.with_suffix(".json")).write_text(
        json.dumps({"counts": dict(counts), "results": results}, indent=2) + "\n",
        encoding="utf-8",
    )
    print(args.report.read_text(encoding="utf-8"))
    print(f"Step117 native E32 result counts: {dict(counts)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
