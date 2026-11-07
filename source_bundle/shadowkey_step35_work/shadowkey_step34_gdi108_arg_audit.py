#!/usr/bin/env python3
"""Step34: resolve sub_10023608 GDI108 r1 at the call boundary.

This is a static provenance audit of the lifted ARM control flow. It does not
identify GDI ordinal 108 or assign meaning to its second parameter.
"""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parent
SRC = (ROOT / 'shadowkey_lifted_v6.c').read_text(errors='replace')

# The only direct BL callsites to sub_10023608 in the recovered image.
callers = {
    0x1006B734: {
        'setup': {
            0x14: 'c->r[5]',  # r5 was just set to 0
            0x18: 'c->r[8]',  # r8 was just set to 1
        },
        'preceding': ['c->r[5] = 0x00000000u;', 'c->r[8] = 0x00000001u;'],
    },
    0x1006B7D8: {
        'setup': {
            0x14: 'c->r[5]',
            0x18: 'c->r[8]',
        },
        'preceding': ['c->r[5] = 0x00000000u;', 'c->r[8] = 0x00000001u;'],
    },
}

# Ensure no other direct call exists in the lifted source.
found = [int(x, 16) for x in re.findall(
    r'c->r\[14\] = 0x([0-9a-fA-F]{8})u; ngage_call\(c, 0x10023608u\)', SRC)]
assert sorted(found) == sorted(callers), f'unexpected sub_10023608 callsites: {[hex(x) for x in found]}'

for lr, spec in callers.items():
    call = f'c->r[14] = 0x{lr:08x}u; ngage_call(c, 0x10023608u)'
    pos = SRC.index(call)
    before = SRC[max(0, pos - 2400):pos]
    for needle in spec['preceding']:
        assert needle in before, f'{hex(lr)} missing caller setup {needle}'
    for off, value in spec['setup'].items():
        needle = f'ngage_w32(c, (c->r[13] + {off}u), (uint32_t){value})'
        assert needle in before, f'{hex(lr)} missing outgoing stack argument at +{off:#x}'

# Callee frame arithmetic: push 8 regs = 0x20, then subtract 0x6a0 + 0x0c.
# Thus callee SP+0x6e0/+0x6e4 alias entry-SP+0x14/+0x18.
callee = SRC[SRC.index('void sub_10023608(ngage_cpu_t *c)'):SRC.index('void sub_10023910(ngage_cpu_t *c)')]
assert 'c->r[13] = c->r[13] - 0x000006a0u' in callee
assert 'c->r[13] = c->r[13] - 0x0000000cu' in callee
assert 'c->r[6] = ngage_r8(c, c->r[8])' in callee
assert 'c->r[5] = ngage_r8(c, c->r[9])' in callee
assert 'c->r[8] = c->r[13] + 0x000006e0u' in callee
assert 'c->r[9] = c->r[13] + 0x000006e0u' in callee
assert 'c->r[9] = c->r[9] + 0x00000004u' in callee

# Both callers pass 0 and 1, so callee's byte loads are deterministically 0 and 1.
# The GDI101 branch is gated by r5!=0; GDI108 r1 is r10 on r6==0 path.
assert 'if (!ngage_zf(c)) { c->r[1] = 0x00000001u; }' in callee
assert 'c->r[1] = c->r[10];' in callee
assert 'c->r[10] = 0x00000000u;' in callee
# The +13 accumulation occurs strictly after the GDI108 call.
call108 = callee.index('c->r[14] = 0x100236d8u; ngage_call(c, 0x100a00c0u)')
first_plus13 = callee.index('c->r[10] = c->r[10] + 0x0000000du;')
assert first_plus13 > call108

print('PASS: exactly two direct callsites to sub_10023608 are present')
print('PASS: both callers write outgoing stack args +0x14=0 and +0x18=1')
print('PASS: callee frame arithmetic maps those words to LDRB inputs r6=0 and r5=1')
print('PASS: GDI101 conditional path is taken (r5=1), GDI108 gets r1=r10=0 (r6=0)')
print('PASS: r10 += 13 occurs only after the GDI108 call; it is not that call argument')
print('LIMIT: GDI ordinal 101/108 identities and parameter semantics remain unverified')
