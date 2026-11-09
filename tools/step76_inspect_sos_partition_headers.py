#!/usr/bin/env python3
"""Inspect the SOS+ROFS/SOS+ROFX 1 KiB FPSX metadata blocks."""
from pathlib import Path
import hashlib
import re
import sys

pairs = [
    (Path("firmware-input/core-unpack.log"), Path("firmware-parsed/core/rofs.img"), "CORE"),
    (Path("firmware-input/ppm-unpack.log"), Path("firmware-parsed/ppm/rofs.img"), "PPM"),
]
pattern = re.compile(r"Description: (SOS\+ROFS|SOS\+ROFX)")
data_pattern = re.compile(r"Data block: (\d+):(\d+)")
lines_out = []

def dump(label, offset, data):
    lines_out.append(f"{label}: offset=0x{offset:X} length={len(data)} sha256={hashlib.sha256(data).hexdigest()}")
    for start in range(0, min(len(data), 512), 16):
        chunk = data[start:start+16]
        hx = " ".join(f"{b:02X}" for b in chunk)
        asc = "".join(chr(b) if 32 <= b < 127 else "." for b in chunk)
        lines_out.append(f"  +0x{start:04X}: {hx:<47}  {asc}")
    for magic in (b"ROFS", bytes.fromhex("a3959780"), b"SOS+ROFS", b"SOS+ROFX"):
        positions = []
        pos = 0
        while True:
            pos = data.find(magic, pos)
            if pos < 0:
                break
            positions.append(pos)
            pos += 1
        if positions:
            lines_out.append(f"  {magic!r} at " + ", ".join(f"0x{x:X}" for x in positions))

for log, image, label in pairs:
    lines_out.append(f"=== {label}: {log} / {image} ===")
    if not log.exists() or not image.exists():
        lines_out.append("missing input")
        continue
    pending = None
    matches = []
    for line in log.read_text(errors="backslashreplace").splitlines():
        m = pattern.search(line)
        if m:
            pending = m.group(1)
            continue
        if pending:
            dm = data_pattern.search(line)
            if dm:
                matches.append((pending, int(dm.group(1)), int(dm.group(2))))
                pending = None
    if not matches:
        lines_out.append("No SOS+ROFS/SOS+ROFX blocks identified")
        continue
    with image.open("rb") as f:
        for index, (desc, offset, length) in enumerate(matches):
            lines_out.append(f"Block {index}: description={desc} data_offset={offset} data_length={length}")
            for delta, amount, label2 in ((0, min(length, 1024), "metadata-block"),
                                          (1024, 512, "payload-after-metadata"),
                                          (0, 4096, "metadata-plus-payload")):
                f.seek(offset + delta)
                data = f.read(amount)
                dump(f"{label}/{index}/{label2}", offset + delta, data)
    lines_out.append("")
out = Path("firmware-input/STEP76_SOS_PARTITION_HEADERS.txt")
out.write_text("\n".join(lines_out) + "\n", encoding="utf-8")
print(out.read_text(encoding="utf-8"))
