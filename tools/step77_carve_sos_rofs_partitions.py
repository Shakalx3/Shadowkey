#!/usr/bin/env python3
"""Carve SOS+ROFS/ROFX blocks from sparse FPSX flash images.

The SOS descriptor stores a 1 KiB BB5 wrapper at its flash offset. The
following FPSX data blocks are contiguous and contain the filesystem payload.
This script follows those block extents from the unpacker log and preserves
the wrapper so unpacker can apply its BB5 +0x400 handling.
"""
from pathlib import Path
import hashlib
import re
import sys

BLOCK_RE = re.compile(r"Block #(\d+):\s*(.*?)(?=\nBlock #|\Z)", re.S)
DESC_RE = re.compile(r"Description: (SOS\+ROFS|SOS\+ROFX|SOS\+CORE)")
DATA_RE = re.compile(r"Data block: (\d+):(\d+)")


def parse_blocks(log_path):
    text = log_path.read_text(errors="backslashreplace")
    blocks = []
    for m in BLOCK_RE.finditer(text):
        body = m.group(2)
        dm = DATA_RE.search(body)
        if not dm:
            continue
        desc = DESC_RE.search(body)
        blocks.append({
            "number": int(m.group(1)),
            "description": desc.group(1) if desc else None,
            "offset": int(dm.group(1)),
            "length": int(dm.group(2)),
        })
    return blocks


def main():
    root = Path("firmware-parsed")
    jobs = [
        ("core", "core-unpack.log", "core/rofs.img", "SOS+ROFS"),
        ("rom", "core-unpack.log", "core/rofs.img", "SOS+CORE"),
        ("ppm", "ppm-unpack.log", "ppm/rofs.img", "SOS+ROFX"),
    ]
    report = []
    for name, log_name, image_name, wanted in jobs:
        log = Path("firmware-input") / log_name
        image = root / image_name
        if not log.exists() or not image.exists():
            report.append(f"{name}: missing log or image")
            continue
        blocks = parse_blocks(log)
        descriptors = [b for b in blocks if b["description"] == wanted]
        if not descriptors:
            report.append(f"{name}: no {wanted} descriptor")
            continue
        # Repeated descriptor records refer to the same metadata page.
        desc = descriptors[0]
        start = desc["offset"]
        payload_start = start + desc["length"]
        spans = sorted({(b["offset"], b["length"]) for b in blocks
                        if b["description"] is None and b["offset"] >= payload_start})
        end = payload_start
        used = []
        for off, length in spans:
            if off < end:
                if off + length > end:
                    end = off + length
                    used.append((off, length))
            elif off == end:
                end = off + length
                used.append((off, length))
            else:
                break
        if end <= payload_start:
            report.append(f"{name}: no contiguous payload blocks after 0x{start:X}")
            continue
        if end > image.stat().st_size:
            report.append(f"{name}: computed end 0x{end:X} exceeds image size 0x{image.stat().st_size:X}")
            continue
        outdir = root / "carved"
        outdir.mkdir(parents=True, exist_ok=True)
        extension = ".img" if wanted == "SOS+CORE" else ".rofs"
        out = outdir / f"{name}-{wanted.lower().replace('+', '-')}{extension}"
        with image.open("rb") as src, out.open("wb") as dst:
            src.seek(start)
            remaining = end - start
            digest = hashlib.sha256()
            while remaining:
                chunk = src.read(min(1024 * 1024, remaining))
                if not chunk:
                    raise IOError(f"unexpected EOF at {start + (end-start-remaining):#x}")
                dst.write(chunk)
                digest.update(chunk)
                remaining -= len(chunk)
        with out.open("rb") as f:
            wrapper = f.read(1040)
        report.append(
            f"{name}: description={wanted} descriptor_count={len(descriptors)} "
            f"start=0x{start:X} payload=0x{payload_start:X} end=0x{end:X} "
            f"partition_bytes={out.stat().st_size} contiguous_data_blocks={len(used)} "
            f"magic0={wrapper[:4].hex()} magic400={wrapper[1024:1028]!r} "
            f"sha256={digest.hexdigest()} output={out}"
        )
    text = "\n".join(report) + "\n"
    Path("firmware-input/STEP77_CARVED_PARTITIONS.txt").write_text(text, encoding="utf-8")
    print(text, end="")


if __name__ == "__main__":
    main()
