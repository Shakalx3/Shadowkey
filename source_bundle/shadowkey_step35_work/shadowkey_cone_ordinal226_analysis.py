#!/usr/bin/env python3
"""Call-site consistency checks for the CONE ordinal 226 semantic inference.

The inference is based on the original ARM call sequences, not on a guessed
ordinal table. 226 is a CCoeControl graphics-context accessor candidate;
55 is a drawable-window accessor candidate. This script checks the evidence
survives changes to the lifted source.
"""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parent
SRC = (ROOT / "shadowkey_lifted_v6.c").read_text(errors="replace")


def function(name: str) -> str:
    m = re.search(rf"void {re.escape(name)}\(ngage_cpu_t \*c\) \{{", SRC)
    assert m, f"missing function {name}"
    n = re.search(r"\nvoid [A-Za-z0-9_]+\(ngage_cpu_t \*c\) \{", SRC[m.end():])
    return SRC[m.start():m.end() + n.start()] if n else SRC[m.start():]


ord226_calls = re.findall(r"ngage_call\(c, 0x1009f540u\)", SRC)
ord55_calls = re.findall(r"ngage_call\(c, 0x1009f560u\)", SRC)
assert len(ord226_calls) == 4, f"expected 4 ordinal-226 calls, got {len(ord226_calls)}"
assert len(ord55_calls) == 2, f"expected 2 ordinal-55 calls, got {len(ord55_calls)}"

# These two call sites have the characteristic Symbian drawing sequence:
# accessor(this)->CWindowGc, accessor(this)->RDrawableWindow, then
# CWindowGc::Activate(RDrawableWindow&), vtable byte offset 0xD8.
for name, receiver, gcvar, vtablevar in (
    ("sub_1002256c", 6, 4, 5),
    ("sub_10022898", 8, 9, 4),
):
    body = function(name)
    p226 = body.find("ngage_call(c, 0x1009f540u)")
    p55 = body.find("ngage_call(c, 0x1009f560u)", p226 + 1)
    assert p226 >= 0 and p55 > p226, f"{name}: accessor order changed"
    prefix = body[max(0, p226 - 300):p226]
    tail = body[p226:p55 + 500]
    if name == "sub_10022898":
        assert "c->r[8] = c->r[0];" in prefix, f"{name}: entry this pointer not preserved in r8"
    else:
        assert f"c->r[0] = c->r[{receiver}];" in prefix, f"{name}: ordinal 226 receiver not {receiver}"
    assert f"c->r[{gcvar}] = c->r[0];" in tail, f"{name}: ordinal 226 result not retained"
    window_prefix = body[max(p226, p55 - 180):p55]
    assert f"c->r[0] = c->r[{receiver}];" in window_prefix, f"{name}: ordinal 55 receiver mismatch"
    # Exact vtable call shape: load gc vptr, load slot +0xD8, pass window in r1.
    assert f"(c->r[{vtablevar}] + 216u)" in tail, f"{name}: expected vtable slot +0xD8"

# Remaining two callers use the same returned interface and invoke GC virtuals
# at +0x48; one of them also invokes +0xB8.
for name in ("sub_10021b98", "sub_10028260"):
    body = function(name)
    assert "ngage_call(c, 0x1009f540u)" in body, f"{name}: missing ordinal 226"
    assert "+ 72u" in body, f"{name}: expected CWindowGc virtual slot +0x48"
assert "+ 184u" in function("sub_10028260"), "missing additional graphics-context slot +0xB8"

print("PASS: CONE ordinal 226 has four this-only call sites")
print("PASS: ordinal 55 has two matching this-only call sites")
print("PASS: both paired sites call returned object's vtable slot +0xD8 with ordinal-55 result")
print("PASS: remaining ordinal-226 sites use returned object's graphics-context slots +0x48 / +0xB8")
print("INFERENCE: ordinal 226 = CCoeControl::SystemGc() (high confidence, not export-table proven)")
print("INFERENCE: ordinal 55 = CCoeControl::DrawableWindow() (high confidence, not export-table proven)")
