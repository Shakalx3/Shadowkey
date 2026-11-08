#!/usr/bin/env python3
"""Inspect the SDK's WINS UDEB EIKCORE DLL as a semantic reference only."""
from pathlib import Path
import hashlib
import os
import re
import shutil
import subprocess

root = Path(os.environ.get("SHADOWKEY_ARM_SDK_ROOT", "/tmp/ngagesdk-sdk"))
dll = root / "6.1/Series60/Epoc32/Release/wins/udeb/eikcore.dll"

def run(args):
    return subprocess.run(args, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                          check=False)

out = [
    "# Step 52 — WINS UDEB EIKCORE DLL probe",
    "",
    "This is a semantic/reference probe of the SDK's WINS UDEB EIKCORE DLL.",
    "It is not ARM UREL code and cannot supply ARM vtable addresses or prove",
    "the exact ARM constructor implementation.",
    "",
]
if not dll.exists():
    out += [f"- DLL not found: {dll}", ""]
else:
    data = dll.read_bytes()
    out += [
        f"- File: {dll}",
        f"- Size: {len(data)} bytes",
        f"- SHA-256: {hashlib.sha256(data).hexdigest()}",
        "",
    ]
    if shutil.which("file"):
        p = run(["file", str(dll)])
        out += ["## File identification", "", "~~~text",
                p.stdout.decode("utf-8", "replace").strip(),
                "~~~", ""]
    for tool, args in [
        ("llvm-readobj", ["--file-headers", "--coff-exports", str(dll)]),
        ("llvm-nm", ["-C", "--defined-only", str(dll)]),
    ]:
        if not shutil.which(tool):
            out += [f"## {tool}", "", f"- Tool not installed: {tool}", ""]
            continue
        p = run([tool, *args[1:]]) if args[0] == tool else run([tool, *args])
        txt = p.stdout.decode("utf-8", "replace")
        if tool == "llvm-nm":
            hits = [line for line in txt.splitlines()
                    if re.search(r"CEikAppUi|CEikApplication|CEikDocument|CCoeAppUi|MObjectProvider|CleanupStack", line)]
            out += ["## C++ symbol table matches", "", f"- Exit code: {p.returncode}",
                    f"- Matching lines: {len(hits)}", "~~~text"]
            out.extend(hits[:160] or ["<no matching public/debug symbols>"])
            out += ["~~~", ""]
        else:
            out += ["## PE headers and exports", "", f"- Exit code: {p.returncode}", "~~~text"]
            out.extend(txt.splitlines()[:240] or ["<no output>"])
            out += ["~~~", ""]
    if shutil.which("strings"):
        p = run(["strings", "-a", str(dll)])
        hits = [line for line in p.stdout.decode("utf-8", "replace").splitlines()
                if re.search(r"CEikAppUi|CEikApplication|CEikDocument|MObjectProvider", line)]
        out += ["## Printable class-name strings", "", f"- Matches: {len(hits)}", "~~~text"]
        out.extend(hits[:100] or ["<no matching strings>"])
        out += ["~~~", ""]

out += [
    "## Interpretation boundary",
    "",
    "If symbols or constructor code are recovered here, use them only to",
    "understand field initialization and control flow. Do not transplant WINS",
    "addresses, vtables, calling conventions or export ordinals into the ARM",
    "game. The current live trace is blocked at ARM UREL EIKCORE ordinal 224;",
    "a matching N-Gage ARM EIKCORE DLL or ROM dump is still needed to resolve",
    "its remaining secondary-vtable initialization with confidence.",
]
target = Path("docs/STEP52_EIKCORE_WINS_PROBE.md")
target.write_text("\n".join(out) + "\n")
print(f"Wrote {target} ({target.stat().st_size} bytes)")
