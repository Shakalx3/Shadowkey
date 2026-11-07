#!/usr/bin/env python3
"""Repair data-processing Operand2 shifts lost by the original LLVM lift."""
from pathlib import Path
import re
import shadowkey_llvm_lift_v2 as lifter

src=Path('shadowkey_lifted_v6.c')
text=src.read_text(errors='replace')
lines=text.splitlines()
allowed={'mov','mvn','adc','sbc','rsc','add','sub','rsb','and','orr','eor','bic','cmp','cmn','tst','teq'}
label_re=re.compile(r'^L_([0-9a-fA-F]{8}):')
comment_re=re.compile(r'/\*\s*([a-z][a-z0-9.]*)\s+(.*?)\s*\*/',re.I)
shift_re=re.compile(r'\b(?:lsl|lsr|asr|ror|rrx)\b',re.I)
addr=None
patched=0
skipped=[]
for i,line in enumerate(lines):
    lm=label_re.match(line.strip())
    if lm:
        addr=int(lm.group(1),16)
        continue
    if addr is None or 'fprintf(' in line or 'TRACE ' in line:
        continue
    comments=list(comment_re.finditer(line))
    chosen=None
    for cm in comments:
        mnem=cm.group(1).lower()
        ops=cm.group(2).strip()
        base,_=lifter.cond_mnem(mnem)
        if base.endswith('s') and base[:-1] in allowed: base=base[:-1]
        if base in allowed and shift_re.search(ops):
            chosen=(cm,mnem,ops)
    if not chosen:
        continue
    cm,mnem,ops=chosen
    # Only replace ordinary lifted instruction lines. This avoids touching
    # hand-authored diagnostics or compound C statements.
    prefix=line[:cm.start()].strip()
    if not prefix or prefix.startswith('fprintf') or 'TRACE' in prefix:
        skipped.append((i+1,line[:180])); continue
    try:
        generated=lifter.lift_ins(addr,0,mnem,ops,[],lambda _va:None,False,{})
    except Exception as e:
        skipped.append((i+1,f'{mnem} {ops}: {e}')); continue
    if 'ngage_unimplemented' in generated:
        skipped.append((i+1,f'{mnem} {ops}: still unsupported')); continue
    lines[i]='    '+generated
    patched+=1

out='\n'.join(lines)+'\n'
if '#include "shadowkey_arm_shift.h"' not in out:
    needle='typedef struct { uint32_t r[16]; uint32_t cpsr; uint8_t *mem; } ngage_cpu_t;\n'
    if needle not in out: raise SystemExit('CPU typedef not found')
    out=out.replace(needle,needle+'#include "shadowkey_arm_shift.h"\n',1)
src.write_text(out)
print(f'patched={patched} skipped={len(skipped)}')
for row in skipped[:40]: print('SKIP',row)
