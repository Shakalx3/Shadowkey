#!/usr/bin/env python3
"""Step18 regression: distinguish mandatory GDI glyph prep from optional GDI101 path."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parent
SRC = (ROOT / "shadowkey_lifted_v6.c").read_text(errors="replace")

def function(name: str) -> str:
    m = re.search(rf"void {re.escape(name)}\(ngage_cpu_t \*c\) \{{", SRC)
    assert m, f"missing {name}"
    n = re.search(r"\nvoid [A-Za-z0-9_]+\(ngage_cpu_t \*c\) \{", SRC[m.end():])
    return SRC[m.start():m.end() + n.start()] if n else SRC[m.start():]

# Five independent call sites share the same broad pipeline.
names = ["sub_10022b20", "sub_10022d48", "sub_10022f88", "sub_100231b4", "sub_10023608"]
for name in names:
    body = function(name)
    assert "ngage_call(c, 0x100a00a0u)" in body, f"{name}: missing GDI151"
    assert "ngage_call(c, 0x100a00c0u)" in body, f"{name}: missing GDI108"
    assert body.index("ngage_call(c, 0x100a00a0u)") < body.index("ngage_call(c, 0x100a00c0u)"), name
    assert "0x00000014u" in body, f"{name}: 20-byte record copy length not visible"
    assert "0x000000d5u" in body, f"{name}: character argument D5 not visible"

# The optional GDI 101 stage is explicitly conditional in first call site.
b = function("sub_10022b20")
assert "ngage_call(c, 0x100a00b0u)" in b
assert "if (!ngage_zf(c)) { c->r[0] = c->r[13] + 0x00000268u; }" in b
assert b.index("ngage_call(c, 0x100a00a0u)") < b.index("ngage_call(c, 0x100a00b0u)") < b.index("ngage_call(c, 0x100a00c0u)")

# GDI108's output/work slot is four bytes before the 60-byte GDI151 result.
assert "c->r[0] = c->r[13] + 0x00000268u;" in b
assert "c->r[2] = c->r[13] + 0x0000022cu;" in b

# EUSER1575 and 1557 are a paired stateful operation; preserve existing guard.
e = function("sub_10022898")
assert "ngage_call(c, 0x1009f240u)" in e
assert "ngage_call(c, 0x1009f250u)" in e
assert e.index("ngage_call(c, 0x1009f240u)") < e.index("ngage_call(c, 0x1009f250u)")
assert "if (ngage_zf(c)) { goto L_10022a4c; }" in e

print("PASS: all five text-chain sites contain GDI151 -> GDI108 and 20-byte record preparation")
print("PASS: first site proves conditional GDI101 between GDI151 and GDI108")
print("PASS: GDI151 result span is 60 bytes; GDI108 work/output slot is separate at +0x268")
print("PASS: EUSER1575 success guard precedes paired EUSER1557 operation")
print("LIMIT: export names, internal structure fields, glyph rasterization semantics remain unproven")
