#!/usr/bin/env python3
"""Inspect WINS UDEB EIKCORE as semantic reference, never as ARM code."""
from pathlib import Path
import hashlib
import os
import re
import shutil
import subprocess
import tempfile

root = Path(os.environ.get("SHADOWKEY_ARM_SDK_ROOT", "/tmp/ngagesdk-sdk"))
base = root / "6.1/Series60/Epoc32/Release/wins/udeb"
dll = base / "eikcore.dll"
lib = base / "eikcore.lib"

def run(args):
    return subprocess.run(args, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                          check=False)

def decode(p):
    return p.stdout.decode("utf-8", "replace")

out = [
    "# Step 52 — WINS UDEB EIKCORE probe",
    "",
    "WINS UDEB is used only as a semantic reference. It is not ARM UREL",
    "code and cannot supply ARM vtable addresses or prove exact ARM behavior.",
    "",
]
export_map = {}
image_base = None
if not dll.exists():
    out += [f"- DLL not found: {dll}", ""]
else:
    data = dll.read_bytes()
    out += [
        f"- DLL: {dll}",
        f"- Size: {len(data)} bytes",
        f"- SHA-256: {hashlib.sha256(data).hexdigest()}",
        "",
    ]
    if shutil.which("file"):
        out += ["## File identification", "", "~~~text",
                decode(run(["file", str(dll)])).strip(), "~~~", ""]
    if shutil.which("llvm-readobj"):
        p = run(["llvm-readobj", "--file-headers", "--coff-exports", str(dll)])
        txt = decode(p)
        m = re.search(r"ImageBase:\s*(0x[0-9A-Fa-f]+)", txt)
        if m:
            image_base = int(m.group(1), 16)
        for m in re.finditer(
            r"Export\s*\{\s*Ordinal:\s*(\d+)\s*Name:\s*[^\n]*\s*RVA:\s*(0x[0-9A-Fa-f]+)",
            txt, re.S
        ):
            export_map[int(m.group(1))] = int(m.group(2), 16)
        out += [
            "## PE export table",
            "",
            f"- llvm-readobj exit code: {p.returncode}",
            f"- Export entries parsed: {len(export_map)}",
            f"- Image base: {hex(image_base) if image_base is not None else 'not parsed'}",
            "",
        ]

if not lib.exists():
    out += [f"- WINS import library not found: {lib}", ""]
elif not shutil.which("ar"):
    out += ["- ar not installed; cannot inspect import library.", ""]
else:
    listing = run(["ar", "t", str(lib)])
    members = decode(listing).splitlines()
    out += [
        "## WINS import-library constructor symbol search",
        "",
        f"- Library: {lib}",
        f"- Archive members: {len(members)}",
        "",
    ]
    patterns = re.compile(r"CEikAppUi|CEikApplication|CEikDocument|CCoeAppUi|MObjectProvider")
    matches = []
    for member in members:
        m = re.fullmatch(r"ds0*(\d+)\.o", member, re.I)
        if not m:
            continue
        ordinal = int(m.group(1))
        blob = run(["ar", "p", str(lib), member]).stdout
        if not blob:
            continue
        with tempfile.NamedTemporaryFile() as f:
            f.write(blob)
            f.flush()
            strings = decode(run(["strings", "-a", f.name])).splitlines() if shutil.which("strings") else []
            nm = decode(run(["nm", "-C", f.name])).splitlines() if shutil.which("nm") else []
        hits = [x.strip() for x in nm + strings if patterns.search(x)]
        if hits:
            matches.append((ordinal, member, len(blob), hits[:12]))
    if not matches:
        out += ["- No matching class/constructor symbol strings found in archive members.", ""]
    for ordinal, member, size, hits in matches:
        rva = export_map.get(ordinal)
        out += [
            f"### Ordinal {ordinal} ({member})",
            "",
            f"- Member size: {size} bytes",
            f"- Corresponding WINS DLL export RVA: {hex(rva) if rva is not None else 'not found'}",
            "~~~text",
        ]
        out.extend(hits)
        out += ["~~~", ""]
        if rva is not None and image_base is not None and shutil.which("llvm-objdump"):
            va = image_base + rva
            dis = run(["llvm-objdump", "-d", "--start-address=" + hex(va),
                       "--stop-address=" + hex(va + 0x100), str(dll)])
            out += [f"#### WINS disassembly near {hex(va)}", "", "~~~asm"]
            out.extend(decode(dis).splitlines()[:100] or ["<no disassembly output>"])
            out += ["~~~", ""]

out += [
    "## Interpretation boundary",
    "",
    "WINS ordinal values and virtual addresses are not ARM UREL values.",
    "Even if a WINS constructor is identified, use it only to corroborate",
    "field initialization and high-level control flow. The current game trace",
    "stops at ARM UREL EIKCORE ordinal 224 (CEikAppUi constructor); its",
    "secondary-base vtable state still requires matching ARM evidence.",
]
target = Path("docs/STEP52_EIKCORE_WINS_PROBE.md")
target.write_text("\n".join(out) + "\n")
print(f"Wrote {target} ({target.stat().st_size} bytes)")
