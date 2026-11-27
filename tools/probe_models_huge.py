#!/usr/bin/env python3
"""Probe the first two records in Shadowkey's models.huge.

Only the two sample layouts documented in the accompanying checkpoint are
handled. Coordinate triples and RGB565 texture decoding are explicitly
provisional; this is a forensic exporter, not a complete model decoder.
"""
from __future__ import annotations
import csv
import json
import struct
import sys
from pathlib import Path


def u16(data: bytes, offset: int) -> int:
    return struct.unpack_from("<H", data, offset)[0]


def s16_array(data: bytes, offset: int, count: int):
    return struct.unpack_from("<" + "h" * count, data, offset)


def write_bmp_rgb565(path: Path, data: bytes, offset: int, width: int, height: int):
    pixels = struct.unpack_from("<" + "H" * (width * height), data, offset)
    stride = (width * 3 + 3) & ~3
    body = bytearray()
    for y in range(height - 1, -1, -1):
        row = bytearray()
        for x in range(width):
            value = pixels[y * width + x]
            r = ((value >> 11) & 31) * 255 // 31
            g = ((value >> 5) & 63) * 255 // 63
            b = (value & 31) * 255 // 31
            row.extend((b, g, r))
        row.extend(b"\\x00" * (stride - width * 3))
        body.extend(row)
    header = struct.pack("<2sIHHI", b"BM", 54 + len(body), 0, 0, 54)
    dib = struct.pack("<IiiHHIIiiII", 40, width, height, 1, 24, 0,
                      len(body), 2835, 2835, 0, 0)
    path.write_bytes(header + dib + body)


def export_points(path: Path, values):
    with path.open("w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(("point", "x_raw", "y_raw", "z_raw"))
        for i in range(len(values) // 3):
            w.writerow((i, *values[i * 3:i * 3 + 3]))


def main():
    if len(sys.argv) != 2:
        raise SystemExit("usage: probe_models_huge.py ZONE_DIRECTORY")
    zone = Path(sys.argv[1])
    data = (zone / "models.huge").read_bytes()
    out = zone / "models_huge_probe"
    out.mkdir(exist_ok=True)

    # Record 0: initial header followed by 18 coordinate triplets.
    r0 = {
        "record_start": 0,
        "header_offset": 0,
        "header_u16": [u16(data, i) for i in range(0, 14, 2)],
        "coordinate_offset": 14,
        "coordinate_i16_count": 54,
        "texture_dimensions_offset": 0x2BC,
        "texture_width": u16(data, 0x2BC),
        "texture_height": u16(data, 0x2BE),
        "texture_pixels_offset": 0x2C0,
        "texture_format": "RGB565 candidate, not yet confirmed",
    }
    p0 = s16_array(data, r0["coordinate_offset"], 54)
    export_points(out / "record0_coordinate_triplets.csv", p0)
    write_bmp_rgb565(out / "record0_texture_rgb565_candidate.bmp", data,
                     r0["texture_pixels_offset"], 32, 32)

    # Record 1: 32-bit prefix, nine u16 header fields, then 17 triplets.
    r1 = {
        "record_start": 0xAC0,
        "prefix_u32": struct.unpack_from("<I", data, 0xAC0)[0],
        "header_offset": 0xAC4,
        "header_u16": [u16(data, 0xAC4 + 2 * i) for i in range(9)],
        "coordinate_offset": 0xAD4,
        "coordinate_i16_count": 51,
        "texture_dimensions_offset": 0xD7E,
        "texture_width": u16(data, 0xD7E),
        "texture_height": u16(data, 0xD80),
        "texture_pixels_offset": 0xD82,
        "texture_format": "RGB565 candidate, not yet confirmed",
    }
    p1 = s16_array(data, r1["coordinate_offset"], 51)
    export_points(out / "record1_coordinate_triplets.csv", p1)
    write_bmp_rgb565(out / "record1_texture_rgb565_candidate.bmp", data,
                     r1["texture_pixels_offset"], 64, 64)

    report = {
        "file_size": len(data),
        "records": [r0, r1],
        "confirmed_observations": [
            "The first sample contains 54 consecutive signed 16-bit values after its 7-word header.",
            "The second sample begins at 0xAC0 with a 32-bit value of 1 and a 9-word header.",
            "The coordinate payloads contain 54 and 51 signed 16-bit values respectively, divisible by three.",
            "The first two embedded image payloads are consistent with 32x32x16-bit and 64x64x16-bit storage."
        ],
        "unverified": [
            "Coordinate triples may be positions, but axis order and scale are unknown.",
            "RGB565 is only a visual decoding candidate; pixel format and alpha behavior are unconfirmed.",
            "The complete vertex/index/material layout and record boundaries are not yet decoded."
        ]
    }
    (out / "report.json").write_text(json.dumps(report, indent=2), encoding="utf-8")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
