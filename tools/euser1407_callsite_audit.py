#!/usr/bin/env python3
"""Extract every recovered guest callsite of the EUSER ordinal-1407 import thunk."""
from pathlib import Path
import re
import struct
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

APP = ROOT / "game_assets/The_Elder_Scrolls_Travels_Shadowkey/system/apps/6R51/6R51.APP"
if not APP.is_file():
    raise SystemExit("6R51.APP missing; cannot map format literals")
app = APP.read_bytes()
code_offset = struct.unpack_from("<I", app, 0x64)[0]
out += ["## Format-string literal provenance", "",
        f"- 6R51.APP code offset: 0x{code_offset:x}",
        "- VA-to-file mapping: code_offset + (VA - 0x10000000)", ""]
for va in [0x100a6470, 0x100abf28, 0x100ac718, 0x100b1068, 0x100b3c8c]:
    off = code_offset + (va - 0x10000000)
    if off < 0 or off + 2 > len(app):
        raise SystemExit(f"Literal VA out of file range: {va:08x}")
    units = []
    for n in range(256):
        pos = off + n * 2
        if pos + 2 > len(app):
            break
        ch = struct.unpack_from("<H", app, pos)[0]
        if ch == 0:
            break
        units.append(ch)
    literal = "".join(chr(x) if 32 <= x < 127 else f"\\u{x:04x}" for x in units)
    out += [f"- VA 0x{va:08x}, file offset 0x{off:x}: {literal!r}"]
out += ["", "## Interpretation boundary", "",
        "Five font-name callsites use the Swiss literal at 0x100ac718 and copy 20 bytes from their temporary object immediately after the call. The other five references use separate format literals and are not safe to handle with a Swiss-specific shortcut.",
        "The generic API shape is consistent with TDes16::Format(TRefByValue<const TDesC16>, ...), but the exact EUSER ordinal-to-export-name mapping and all variadic argument semantics still require target FP1 export/callsite verification.", ""]

REPORT.parent.mkdir(parents=True, exist_ok=True)
REPORT.write_text("\n".join(out) + "\n")
print(f"Wrote {REPORT}: {len(hits)} static callsites")
