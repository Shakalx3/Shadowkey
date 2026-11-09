#!/usr/bin/env python3
"""Locate embedded ROFS/BB5 headers in sparse images emitted by unpacker.

The FPSX parser writes flash blocks at their target offsets. Therefore rofs.img
may be a sparse flash-address image rather than a filesystem image beginning
at byte zero. This scanner records signatures and carves bounded candidates
without modifying the source image.
"""
from pathlib import Path
import argparse
import hashlib

MAGICS = {
    "ROFS": b"ROFS",                 # ROFS_MAGIC as readIntLE()
    "BB5_COMMON": bytes.fromhex("a3959780"),  # 0x809795A3 as little-endian
}

def all_offsets(data: bytes, needle: bytes):
    start = 0
    while True:
        pos = data.find(needle, start)
        if pos < 0:
            return
        yield pos
        start = pos + 1

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("images", nargs="+")
    ap.add_argument("--out", required=True)
    args = ap.parse_args()
    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)
    report = ["image\tsize\tsha256\tsignature\toffset\tcandidate"]
    for name in args.images:
        p = Path(name)
        data = p.read_bytes()
        digest = hashlib.sha256(data).hexdigest()
        found = []
        for label, magic in MAGICS.items():
            found.extend((pos, label) for pos in all_offsets(data, magic))
        found.sort()
        if not found:
            report.append(f"{p}\t{len(data)}\t{digest}\tNONE\t-\t")
        for index, (pos, label) in enumerate(found):
            candidate = out / f"{p.parent.name}_{label}_{pos:08x}_{index}.img"
            candidate.write_bytes(data[pos:])
            report.append(f"{p}\t{len(data)}\t{digest}\t{label}\t{pos}\t{candidate}")
    Path("firmware-input/ROFS_SIGNATURE_SCAN.tsv").write_text("\n".join(report) + "\n")
    print("\n".join(report))

if __name__ == "__main__":
    main()
