#!/usr/bin/env python3
"""Extract lifted ARM callsite context for imports currently blocking VFS startup."""
from pathlib import Path
import re

source = Path("source_bundle/shadowkey_step35_work/shadowkey_lifted_v6.c")
lines = source.read_text(errors="replace").splitlines()
targets = {
    "EIKCORE 222 CEikApplication constructor": "0x1009fa00u",
    "EIKCORE 219 CEikDocument constructor": "0x1009f900u",
    "EIKCORE 224 CEikAppUi constructor": "0x1009f700u",
    "EUSER 1582 CBase::operator new": "0x1009eef0u",
}
out = [
    "# Step 50 — lifted ARM callsite context for EIKCORE constructors",
    "",
    "Generated from the committed lifted ARM source. The listed import thunk",
    "addresses come from shadowkey_import_dispatch.c and the ARM UREL names",
    "come from docs/STEP46_ARM_IMPORTLIB_ORDINAL_MAP.md.",
    "",
]
for label, thunk in targets.items():
    thunk_pattern = re.compile(r"ngage_call\\s*\\(\\s*c\\s*,\\s*" +
                               re.escape(thunk.rstrip("u")) + r"u?\\s*\\)", re.I)
    hits = [i for i, line in enumerate(lines) if thunk_pattern.search(line)]
    out += [f"## {label}", "", f"- Thunk: {thunk}", f"- Call sites: {len(hits)}", ""]
    for hit in hits:
        function = "<enclosing function not identified>"
        for j in range(hit, max(-1, hit-500), -1):
            m = re.search(r"\b(?:static\s+)?void\s+(sub_[0-9a-fA-F]+)\s*\(", lines[j])
            if m:
                function = m.group(1)
                break
        start, end = max(0, hit-18), min(len(lines), hit+22)
        out += [f"### {function}, source line {hit+1}", "", "~~~c"]
        out.extend(lines[start:end])
        out += ["~~~", ""]
out += [
    "## Interpretation boundary",
    "",
    "This is lifted host C generated from the ARM image, not original compiler",
    "source. Register assignments and call order are useful for ABI analysis,",
    "but the snippet does not by itself establish object construction side",
    "effects or a real EKA1/EKA2 runtime.",
]
target = Path("docs/STEP50_EIKCORE_CALLSITE_CONTEXT.md")
target.write_text("\n".join(out) + "\n")
print(f"Wrote {target} ({target.stat().st_size} bytes)")
