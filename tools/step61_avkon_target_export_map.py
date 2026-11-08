#!/usr/bin/env python3
"""Audit target S60 3.1 FP1 CAknAppUi exports and class layout."""
from __future__ import annotations
import hashlib
import json
import re
import subprocess
from pathlib import Path

def run(*args: str) -> str:
    return subprocess.check_output(args, text=True)

def parse_symbols(text: str):
    rows = []
    for line in text.splitlines():
        m = re.match(r"\s*\d+:\s+([0-9a-fA-F]+)\s+\d+\s+\S+\s+GLOBAL\s+DEFAULT\s+(\S+)\s+(.+)$", line)
        if not m or m.group(2) == "UND":
            continue
        value = int(m.group(1), 16)
        if value % 4:
            continue
        raw = m.group(3).strip().split("@@", 1)[0]
        demangled = subprocess.check_output(["c++filt", raw], text=True).strip()
        rows.append({"ordinal": value // 4 + 1, "raw": raw, "demangled": demangled})
    return rows

def class_block(text: str, name: str):
    marker = "class " + name
    start = text.find(marker)
    if start < 0:
        return None
    brace = text.find("{", start)
    depth = 0
    for i in range(brace, len(text)):
        if text[i] == "{":
            depth += 1
        elif text[i] == "}":
            depth -= 1
            if depth == 0:
                return text[start:i + 2]
    return None

def main():
    root = Path("/tmp/s60-devkit")
    include = root / "Epoc32/include"
    libdir = root / "Epoc32/release/armv5/lib"
    avkon = libdir / "avkon.dso"
    if not avkon.is_file():
        raise SystemExit(f"missing {avkon}")
    header = subprocess.check_output(["readelf", "-h", str(avkon)], text=True)
    if "ELF32" not in header or "ARM" not in header or "Version4 EABI" not in header:
        raise SystemExit("AVKON DSO is not expected ELF32 ARM EABI4")
    symbols = parse_symbols(run("readelf", "-Ws", str(avkon)))
    wanted = [
        ("HandleStatusPaneSizeChange", 802),
        ("HandleViewDeactivation", 805),
        ("PrepareToExit", 803),
        ("ProcessCommandL", 808),
    ]
    methods = []
    for needle, old_ord in wanted:
        matches = [s for s in symbols if needle in s["demangled"] and "CAknAppUi::" in s["demangled"]]
        same = next((s for s in symbols if s["ordinal"] == old_ord), None)
        methods.append({
            "method": needle,
            "original_ngage_ordinal": old_ord,
            "target_matches": matches,
            "target_symbol_at_old_ordinal": same,
        })
    akn_header = (include / "aknappui.h").read_text(errors="replace")
    eik_header = (include / "eikappui.h").read_text(errors="replace")
    coe_header = (include / "coeaui.h").read_text(errors="replace")
    akn_class = class_block(akn_header, "CAknAppUi")
    eik_class = class_block(eik_header, "CEikAppUi")
    coe_class = class_block(coe_header, "CCoeAppUi")
    report = {
        "target_sdk": "S60 3.1 FP1 / Symbian OS 9.2 ARMv5",
        "avkon_dso": {"path": str(avkon), "sha256": hashlib.sha256(avkon.read_bytes()).hexdigest(), "abi": "ELF32 ARM EABI4"},
        "methods": methods,
        "target_caknappui_header": akn_class,
        "target_ceikappui_header": eik_class,
        "target_ccoeappui_header": coe_class,
        "target_header_files": {
            "aknappui.h": str(include / "aknappui.h"),
            "eikappui.h": str(include / "eikappui.h"),
            "coeaui.h": str(include / "coeaui.h"),
        },
    }
    out = Path("/tmp/probe")
    out.mkdir(exist_ok=True)
    (out / "step61-avkon-layout.json").write_text(json.dumps(report, indent=2) + "\n")
    lines = [
        "# Step61 — target CAknAppUi layout and AVKON exports", "",
        "Target SDK: S60 3.1 FP1 / Symbian OS 9.2 ARMv5.", "",
        "## AVKON method remapping", "",
        "| Method | Original N-Gage ordinal | Target ordinal(s) | Symbol at old ordinal |",
        "|---|---:|---|---|",
    ]
    for row in methods:
        target = ", ".join(str(m["ordinal"]) + " " + m["demangled"] for m in row["target_matches"]) or "NOT FOUND"
        same = row["target_symbol_at_old_ordinal"]
        collision = f"{same['ordinal']} {same['demangled']}" if same else "NOT FOUND"
        lines.append(f"| {row['method']} | {row['original_ngage_ordinal']} | {target} | {collision} |")
    lines += ["", "## Target CAknAppUi declaration", "", akn_class or "NOT FOUND", "", "## Target CEikAppUi declaration", "", eik_class or "NOT FOUND", "", "## Target CCoeAppUi declaration", "", coe_class or "NOT FOUND", ""]
    (out / "STEP61_TARGET_CAKNAPPUI_LAYOUT.md").write_text("\n".join(lines))
    print(json.dumps({"avkon_dso": str(avkon), "method_matches": {m["method"]: [x["ordinal"] for x in m["target_matches"]] for m in methods}}, indent=2))

if __name__ == "__main__":
    main()
