#!/usr/bin/env python3
"""Decode Shadowkey's length-prefixed zlib resource containers.

Several zone resources begin with a little-endian uint32 uncompressed length,
followed by a standard zlib stream. This tool preserves originals and writes
decoded siblings with a .raw suffix. Unknown/non-matching files are skipped.
"""
from __future__ import annotations
import argparse
import pathlib
import struct
import zlib

CANDIDATE_SUFFIXES = {".zmp", ".ztx", ".zlu", ".zfg", ".zsk", ".zcp"}

def decode(path: pathlib.Path) -> tuple[bool, str]:
    data = path.read_bytes()
    if len(data) < 6:
        return False, "too short"
    expected = struct.unpack_from("<I", data, 0)[0]
    if data[4:6] != b"\x78\x9c":
        return False, "no zlib 78 9c signature at offset 4"
    try:
        decoded = zlib.decompress(data[4:])
    except zlib.error as exc:
        return False, f"zlib error: {exc}"
    if len(decoded) != expected:
        return False, f"length mismatch: header={expected}, decoded={len(decoded)}"
    out = path.with_name(path.name + ".raw")
    out.write_bytes(decoded)
    return True, f"{len(data)} -> {len(decoded)} bytes: {out.name}"

def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("root", type=pathlib.Path, help="game asset root or a zone folder")
    args = ap.parse_args()
    files = sorted(p for p in args.root.rglob("*") if p.is_file() and p.suffix.lower() in CANDIDATE_SUFFIXES)
    ok = skipped = failed = 0
    for path in files:
        try:
            success, message = decode(path)
            print(("OK " if success else "SKIP ") + str(path) + ": " + message)
            ok += int(success)
            skipped += int(not success)
        except OSError as exc:
            print("ERROR " + str(path) + ": " + str(exc))
            failed += 1
    print(f"\nSummary: decoded={ok}, skipped={skipped}, errors={failed}")
    return 1 if failed else 0

if __name__ == "__main__":
    raise SystemExit(main())
