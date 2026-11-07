#!/usr/bin/env python3
"""Static callsite audit for EUSER1575, CONE160 and EUSER248."""
from pathlib import Path
ROOT=Path("source_bundle/shadowkey_step35_work")
DISPATCH=ROOT/"shadowkey_import_dispatch.c"
LIFTED=ROOT/"shadowkey_lifted_v6.c"
OUT=Path("docs/STEP41_EUSER1575_CONE160_EUSER248_CALLSITE_AUDIT.md")
targets=[
    ("EUSER",1575,"0x1009f240u"),
    ("CONE",160,"0x1009f510u"),
    ("EUSER",248,"0x1009f220u"),
]
dispatch=DISPATCH.read_text(errors="replace").splitlines()
lines=LIFTED.read_text(errors="replace").splitlines()
out=[
 "# Step 41 — EUSER1575 / CONE160 / EUSER248 callsite audit","",
 "Generated from the extracted 6R51.APP lifted source and import dispatch table.","",
 f"- Lifted source: {LIFTED.stat().st_size} bytes; {len(lines)} lines",
 "",
 "## Import-thunk mapping",""
]
for dll,ordinal,thunk in targets:
    matches=[x.strip() for x in dispatch if thunk in x and f'"{dll}[' in x and f', {ordinal}u' in x]
    if len(matches)!=1:
        raise SystemExit(f"Expected one {dll} ordinal {ordinal} mapping at {thunk}, got {matches}")
    out.append(matches[0])
out += ["","## Recovered callsites",""]
for dll,ordinal,thunk in targets:
    hits=[i for i,line in enumerate(lines) if thunk in line]
    if not hits: raise SystemExit(f"No lifted callsites for {dll} ordinal {ordinal}")
    out += [f"### {dll} ordinal {ordinal}", "", f"Static references: {len(hits)}", ""]
    for n,hit in enumerate(hits,1):
        start=max(0,hit-50); end=min(len(lines),hit+41)
        out += [f"#### Call {n} — lifted line {hit+1}", "", "SOURCE BEGIN"]
        out.extend(f"{i+1}: {lines[i]}" for i in range(start,end))
        out += ["SOURCE END",""]
out += [
 "## Audit constraints","",
 "- Register and stack arguments must be reconstructed from the callsite, not inferred from ordinal number alone.",
 "- Return values must be followed into caller-side status checks and subsequent reads/writes.",
 "- Do not implement either import until object type, ownership, and failure behavior are established.",
 "- EUSER248's previous text-path hypothesis is not treated as proven by this audit.",
 ""
]
OUT.parent.mkdir(parents=True,exist_ok=True)
OUT.write_text("\n".join(out))
print(f"Wrote {OUT}")
