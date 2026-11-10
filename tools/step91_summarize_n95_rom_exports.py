#!/usr/bin/env python3
"""Summarize selected RM-320 ROM modules and mapped Shadowkey imports."""
from collections import Counter
import csv
from pathlib import Path

ROOT = Path("firmware-input")
SELECTED = {"euser.dll", "cone.dll", "gdi.dll", "fbscli.dll",
            "eikcore.dll", "ws32.dll", "efsrv.dll"}
EXPECTED = {
    "apparc.dll", "avkon.dll", "bafl.dll", "bitgdi.dll", "bluetooth.dll",
    "btdevice.dll", "bteng.dll", "btmanclient.dll", "cone.dll", "efsrv.dll",
    "eikcoctl.dll", "eikcore.dll", "esock.dll", "estlib.dll", "etel.dll",
    "euser.dll", "ezlib.dll", "fbscli.dll", "gamecomms.dll", "gdi.dll",
    "hal.dll", "mediaclientaudiostream.dll", "msgs.dll", "sdpagent.dll",
    "sdpdatabase.dll", "simkin.dll", "ws32.dll",
}

def read_tsv(name):
    path = ROOT / name
    if not path.exists():
        return []
    with path.open(newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f, delimiter="\t"))

modules = read_tsv("ROM_TARGET_MODULES.tsv")
rom_exports = read_tsv("ROM_EXPORTS.tsv")
sdk_counts = read_tsv("ROM_SDK_EXPORT_COUNTS.tsv")
sdk_map = read_tsv("ROM_SDK_EXPORT_MAP.tsv")
module_by_name = {
    Path(r["path"].replace("\\", "/")).name.lower(): r for r in modules
}
rom_count = Counter(r["module"].lower() for r in rom_exports)
sdk_count = {r["module"].lower(): r for r in sdk_counts}
selected_export_rows = [r for r in sdk_map if r["module"].lower() in SELECTED]

with (ROOT / "STEP91_TARGET_EXPORTS.tsv").open("w", encoding="utf-8") as f:
    f.write("module\tordinal\tsdk_symbol\trom_address\tthumb\tlocation\n")
    for r in selected_export_rows:
        f.write("\t".join(r.get(k, "") for k in
                          ("module", "ordinal", "sdk_symbol", "rom_address", "thumb", "location")) + "\n")

imports = []
for name in ("STEP82_GAME_IMPORT_TARGET_MAP.tsv",
             "STEP82_SIMKIN_IMPORT_TARGET_MAP.tsv",
             "STEP82_GAMECOMMS_IMPORT_TARGET_MAP.tsv"):
    for r in read_tsv(name):
        target_dll = r.get("target_dll", "").lower()
        source_dll = r.get("dll", "").lower()
        if target_dll + ".dll" in SELECTED or source_dll + ".dll" in SELECTED:
            imports.append((name, r))

with (ROOT / "STEP91_SELECTED_IMPORTS.tsv").open("w", encoding="utf-8") as f:
    f.write("source_map\tsource_dll\told_ordinal\told_symbol\ttarget_dll\ttarget_ordinal\ttarget_symbol\ttarget_rom_address\tstatus\n")
    for name, r in imports:
        fields = (name, r.get("dll", ""), r.get("old_ordinal", ""),
                  r.get("old_symbol", ""), r.get("target_dll", ""),
                  r.get("target_ordinal", ""), r.get("target_symbol", ""),
                  r.get("target_rom_address", ""), r.get("status", ""))
        f.write("\t".join(fields) + "\n")

found = set(module_by_name)
missing = sorted(EXPECTED - found)
lines = [
    "# Step91 — RM-320 v35 ROM export summary",
    "",
    "Source: reconstructed SOS+CORE ROM from the RM-320 v35.0.001 package.",
    "SDK names are symbolization evidence, not a substitute for runtime testing.",
    "",
    f"- Target modules found: **{len(modules)}**",
    f"- Raw ROM export rows: **{len(rom_exports)}**",
    f"- SDK-symbolized export-map rows: **{len(sdk_map)}**",
    f"- Selected exports written: **{len(selected_export_rows)}**",
    f"- Selected import mappings: **{len(imports)}**",
    f"- Expected target modules not found: **{len(missing)}**",
    "",
    "| Module | UID3 | ROM exports | SDK DSO exports | Count check |",
    "|---|---:|---:|---:|---|",
]
for name in sorted(SELECTED):
    m = module_by_name.get(name)
    c = sdk_count.get(name, {})
    uid3 = m.get("uid3", "") if m else ""
    sdk_n = c.get("sdk_dso_export_count", "") if c else ""
    status = c.get("status", "ROM_MODULE_MISSING" if not m else "NO_SDK_COUNT_ROW")
    rom_n = str(rom_count.get(name, 0)) if m else "—"
    lines.append(f"| {name} | {uid3} | {rom_n} | {sdk_n or '—'} | {status} |")
lines += ["", "## Missing target modules", ""]
lines += [f"- `{x}`" for x in missing] or ["None."]
lines += ["", "## Selected import-map status counts", ""]
for status, count in sorted(Counter(r.get("status", "") for _, r in imports).items()):
    lines.append(f"- `{status}`: {count}")
lines += [
    "",
    "Full selected export rows: `STEP91_TARGET_EXPORTS.tsv`.",
    "Selected import remaps: `STEP91_SELECTED_IMPORTS.tsv`.",
    "Raw ROM module binaries are removed before artifact upload.",
    "",
]
report = "\n".join(lines)
(ROOT / "STEP91_N95_ROM_EXPORT_SUMMARY.md").write_text(report, encoding="utf-8")
print(report)
print("Selected import mappings:")
for name, r in imports:
    print(f"{r.get('dll','')}!{r.get('old_ordinal','')} -> "
          f"{r.get('target_dll','')}!{r.get('target_ordinal','')} "
          f"{r.get('status','')} {r.get('target_symbol','')}")
