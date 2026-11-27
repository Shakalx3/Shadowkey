#!/usr/bin/env python3
"""Export candidate mesh tables from the first models.huge record."""
import csv, json, struct, sys
from pathlib import Path

def main():
    if len(sys.argv) != 2:
        raise SystemExit("usage: inspect_models_huge_record0.py ZONE_DIRECTORY")
    zone = Path(sys.argv[1])
    data = (zone / "models.huge").read_bytes()
    if len(data) < 0xAC0:
        raise ValueError("models.huge is shorter than the first record")
    out = zone / "models_huge_probe"
    out.mkdir(exist_ok=True)

    coords = struct.unpack_from("<54h", data, 0x0E)
    uv = struct.unpack_from(">144H", data, 0x7A)
    indices = struct.unpack_from("<147H", data, 0x19A)
    if max(indices) >= 72:
        raise ValueError("candidate triangle index exceeds 72-pair table")

    with (out / "record0_coordinate_triplets.csv").open("w", newline="") as f:
        w = csv.writer(f); w.writerow(("vertex_or_vector", "x_raw", "y_raw", "z_raw"))
        for i in range(18): w.writerow((i, *coords[i*3:i*3+3]))
    with (out / "record0_uv_pairs.csv").open("w", newline="") as f:
        w = csv.writer(f); w.writerow(("uv_index", "u_raw", "v_raw"))
        for i in range(72): w.writerow((i, uv[i*2], uv[i*2+1]))
    with (out / "record0_triangle_indices.csv").open("w", newline="") as f:
        w = csv.writer(f); w.writerow(("triangle", "index_a", "index_b", "index_c"))
        for i in range(49): w.writerow((i, *indices[i*3:i*3+3]))

    report = {
        "record0_range": ["0x0000", "0x0ABF"],
        "header_u16_le": list(struct.unpack_from("<7H", data, 0)),
        "coordinate_table": {"offset": "0x000E", "count": 18, "components": 3,
                             "type": "signed i16 little-endian"},
        "two_component_table": {"offset": "0x007A", "count": 72, "components": 2,
                                "type": "u16 big-endian", "range": [min(uv), max(uv)],
                                "unique_pairs": len(set(zip(uv[::2], uv[1::2])))},
        "triangle_table": {"offset": "0x019A", "triangles": 49,
                           "type": "u16 little-endian", "index_range": [min(indices), max(indices)],
                           "indices_fit_72_pair_table": max(indices) < 72},
        "image": {"dimensions_offset": "0x02BC", "width": struct.unpack_from("<H", data, 0x2BC)[0],
                  "height": struct.unpack_from("<H", data, 0x2BE)[0],
                  "pixels_offset": "0x02C0", "end_offset": "0x0AC0"},
        "unresolved": [
            "The relationship between the 18 triples and 72 indexed pairs is unknown.",
            "The two-component values may be UV coordinates but this is not validated.",
            "The image's RGB444 interpretation is a candidate, not a confirmed engine format.",
            "The record-to-model-slot mapping is unknown."
        ]
    }
    (out / "record0_mesh_table_report.json").write_text(json.dumps(report, indent=2))
    print(json.dumps(report, indent=2))

if __name__ == "__main__":
    main()
