#!/usr/bin/env python3
"""Inspect code around IAT references whose import thunk was not recognized."""
import argparse
import csv
import json
import subprocess
import struct
from pathlib import Path

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--game", type=Path, required=True)
    ap.add_argument("--header", type=Path, required=True)
    ap.add_argument("--iat-refs", type=Path, required=True)
    ap.add_argument("--objdump", type=Path, required=True)
    ap.add_argument("--out", type=Path, required=True)
    args = ap.parse_args()

    h = json.loads(args.header.read_text(encoding="utf-8"))
    data = args.game.read_bytes()
    code_base = int(h["code_base"], 16)
    code_off = int(h["code_offset"])
    adjust_vma = code_base - code_off
    rows = list(csv.DictReader(args.iat_refs.open(newline="", encoding="utf-8"), delimiter="\t"))
    unmatched = [r for r in rows if r["recognized_thunk"].lower() != "true"]
    out = [
        f"unmatched IAT slots: {len(unmatched)}",
        f"game code base: 0x{code_base:08X}",
        f"code file offset: 0x{code_off:X}",
        f"objdump adjust VMA: 0x{adjust_vma:08X}",
        "",
    ]
    for row in unmatched:
        out.append(f"{row['dependency']} ordinal={row['ordinal']} slot={row['slot_address']}")
        refs = [int(x, 16) for x in row["reference_offsets"].split(",") if x]
        if not refs:
            out.append("  no code literal references to this IAT slot")
            continue
        for foff in refs:
            va = code_base + (foff - code_off)
            lo = max(0, foff-48)
            hi = min(len(data), foff+32)
            out.append(f"  reference fileoff=0x{foff:X} VA=0x{va:08X}")
            out.append(f"  bytes[{lo:#x}:{hi:#x}]={data[lo:hi].hex(' ')}")
            candidate_start = va - 8
            code = data[code_off:code_off+int(h["code_size"])]
            branch_refs = []
            for insn_off in range(0, len(code)-3, 4):
                insn = struct.unpack_from("<I", code, insn_off)[0]
                if (insn & 0x0E000000) == 0x0A000000:
                    imm = insn & 0x00FFFFFF
                    if imm & 0x00800000:
                        imm -= 0x01000000
                    target = code_base + insn_off + 8 + (imm << 2)
                    if target == candidate_start:
                        branch_refs.append(f"0x{code_base+insn_off:08X}")
            out.append(f"  candidate two-instruction thunk start=0x{candidate_start:08X}")
            out.append(f"  ARM B/BL references to candidate={branch_refs}")
            for mode in ("arm", "force-thumb"):
                start = max(code_base, va-48)
                align = 4 if mode == "arm" else 2
                start -= (start - code_base) % align
                stop = va + 16
                p = subprocess.run([
                    str(args.objdump), "-D", "-b", "binary", "-m", "arm", "-M", mode,
                    f"--adjust-vma=0x{adjust_vma:X}",
                    f"--start-address=0x{start:X}",
                    f"--stop-address=0x{stop:X}",
                    str(args.game),
                ], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
                out.append(f"  disassembly ({mode}):")
                if p.returncode:
                    out.append("    ERROR: " + p.stderr.strip())
                else:
                    out.extend("    " + x for x in p.stdout.splitlines())
        out.append("")
    text = "\n".join(out) + "\n"
    args.out.write_text(text, encoding="utf-8")
    print(text)

if __name__ == "__main__":
    main()
