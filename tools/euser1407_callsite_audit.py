#!/usr/bin/env python3
"""Extract every recovered guest callsite of the EUSER ordinal-1407 import thunk."""
from pathlib import Path
import re
ROOT = Path("source_bundle/shadowkey_step35_work")
LIFTED = ROOT / "shadowkey_lifted_v6.c"
DISPATCH = ROOT / "shadowkey_import_dispatch.c"
REPORT = Path("docs/STEP39_EUSER1407_STATIC_CALLSITE_AUDIT.md")
THUNK = "0x1009f0f0u"
if not LIFTED.is_file() or not DISPATCH.is_file():
    raise SystemExit("Required extracted archive source files are missing")
dispatch = DISPATCH.read_text(errors="replace")
mapping = [line.strip() for line in dispatch.splitlines() if THUNK in line]
if len(mapping) != 1 or "1407u" not in mapping[0] or "EUSER" not in mapping[0]:
    raise SystemExit(f"Unexpected import-thunk mapping: {mapping}")
lines = LIFTED.read_text(errors="replace").splitlines()
rx = re.compile(r"(?:ngage_call|simkin_call)\s*\(\s*c\s*,\s*" + re.escape(THUNK), re.I)
hits = [i for i, line in enumerate(lines) if THUNK in line]
if not hits:
    hits = [i for i, line in enumerate(lines) if THUNK in line]
if not hits:
    raise SystemExit("No EUSER1407 thunk references found in lifted source")
out = [
    "# Step 39 — EUSER1407 static callsite audit", "",
    "Generated from the extracted archive committed under source_bundle/.", "",
    f"- Import thunk mapping: {mapping[0]}",
    f"- Lifted source size: {LIFTED.stat().st_size} bytes; {len(lines)} lines",
    f"- Static references found: **{len(hits)}**", "",
    "## Callsite context", "",
    "Each excerpt includes the enclosing function label where detectable and 28 lines before / 10 lines after the import call."
]
for number, hit in enumerate(hits, 1):
    start, end = max(0, hit - 28), min(len(lines), hit + 11)
    fn = "function boundary not yet resolved"
    out += [f"### Reference {number} — line {hit+1}, function {fn}", "", "SOURCE BEGIN"]
    out.extend(f"{i+1}: {lines[i]}" for i in range(start, end))
    out += ["SOURCE END", ""]
for rel in ["diagnostics/step26/live_font_name_descriptor_trace.log",
            "diagnostics/step31/live_font_descriptor_trace.log",
            "diagnostics/step32/live_font_spec_trace.log"]:
    p = ROOT / rel
    if not p.is_file():
        continue
    log = p.read_text(errors="replace").splitlines()
    ix = [i for i, line in enumerate(log) if "EUSER1407" in line or "ordinal 1407" in line]
    out += [f"## Historical diagnostic log: {rel}", "", f"Matching lines: {len(ix)}", ""]
    for i in ix[:20]:
        out += ["LOG BEGIN", *log[max(0, i-2):min(len(log), i+4)], "LOG END", ""]
REPORT.parent.mkdir(parents=True, exist_ok=True)
REPORT.write_text("\n".join(out) + "\n")
print(f"Wrote {REPORT}: {len(hits)} static callsites")
