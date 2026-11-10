#!/usr/bin/env python3
"""Disassemble ordinal 1 of the legacy APP DLL using the original ARM toolchain."""
import argparse
import csv
import json
import subprocess
from pathlib import Path

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--game", type=Path, required=True)
    ap.add_argument("--header", type=Path, required=True)
    ap.add_argument("--exports", type=Path, required=True)
    ap.add_argument("--objdump", type=Path, required=True)
    ap.add_argument("--out", type=Path, required=True)
    args = ap.parse_args()

    h = json.loads(args.header.read_text(encoding="utf-8"))
    rows = list(csv.DictReader(args.exports.open(newline="", encoding="utf-8"), delimiter="\t"))
    factory = next((r for r in rows if int(r["ordinal"]) == 1), None)
    if factory is None:
        raise ValueError("legacy APP DLL has no ordinal-1 export")
    if factory["valid_code_offset"].lower() != "true":
        raise ValueError(f"ordinal 1 does not point into code: {factory}")

    va = int(factory["runtime_address"], 16)
    code_base = int(h["code_base"], 16)
    code_off = int(h["code_offset"])
    adjust_vma = code_base - code_off
    mode = "force-thumb" if int(factory["thumb"]) else "arm"
    start = va
    stop = va + 160
    p = subprocess.run([
        str(args.objdump), "-D", "-b", "binary", "-m", "arm", "-M", mode,
        f"--adjust-vma=0x{adjust_vma:X}",
        f"--start-address=0x{start:X}",
        f"--stop-address=0x{stop:X}",
        str(args.game),
    ], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if p.returncode:
        raise RuntimeError(p.stderr)
    lines = [
        "Legacy APP DLL factory export",
        f"UID1={h['uid1']} UID2={h['uid2']} UID3={h['uid3']}",
        f"module_kind={h['module_kind']} flags={h['flags']}",
        f"ordinal=1 runtime_address=0x{va:08X} thumb={factory['thumb']}",
        f"code_file_offset={factory['code_file_offset']} adjust_vma=0x{adjust_vma:08X}",
        "",
        p.stdout,
    ]
    args.out.write_text("\n".join(lines), encoding="utf-8")
    print("\n".join(lines))

if __name__ == "__main__":
    main()
