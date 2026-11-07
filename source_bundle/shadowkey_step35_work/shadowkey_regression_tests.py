#!/usr/bin/env python3
"""Regression checks for the IDA-free Shadowkey ARM recovery/lifter prototype."""
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT))
import shadowkey_recover_vtables_v2 as recover

# These exact encodings were previously missed because the mask erased Rm but
# the comparison still required the Rm bits to equal PC/LR.
assert recover.is_mov_lr_pc(0xE1A0E00F), "MOV LR, PC must be recognized"
assert recover.is_mov_pc_lr(0xE1A0F00E), "MOV PC, LR must be recognized"
assert not recover.is_mov_lr_pc(0xE1A0E000), "MOV LR, R0 must not match MOV LR, PC"

map_path = ROOT / "shadowkey_functions_v2.json"
lift_path = ROOT / "shadowkey_lifted_v4.c"
if not map_path.exists(): map_path = ROOT / "vtable_recovery" / "shadowkey_functions_v2.json"
if not lift_path.exists(): lift_path = ROOT / "vtable_recovery" / "shadowkey_lifted_v4.c"

j = json.loads(map_path.read_text())
funcs = {f["start"]: f for f in j["functions"]}
# This constructor has an indirect virtual call at 0x10021480. The old recovery
# treated BX R12 as a tail dispatch and truncated the function at 0x10021484.
f = funcs[0x10021244]
assert f["end"] >= 0x100214AC, hex(f["end"])
assert 0x10021484 in f["heads"] and 0x100214A8 in f["heads"]

src = lift_path.read_text()
for address, continuation in [(0x10021480, 0x10021484), (0x10021740, 0x10021744)]:
    block = re.search(rf"L_{address:08x}:\n([^\n]+)", src)
    assert block, f"missing lifted address {address:#x}"
    assert f"goto L_{continuation:08x}" in block.group(1), block.group(1)

print("PASS: ARM return/call idiom masks")
print("PASS: CFG continues after MOV LR,PC ; BX Rm")
print("PASS: lifted unconditional and conditional indirect-call continuations")
print(f"PASS: map contains {len(funcs)} function candidates and {sum(len(f['heads']) for f in funcs.values())} instruction heads")
