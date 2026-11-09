#!/usr/bin/env python3
"""Inventory Symbian E32Image build tools in the pinned S60 3.1 devkit and runner."""
from __future__ import annotations
import hashlib
import json
import shutil
import subprocess
from pathlib import Path

SDK = Path("/tmp/s60-devkit")
NAMES = [
    "elf2e32", "elf2e32.exe", "armcc", "armcc.exe",
    "arm-none-symbianelf-gcc", "arm-none-symbianelf-g++",
    "arm-none-eabi-gcc", "arm-none-eabi-g++",
    "arm-linux-gnueabi-gcc", "arm-linux-gnueabi-g++",
    "abld", "abld.bat", "bldmake", "bldmake.bat",
    "sbs", "sbs.bat", "makmake", "makmake.bat",
]
SEARCH_DIRS = [
    SDK / "Epoc32/tools", SDK / "Epoc32/gcc", SDK / "tools",
    Path("/usr/bin"), Path("/usr/local/bin"), Path("/opt"),
]

def inspect(path: Path):
    row = {"path": str(path), "size": path.stat().st_size,
           "sha256": hashlib.sha256(path.read_bytes()).hexdigest()}
    try:
        row["file"] = subprocess.check_output(["file", "-b", str(path)], text=True).strip()
    except Exception as e:
        row["file_error"] = str(e)
    if path.name.lower() in ("elf2e32", "elf2e32.exe", "armcc", "armcc.exe",
                              "arm-none-symbianelf-gcc", "arm-none-symbianelf-g++"):
        try:
            row["version"] = subprocess.check_output([str(path), "--version"], text=True,
                                                       stderr=subprocess.STDOUT, timeout=5).splitlines()[:5]
        except Exception as e:
            row["version_probe"] = str(e)
    return row

def main():
    found = {}
    for name in NAMES:
        which = shutil.which(name)
        if which:
            found[str(Path(which).resolve())] = Path(which).resolve()
    for root in SEARCH_DIRS:
        if not root.exists(): continue
        if root.is_file():
            if root.name.lower() in {n.lower() for n in NAMES}: found[str(root)] = root
            continue
        for name in NAMES:
            for p in root.rglob(name):
                if p.is_file(): found[str(p.resolve())] = p.resolve()
    rows = [inspect(p) for p in sorted(found.values(), key=str)]
    sdk_counts = {}
    for sub in ("Epoc32/include", "Epoc32/release/armv5/lib", "Epoc32/tools"):
        p = SDK / sub
        sdk_counts[sub] = sum(1 for x in p.rglob("*") if x.is_file()) if p.exists() else 0
    report = {
        "sdk_root": str(SDK),
        "sdk_present": SDK.is_dir(),
        "sdk_counts": sdk_counts,
        "tools": rows,
        "elf2e32_found": any(Path(r["path"]).name.lower().startswith("elf2e32") for r in rows),
        "arm_compiler_found": any("armcc" in Path(r["path"]).name.lower() or "arm-none-symbianelf" in Path(r["path"]).name.lower() for r in rows),
    }
    out = Path("/tmp/probe")
    out.mkdir(exist_ok=True)
    (out / "step70-e32-toolchain-inventory.json").write_text(json.dumps(report, indent=2) + "\n")
    lines = [
        "# Step70 — E32Image toolchain inventory", "",
        f"- Pinned S60 devkit present: {report['sdk_present']}",
    ]
    lines += [f"- {k}: {v} files" for k,v in sdk_counts.items()]
    lines += ["", f"- elf2e32 found: {report['elf2e32_found']}",
              f"- ARM compiler found: {report['arm_compiler_found']}", "",
              "| Tool path | File type | Version probe |", "|---|---|---|"]
    for r in rows:
        lines.append(f"| {r['path']} | {r.get('file','?')} | {'; '.join(r.get('version', [])) or r.get('version_probe','not probed')} |")
    if not rows: lines.append("| (none found) | — | — |")
    lines += ["", "This inventory does not prove the toolchain can produce a loadable Symbian E32Image. A successful E32Image build and loader/runtime validation remain separate gates.", ""]
    (out / "STEP70_E32_TOOLCHAIN_INVENTORY.md").write_text("\n".join(lines))
    print(json.dumps({"elf2e32_found":report["elf2e32_found"],"arm_compiler_found":report["arm_compiler_found"],"tools":[r["path"] for r in rows]},indent=2))

if __name__ == "__main__":
    main()
