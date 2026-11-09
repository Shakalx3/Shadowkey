#!/usr/bin/env python3
"""Resolve target S60 3.1 CCoeControl exports needed by the old game-control bridge."""
from __future__ import annotations
import hashlib
import json
import re
import subprocess
from pathlib import Path

ROOT = Path("/tmp/s60-devkit/Epoc32/release/armv5/lib")
SPECS = [
    (236, "constructor", "CCoeControl::CCoeControl"),
    (232, "destructor", "CCoeControl::~CCoeControl"),
    (226, "SystemGc", "CCoeControl::SystemGc"),
    (160, "Rect", "CCoeControl::Rect"),
    (40, "CreateWindowL", "CCoeControl::CreateWindowL"),
    (214, "SetRect", "CCoeControl::SetRect"),
    (138, "MakeVisible", "CCoeControl::MakeVisible"),
    (200, "SetDimmed", "CCoeControl::SetDimmed"),
    (197, "SetContainerWindowL", "CCoeControl::SetContainerWindowL"),
    (29, "ConstructFromResourceL", "CCoeControl::ConstructFromResourceL"),
    (3, "ActivateL", "CCoeControl::ActivateL"),
    (153, "PrepareForFocusLossL", "CCoeControl::PrepareForFocusLossL"),
    (185, "SetAdjacent", "CCoeControl::SetAdjacent"),
    (208, "SetNeighbor", "CCoeControl::SetNeighbor"),
    (95, "HasBorder", "CCoeControl::HasBorder"),
    (139, "MinimumSize", "CCoeControl::MinimumSize"),
    (87, "HandleResourceChange", "CCoeControl::HandleResourceChange"),
    (72, "GetColorUseListL", "CCoeControl::GetColorUseListL"),
    (74, "GetHelpContext", "CCoeControl::GetHelpContext"),
    (84, "HandlePointerBufferReadyL", "CCoeControl::HandlePointerBufferReadyL"),
    (221, "SizeChanged", "CCoeControl::SizeChanged"),
    (147, "PositionChanged", "CCoeControl::PositionChanged"),
    (33, "CountComponentControls", "CCoeControl::CountComponentControls"),
    (28, "ComponentControl", "CCoeControl::ComponentControl"),
    (173, "WriteInternalStateL", "CCoeControl::WriteInternalStateL"),
    (177, "Reserved_2", "CCoeControl::Reserved_2"),
]

def main():
    dso = ROOT / "cone.dso"
    if not dso.is_file(): raise SystemExit(f"missing target DSO: {dso}")
    raw = subprocess.check_output(["readelf", "-Ws", str(dso)], text=True)
    rows = []
    for line in raw.splitlines():
        m = re.match(r"\s*\d+:\s+([0-9a-fA-F]+)\s+\d+\s+\S+\s+GLOBAL\s+DEFAULT\s+(\S+)\s+(.+)$", line)
        if not m or m.group(2) == "UND": continue
        value = int(m.group(1), 16)
        if value % 4: continue
        name = m.group(3).strip().split("@@", 1)[0]
        demangled = subprocess.check_output(["c++filt", name], text=True).strip()
        rows.append({"ordinal": value // 4 + 1, "raw": name, "demangled": demangled})
    by_ordinal = {r["ordinal"]: r for r in rows}
    report_rows = []
    for old_ord, label, needle in SPECS:
        matches = [r for r in rows if needle in r["demangled"]]
        report_rows.append({
            "old_ngage_ordinal": old_ord, "method": label,
            "target_matches": matches,
            "target_symbol_at_same_ordinal": by_ordinal.get(old_ord),
        })
    report = {
        "target_sdk": "S60 3.1 FP1 / Symbian OS 9.2 ARMv5 EABI4",
        "dso": str(dso),
        "dso_sha256": hashlib.sha256(dso.read_bytes()).hexdigest(),
        "rows": report_rows,
    }
    out = Path("/tmp/probe")
    out.mkdir(exist_ok=True)
    (out / "step67-target-coecontrol-exports.json").write_text(json.dumps(report, indent=2) + "\n")
    lines = [
        "# Step67 — target CCoeControl export map", "",
        "Target: S60 3.1 FP1 / Symbian OS 9.2 ARMv5 EABI4 CONE DSO.", "",
        "| Old N-Gage ordinal | Method | Target ordinal(s) | Symbol at unchanged ordinal |",
        "|---:|---|---|---|",
    ]
    for r in report_rows:
        target = ", ".join(f"{x['ordinal']} {x['demangled']}" for x in r["target_matches"]) or "NOT FOUND"
        same = r["target_symbol_at_same_ordinal"]
        collision = f"{same['ordinal']} {same['demangled']}" if same else "NOT FOUND"
        lines.append(f"| {r['old_ngage_ordinal']} | {r['method']} | {target} | {collision} |")
    lines += ["", f"CONE DSO SHA-256: {report['dso_sha256']}", ""]
    (out / "STEP67_TARGET_COECONTROL_EXPORT_MAP.md").write_text("\n".join(lines))
    print(json.dumps({r["method"]: [m["ordinal"] for m in r["target_matches"]] for r in report_rows}, indent=2))

if __name__ == "__main__":
    main()
