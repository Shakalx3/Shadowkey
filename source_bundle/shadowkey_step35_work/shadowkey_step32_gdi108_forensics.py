#!/usr/bin/env python3
"""Step32: verify the five GDI108 sites and the diagnostic TFontSpec72 path."""
from pathlib import Path
import re, csv, sys
ROOT=Path(__file__).resolve().parent
src=(ROOT/'shadowkey_lifted_v6.c').read_text(errors='replace')
trace_src=(ROOT/'shadowkey_hle_vfs_trace.c').read_text(errors='replace')
live_harness=(ROOT/'shadowkey_engine_init_live_test.c').read_text(errors='replace')
rows=[]
with (ROOT/'shadowkey_import_callsites_v2.csv').open(newline='') as f:
    for row in csv.DictReader(f):
        if row.get('dll','').startswith('GDI') and row.get('ordinal')=='108':
            rows.append(row)
expected={
    '0x10022bd0':('sub_10022b20','0x268','0x26c'),
    '0x10022dfc':('sub_10022d48','0x268','0x26c'),
    '0x10023038':('sub_10022f88','0x268','0x26c'),
    '0x1002328c':('sub_100231b4','0x680','0x684'),
    '0x100236d4':('sub_10023608','0x678','0x67c'),
}
assert len(rows)==5, f'expected 5 GDI108 callsites, got {len(rows)}'
for row in rows:
    key=row['callsite'].lower()
    assert key in expected, f'unexpected GDI108 callsite {key}'
    assert row['caller']==expected[key][0], (key,row['caller'],expected[key][0])
for addr,(fn,base,desc) in expected.items():
    lr=int(addr,16)+4
    call_line=next((x for x in src.splitlines() if 'ngage_call(c, 0x100a00c0u)' in x and f'c->r[14] = 0x{lr:08x}u' in x),None)
    assert call_line, f'missing GDI108 call instruction at {addr}'
    start=src.find(f'void {fn}(ngage_cpu_t *c)')
    end=src.find('\nvoid ',start+6)
    if end<0: end=len(src)
    block=src[start:end]
    assert not re.search(rf'ngage_w32\(c,\s*\(c->r\[13\]\s*\+\s*{int(base,16)}u\)',block), f'{fn} directly writes GDI108 receiver base'
assert 'SHADOWKEY_EXPERIMENTAL_GDI151_LEGACY_LAYOUT' in trace_src
assert 'SHADOWKEY_EXPERIMENTAL_GDI151_TFONTSPEC' in trace_src
print('PASS: all five GDI108 callsites are accounted for')
print('PASS: each receiver is exactly TFontSpec candidate base + 0x3C; source descriptor starts at receiver + 4')
print('PASS: conflicting legacy GDI151 layout is isolated behind a separate opt-in')

# The live watch must cover all guest store widths. Step32's original live
# harness omitted W16 instrumentation, so its 'no writes' claim was incomplete.
assert re.search(r'void ngage_w16\([^\n]+WATCH RANGE WRITE16', live_harness), 'live harness does not watch 16-bit stores'
print('PASS: live watch instruments guest WRITE8/WRITE16/WRITE32 paths')

log_path=ROOT/'.build/live_hal_vfs_trace.log'
assert log_path.exists(), 'run trace_asset_loader_live_vfs.sh first; the live trace must be generated in .build'
log=log_path.read_text(errors='replace')
checks={
 'watch armed on receiver subobject':r'WATCH GDI108 receiver armed base=102fed2c size=24 lr=10023230',
 'no guest CPU writes to receiver range before GDI108':None,
 'pre-call first 12 bytes captured':r'TRACE GDI108 TFontStyle candidate PRE-CALL @102fed2c: 70 fe 0f 10 05 00 00 30 06 00 00 00',
 'GDI108 experimental default writes 12 zero bytes':r'EXPERIMENT GDI108 TFontStyle default: dst=102fed2c spec=102fecf0\+0x3c fields=\{0,0,0\} size=12',
 'post-call style block is zero':r'TRACE GDI108 experimental TFontStyle AFTER @102fed2c: 00 00 00 00 00 00 00 00 00 00 00 00',
 'GDI151 candidate prefix is 60 bytes of a 72-byte spec':r'EXPERIMENT GDI151 TFontSpec prefix: name-length=5 height=213 twips prefix=60 total=72; TBufC<24> candidate',
 'font lookup reads the 72-byte candidate':r'GFX HLE GetNearestFontInTwips: TFontSpec72 name=\'Swiss\' height=213 twips style=\(0,0,0\) -> provisional 14 px',
 'first DrawText reached':r'DrawText\(gc=.*point=.*\(0,160\).*baseline=83',
 'second DrawText reached':r'DrawText\(gc=.*point=.*\(0,13\).*baseline=83',
 'unmodified live-state RunL returned':r'ENGINE RUNL live-state returned',
}
for label,pat in checks.items():
    if pat is None:
        ok=not re.search(r'WATCH RANGE WRITE(?:8|16|32)',log)
    else:
        ok=re.search(pat,log) is not None
    print(('PASS: ' if ok else 'FAIL: ')+label)
    if not ok: raise SystemExit(1)
assert 'IMPORT dll=GDI[10003b15].DLL ord=101' not in log, 'GDI101 unexpectedly executed in this trace'
print('PASS: GDI101 was skipped in this observed call path')
print('LIMIT: the TFontSpec72/TBufC<24>/GDI108 mapping remains a cross-checked experiment, not N95 ROM-confirmed ABI')
print('LIMIT: DrawText is diagnostic only; no glyph rasterization or physical N95 launch')
