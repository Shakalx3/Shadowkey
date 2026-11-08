#!/usr/bin/env python3
"""Audit and relocatably combine the recovered Shadowkey ARMv6 object artifact.

This is an object-closure check only. It does not emit an EKA2 E32 image.
"""
from __future__ import annotations
import argparse
import json
import re
import subprocess
from pathlib import Path


def run(*args: str) -> str:
    return subprocess.check_output(args, text=True, stderr=subprocess.STDOUT)


def symbol_rows(readelf: str, obj: Path):
    for line in run(readelf, "-sW", str(obj)).splitlines():
        parts = line.split()
        # Num Value Size Type Bind Vis Ndx Name [version]
        if len(parts) >= 8 and parts[0].rstrip(":").isdigit():
            yield {
                "ndx": parts[6],
                "name": parts[7].split("@", 1)[0],
                "bind": parts[4],
                "type": parts[3],
            }


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("artifact_root", type=Path)
    ap.add_argument("--readelf", default="readelf")
    ap.add_argument("--linker", default="ld.lld")
    ap.add_argument("--output", type=Path, default=Path("shadowkey-armv6-combined-rel.o"))
    ap.add_argument("--json", type=Path, default=Path("shadowkey-armv6-link-audit.json"))
    args = ap.parse_args()

    objdir = args.artifact_root / "build/shadowkey-armv6"
    objects = sorted(objdir.glob("*.o"))
    if not objects:
        raise SystemExit(f"no .o files found under {objdir}")

    object_checks = []
    for obj in objects:
        header = run(args.readelf, "-h", str(obj))
        attrs = run(args.readelf, "-A", str(obj))
        ok = all(x in header for x in ("ELF32", "ARM", "Version5 EABI")) and "Tag_CPU_arch: v6" in attrs
        if not ok:
            raise SystemExit(f"unexpected target attributes in {obj}\\n{header}\\n{attrs}")
        object_checks.append({"file": obj.name, "size": obj.stat().st_size, "armv6_eabi5": True})

    args.output.parent.mkdir(parents=True, exist_ok=True)
    command = [args.linker, "-r", "-m", "armelf_linux_eabi", "-o", str(args.output), *map(str, objects)]
    linker_version = run(args.linker, "--version").splitlines()[0]
    run(*command)

    unresolved = {}
    for row in symbol_rows(args.readelf, args.output):
        if row["ndx"] == "UND" and row["name"]:
            unresolved[row["name"]] = row["bind"]

    names = sorted(unresolved)
    game_missing = [n for n in names if re.fullmatch(r"sub_[0-9a-fA-F]+", n)]
    custom_runtime = [n for n in names if n.startswith("ngage_runtime_")]
    c_runtime = [n for n in names if n not in custom_runtime and n not in game_missing]
    combined_header = run(args.readelf, "-h", str(args.output))
    soft_float = "soft-float ABI" in combined_header
    report = {
        "object_count": len(objects),
        "objects": object_checks,
        "linker": linker_version,
        "link_command": command,
        "combined_object": str(args.output),
        "combined_size": args.output.stat().st_size,
        "combined_target": "ELF32 ARM EABI5" + (", soft-float ABI" if soft_float else ""),
        "undefined_symbol_count": len(names),
        "undefined_symbols": names,
        "unresolved_game_functions": game_missing,
        "custom_runtime_hooks": custom_runtime,
        "other_runtime_symbols": c_runtime,
        "object_closure_result": "PASS" if not game_missing else "FAIL",
        "e32_image_generated": False,
    }
    args.json.write_text(json.dumps(report, indent=2) + "\\n")
    print(json.dumps(report, indent=2))
    return 0 if not game_missing else 1


if __name__ == "__main__":
    raise SystemExit(main())
