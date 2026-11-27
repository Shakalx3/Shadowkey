#!/usr/bin/env python3
"""Inspect the model offset/index table and correlate it with models.huge."""
import json, struct, sys
from pathlib import Path

def main():
    zone = Path(sys.argv[1])
    idx = (zone / "models.idx").read_bytes()
    huge = (zone / "models.huge").read_bytes()
    report = {
        "models_idx_size": len(idx),
        "models_huge_size": len(huge),
        "first_bytes": idx[:64].hex(" "),
        "candidate_u32_le": list(struct.unpack_from("<" + "I" * (len(idx)//4), idx, 0))[:80],
        "candidate_u16_le": list(struct.unpack_from("<" + "H" * (len(idx)//2), idx, 0))[:120],
        "candidate_u32_be": list(struct.unpack_from(">" + "I" * (len(idx)//4), idx, 0))[:80],
    }
    # Test candidate offset arrays in both common byte orders.
    candidates = {}
    for endian in ("<", ">"):
        vals = struct.unpack_from(endian + "I" * (len(idx)//4), idx, 0)
        valid = [v for v in vals if 0 <= v < len(huge)]
        monotonic = sum(a < b for a,b in zip(vals, vals[1:]))
        aligned = sum(v % 4 == 0 for v in vals)
        candidates[endian] = {
            "count": len(vals), "in_file_range": len(valid),
            "strictly_increasing_pairs": monotonic, "four_byte_aligned": aligned,
            "first_30": list(vals[:30]),
            "first_30_hex": [hex(v) for v in vals[:30]]
        }
    report["offset_hypotheses"] = candidates
    # Locate all plausible absolute/relative offset values at 4-byte alignment.
    hits = []
    for endian in ("<", ">"):
        vals = struct.unpack_from(endian + "I" * (len(idx)//4), idx, 0)
        for i,v in enumerate(vals):
            if 0 < v < len(huge) and huge[v:v+2] in (b"\x01\x00", b"\x07\x00"):
                hits.append({"endian": endian, "index": i, "offset": v,
                             "prefix": huge[v:v+16].hex(" ")})
    report["candidate_record_starts"] = hits[:100]
    (zone / "models_huge_probe" / "models_idx_report.json").write_text(
        json.dumps(report, indent=2), encoding="utf-8")
    print(json.dumps(report, indent=2))

if __name__ == "__main__":
    main()
