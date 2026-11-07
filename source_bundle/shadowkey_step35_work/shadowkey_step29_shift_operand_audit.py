#!/usr/bin/env python3
from pathlib import Path
import re
import shadowkey_llvm_lift_v2 as lift

p=Path('shadowkey_lifted_v6.c')
lines=p.read_text(errors='replace').splitlines()
allowed={'mov','mvn','adc','sbc','rsc','add','sub','rsb','and','orr','eor','bic','cmp','cmn','tst','teq'}
comment=re.compile(r'/\*\s*([a-z][a-z0-9.]*)\s+(.*?)\s*\*/',re.I)
shift=re.compile(r'\b(?:lsl|lsr|asr|ror|rrx)\b',re.I)
count=0; missing=[]
for no,line in enumerate(lines,1):
    m=comment.search(line)
    if not m: continue
    mnemonic=m.group(1).lower(); base,_=lift.cond_mnem(mnemonic)
    if base.endswith('s') and base[:-1] in allowed: base=base[:-1]
    if base in allowed and shift.search(m.group(2)):
        count+=1
        if 'shadowkey_arm_shift_operand' not in line:
            missing.append((no,line.strip()))
if count!=4961 or missing:
    print(f'FAIL shifted data-processing audit count={count} missing={len(missing)}')
    for row in missing[:20]: print(row)
    raise SystemExit(1)
# Verify generator output for the two instructions that exposed the bug and
# representative register/RRX operand forms.
cases=[
    ('add','r4, r0, r4, asr #1','shadowkey_arm_shift_operand(c, c->r[4], 2u, 1u, 1u, 0u)'),
    ('add','r4, r4, r4, lsr #31','shadowkey_arm_shift_operand(c, c->r[4], 1u, 31u, 1u, 0u)'),
    ('mov','r0, r1, lsl #8','shadowkey_arm_shift_operand(c, c->r[1], 0u, 8u, 1u, 0u)'),
    ('orr','r2, r3, r2, rrx','shadowkey_arm_shift_operand(c, c->r[2], 3u, 0u, 1u, 0u)'),
    ('add','r3, r3, r12, lsl r1','shadowkey_arm_shift_operand(c, c->r[12], 0u, (c->r[1] & 0xffu), 0u, 0u)'),
    ('rsc','r7, r3, r7, lsr #32','shadowkey_arm_shift_operand(c, c->r[7], 1u, 32u, 1u, 0u)'),
]
for mn,ops,needle in cases:
    out=lift.lift_ins(0x10000000,0,mn,ops,[],lambda _a:None,False,{})
    if needle not in out:
        print('FAIL generator case',mn,ops,out)
        raise SystemExit(2)
print(f'PASS: {count} shifted ARM data-processing instructions now use full Operand2 semantics; generator cases pass')
