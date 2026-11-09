#!/usr/bin/env python3
"""Cross-check actual RM-320 ROM export ordinals against S60 3.1 FP1 DSOs."""
import argparse
import csv
import json
import re
import subprocess
from pathlib import Path

SYMBOL_RE = re.compile(
    r"\s*\d+:\s+([0-9a-fA-F]+)\s+\d+\s+\S+\s+GLOBAL\s+DEFAULT\s+(\S+)\s+(.+)$"
)

def dso_exports(path):
    text = subprocess.check_output(["readelf", "-Ws", str(path)], text=True, errors="replace")
    result = {}
    for line in text.splitlines():
        m = SYMBOL_RE.match(line)
        if not m or m.group(2) == "UND":
            continue
        value = int(m.group(1), 16)
        if value % 4:
            continue
        symbol = m.group(3).strip().split("@@", 1)[0]
        result[value // 4 + 1] = symbol
    return result

def read_tsv(path):
    with path.open(newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f, delimiter="\t"))

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--sdk-root", type=Path, required=True)
    ap.add_argument("--rom-dir", type=Path, required=True)
    args = ap.parse_args()
    libdir = args.sdk_root / "Epoc32/release/armv5/lib"
    modules = read_tsv(args.rom_dir / "ROM_TARGET_MODULES.tsv")
    rom_rows = read_tsv(args.rom_dir / "ROM_EXPORTS.tsv")
    remap_path = args.rom_dir / "s60-sdk/target-export-remap.json"
    remap = json.loads(remap_path.read_text(encoding="utf-8"))
    rom_by_module = {}
    for row in rom_rows:
        rom_by_module.setdefault(row["module"].lower(), {})[int(row["ordinal"])] = row
    module_meta = {row["path"].rsplit("/", 1)[-1].lower(): row for row in modules}

    count_rows = []
    export_rows = []
    dso_by_module = {}
    for module_name, meta in module_meta.items():
        stem = module_name[:-4] if module_name.endswith(".dll") else module_name
        dso_path = libdir / f"{stem}.dso"
        if not dso_path.is_file():
            count_rows.append((module_name, meta["uid3"], int(meta["export_count"]), "", "DSO_MISSING"))
            continue
        symbols = dso_exports(dso_path)
        dso_by_module[stem] = symbols
        rom_exports = rom_by_module.get(module_name, {})
        rom_count = int(meta["export_count"])
        if len(symbols) == rom_count and len(rom_exports) == rom_count:
            status = "MATCH"
        elif rom_count > len(symbols) and len(rom_exports) == rom_count and all(o in rom_exports for o in symbols):
            status = "ROM_EXTRA_EXPORTS"
        elif len(symbols) > rom_count:
            status = "ROM_MISSING_EXPORTS"
        else:
            status = "COUNT_MISMATCH"
        count_rows.append((module_name, meta["uid3"], rom_count, len(symbols), status))
        code_start = int(meta["code_address"], 16)
        code_end = code_start + int(meta["code_size"])
        for ordinal in sorted(set(symbols) | set(rom_exports)):
            symbol = symbols.get(ordinal, "")
            rom = rom_exports.get(ordinal)
            if rom is None:
                addr, thumb, location = "", "", "NO_ROM_EXPORT"
            else:
                addr = rom["address"]
                thumb = rom["thumb"]
                raw_addr = int(addr, 16) & ~1
                location = "IN_CODE" if code_start <= raw_addr < code_end else "OUTSIDE_CODE"
            export_rows.append((module_name, ordinal, symbol, addr, thumb, location))

    count_path = args.rom_dir / "ROM_SDK_EXPORT_COUNTS.tsv"
    with count_path.open("w", encoding="utf-8") as f:
        f.write("module\tuid3\trom_export_count\tsdk_dso_export_count\tstatus\n")
        for row in count_rows:
            f.write("\t".join(map(str, row)) + "\n")
    map_path = args.rom_dir / "ROM_SDK_EXPORT_MAP.tsv"
    with map_path.open("w", encoding="utf-8") as f:
        f.write("module\tordinal\tsdk_symbol\trom_address\tthumb\tlocation\n")
        for row in export_rows:
            f.write("\t".join(map(str, row)) + "\n")

    game_rows = []
    for case in remap.get("game_import_remaps", []):
        dll = case["dll"]
        module_name = dll + ".dll"
        rom_exports = rom_by_module.get(module_name, {})
        symbols = dso_by_module.get(dll, {})
        old_ord = int(case["original_ngage_ordinal"])
        old_rom = rom_exports.get(old_ord)
        api_ord = case.get("target_api_ordinal")
        api_rom = rom_exports.get(int(api_ord)) if api_ord is not None else None
        old_symbol = symbols.get(old_ord, "")
        api_symbol = symbols.get(int(api_ord), "") if api_ord is not None else ""
        meta = module_meta.get(module_name, {})
        code_start = int(meta.get("code_address", "0"), 16)
        code_end = code_start + int(meta.get("code_size", 0))
        def loc(row):
            if not row:
                return "NOT_EXPORTED"
            addr = int(row["address"], 16) & ~1
            return "IN_CODE" if code_start <= addr < code_end else "OUTSIDE_CODE"
        game_rows.append((
            dll, old_ord, old_symbol,
            old_rom["address"] if old_rom else "", loc(old_rom),
            api_symbol, api_ord if api_ord is not None else "",
            api_rom["address"] if api_rom else "", loc(api_rom),
        ))
    game_path = args.rom_dir / "STEP80_GAME_IMPORT_ROM_REMAP.tsv"
    with game_path.open("w", encoding="utf-8") as f:
        f.write("dll\toriginal_ngage_ordinal\tsdk_symbol_at_same_ordinal\trom_address_at_same_ordinal\tlocation\t"
                "correct_target_symbol\ttarget_ordinal\ttarget_rom_address\ttarget_location\n")
        for row in game_rows:
            f.write("\t".join(map(str, row)) + "\n")

    dispatch_path = Path("source_bundle/shadowkey_step35_work/shadowkey_import_dispatch.c")
    dispatch_text = dispatch_path.read_text(encoding="utf-8", errors="replace")
    imported_dlls = sorted(set(
        name.lower() for name in re.findall(r'"([A-Z0-9]+)\[[0-9a-fA-F]+\]\.DLL"', dispatch_text)
    ))
    availability_path = args.rom_dir / "GAME_IMPORT_DLL_AVAILABILITY.tsv"
    with availability_path.open("w", encoding="utf-8") as f:
        f.write("dll\trom_path\tstatus\n")
        for dll in imported_dlls:
            meta = module_meta.get(dll + ".dll")
            f.write(f"{dll}.dll\t{meta['path'] if meta else ''}\t{'PRESENT_IN_ROM' if meta else 'MISSING_FROM_ROM'}\n")

    matches = sum(1 for r in count_rows if r[-1] == "MATCH")
    summary = {
        "rom_modules": len(modules),
        "sdk_dso_modules_found": sum(1 for r in count_rows if r[-1] != "DSO_MISSING"),
        "export_count_matches": matches,
        "game_import_remaps": len(game_rows),
        "game_import_dlls": len(imported_dlls),
        "game_import_dlls_present": sum(1 for d in imported_dlls if d + ".dll" in module_meta),
        "game_import_dlls_missing": [d for d in imported_dlls if d + ".dll" not in module_meta],
        "count_report": str(count_path),
        "symbolized_export_map": str(map_path),
        "game_import_report": str(game_path),
    }
    (args.rom_dir / "STEP80_ROM_SDK_EXPORT_CHECK.json").write_text(
        json.dumps(summary, indent=2) + "\n", encoding="utf-8"
    )
    print(json.dumps(summary, indent=2))

if __name__ == "__main__":
    main()
