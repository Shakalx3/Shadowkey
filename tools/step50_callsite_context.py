#!/usr/bin/env python3
"""Extract lifted ARM callsite context for imports currently blocking VFS startup."""
from pathlib import Path
import re

source = Path("source_bundle/shadowkey_step35_work/shadowkey_lifted_v6.c")
raw = source.read_text(errors="replace")
lines = raw.splitlines()
targets = {
    "EIKCORE 222 CEikApplication constructor": {
        "thunk": "0x1009fa00", "iat": "0x1010057c", "lr": "0x10028438"
    },
    "EIKCORE 219 CEikDocument constructor": {"thunk": "0x1009f900"},
    "EIKCORE 224 CEikAppUi constructor": {"thunk": "0x1009f700"},
    "EUSER 1582 CBase::operator new": {
        "thunk": "0x1009eef0", "iat": "0x101007ec", "lr": "0x10028428"
    },
    "EUSER 3 CBase::newL": {
        "thunk": "0x1009f020", "iat": "0x10100674", "lr": "0x100283cc"
    },
}
out = [
    "# Step 50 — lifted ARM callsite context for EIKCORE constructors and allocators",
    "",
    f"- Source file bytes: {len(raw.encode('utf-8'))}",
    f"- Source lines: {len(lines)}",
    "",
]
for label, addresses in targets.items():
    out += [f"## {label}", ""]
    found_any = False
    for kind, address in addresses.items():
        pattern = re.compile(re.escape(address) + r"u?", re.I)
        hits = [i for i, line in enumerate(lines) if pattern.search(line)]
        out += [f"- {kind}: {address}; occurrences: {len(hits)}"]
        for hit in hits:
            found_any = True
            function = "<enclosing function not identified>"
            for j in range(hit, max(-1, hit-500), -1):
                m = re.search(r"\b(?:static\s+)?void\s+(sub_[0-9a-fA-F]+)\s*\(", lines[j])
                if m:
                    function = m.group(1)
                    break
            start, end = max(0, hit-18), min(len(lines), hit+22)
            out += [f"### {kind} occurrence, {function}, source line {hit+1}", "", "~~~c"]
            out.extend(lines[start:end])
            out += ["~~~", ""]
    if not found_any:
        out += ["- No raw thunk, IAT or LR address found in this lifted source.", ""]
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
