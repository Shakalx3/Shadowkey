#!/usr/bin/env python3
"""Map target S60 3.1 lifecycle exports used by the old CAknAppUi construction path."""
from __future__ import annotations
import hashlib
import json
import re
import subprocess
from pathlib import Path

ROOT = Path("/tmp/s60-devkit/Epoc32/release/armv5/lib")

def symbols(dso: Path):
    text = subprocess.check_output(["readelf", "-Ws", str(dso)], text=True)
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

def main():
    specs = [
        ("AVKON", 63, "BaseConstructL", ["CAknAppUi::", "CAknAppUiBase::"]),
        ("EIKCORE", 233, "ApplicationRect", ["CEikAppUi::"]),
        ("CONE", 12, "AddToStackL", ["CCoeAppUi::"]),
        ("AVKON", 1529, "SetKeyBlockMode", ["CAknAppUi::", "CAknAppUiBase::"]),
        ("AVKON", 874, "KeySounds", ["CAknAppUi::", "CAknAppUiBase::"]),
        ("AVKON", 1272, "PushContextL", ["CAknKeySoundSystem::"]),
        ("AVKON", 1213, "PopContext", ["CAknKeySoundSystem::"]),
        ("CONE", 167, "RemoveFromStack", ["CCoeAppUi::"]),
        ("AVKON", 2048, "~CAknAppUi", ["CAknAppUi::~CAknAppUi"]),
    ]
    cache = {}
    rows = []
    for dll, old_ord, method, class_filters in specs:
        dso = ROOT / (dll.lower() + ".dso")
        if not dso.is_file():
            raise SystemExit(f"missing target DSO: {dso}")
        if dll not in cache:
            cache[dll] = symbols(dso)
        matches = [
            s for s in cache[dll]
            if method in s["demangled"] and any(c in s["demangled"] for c in class_filters)
        ]
        same = next((s for s in cache[dll] if s["ordinal"] == old_ord), None)
        rows.append({
            "dll": dll, "old_ngage_ordinal": old_ord, "method": method,
            "target_matches": matches, "target_symbol_at_old_ordinal": same,
        })
    dso_hashes = {
        dll: hashlib.sha256((ROOT / (dll.lower() + ".dso")).read_bytes()).hexdigest()
        for dll in ("AVKON", "EIKCORE", "CONE")
    }
    report = {"target_sdk": "S60 3.1 FP1 / Symbian OS 9.2 ARMv5 EABI4", "dso_sha256": dso_hashes, "rows": rows}
    out = Path("/tmp/probe")
    out.mkdir(exist_ok=True)
    (out / "step63-lifecycle-export-map.json").write_text(json.dumps(report, indent=2) + "\n")
    lines = [
        "# Step63 — target S60 lifecycle import remap", "",
        "Target: S60 3.1 FP1 ARMv5 EABI4.", "",
        "| Old import | Expected method | Target ordinal(s) | Symbol at unchanged old ordinal |",
        "|---|---|---|---|",
    ]
    for row in rows:
        target = ", ".join(f"{m['ordinal']} {m['demangled']}" for m in row["target_matches"]) or "NOT FOUND"
        same = row["target_symbol_at_old_ordinal"]
        collision = f"{same['ordinal']} {same['demangled']}" if same else "NOT FOUND"
        lines.append(f"| {row['dll']} {row['old_ngage_ordinal']} | {row['method']} | {target} | {collision} |")
    lines += ["", "## DSO SHA-256", ""]
    lines += [f"- {dll}: {digest}" for dll, digest in dso_hashes.items()]
    lines += [""]
    (out / "STEP63_TARGET_LIFECYCLE_EXPORT_MAP.md").write_text("\n".join(lines))
    print(json.dumps({"matches": {f"{r['dll']}:{r['old_ngage_ordinal']}": [m["ordinal"] for m in r["target_matches"]] for r in rows}}, indent=2))

if __name__ == "__main__":
    main()
