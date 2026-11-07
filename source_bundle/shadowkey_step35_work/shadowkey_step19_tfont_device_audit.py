#!/usr/bin/env python3
"""Regression checks for step19 TFontSpec/device-vtable identification."""
from pathlib import Path
import re
ROOT = Path(__file__).resolve().parent
SRC = (ROOT / 'shadowkey_lifted_v6.c').read_text(errors='replace')
REG = (ROOT / 'shadowkey_function_registry.c').read_text(errors='replace')

def fn(name):
    m = re.search(rf'void {name}\(ngage_cpu_t \*c\) \{{', SRC)
    assert m, name
    n = re.search(r'\nvoid [A-Za-z0-9_]+\(ngage_cpu_t \*c\) \{', SRC[m.end():])
    return SRC[m.start():m.end()+n.start()] if n else SRC[m.start():]

# GDI 151 is the constructor-shaped call: this, descriptor, 213 twips.
b = fn('sub_10022b20')
for needle in [
    'c->r[0] = c->r[13] + 0x0000022cu;',
    'c->r[1] = c->r[13] + 0x0000026cu;',
    'c->r[2] = 0x000000d5u;',
    'ngage_call(c, 0x100a00a0u)',
    'c->r[1] = c->r[13] + 0x00000018u;',
    'c->r[2] = c->r[13] + 0x0000022cu;',
    'ngage_r32(c, (c->r[3] + 68u))',
]:
    assert needle in b, needle
assert '{ 0x100a00a0u, import_GDI_ord_151 }' in REG

# Bitmap/device/context creation chain and field stores.
init = fn('sub_10021244')
assert 'ngage_call(c, 0x1000b9c8u)' in init
assert 'ngage_w32(c, (c->r[7] + 740u), (uint32_t)c->r[0])' in init
assert 'ngage_call(c, 0x1000ba7cu)' in init
assert 'ngage_w32(c, (c->r[7] + 744u), (uint32_t)c->r[0])' in init
assert 'ngage_call(c, 0x1000bab8u)' in init
assert 'ngage_w32(c, (c->r[7] + 748u), (uint32_t)c->r[0])' in init
assert 'ngage_call(c, 0x1009fd50u)' in fn('sub_1000ba7c')
assert 'ngage_call(c, 0x1009fd60u)' in fn('sub_1000bab8')
assert '{ 0x1009fd50u, import_BITGDI_ord_86 }' in REG
assert '{ 0x1009fd60u, import_BITGDI_ord_23 }' in REG

# Five independent sites pass a font-spec-like object through device slot +0x44.
for name in ['sub_10022b20','sub_10022d48','sub_10022f88','sub_100231b4','sub_10023608']:
    body = fn(name)
    assert 'ngage_call(c, 0x100a00a0u)' in body, name
    assert 'ngage_r32(c, (c->r[3] + 68u))' in body, name
    assert 'ngage_call(c, c->r[12])' in body, name
print('PASS: GDI151 constructor ABI is (TFontSpec*, TDesC&, 213 twips) at first site')
print('PASS: engine +0x2e4/+0x2e8/+0x2ec creation chain maps bitmap/device/context')
print('PASS: all five text sites invoke device vtable byte offset +0x44 with font-spec path')
print('LIMIT: exact FP1 ordinal names and descriptor concrete type still require matching SDK/ROM proof')
