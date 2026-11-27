#!/usr/bin/env python3
"""Export the Crypt3 indexed texture using its companion 256xRGB palette."""
from __future__ import annotations
import argparse
import pathlib
import struct

WIDTH = 768
HEIGHT = 384

def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("zone", type=pathlib.Path)
    args = ap.parse_args()
    root = args.zone
    raw = (root / "Crypt3.ztx.raw").read_bytes()
    palette = (root / "Crypt3.pal").read_bytes()
    if len(raw) != 1 + WIDTH * HEIGHT:
        raise ValueError(f"Unexpected ztx size: {len(raw)}; expected {1 + WIDTH * HEIGHT}")
    if len(palette) != 256 * 3:
        raise ValueError(f"Unexpected palette size: {len(palette)}; expected 768")
    pixels = raw[1:]
    # BMP stores rows bottom-up and palette entries as B,G,R,reserved.
    rows = b"".join(
        pixels[y * WIDTH:(y + 1) * WIDTH]
        for y in range(HEIGHT - 1, -1, -1)
    )
    bmp_palette = b"".join(
        bytes((palette[i + 2], palette[i + 1], palette[i], 0))
        for i in range(0, len(palette), 3)
    )
    offset = 14 + 40 + len(bmp_palette)
    image_size = len(rows)
    file_size = offset + image_size
    file_header = struct.pack("<2sIHHI", b"BM", file_size, 0, 0, offset)
    dib_header = struct.pack(
        "<IiiHHIIiiII", 40, WIDTH, HEIGHT, 1, 8, 0,
        image_size, 2835, 2835, 256, 256
    )
    out = root / "Crypt3_texture_atlas.bmp"
    out.write_bytes(file_header + dib_header + bmp_palette + rows)
    print(f"Exported {out.name}: {WIDTH}x{HEIGHT}, indexed 8-bit, palette=256 RGB entries")
    print("The leading 0x12 byte in .ztx is omitted from the pixel plane; its meaning is not yet known.")

if __name__ == "__main__":
    main()
