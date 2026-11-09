#!/usr/bin/env python3
"""Match N-Gage ARM UREL imports to real RM-320 ROM export ordinals."""
import argparse
import csv
import json
import re
import subprocess
from pathlib import Path

ENTRY_RE = re.compile(
    r'\{\s*(0x[0-9a-fA-F]+)u?,\s*(0x[0-9a-fA-F]+)u?,\s*"([A-Z0-9]+)\[[^]]+\]\.DLL",\s*(\d+)u\s*\}'
)

def read_tsv(path):
    with path.open(newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f, delimiter="\t"))

def demangle(tool, names):
    unique = list(dict.fromkeys(x for x in names if x))
    if not unique:
        return {}
    p = subprocess.run([tool], input="\n".join(unique) + "\n", text=True,
                       stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
    lines = p.stdout.splitlines()
    if len(lines) != len(unique):
        raise RuntimeError(f"{tool} returned {len(lines)} lines for {len(unique)} symbols")
    return dict(zip(unique, lines))

def normalize(s):
    s = s.strip()
    s = re.sub(r"\b(class|struct|enum)\s+", "", s)
    s = s.replace("(void)", "()")
    s = re.sub(r"\s*::\s*", "::", s)
    s = re.sub(r"\s*,\s*", ",", s)
    s = re.sub(r"\s*&\s*", "&", s)
    s = re.sub(r"\s*\*\s*", "*", s)
    s = re.sub(r"\(\s*", "(", s)
    s = re.sub(r"\s*\)", ")", s)
    s = re.sub(r"\s+", " ", s)
    return s.strip()

def read_dispatch(path):
    text = path.read_text(encoding="utf-8", errors="replace")
    rows = []
    for thunk, slot, dll, ordinal in ENTRY_RE.findall(text):
        rows.append({
            "thunk": int(thunk, 16),
            "slot": int(slot, 16),
            "dll": dll.lower(),
            "ordinal": int(ordinal),
        })
    return rows

def load_arm_map(path):
    return {(r["dll"].lower(), int(r["ordinal"])): r for r in read_tsv(path)}

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--epoc-demangler", required=True)
    ap.add_argument("--target-demangler", default="c++filt")
    ap.add_argument("--rom-dir", type=Path, required=True)
    ap.add_argument("--game-dispatch", type=Path, required=True)
    ap.add_argument("--simkin-dispatch", type=Path, required=True)
    ap.add_argument("--gamecomms-dispatch", type=Path, required=True)
    ap.add_argument("--game-arm-map", type=Path, required=True)
    ap.add_argument("--simkin-arm-map", type=Path, required=True)
    ap.add_argument("--gamecomms-arm-map", type=Path, required=True)
    args = ap.parse_args()

    target_rows = read_tsv(args.rom_dir / "ROM_SDK_EXPORT_MAP.tsv")
    target_names = [r["sdk_symbol"] for r in target_rows if r["sdk_symbol"]]
    target_demangled = demangle(args.target_demangler, target_names)
    target_by_dll_sig = {}
    target_by_dll_ord = {}
    for row in target_rows:
        dll = row["module"].lower().removesuffix(".dll")
        symbol = row["sdk_symbol"]
        if not symbol:
            continue
        sig = normalize(target_demangled[symbol])
        target_by_dll_sig.setdefault(dll, {}).setdefault(sig, []).append(row)
        target_by_dll_ord.setdefault(dll, {})[int(row["ordinal"])] = row

    remap_json = json.loads((args.rom_dir / "s60-sdk/target-export-remap.json").read_text(encoding="utf-8"))
    overrides = {}
    for case in remap_json.get("game_import_remaps", []):
        overrides[(case["dll"].lower(), int(case["original_ngage_ordinal"]))] = case

    game_arm = load_arm_map(args.game_arm_map)
    simkin_arm = load_arm_map(args.simkin_arm_map)
    gamecomms_arm = load_arm_map(args.gamecomms_arm_map)
    all_arm_symbols = [r["arm_urel_symbol"] for r in list(game_arm.values()) + list(simkin_arm.values()) + list(gamecomms_arm.values())
                       if r["arm_urel_symbol"] and r["arm_urel_symbol"] != "<no archive-index symbol>"]
    epoc_demangled = demangle(args.epoc_demangler, all_arm_symbols)

    private_dlls = {"simkin", "gamecomms"}

    def map_dispatch(dispatch_path, arm_map, output_name):
        imports = read_dispatch(dispatch_path)
        out_rows = []
        counts = {}
        for imp in imports:
            dll, old_ord = imp["dll"], imp["ordinal"]
            arm = arm_map.get((dll, old_ord), {})
            arm_symbol = arm.get("arm_urel_symbol", "")
            old_sig = epoc_demangled.get(arm_symbol, "")
            target_ord = ""
            target_symbol = ""
            target_sig = ""
            target_address = ""
            target_location = ""
            status = ""
            candidates = []

            if dll in private_dlls:
                status = "BUNDLED_PRIVATE_DLL_UNCHANGED"
                target_ord = old_ord
            elif arm.get("status") != "OK" or not arm_symbol or arm_symbol == "<no archive-index symbol>":
                status = "NO_ARM_UREL_SYMBOL"
            else:
                override = overrides.get((dll, old_ord))
                if override is not None:
                    api_ord = override.get("target_api_ordinal")
                    if api_ord is None:
                        status = "NO_TARGET_SIGNATURE"
                    else:
                        row = target_by_dll_ord.get(dll, {}).get(int(api_ord))
                        if row is None:
                            status = "OVERRIDE_TARGET_ORDINAL_MISSING"
                        elif row["sdk_symbol"] != override.get("target_api_symbol"):
                            status = "OVERRIDE_SYMBOL_MISMATCH"
                            candidates = [row]
                        else:
                            candidates = [row]
                            status = "MANUAL_OVERRIDE"
                else:
                    sig = normalize(old_sig)
                    candidates = target_by_dll_sig.get(dll, {}).get(sig, [])
                    if not candidates and "::" not in sig and "(" in sig:
                        # C runtime aliases may be exported by name without C++ parameter decoration.
                        base_name = sig.split("(", 1)[0]
                        candidates = [
                            row for row in target_rows
                            if row["module"].lower() == dll + ".dll"
                            and row["sdk_symbol"]
                            and normalize(target_demangled[row["sdk_symbol"]]).split("(", 1)[0] == base_name
                        ]
                    if len(candidates) == 1:
                        status = "EXACT_SIGNATURE_MATCH"
                    elif len(candidates) > 1:
                        addresses = {x["rom_address"] for x in candidates}
                        if len(addresses) == 1:
                            candidates = [min(candidates, key=lambda x: int(x["ordinal"]))]
                            status = "ALIAS_SAME_ADDRESS"
                        else:
                            d1 = [x for x in candidates if "D1Ev" in x["sdk_symbol"]]
                            if d1 and all(any(tag in x["sdk_symbol"] for tag in ("D0Ev", "D1Ev", "D2Ev")) for x in candidates):
                                candidates = d1[:1]
                                status = "ABI_D1_DESTRUCTOR_CANDIDATE"
                            else:
                                status = "AMBIGUOUS_SIGNATURE"
                    else:
                        status = "NO_TARGET_SIGNATURE"

            if candidates and status in ("MANUAL_OVERRIDE", "EXACT_SIGNATURE_MATCH", "ALIAS_SAME_ADDRESS", "ABI_D1_DESTRUCTOR_CANDIDATE"):
                chosen = candidates[0]
                target_ord = int(chosen["ordinal"])
                target_symbol = chosen["sdk_symbol"]
                target_sig = target_demangled[target_symbol]
                target_address = chosen["rom_address"]
                target_location = chosen["location"]
            elif candidates and status == "AMBIGUOUS_SIGNATURE":
                target_ord = ";".join(str(int(x["ordinal"])) for x in candidates)
                target_symbol = ";".join(x["sdk_symbol"] for x in candidates)
                target_sig = ";".join(target_demangled[x["sdk_symbol"]] for x in candidates)
                target_address = ";".join(x["rom_address"] for x in candidates)
                target_location = ";".join(x["location"] for x in candidates)

            out_rows.append({
                "thunk": f"0x{imp['thunk']:08X}",
                "slot": f"0x{imp['slot']:08X}",
                "dll": dll,
                "old_ordinal": old_ord,
                "arm_urel_symbol": arm_symbol,
                "original_demangled": old_sig,
                "target_ordinal": target_ord,
                "target_sdk_symbol": target_symbol,
                "target_demangled": target_sig,
                "target_rom_address": target_address,
                "target_location": target_location,
                "status": status,
            })
            counts[status] = counts.get(status, 0) + 1

        out_path = args.rom_dir / output_name
        fields = ["thunk", "slot", "dll", "old_ordinal", "arm_urel_symbol",
                  "original_demangled", "target_ordinal", "target_sdk_symbol",
                  "target_demangled", "target_rom_address", "target_location", "status"]
        with out_path.open("w", newline="", encoding="utf-8") as f:
            w = csv.DictWriter(f, fieldnames=fields, delimiter="\t")
            w.writeheader()
            w.writerows(out_rows)
        return out_path, counts, len(imports)

    game_path, game_counts, game_total = map_dispatch(
        args.game_dispatch, game_arm, "STEP82_GAME_IMPORT_TARGET_MAP.tsv"
    )
    simkin_path, simkin_counts, simkin_total = map_dispatch(
        args.simkin_dispatch, simkin_arm, "STEP82_SIMKIN_IMPORT_TARGET_MAP.tsv"
    )
    gamecomms_path, gamecomms_counts, gamecomms_total = map_dispatch(
        args.gamecomms_dispatch, gamecomms_arm, "STEP82_GAMECOMMS_IMPORT_TARGET_MAP.tsv"
    )
    summary = {
        "game_import_slots": game_total,
        "game_status_counts": game_counts,
        "simkin_import_slots": simkin_total,
        "simkin_status_counts": simkin_counts,
        "gamecomms_import_slots": gamecomms_total,
        "gamecomms_status_counts": gamecomms_counts,
        "game_map": str(game_path),
        "simkin_map": str(simkin_path),
        "gamecomms_map": str(gamecomms_path),
        "rom_target_modules": len({r["module"] for r in target_rows}),
        "rom_symbolized_exports": sum(1 for r in target_rows if r["sdk_symbol"]),
    }
    (args.rom_dir / "STEP82_IMPORT_MAPPING_SUMMARY.json").write_text(
        json.dumps(summary, indent=2) + "\n", encoding="utf-8"
    )
    print(json.dumps(summary, indent=2))

if __name__ == "__main__":
    main()
