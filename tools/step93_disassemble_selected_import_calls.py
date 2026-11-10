#!/usr/bin/env python3
"""Disassemble callers and import thunks for selected 6R51.APP imports."""
import argparse
import csv
import json
import re
import subprocess
from pathlib import Path

SELECTED = [
    ("euser", 1407), ("euser", 1575), ("cone", 160),
    ("eikcore", 224), ("gdi", 101), ("gdi", 108), ("gdi", 151),
]


def run_objdump(objdump: Path, game: Path, adjust_vma: int,
                start: int, stop: int, mode: str) -> str:
    p = subprocess.run([
        str(objdump), "-D", "-b", "binary", "-m", "arm", "-M", mode,
        f"--adjust-vma=0x{adjust_vma:X}",
        f"--start-address=0x{start:X}",
        f"--stop-address=0x{stop:X}",
        str(game),
    ], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if p.returncode:
        raise RuntimeError(f"objdump ({mode}) failed: {p.stderr.strip()}")
    return p.stdout


def direct_branch_targets(disassembly: str, target: int) -> list[tuple[int, str]]:
    found = []
    for line in disassembly.splitlines():
        if ":" not in line:
            continue
        left, right = line.split(":", 1)
        try:
            address = int(left.strip(), 16)
        except ValueError:
            continue
        m = re.search(r"\b([a-z][a-z0-9.]*)\s+0x([0-9a-fA-F]+)\b", right)
        if not m:
            continue
        mnemonic = m.group(1).lower()
        if not mnemonic.startswith("b"):
            continue
        try:
            dest = int(m.group(2), 16)
        except ValueError:
            continue
        if dest == target:
            found.append((address, mnemonic))
    return found


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--game", type=Path, required=True)
    ap.add_argument("--header", type=Path, required=True)
    ap.add_argument("--iat-refs", type=Path, required=True)
    ap.add_argument("--objdump", type=Path, required=True)
    ap.add_argument("--out", type=Path, required=True)
    args = ap.parse_args()

    h = json.loads(args.header.read_text(encoding="utf-8"))
    code_base = int(h["code_base"], 16)
    code_off = int(h["code_offset"])
    code_size = int(h["code_size"])
    adjust_vma = code_base - code_off
    code_end = code_base + code_size
    rows = list(csv.DictReader(args.iat_refs.open(newline="", encoding="utf-8"), delimiter="\t"))
    by_key = {
        (r["dependency"].split("[", 1)[0].lower(), int(r["ordinal"])): r
        for r in rows
    }

    out = [
        "Step93 — selected import caller and thunk disassembly",
        f"game={args.game}",
        f"code_base=0x{code_base:08X} code_size=0x{code_size:X} code_offset=0x{code_off:X}",
        f"objdump_adjust_vma=0x{adjust_vma:08X}",
        "Branch search scans the complete code segment in ARM and forced-Thumb modes.",
        "A missing direct branch is not proof of an unused import; indirect calls are possible.",
        "",
    ]

    full_disassembly = {}
    for mode in ("arm", "force-thumb"):
        full_disassembly[mode] = run_objdump(
            args.objdump, args.game, adjust_vma, code_base, code_end, mode
        )

    data = args.game.read_bytes()
    for dll, ordinal in SELECTED:
        row = by_key.get((dll, ordinal))
        out.append(f"=== {dll.upper()} ordinal {ordinal} ===")
        if row is None:
            out.append("No IAT row found.")
            out.append("")
            continue
        thunk = int(row["thunk_address"], 16) if row["thunk_address"] else 0
        slot = int(row["slot_address"], 16)
        refs = [int(x, 16) for x in row["reference_offsets"].split(",") if x]
        out.append(f"slot=0x{slot:08X} thunk=0x{thunk:08X} literal_refs={len(refs)}")
        for foff in refs:
            va = code_base + (foff - code_off)
            lo = max(0, foff - 16)
            hi = min(len(data), foff + 20)
            out.append(f"literal fileoff=0x{foff:X} VA=0x{va:08X} bytes[{lo:#x}:{hi:#x}]={data[lo:hi].hex(' ')}")
        if thunk:
            for mode in ("arm", "force-thumb"):
                start = max(code_base, thunk - 12)
                stop = min(code_end, thunk + 32)
                out.append(f"thunk disassembly ({mode}):")
                out.extend("  " + x for x in run_objdump(
                    args.objdump, args.game, adjust_vma, start, stop, mode
                ).splitlines())

            for mode in ("arm", "force-thumb"):
                branches = direct_branch_targets(full_disassembly[mode], thunk)
                out.append(f"direct branches to thunk ({mode}): {len(branches)}")
                for address, mnemonic in branches:
                    out.append(f"  {mnemonic} at 0x{address:08X}")
                    start = max(code_base, address - 20)
                    stop = min(code_end, address + 28)
                    out.extend("    " + x for x in run_objdump(
                        args.objdump, args.game, adjust_vma, start, stop, mode
                    ).splitlines())
        else:
            out.append("No recognized thunk address in dispatch table.")
        out.append("")

    args.out.write_text("\n".join(out) + "\n", encoding="utf-8")
    print("\n".join(out))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
