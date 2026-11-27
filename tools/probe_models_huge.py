#!/usr/bin/env python3
"""Probe initial records in Shadowkey models.huge; partial forensic decoder."""
from __future__ import annotations
import csv, json, struct, sys
from pathlib import Path

def u16(data, offset):
    return struct.unpack_from("<H", data, offset)[0]

def s16_array(data, offset, count):
    return struct.unpack_from("<" + "h" * count, data, offset)

def write_bmp_rgb444(path, data, offset, width, height):
    """Decode 12-bit RGB444 words to a 24-bit BMP."""
    pixels = struct.unpack_from("<" + "H" * (width * height), data, offset)
    stride = (width * 3 + 3) & ~3
    body = bytearray()
    for y in range(height - 1, -1, -1):
        row = bytearray()
        for x in range(width):
            value = pixels[y * width + x]
            r = ((value >> 8) & 15) * 17
            g = ((value >> 4) & 15) * 17
            b = (value & 15) * 17
            row.extend((b, g, r))
        row.extend(bytes(stride - width * 3))
        body.extend(row)
    header = struct.pack("<2sIHHI", b"BM", 54 + len(body), 0, 0, 54)
    dib = struct.pack("<IiiHHIIiiII", 40, width, height, 1, 24, 0,
                      len(body), 2835, 2835, 0, 0)
    path.write_bytes(header + dib + body)

def export_points(path, values):
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

    r0 = {
        "record_start": 0,
        "header_u16": [u16(data, i) for i in range(0, 14, 2)],
        "coordinate_offset": 14,
        "coordinate_i16_count": 54,
        "texture_dimensions_offset": 0x2BC,
        "texture_width": u16(data, 0x2BC),
        "texture_height": u16(data, 0x2BE),
        "texture_pixels_offset": 0x2C0,
        "texture_format": "12-bit RGB444 candidate",
    }
    p0 = s16_array(data, 14, 54)
    export_points(out / "record0_coordinate_triplets.csv", p0)
    write_bmp_rgb444(out / "record0_texture_rgb444.bmp", data, 0x2C0, 32, 32)

    r1 = {
        "record_start": 0xAC0,
        "prefix_u32": struct.unpack_from("<I", data, 0xAC0)[0],
        "header_u16": [u16(data, 0xAC4 + 2 * i) for i in range(9)],
        "coordinate_offset": 0xAD4,
        "coordinate_i16_count": 51,
        "texture_dimensions_offset": 0xD7E,
        "texture_width": u16(data, 0xD7E),
        "texture_height": u16(data, 0xD80),
        "metadata_offset": 0xD82,
        "metadata_bytes": data[0xD82:0xD96].decode("ascii", errors="replace"),
        "texture_pixels_offset": 0xD96,
        "texture_format": "12-bit RGB444 candidate",
    }
    p1 = s16_array(data, 0xAD4, 51)
    export_points(out / "record1_coordinate_triplets.csv", p1)
    write_bmp_rgb444(out / "record1_texture_rgb444.bmp", data, 0xD96, 64, 64)

    pix0 = struct.unpack_from("<1024H", data, 0x2C0)
    pix1 = struct.unpack_from("<4096H", data, 0xD96)
    report = {
        "file_size": len(data),
        "records": [r0, r1],
        "confirmed_observations": [
            "Record 0 has 32x32 16-bit pixel storage at 0x2C0; its end is exactly 0xAC0, the next sample's record start.",
            "Record 1 has 64x64 16-bit pixel storage beginning at 0xD96, after a 20-byte metadata/name area.",
            "All sample texture words fit in 12 bits (0..0xFFF); RGB444 produces recognizable foliage-like imagery.",
            "The coordinate payloads contain 54 and 51 signed 16-bit values, divisible by three."
        ],
        "texture_value_stats": {
            "record0_unique_words": len(set(pix0)),
            "record0_0xF0F_count": sum(v == 0xF0F for v in pix0),
            "record1_unique_words": len(set(pix1)),
            "record1_zero_count": sum(v == 0 for v in pix1)
        },
        "unverified": [
            "RGB444 channel ordering and alpha/transparency key semantics are not confirmed.",
            "Coordinate triples may be positions, but axes and scale are unknown.",
            "The complete vertex/index/material layout and model-name mapping are not decoded."
        ]
    }
    (out / "report.json").write_text(json.dumps(report, indent=2), encoding="utf-8")
    print(json.dumps(report, indent=2))

if __name__ == "__main__":
    main()
