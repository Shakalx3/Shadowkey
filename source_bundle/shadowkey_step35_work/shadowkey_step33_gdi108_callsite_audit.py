#!/usr/bin/env python3
"""Step33 static audit: preserve GDI108 argument provenance without guessing its ABI."""
from pathlib import Path
import csv

ROOT = Path(__file__).resolve().parent
SRC = (ROOT / 'shadowkey_lifted_v6.c').read_text(errors='replace')
TRACE = (ROOT / 'shadowkey_hle_vfs_trace.c').read_text(errors='replace')
LIVE = (ROOT / 'shadowkey_engine_init_live_test.c').read_text(errors='replace')

expected = {
    '0x10022bd0': {
        'caller': 'sub_10022b20',
        'r0': 'sp+0x268',
        'r1': 'r10 (0/1 path) OR r5 (incoming stack value)',
        'evidence': ['c->r[10] = 0x00000000u', 'c->r[10] = 0x00000001u', 'c->r[1] = c->r[5]', 'c->r[1] = c->r[10]'],
    },
    '0x10022dfc': {
        'caller': 'sub_10022d48',
        'r0': 'sp+0x268',
        'r1': '*(sp+8) (initialized 0, later 1) OR r5',
        'evidence': ['ngage_w32(c, (c->r[13] + 8u), (uint32_t)c->r[9])', 'c->r[1] = ngage_r32(c, (c->r[13] + 8u))', 'c->r[1] = c->r[5]'],
    },
    '0x10023038': {
        'caller': 'sub_10022f88',
        'r0': 'sp+0x268',
        'r1': 'r10 (0/1 path) OR r5 (incoming stack value)',
        'evidence': ['c->r[10] = 0x00000000u', 'c->r[10] = 0x00000001u', 'c->r[1] = c->r[5]', 'c->r[1] = c->r[10]'],
    },
    '0x1002328c': {
        'caller': 'sub_100231b4',
        'r0': 'sp+0x680',
        'r1': '*(sp+28) (initialized 0, later 1) OR literal 1',
        'evidence': ['ngage_w32(c, (c->r[13] + 28u), (uint32_t)c->r[10])', 'c->r[1] = ngage_r32(c, (c->r[13] + 28u))', 'c->r[1] = 0x00000001u'],
    },
    '0x100236d4': {
        'caller': 'sub_10023608',
        'r0': 'sp+0x678',
        'r1': 'r10 (starts 0, then accumulates +13) OR literal 1',
        'evidence': ['c->r[10] = 0x00000000u', 'c->r[10] = c->r[10] + 0x0000000du', 'c->r[1] = c->r[10]', 'c->r[1] = 0x00000001u'],
    },
}

rows = []
with (ROOT / 'shadowkey_import_callsites_v2.csv').open(newline='') as f:
    for row in csv.DictReader(f):
        if row.get('dll', '').startswith('GDI') and row.get('ordinal') == '108':
            rows.append(row)
assert len(rows) == 5, f'expected five GDI108 callsites, got {len(rows)}'
for row in rows:
    addr = row['callsite'].lower()
    assert addr in expected, f'unexpected GDI108 site {addr}'
    assert row['caller'] == expected[addr]['caller']
    lr = int(addr, 16) + 4
    call = f'c->r[14] = 0x{lr:08x}u; ngage_call(c, 0x100a00c0u)'
    assert call in SRC, f'missing translated call at {addr}'
    start = SRC.index('void ' + row['caller'] + '(ngage_cpu_t *c)')
    end = SRC.find('\nvoid ', start + 6)
    body = SRC[start:end if end >= 0 else None]
    for evidence in expected[addr]['evidence']:
        assert evidence in body, f'{addr}: missing argument-provenance evidence {evidence}'

# Every GDI108 receiver is the style subobject at spec candidate + 0x3c.
assert 'c->r[0] = c->r[13] + 0x00000268u' in SRC
assert 'c->r[0] = c->r[13] + 0x00000680u' in SRC
assert 'c->r[0] = c->r[13] + 0x00000670u' in SRC and 'c->r[0] = c->r[0] + 0x00000008u' in SRC
# A live memory watch must cover all guest store widths.
assert 'WATCH RANGE WRITE8' in LIVE
assert 'WATCH RANGE WRITE16' in LIVE
assert 'WATCH RANGE WRITE32' in LIVE
# Only the observed r1==0 site is modified by the current experimental GDI108 shim.
assert 'c->r[14]==0x10023290u && c->r[1]==0u' in TRACE
# The older conflicting 60-byte layout must not be enabled by the main experiment.
assert 'SHADOWKEY_EXPERIMENTAL_GDI151_LEGACY_LAYOUT' in TRACE
assert 'HALT unresolved GDI import' in TRACE
assert 'exit(95)' in TRACE

print('PASS: exactly five GDI108 callsites are mapped to their callers')
print('PASS: all five receiver expressions and r1 provenance branches are accounted for')
print('PASS: r1 is not uniform: incoming value / local 0-or-1 / accumulated +13 paths remain distinct')
print('PASS: current GDI108 experiment remains limited to the observed r1=0 callsite')
print('PASS: live watch covers 8-, 16-, and 32-bit guest stores')
print('PASS: conflicting legacy GDI151 layout requires a separate opt-in')
print('PASS: unknown GDI108/GDI151 callsites fail closed instead of returning synthetic zero')
print('LIMIT: GDI108 signature, enum semantics, and nonzero-r1 cases are not identified')
print('LIMIT: GDI151 argument variants at the five sites are not all dynamically observed')
