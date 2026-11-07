#!/usr/bin/env python3
"""Step26: audit the unresolved font-name descriptor path without guessing ABI."""
from pathlib import Path
import re, struct
ROOT=Path(__file__).resolve().parent
app=ROOT/'game_assets/The_Elder_Scrolls_Travels_Shadowkey/system/apps/6R51/6R51.APP'
b=app.read_bytes()
# E32 header gives code offset 0x7c; the imported literal's VA is 0x100ac718.
code_off=struct.unpack_from('<I',b,0x64)[0]
va=0x100ac718
fo=code_off+(va-0x10000000)
assert code_off==0x7c, hex(code_off)
assert b[fo:fo+12]=='Swiss'.encode('utf-16le')+b'\0\0', b[fo:fo+12].hex()
source=(ROOT/'shadowkey_lifted_v6.c').read_text(errors='replace')
assert 'c->r[1] = 0x100ac718u;' in source
assert 'c->r[2] = 0x00000014u;' in source
assert 'c->r[2] = 0x000000d5u;' in source
assert 'ngage_call(c, 0x1009f0f0u)' in source
assert 'ngage_call(c, 0x1009f090u)' in source
core=(ROOT/'shadowkey_hle_bootstrap_v2.c').read_text()
vfs=(ROOT/'shadowkey_hle_vfs_trace.c').read_text()
assert 'ordinal==1282u' in core and 'memmove(d,q,n)' in core
assert 'ordinal==1282u' in vfs and 'HLE EUSER1282 Mem::Copy' in vfs
log=(ROOT/'.build/live_hal_vfs_trace.log').read_text(errors='replace')
assert 'EUSER1407 FORENSIC r0=102fe6d8 r1=100ac718' in log
assert 'UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407' in log
assert 'HLE EUSER1282 Mem::Copy dst=102fed30 src=102fe6d8 size=20' in log
assert 'TRACE GDI151 descriptor @102fed30: 61 00 70 00 70 00 73 00' in log
assert 'GDI[10003b15].DLL ord=151 r0=102fecf0 r1=102fed30 r2=000000d5' in log
print(f'PASS: E32 code offset 0x{code_off:x}; VA {va:08x} -> file offset {fo:08x}; literal = Swiss')
print('PASS: live TFontSpec constructor site uses 20-byte descriptor copy and height 213 twips')
print('PASS: EUSER1282 three-argument byte-copy ABI implemented; live copy reaches GDI151')
print('BLOCKER: EUSER1407 leaves its 20-byte source descriptor unformatted; GDI151 receives stale UTF-16 path bytes')
print('INFERENCE: EUSER1407 call ABI matches TDes16::Format(TRefByValue<const TDesC16>, ...); export name still needs FP1 export-table proof')
