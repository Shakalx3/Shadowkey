#!/usr/bin/env python3
"""Find and validate embedded Nokia ROFS/BB5 filesystem images.

The FPSX parser writes flash blocks at target offsets, so its rofs.img may be a
sparse flash-address image. This scanner validates ROFS header geometry before
carving; raw signature hits are reported but are not passed to the extractor.
"""
from pathlib import Path
import argparse
import hashlib
import struct

ROFS = b"ROFS"
BB5_COMMON = bytes.fromhex("a3959780")


def all_offsets(data: bytes, needle: bytes):
    start = 0
    while True:
        pos = data.find(needle, start)
        if pos < 0:
            return
        yield pos
        start = pos + 1


def rofs_header(data: bytes, pos: int):
    """Return (valid, image_size, reason) for a ROFS header at pos."""
    if pos + 48 > len(data):
        return False, 0, "truncated-header"
    header_size = data[pos + 4]
    if header_size < 48 or pos + header_size > len(data):
        return False, 0, f"bad-header-size-{header_size}"
    tree_off, tree_size, entries_off, entries_size = struct.unpack_from(
        "<IIII", data, pos + 8
    )
    image_size = struct.unpack_from(">I", data, pos + 36)[0]
    max_image_size = struct.unpack_from(">I", data, pos + 44)[0]
    if image_size < header_size or image_size > len(data) - pos:
        return False, image_size, f"bad-image-size-{image_size}"
    if tree_off < 48 or tree_size == 0 or tree_off + tree_size > image_size:
        return False, image_size, "bad-directory-tree-range"
    if entries_size and (entries_off < 48 or entries_off + entries_size > image_size):
        return False, image_size, "bad-file-entry-range"
    if max_image_size and max_image_size < image_size:
        return False, image_size, "max-image-size-smaller-than-image"
    return True, image_size, "valid"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("images", nargs="+")
    ap.add_argument("--out", required=True)
    args = ap.parse_args()
    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)
    report = ["image\tsize\tsha256\tsignature\toffset\tvalidation\timage_size\tcandidate"]
    for name in args.images:
        p = Path(name)
        data = p.read_bytes()
        digest = hashlib.sha256(data).hexdigest()
        hits = []
        hits.extend((pos, "ROFS") for pos in all_offsets(data, ROFS))
        hits.extend((pos, "BB5_COMMON") for pos in all_offsets(data, BB5_COMMON))
        hits.sort()
        accepted = 0
        for pos, label in hits:
            candidate = ""
            image_size = 0
            status = "signature-only"
            start = pos
            length = len(data) - pos
            suffix = ".img"
            if label == "ROFS":
                valid, image_size, status = rofs_header(data, pos)
                if valid:
                    length = image_size
                    suffix = ".rofs"
            else:
                nested = pos + 1024
                if nested + 48 <= len(data) and data[nested:nested + 4] == ROFS:
                    valid, image_size, status = rofs_header(data, nested)
                    if valid:
                        # Keep the BB5 wrapper because unpacker expects its magic
                        # at byte zero and locates the ROFS payload at +1024.
                        length = min(len(data) - pos, 1024 + image_size)
                    else:
                        status = "BB5-wrapper/" + status
                else:
                    status = "no-ROFS-at-plus-1024"
            if status == "valid":
                accepted += 1
                candidate_path = out / f"{p.parent.name}_{label}_{pos:08x}_{accepted}{suffix}"
                candidate_path.write_bytes(data[start:start + length])
                candidate = str(candidate_path)
            report.append(
                f"{p}\t{len(data)}\t{digest}\t{label}\t{pos}\t{status}\t{image_size}\t{candidate}"
            )
        if not hits:
            report.append(f"{p}\t{len(data)}\t{digest}\tNONE\t-\tno-signatures\t0\t")
    text = "\n".join(report) + "\n"
    Path("firmware-input/ROFS_SIGNATURE_SCAN.tsv").write_text(text, encoding="utf-8")
    print(text, end="")


if __name__ == "__main__":
    main()
