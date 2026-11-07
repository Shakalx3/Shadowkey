#!/bin/sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
TMP=${TMPDIR:-/tmp}/shadowkey_step35_$$
trap 'rm -rf "$TMP"' EXIT INT TERM
mkdir -p "$TMP"
python3 "$ROOT/shadowkey_e32_inject_arm_stub.py" "$ROOT/6R51.APP" \
  -o "$TMP/6R51_probe.APP" --stub-hex 0000a0e11eff2fe1 \
  --patch-thunk 0x100A00B0 > "$TMP/patch.log"
python3 "$ROOT/shadowkey_extract_e32_imports.py" "$TMP/6R51_probe.APP" \
  -o "$TMP/import_thunks.csv" > "$TMP/imports.log"
python3 - "$ROOT/6R51.APP" "$TMP/6R51_probe.APP" "$TMP/import_thunks.csv" "$TMP/import_blocks.csv" <<'PY'
import csv, struct, sys
from pathlib import Path
src=Path(sys.argv[1]).read_bytes(); out=Path(sys.argv[2]).read_bytes()
u=lambda b,o:struct.unpack_from('<I',b,o)[0]
base=u(src,0x4c); co=u(src,0x64); old_text=u(src,0x60); old_code=u(src,0x30)
delta=8
assert out[0x10:0x14]==b'EPOC'
assert u(out,0x30)==old_code+delta
assert u(out,0x60)==old_text+delta
assert u(out,0x58)==u(src,0x58)+delta
assert u(out,0x6c)==u(src,0x6c)+delta
assert u(out,0x70)==u(src,0x70)+delta
# Original text is byte-identical except the intentionally replaced veneer.
orig=src[co:co+old_text]
patched=bytearray(out[co:co+old_text+delta])
assert patched[old_text:old_text+8]==bytes.fromhex('0000a0e11eff2fe1')
thunk_off=0x100A00B0-base
assert struct.unpack_from('<I',patched,thunk_off)[0]==0xEA0180A2
patched[thunk_off:thunk_off+4]=orig[thunk_off:thunk_off+4]
# Undo only relocation-backed IAT pointer moves in a copy, then require all
# original text bytes to match exactly.
ro=u(src,0x70); rsize,rcount=struct.unpack_from('<II',src,ro); pos=ro+8
while pos<ro+8+rsize:
    page,bs=struct.unpack_from('<II',src,pos)
    for q in range(pos+8,pos+bs,2):
        raw=struct.unpack_from('<H',src,q)[0]
        if raw>>12==3:
            site=page+(raw&0xfff)
            value=u(src,co+site)
            if base+old_text<=value<base+old_code:
                struct.pack_into('<I',patched,site,value)
    pos+=bs
assert patched[:old_text]==orig
# New additive E32 code checksum covers text + IAT + export directory.
cs=u(out,0x30); calc=sum(struct.unpack_from('<'+'I'*(cs//4),out,co))&0xffffffff
assert u(out,0x18)==calc
# Import table remains complete and GDI ordinal 101 remains present.
rows=list(csv.DictReader(open(sys.argv[3],newline='')))
assert len(rows)==413 # one GDI veneer deliberately replaced by a direct B
blocks=list(csv.DictReader(open(sys.argv[4],newline='')))
gdi=next(r for r in blocks if r['dependency'].startswith('GDI'))
assert '101' in gdi['ordinals'].split(',')
print('PASS: E32 header/table offsets, code insertion, direct branch, checksum, and import table validated')
print('NOTE: this validates binary rewriting only; it does not validate EKA2 loader compatibility or game behavior')
PY
cat "$TMP/patch.log"
cat "$TMP/imports.log"
