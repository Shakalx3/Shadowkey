#!/usr/bin/env python3
"""Read-only EKA1 E32 header and relocation-boundary audit for 6R51.APP."""
from __future__ import annotations
import argparse, json, struct
from pathlib import Path

def u32(b, o):
    return struct.unpack_from("<I", b, o)[0]

def word_sum(b):
    b += b"\0" * ((-len(b)) & 3)
    if not b:
        return 0
    return sum(struct.unpack("<" + "I" * (len(b) // 4), b)) & 0xffffffff

def reloc_header(b, off):
    if off == 0:
        return {"present": False, "offset": 0}
    if off < 0 or off + 8 > len(b):
        return {"present": True, "offset": off, "valid_bounds": False}
    size, count = struct.unpack_from("<II", b, off)
    return {
        "present": True, "offset": off, "available": len(b) - off,
        "size_candidate": size, "relocation_count_candidate": count,
        "size_candidate_in_file": 8 <= size <= len(b) - off,
        "first_16_bytes": b[off:off+16].hex()
    }

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--game", type=Path, required=True)
    ap.add_argument("--out-dir", type=Path, required=True)
    a = ap.parse_args()
    b = a.game.read_bytes()
    if len(b) < 0x7c or b[0x10:0x14] != b"EPOC":
        raise SystemExit("not a complete EPOC-signed E32 image")

    # Legacy EKA1 E32ImageHeader field offsets.
    h = {
        "uid1": f"0x{u32(b,0):08X}", "uid2": f"0x{u32(b,4):08X}",
        "uid3": f"0x{u32(b,8):08X}", "uid_checksum": f"0x{u32(b,12):08X}",
        "cpu": f"0x{u32(b,0x14):08X}",
        "code_checksum": f"0x{u32(b,0x18):08X}",
        "data_checksum": f"0x{u32(b,0x1c):08X}",
        "version": f"0x{u32(b,0x20):08X}",
        "time_lo": f"0x{u32(b,0x24):08X}", "time_hi": f"0x{u32(b,0x28):08X}",
        "flags": f"0x{u32(b,0x2c):08X}",
        "code_size": u32(b,0x30), "data_size": u32(b,0x34),
        "text_size": u32(b,0x60), "code_offset": u32(b,0x64),
        "data_offset": u32(b,0x68), "import_offset": u32(b,0x6c),
        "code_reloc_offset": u32(b,0x70), "data_reloc_offset": u32(b,0x74),
        "priority_raw": f"0x{u32(b,0x78):08X}", "file_size": len(b)
    }
    co, cs, ts = h["code_offset"], h["code_size"], h["text_size"]
    do, ds, io = h["data_offset"], h["data_size"], h["import_offset"]
    checks = {
        "arm_cpu_marker": u32(b,0x14) == 0x2000,
        "legacy_header_size_0x7c": co == 0x7c,
        "code_range_in_file": co <= len(b) and cs <= len(b)-co,
        "text_fits_code": ts <= cs,
        "code_ends_at_import": co + cs == io,
        "data_range_in_file": ds == 0 or (do <= len(b) and ds <= len(b)-do),
        "import_offset_in_file": io <= len(b)-4
    }
    imp_size = u32(b,io) if checks["import_offset_in_file"] else 0
    checks["import_table_in_file"] = 4 <= imp_size <= len(b)-io
    imp_end = io + imp_size if checks["import_table_in_file"] else 0

    code_sums = {}
    if checks["code_range_in_file"]:
        code_sums["text_size"] = f"0x{word_sum(b[co:co+ts]):08X}"
        code_sums["code_size"] = f"0x{word_sum(b[co:co+cs]):08X}"
        if imp_end:
            code_sums["through_import_end"] = f"0x{word_sum(b[co:imp_end]):08X}"
    data_sum = word_sum(b[do:do+ds]) if ds and checks["data_range_in_file"] else 0
    stored_code, stored_data = u32(b,0x18), u32(b,0x1c)
    code_reloc = reloc_header(b,h["code_reloc_offset"])
    data_reloc = reloc_header(b,h["data_reloc_offset"])

    result = {
        "format": "read-only legacy EKA1 E32 header audit",
        "game": str(a.game), "header": h, "structural_checks": checks,
        "checksums": {
            "stored_code": f"0x{stored_code:08X}", "code_sum_candidates": code_sums,
            "code_match": any(int(v,16)==stored_code for v in code_sums.values()),
            "stored_data": f"0x{stored_data:08X}", "computed_data": f"0x{data_sum:08X}",
            "data_match": stored_data == data_sum
        },
        "import_table": {"offset": io, "size": imp_size, "end": imp_end,
                         "trailing_bytes": len(b)-imp_end if imp_end else None},
        "relocations": {"code": code_reloc, "data": data_reloc},
        "header_words": [{"offset": f"0x{x:02X}", "value": f"0x{u32(b,x):08X}"}
                         for x in range(0,0x7c,4)],
        "header_hex": b[:0x80].hex(), "patch_authorized": False
    }
    required = all(checks.values())
    result["status"] = "STRUCTURE_PASS_CHECKSUM_REVIEW" if required else "STRUCTURE_FAIL"
    a.out_dir.mkdir(parents=True,exist_ok=True)
    (a.out_dir/"STEP104_EKA1_HEADER_AUDIT.json").write_text(json.dumps(result,indent=2)+"\n")
    lines = [
        "# Step104 — legacy EKA1 E32 header audit", "",
        "Read-only; 6R51.APP is not modified.", "",
        f"- Status: {result['status']}",
        f"- CPU at 0x14: {h['cpu']}; code checksum at 0x18: {h['code_checksum']}",
        f"- Computed code sums: {code_sums}",
        f"- Data checksum stored/computed: {h['data_checksum']} / 0x{data_sum:08X}",
        f"- Code offset/size/text size: 0x{co:X} / {cs} / {ts}",
        f"- Import offset/size/end: 0x{io:X} / {imp_size} / 0x{imp_end:X}",
        f"- EKA1 code relocation offset (0x70): 0x{h['code_reloc_offset']:08X}",
        f"- EKA1 data relocation offset (0x74): 0x{h['data_reloc_offset']:08X}",
        f"- Raw priority word at 0x78: {h['priority_raw']}", "",
        "## Relocation headers", "", f"- Code: {code_reloc}", f"- Data: {data_reloc}", "",
        "## Structural checks", ""
    ]
    lines += [f"- {k}: {v}" for k,v in checks.items()]
    lines += ["", "## Header words", "",
              " ".join(f"{u32(b,x):08X}" for x in range(0,0x7c,4)),
              "", "## Safety", "",
              "- EKA1 relocation fields at 0x70 and 0x74 are offsets, not EKA2 offset/size pairs.",
              "- The word at 0x78 is not treated as a relocation offset.",
              "- A structural pass does not authorize patching; checksum coverage and relocation encoding still require review.",
              "- No import, code, relocation, or header bytes are changed.", ""]
    report = "\n".join(lines)
    (a.out_dir/"STEP104_EKA1_HEADER_AUDIT.md").write_text(report)
    print(report)
    print(json.dumps(result,indent=2))
    return 0 if required else 2

if __name__ == "__main__":
    raise SystemExit(main())
