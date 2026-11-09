#!/usr/bin/env python3
"""Inventory Symbian E32Image tools and probe host ARM compiler support."""
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
SEARCH_DIRS = [SDK / "Epoc32/tools", SDK / "Epoc32/gcc", SDK / "tools"]

def inspect(path: Path):
    row = {"path": str(path), "size": path.stat().st_size,
           "sha256": hashlib.sha256(path.read_bytes()).hexdigest()}
    try:
        row["file"] = subprocess.check_output(["file", "-b", str(path)], text=True).strip()
    except Exception as e:
        row["file_error"] = str(e)
    return row

def main():
    found = {}
    for name in NAMES:
        which = shutil.which(name)
        if which: found[str(Path(which).resolve())] = Path(which).resolve()
    for root in SEARCH_DIRS:
        if not root.exists(): continue
        for name in NAMES:
            for p in root.rglob(name):
                if p.is_file(): found[str(p.resolve())] = p.resolve()
    rows = [inspect(p) for p in sorted(found.values(), key=str)]

    host_tools = {}
    for name in ("wine", "wine64", "wibo", "clang", "clang++", "ld.lld",
                 "llvm-readelf", "llvm-objdump", "gcc", "g++"):
        path = shutil.which(name)
        if path:
            try:
                version = subprocess.check_output([path, "--version"], text=True,
                                                  stderr=subprocess.STDOUT, timeout=5).splitlines()[:3]
            except Exception as e:
                version = [str(e)]
            host_tools[name] = {"path": path, "version": version}

    out = Path("/tmp/probe")
    out.mkdir(exist_ok=True)
    arm_probe = {"attempted": False}
    clang = shutil.which("clang")
    if clang:
        arm_probe["attempted"] = True
        source = out / "arm-eabi-probe.c"
        source.write_text("int shadowkey_eabi_probe(int x) { return x + 1; }\n")
        attempts = []
        for args in (
            ["--target=armv5-none-symbianelf", "-meabi=4"],
            ["--target=armv5-none-symbianelf"],
            ["--target=arm-none-eabi", "-march=armv5te", "-mabi=aapcs"],
        ):
            obj = out / "arm-eabi-probe.o"
            cmd = [clang, *args, "-c", str(source), "-o", str(obj)]
            try:
                result = subprocess.run(cmd, text=True, stdout=subprocess.PIPE,
                                        stderr=subprocess.STDOUT, timeout=15)
                probe = {"command": cmd, "returncode": result.returncode,
                         "output": result.stdout[-2000:]}
                if result.returncode == 0 and obj.exists():
                    probe["elf_header"] = subprocess.check_output(["readelf", "-h", str(obj)], text=True)
                    probe["sha256"] = hashlib.sha256(obj.read_bytes()).hexdigest()
                attempts.append(probe)
            except Exception as e:
                attempts.append({"command": cmd, "error": str(e)})
        arm_probe["attempts"] = attempts

    sdk_counts = {}
    for sub in ("Epoc32/include", "Epoc32/release/armv5/lib", "Epoc32/tools"):
        p = SDK / sub
        sdk_counts[sub] = sum(1 for z in p.rglob("*") if z.is_file()) if p.exists() else 0
    report = {
        "sdk_root": str(SDK), "sdk_present": SDK.is_dir(), "sdk_counts": sdk_counts,
        "tools": rows,
        "elf2e32_found": any(Path(r["path"]).name.lower().startswith("elf2e32") for r in rows),
        "arm_compiler_found": any("armcc" in Path(r["path"]).name.lower() or
                                  "arm-none-symbianelf" in Path(r["path"]).name.lower() for r in rows),
        "host_tools": host_tools, "arm_clang_probe": arm_probe,
    }
    (out / "step70-e32-toolchain-inventory.json").write_text(json.dumps(report, indent=2) + "\n")
    lines = [
        "# Step70 — E32Image toolchain inventory", "",
        f"- Pinned S60 devkit present: {report['sdk_present']}",
    ]
    lines += [f"- {k}: {v} files" for k,v in sdk_counts.items()]
    lines += ["", f"- elf2e32 found: {report['elf2e32_found']}",
              f"- ARM compiler in SDK: {report['arm_compiler_found']}",
              f"- Wine found: {'wine' in host_tools or 'wine64' in host_tools}",
              f"- Clang found: {'clang' in host_tools}", "",
              "| Tool path | File type |", "|---|---|"]
    for r in rows: lines.append(f"| {r['path']} | {r.get('file','?')} |")
    if not rows: lines.append("| (none found) | — |")
    lines += ["", "## Host tool availability", ""]
    for name, info in host_tools.items():
        lines.append(f"- {name}: {info['path']} ({'; '.join(info['version'])})")
    lines += ["", "## ARM Clang probe", "", json.dumps(arm_probe, indent=2), "",
              "This inventory does not prove the toolchain can produce a loadable Symbian E32Image. A successful E32Image build and loader/runtime validation remain separate gates.", ""]
    (out / "STEP70_E32_TOOLCHAIN_INVENTORY.md").write_text("\n".join(lines))
    print(json.dumps({"elf2e32_found": report["elf2e32_found"],
                      "arm_compiler_found": report["arm_compiler_found"],
                      "host_tools": list(host_tools),
                      "arm_clang_probe": arm_probe}, indent=2))

if __name__ == "__main__":
    main()
