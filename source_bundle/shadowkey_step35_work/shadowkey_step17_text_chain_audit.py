#!/usr/bin/env python3
"""Regression checks for the step17 static text/geometry call-chain audit.

This deliberately checks ABI/data-flow evidence only. It does not assign
unverified Symbian export names or provide guessed HLE implementations.
"""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parent
SRC = (ROOT / "shadowkey_lifted_v6.c").read_text(errors="replace")


def fn(name: str) -> str:
    m = re.search(rf"void {re.escape(name)}\(ngage_cpu_t \*c\) \{{", SRC)
    assert m, f"missing {name}"
    n = re.search(r"\nvoid [A-Za-z0-9_]+\(ngage_cpu_t \*c\) \{", SRC[m.end():])
    return SRC[m.start():m.end() + n.start()] if n else SRC[m.start():]

# CONE 160: all four sites use hidden-result ABI; first site feeds the pair
# then overwritten by constants; do not mistake it for bitmap dimensions.
for address in ("10021400", "10021d8c", "10022ad4", "100282a8"):
    assert f"L_{address}:" in SRC, f"missing CONE160 site {address}"
body = fn("sub_10021244")
assert "c->r[0] = c->r[5];" in body and "c->r[1] = c->r[7];" in body
assert "ngage_call(c, 0x1009f510u)" in body
assert "ngage_call(c, 0x1009f200u)" in body
assert "c->r[0] = c->r[6];" in body and "c->r[1] = c->r[5];" in body
assert body.index("ngage_call(c, 0x1009f200u)") < body.index("c->r[3] = 0x000000b0u;")
assert "ngage_w32(c, c->r[13], (uint32_t)c->r[3]);" in body
assert "c->r[2] = 0x000000e9u;" in body
assert "ngage_w32(c, (c->r[13] + 4u), (uint32_t)c->r[2]);" in body
assert "c->r[2] = 0x0000000au;" in body

# EUSER 1575: output pair copied into object+0x310 only after success;
# return zero is the error/cleanup branch.
body = fn("sub_10022898")
assert "c->r[0] = c->r[10];" in body
assert "c->r[1] = c->r[5];" in body
assert "ngage_call(c, 0x1009f240u)" in body
assert "if (ngage_zf(c)) { goto L_10022a4c; }" in body
assert "c->r[3] = c->r[8] + 0x00000310u;" in body
assert "ngage_w32(c, _b, c->r[6]); ngage_w32(c, _b + 4u, c->r[7]);" in body
assert "ngage_w32(c, (c->r[8] + 796u), (uint32_t)c->r[2]);" in body

# GDI 151 -> GDI 108 ordering and exact first-call argument setup.
body = fn("sub_10022b20")
for snippet in (
    "c->r[0] = c->r[13] + 0x0000022cu;",
    "c->r[1] = c->r[13] + 0x0000026cu;",
    "c->r[2] = 0x000000d5u;",
    "ngage_call(c, 0x100a00a0u)",
    "c->r[0] = c->r[13] + 0x00000268u;",
    "ngage_call(c, 0x100a00c0u)",
):
    assert snippet in body, f"missing GDI text-chain element: {snippet}"
assert body.index("ngage_call(c, 0x100a00a0u)") < body.index("ngage_call(c, 0x100a00c0u)")
assert "(c->r[3] + 68u)" in body  # following virtual dispatch, slot +0x44

print("PASS: CONE 160 has four hidden-result call sites; first-site pair is not misclassified as bitmap dimensions")
print("PASS: EUSER 1575 is status-returning; output pair is committed only on nonzero result")
print("PASS: GDI 151 -> GDI 108 order and first-site argument setup are stable")
print("INFERENCE: TPoint/TSize-like return; Position() and Size() remain candidates pending vtable/export proof")
print("LIMIT: exact export names and HLE semantics remain unproven; no handlers added")
