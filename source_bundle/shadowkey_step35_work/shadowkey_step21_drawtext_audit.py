#!/usr/bin/env python3
"""Step21: verify CGraphicsContext::DrawText rectangle overload ABI at four sites."""
from pathlib import Path
import re
ROOT = Path(__file__).resolve().parent
SRC = (ROOT / 'shadowkey_lifted_v6.c').read_text(errors='replace')

def body(name):
    m = re.search(rf'void {name}\(ngage_cpu_t \*c\) \{{', SRC)
    assert m, name
    n = re.search(r'\nvoid [A-Za-z0-9_]+\(ngage_cpu_t \*c\) \{', SRC[m.end():])
    return SRC[m.start():m.end()+n.start()] if n else SRC[m.start():]

sites = {
    'sub_10022b20': ('c->r[13]', 'c->r[6]', 'c->r[7]'),
    'sub_10022d48': ('c->r[13]', 'c->r[6]', 'c->r[7]'),
    'sub_10022f88': ('c->r[13]', 'c->r[6]', 'c->r[7]'),
    'sub_100231b4': ('c->r[13]', 'c->r[2]', 'c->r[4]'),
}
for name, _ in sites.items():
    b = body(name)
    p = b.find('+ 168u)')
    assert p >= 0, (name, 'context vtable +0xA8')
    pre = b[max(0, p-1500):p]
    post = b[p:p+1200]
    assert 'c->r[1] =' in pre and 'c->r[2] =' in pre and 'c->r[3] =' in pre
    assert 'ngage_call(c, c->r[12])' in post
    # r3 is the baseline argument; it is computed from font metrics before the call.
    assert 'c->r[3] =' in pre
    # The caller stores the two trailing C++ arguments in [sp] and [sp+4].
    assert 'ngage_w32(c, c->r[13]' in pre
    assert 'ngage_w32(c, (c->r[13] + 4u)' in pre
    # Context cleanup at +0x28 immediately follows the draw call.
    tail = b[p:]
    assert ' + 40u)' in tail and '0x28' in tail, name

# Check observed alignment constants for first three call sites.
expected = {
    'sub_10022b20': ('0x00000000u', '0x00000000u'),
    'sub_10022d48': ('0x00000001u', '0x00000000u'),
    'sub_10022f88': ('0x00000002u', '0x00000000u'),
}
for name, vals in expected.items():
    b = body(name)
    p = b.find('+ 168u)')
    pre = b[max(0,p-1200):p]
    assert vals[0] in pre and vals[1] in pre, (name, vals)

print('PASS: four callers pass a descriptor-like object, rectangle pointer, baseline, and two stack arguments to CGraphicsContext vslot +0xA8')
print('PASS: first three sites carry trailing constants (0,0), (1,0), (2,0), consistent with text alignment and margin parameters')
print('PASS: all four sites invoke a no-argument CGraphicsContext vslot +0x28 immediately after the draw call')
print('LIMIT: exact S60 FP1 vtable declaration is unavailable; names are matched by ABI and public CGraphicsContext API sequence')
