#!/usr/bin/env python3
"""Step20: verify post-GetNearestFont text-context call sequence at five sites."""
from pathlib import Path
import re
ROOT = Path(__file__).resolve().parent
SRC = (ROOT / 'shadowkey_lifted_v6.c').read_text(errors='replace')

def fn(name):
    m = re.search(rf'void {name}\(ngage_cpu_t \*c\) \{{', SRC)
    assert m, name
    n = re.search(r'\nvoid [A-Za-z0-9_]+\(ngage_cpu_t \*c\) \{', SRC[m.end():])
    return SRC[m.start():m.end()+n.start()] if n else SRC[m.start():]

sites = ['sub_10022b20','sub_10022d48','sub_10022f88','sub_100231b4','sub_10023608']
for name in sites[:4]:
    b = fn(name)
    # Device GetNearestFontInTwips: vtable byte offset +0x44.
    p_near = b.find('ngage_r32(c, (c->r[3] + 68u))')
    assert p_near >= 0, (name, 'nearest-font slot +0x44')
    # Context.UseFont(CFont*): receiver is engine+0x2ec; arg is the CFont* out slot.
    p_use = b.find('ngage_r32(c, (c->r[2] + 36u))', p_near)
    assert p_use > p_near, (name, 'context slot +0x24')
    # The main drawing candidate is slot +0xA8 (168 bytes), after font binding.
    p_draw = b.find('+ 168u)', p_use)
    assert p_draw > p_use, (name, 'context slot +0xA8')
    # A call on the graphics context follows the draw candidate at +0x28.
    p_after = b.find('ngage_r32(c, (c->r[3] + 40u))', p_draw)
    assert p_after > p_draw, (name, 'post-draw context slot +0x28')

# Fifth site is a different per-character path: it performs the nearest-font request but does not contain the same contiguous UseFont/+0xA8 sequence. Record that divergence rather than forcing a false match.
fifth = fn('sub_10023608')
assert 'ngage_r32(c, (c->r[3] + 68u))' in fifth
assert 'ngage_r32(c, (c->r[3] + 40u))' in fifth
# First site: confirm ABI arguments at candidate draw call.
b = fn('sub_10022b20')
assert 'c->r[1] = c->r[13] + 0x00000024u;' in b
assert 'c->r[2] = c->r[6];' in b
assert 'c->r[3] = c->r[7];' in b
assert 'c->r[12] = ngage_r32(c, (c->r[12] + 168u))' in b
print('PASS: four text sites order GetNearestFont(+0x44) -> UseFont(+0x24) -> draw candidate(+0xA8) -> post-draw context call(+0x28)')
print('PASS: fifth site has a distinct per-character path; nearest-font and context cleanup calls are present, but it is not forced into the same sequence')
print('PASS: first-site draw candidate receives descriptor-like object in r1 and two geometry arguments in r2/r3')
print('LIMIT: exact CGraphicsContext slot names and draw overload require matching FP1 vtable/API proof')
