#!/usr/bin/env python3
"""Convert the E32 import parser CSV into the C dispatch format used by Step46/82."""
import argparse
import csv
import re
from pathlib import Path

DEP_RE = re.compile(r"^([A-Za-z0-9]+)(?:\[([0-9a-fA-F]+)\])?\.DLL$", re.I)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--csv", type=Path, required=True)
    ap.add_argument("--out", type=Path, required=True)
    args = ap.parse_args()
    rows = list(csv.DictReader(args.csv.open(newline="", encoding="utf-8")))
    out = [
        "/* Generated from E32 import table; addresses are original image VAs. */",
        "typedef struct { unsigned int thunk, slot; const char *dependency; unsigned int ordinal; } import_t;",
        "static const import_t imports[] = {",
    ]
    bad = []
    for row in rows:
        dep = row["dependency"].strip()
        m = DEP_RE.match(dep)
        if not m:
            bad.append(dep)
            continue
        dll = m.group(1).upper()
        uid = (m.group(2) or "00000000").lower()
        thunk = int(row["thunk_address"], 16)
        slot = int(row["slot_address"], 16)
        ordinal = int(row["ordinal"])
        out.append(f'    {{0x{thunk:08X}u, 0x{slot:08X}u, "{dll}[{uid}].DLL", {ordinal}u}},')
    out.append("};")
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text("\n".join(out) + "\n", encoding="utf-8")
    print(f"rows={len(rows)} emitted={len(rows)-len(bad)} rejected={len(bad)}")
    if bad:
        print("rejected_dependencies=" + repr(sorted(set(bad))))

if __name__ == "__main__":
    main()
