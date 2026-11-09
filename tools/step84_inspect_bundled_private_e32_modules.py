#!/usr/bin/env python3
"""Inspect E32 headers/exports of the game-bundled SIMKIN and GAMECOMMS DLLs."""
import argparse
import csv
import hashlib
import json
import re
import struct
from pathlib import Path

ENTRY_RE = re.compile(
    r'\{\s*(0x[0-9a-fA-F]+)u?,\s*(0x[0-9a-fA-F]+)u?,\s*"([A-Z0-9]+)\[[^]]+\]\.DLL",\s*(\d+)u\s*\}'
)

def u32(data, off):
    return struct.unpack_from("<I", data, off)[0]

def read_dispatch(path):
    rows = []
    for thunk, slot, dll, ordinal in ENTRY_RE.findall(path.read_text(encoding="utf-8", errors="replace")):
        rows.append((dll.lower(), int(ordinal), int(thunk, 16), int(slot, 16)))
    return rows

def inspect_module(path, module):
    data = path.read_bytes()
    if len(data) < 0x80:
        raise ValueError(f"{module}: too small for E32 header")
    uid1, uid2, uid3 = struct.unpack_from("<III", data, 0)
    signature = data[0x10:0x14]
    fields = {
        "uid1": f"0x{uid1:08X}",
        "uid2": f"0x{uid2:08X}",
        "uid3": f"0x{uid3:08X}",
        "signature": signature.decode("ascii", "replace"),
        "header_crc": f"0x{u32(data,0x14):08X}",
        "module_version": f"0x{u32(data,0x18):08X}",
        "compression_type": f"0x{u32(data,0x1C):08X}",
        "tools_version": f"0x{u32(data,0x20):08X}",
        "time_lo": f"0x{u32(data,0x24):08X}",
        "time_hi": f"0x{u32(data,0x28):08X}",
        "flags": f"0x{u32(data,0x2C):08X}",
        "code_size": u32(data,0x30),
        "data_size": u32(data,0x34),
        "heap_size_min": u32(data,0x38),
        "heap_size_max": u32(data,0x3C),
        "stack_size": u32(data,0x40),
        "bss_size": u32(data,0x44),
        "entry_point": f"0x{u32(data,0x48):08X}",
        "code_base": u32(data,0x4C),
        "data_base": u32(data,0x50),
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
        "data_reloc_size": u32(data,0x7C),
        "process_priority": u32(data,0x80) if len(data) >= 0x84 else 0,
    }
    code_off = fields["code_offset"]
    code_size = fields["code_size"]
    exp_off = fields["export_dir_offset"]
    count = fields["export_count"]
    valid = (
        signature == b"EPOC"
        and code_off <= len(data)
        and code_size <= len(data) - code_off
        and exp_off <= len(data)
        and count * 4 <= len(data) - exp_off
    )
    fields["export_table_file_offset"] = exp_off
    fields["export_dir_ends_at_import_offset"] = exp_off + count * 4 == fields["import_offset"]
    fields["code_segment_ends_at_import_offset"] = code_off + code_size == fields["import_offset"]
    fields["import_table_size"] = max(0, fields["code_reloc_offset"] - fields["import_offset"])
    fields["export_table_valid"] = bool(valid)
    fields["file_size"] = len(data)
    fields["sha256"] = hashlib.sha256(data).hexdigest()
    exports = []
    if valid:
        for ordinal in range(1, count + 1):
            raw = u32(data, exp_off + (ordinal - 1) * 4)
            offset = raw & ~1
            file_off = code_off + offset
            address = (fields["code_base"] + raw) & 0xFFFFFFFF
            sample = data[file_off:file_off+16] if file_off < len(data) else b""
            exports.append({
                "module": module,
                "ordinal": ordinal,
                "raw_offset": f"0x{raw:08X}",
                "runtime_address": f"0x{address:08X}",
                "thumb": raw & 1,
                "code_file_offset": f"0x{file_off:08X}",
                "sample_hex": sample.hex(),
                "valid_code_offset": code_off <= file_off < code_off + code_size,
            })
    return fields, exports

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--simkin", type=Path, required=True)
    ap.add_argument("--gamecomms", type=Path, required=True)
    ap.add_argument("--game-dispatch", type=Path, required=True)
    ap.add_argument("--out-dir", type=Path, required=True)
    args = ap.parse_args()
    args.out_dir.mkdir(parents=True, exist_ok=True)

    modules = [
        ("SIMKIN", args.simkin),
        ("GAMECOMMS", args.gamecomms),
    ]
    metadata = {}
    export_rows = []
    export_values = {}
    for name, path in modules:
        fields, exports = inspect_module(path, name)
        metadata[name] = {"path": str(path), **fields}
        export_rows.extend(exports)
        export_values[name] = {int(x["ordinal"]): int(x["raw_offset"], 16) for x in exports}

    game_imports = read_dispatch(args.game_dispatch)
    used = {}
    for dll, ordinal, thunk, slot in game_imports:
        if dll in ("simkin", "gamecomms"):
            used.setdefault(dll.upper(), []).append({
                "ordinal": ordinal,
                "thunk": f"0x{thunk:08X}",
                "slot": f"0x{slot:08X}",
            })

    validation = []
    for name in ("SIMKIN", "GAMECOMMS"):
        count = metadata[name]["export_count"]
        for imp in used.get(name, []):
            validation.append({
                "module": name,
                "ordinal": imp["ordinal"],
                "export_count": count,
                "ordinal_in_range": imp["ordinal"] <= count,
                "export_nonzero": bool(export_values.get(name, {}).get(imp["ordinal"], 0)),
                "export_raw_offset": f"0x{export_values.get(name, {}).get(imp['ordinal'], 0):08X}",
                "thunk": imp["thunk"],
                "slot": imp["slot"],
            })

    with (args.out_dir / "STEP84_PRIVATE_E32_EXPORTS.tsv").open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=["module","ordinal","raw_offset","runtime_address","thumb","code_file_offset","sample_hex","valid_code_offset"], delimiter="\t")
        w.writeheader()
        w.writerows(export_rows)
    with (args.out_dir / "STEP84_PRIVATE_IMPORT_VALIDATION.tsv").open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=["module","ordinal","export_count","ordinal_in_range","export_nonzero","export_raw_offset","thunk","slot"], delimiter="\t")
        w.writeheader()
        w.writerows(validation)
    (args.out_dir / "STEP84_PRIVATE_E32_MODULES.json").write_text(json.dumps(metadata, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({
        "modules": {k: {x: v for x, v in val.items() if x not in ("sha256",)} for k, val in metadata.items()},
        "game_private_imports": {k: len(v) for k, v in used.items()},
        "import_ordinals_valid": sum(1 for x in validation if x["ordinal_in_range"] and x["export_nonzero"]),
        "import_ordinals_invalid": [x for x in validation if not (x["ordinal_in_range"] and x["export_nonzero"])],
    }, indent=2))

if __name__ == "__main__":
    main()
