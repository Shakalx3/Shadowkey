#!/usr/bin/env python3
"""Inspect the original 6R51.APP E32 header and verify its import/IAT layout."""
import argparse
import csv
import json
import struct
from pathlib import Path

def u32(data, off):
    return struct.unpack_from("<I", data, off)[0]

def cstr(data, off):
    end = data.find(b"\0", off)
    if end < 0:
        raise ValueError(f"unterminated import DLL name at file offset 0x{off:X}")
    return data[off:end].decode("ascii", "replace")

def inspect(path):
    data = path.read_bytes()
    if len(data) < 0x7C or data[0x10:0x14] != b"EPOC":
        raise ValueError("6R51.APP is not a plain E32 image with EPOC signature")
    h = {
        "file": str(path),
        "file_size": len(data),
        "uid1": f"0x{u32(data,0):08X}",
        "uid2": f"0x{u32(data,4):08X}",
        "uid3": f"0x{u32(data,8):08X}",
        "header_crc": f"0x{u32(data,0x14):08X}",
        "module_version": f"0x{u32(data,0x18):08X}",
        "compression_type": f"0x{u32(data,0x1C):08X}",
        "tools_version": f"0x{u32(data,0x20):08X}",
        "time_lo": f"0x{u32(data,0x24):08X}",
        "time_hi": f"0x{u32(data,0x28):08X}",
        "flags": f"0x{u32(data,0x2C):08X}",
        "code_size": u32(data,0x30),
        "data_size": u32(data,0x34),
        "heap_min": u32(data,0x38),
        "heap_max": u32(data,0x3C),
        "stack_size": u32(data,0x40),
        "bss_size": u32(data,0x44),
        "entry_point": f"0x{u32(data,0x48):08X}",
        "code_base": f"0x{u32(data,0x4C):08X}",
        "data_base": f"0x{u32(data,0x50):08X}",
        "dll_ref_count": u32(data,0x54),
        "export_dir_offset": u32(data,0x58),
        "export_count": u32(data,0x5C),
        "text_size": u32(data,0x60),
        "code_offset": u32(data,0x64),
        "data_offset": u32(data,0x68),
        "import_offset": u32(data,0x6C),
        "code_reloc_offset": u32(data,0x70),
        "code_reloc_size": u32(data,0x74),
        "data_reloc_offset": u32(data,0x78),
    }
    h["module_kind"] = {
        "0x10000079": "DLL",
        "0x1000007A": "EXE",
    }.get(h["uid1"].lower(), "UNKNOWN")
    code_off = h["code_offset"]
    code_size = h["code_size"]
    imp_off = h["import_offset"]
    if code_off > len(data) or code_size > len(data) - code_off:
        raise ValueError("code segment lies outside file")
    if imp_off < code_off or imp_off >= len(data):
        raise ValueError("import table offset lies outside code/file region")
    if code_off + code_size != imp_off:
        h["code_ends_at_import_offset"] = False
    else:
        h["code_ends_at_import_offset"] = True

    exp_off = h["export_dir_offset"]
    export_rows = []
    if exp_off > len(data) or h["export_count"]*4 > len(data)-exp_off:
        raise ValueError("export table lies outside file")
    for ordinal in range(1, h["export_count"]+1):
        raw = u32(data, exp_off + (ordinal-1)*4)
        code_file_off = code_off + (raw & ~1)
        export_rows.append({
            "ordinal": ordinal,
            "raw_offset": f"0x{raw:08X}",
            "runtime_address": f"0x{(int(h['code_base'],16)+raw)&0xFFFFFFFF:08X}",
            "thumb": raw & 1,
            "code_file_offset": f"0x{code_file_off:08X}",
            "valid_code_offset": code_off <= code_file_off < code_off+code_size,
            "sample_hex": data[code_file_off:code_file_off+16].hex() if code_file_off < len(data) else "",
        })
    imp_size = u32(data, imp_off)
    if imp_size < 4 or imp_size > len(data) - imp_off:
        raise ValueError(f"invalid import table size 0x{imp_size:X}")
    end = imp_off + imp_size
    pos = imp_off + 4
    iat_start = h["text_size"]
    code = data[code_off:code_off+code_size]
    blocks = []
    iat_slots = []
    for index in range(h["dll_ref_count"]):
        if pos + 8 > end:
            raise ValueError(f"import descriptor {index} exceeds import table")
        name_rel, count = struct.unpack_from("<II", data, pos)
        name = cstr(data, imp_off + name_rel)
        ord_end = pos + 8 + count * 4
        if ord_end > end:
            raise ValueError(f"ordinal array for {name} exceeds import table")
        ordinals = list(struct.unpack_from("<" + "I"*count, data, pos+8)) if count else []
        if iat_start + count*4 > len(code):
            raise ValueError(f"IAT for {name} exceeds code segment")
        iat_values = list(struct.unpack_from("<" + "I"*count, code, iat_start)) if count else []
        array_base = int(h["code_base"], 16) + iat_start
        blocks.append({
            "index": index,
            "dependency": name,
            "array_base": f"0x{array_base:08X}",
            "import_count": count,
            "ordinals": ",".join(map(str, ordinals)),
            "iat_values_match_ordinals": iat_values == ordinals,
        })
        for slot_index, ordinal in enumerate(ordinals):
            iat_slots.append({
                "dependency": name,
                "ordinal": ordinal,
                "slot_address": array_base + slot_index*4,
            })
        iat_start += count*4
        pos = ord_end
    if pos > end:
        raise ValueError("import descriptor table overflow")
    for slot in iat_slots:
        needle = struct.pack("<I", slot["slot_address"])
        refs = []
        pos_ref = 0
        while True:
            found = code.find(needle, pos_ref)
            if found < 0:
                break
            refs.append(found)
            pos_ref = found + 1
        slot["reference_count"] = len(refs)
        slot["reference_offsets"] = ",".join(f"0x{code_off+x:08X}" for x in refs)
    h["import_table_size"] = imp_size
    h["import_descriptors_end"] = pos
    h["import_table_trailing_bytes"] = end - pos
    h["iat_slots"] = sum(int(x["import_count"]) for x in blocks)
    h["iat_matches_import_ordinals"] = all(x["iat_values_match_ordinals"] for x in blocks)
    h["import_blocks"] = len(blocks)
    return h, blocks, export_rows, iat_slots

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--game", type=Path, required=True)
    ap.add_argument("--out-dir", type=Path, required=True)
    args = ap.parse_args()
    args.out_dir.mkdir(parents=True, exist_ok=True)
    header, blocks, export_rows, iat_slots = inspect(args.game)
    (args.out_dir / "STEP86_GAME_E32_HEADER.json").write_text(json.dumps(header, indent=2) + "\n", encoding="utf-8")
    with (args.out_dir / "STEP86_GAME_EXPORTS.tsv").open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=["ordinal","raw_offset","runtime_address","thumb","code_file_offset","valid_code_offset","sample_hex"], delimiter="\t")
        w.writeheader()
        w.writerows(export_rows)
    with (args.out_dir / "STEP86_GAME_IMPORT_BLOCKS.tsv").open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=["index","dependency","array_base","import_count","ordinals","iat_values_match_ordinals"], delimiter="\t")
        w.writeheader()
        w.writerows(blocks)
    with (args.out_dir / "STEP86_GAME_IAT_REFERENCES.tsv").open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=["dependency","ordinal","slot_address","reference_count","reference_offsets"], delimiter="\t")
        w.writeheader()
        for slot in iat_slots:
            w.writerow({
                **slot,
                "slot_address": f"0x{slot['slot_address']:08X}",
            })
    print(json.dumps({
        "uid1": header["uid1"],
        "uid2": header["uid2"],
        "uid3": header["uid3"],
        "module_kind": header["module_kind"],
        "flags": header["flags"],
        "code_size": header["code_size"],
        "data_size": header["data_size"],
        "entry_point": header["entry_point"],
        "dll_ref_count": header["dll_ref_count"],
        "export_count": header["export_count"],
        "iat_slots": header["iat_slots"],
        "exports": export_rows,
        "iat_matches_import_ordinals": header["iat_matches_import_ordinals"],
        "code_ends_at_import_offset": header["code_ends_at_import_offset"],
    }, indent=2))
    if not header["iat_matches_import_ordinals"]:
        raise SystemExit("IAT contents do not match the E32 import ordinal arrays")

if __name__ == "__main__":
    main()
