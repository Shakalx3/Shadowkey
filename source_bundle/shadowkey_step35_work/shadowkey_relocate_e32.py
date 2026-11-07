#!/usr/bin/env python3
"""Relocate a simple ARM E32Image code segment to a new linked base.

Supports the uncompressed, no-data ARM E32 images in this project. It refuses
unknown relocation types rather than silently producing a possibly broken image.
"""
import argparse, struct, hashlib
from pathlib import Path

def u32(b,o): return struct.unpack_from('<I',b,o)[0]
def w32(b,o,v): struct.pack_into('<I',b,o,v&0xffffffff)

def main():
 ap=argparse.ArgumentParser()
 ap.add_argument('image',type=Path);ap.add_argument('-o','--out',type=Path,required=True)
 ap.add_argument('--new-base',type=lambda s:int(s,0),required=True)
 args=ap.parse_args(); src=args.image.read_bytes(); b=bytearray(src)
 if len(b)<0x80 or b[0x10:0x14]!=b'EPOC': raise SystemExit('not an E32Image')
 old_base=u32(b,0x4c); code_size=u32(b,0x30); code_off=u32(b,0x64); reloc_off=u32(b,0x70)
 data_size=u32(b,0x34); data_reloc_off=u32(b,0x74)
 if data_size: raise SystemExit(f'initialized data section not supported: {data_size:#x}')
 if not reloc_off: raise SystemExit('no code relocation section')
 delta=args.new_base-old_base
 if code_off+code_size>len(b): raise SystemExit('code segment outside file')
 sec_size,declared_count=struct.unpack_from('<II',b,reloc_off)
 sec_end=reloc_off+8+sec_size
 if sec_end>len(b): raise SystemExit('relocation section outside file')
 pos=reloc_off+8; blocks=0; entries=0; patched=0; skipped_abs=0; other={}; sites=[]
 while pos<sec_end:
  if pos+8>sec_end: raise SystemExit(f'truncated relocation block at {pos:#x}')
  page_off,block_size=struct.unpack_from('<II',b,pos)
  if block_size<8 or pos+block_size>sec_end: raise SystemExit(f'invalid relocation block size at {pos:#x}: {block_size:#x}')
  if (block_size-8)&1: raise SystemExit(f'odd relocation payload size at {pos:#x}')
  blocks+=1
  for rp in range(pos+8,pos+block_size,2):
   raw=struct.unpack_from('<H',b,rp)[0]; typ=raw>>12; off=raw&0x0fff
   if typ==0:
    skipped_abs+=1; continue
   if typ!=3:
    other[typ]=other.get(typ,0)+1; continue
   site_va=old_base+page_off+off; file_off=code_off+page_off+off
   if file_off+4>code_off+code_size: raise SystemExit(f'relocation site outside code at {site_va:#x}')
   val=u32(b,file_off)
   if not (old_base<=val<old_base+code_size):
    raise SystemExit(f'relocation target outside original code range at {site_va:#x}: {val:#x}')
   w32(b,file_off,val+delta);patched+=1;entries+=1;sites.append((site_va,val,val+delta))
  pos+=block_size
 if pos!=sec_end: raise SystemExit('relocation parser did not end at section boundary')
 if entries!=declared_count: raise SystemExit(f'relocation count mismatch: patched {entries}, header says {declared_count}')
 if other: raise SystemExit(f'unsupported relocation types: {other}')
 w32(b,0x4c,args.new_base)
 args.out.write_bytes(b)
 report=args.out.with_suffix('.relocation_report.txt')
 report.write_text('\n'.join([
  f'Input: {args.image}',f'Input SHA-256: {hashlib.sha256(src).hexdigest()}',
  f'Output: {args.out}',f'Output SHA-256: {hashlib.sha256(b).hexdigest()}',
  f'Old base: 0x{old_base:08X}',f'New base: 0x{args.new_base:08X}',f'Delta: {delta:+#x}',
  f'Code file offset: 0x{code_off:X}',f'Code size: {code_size:,}',
  f'Relocation section: 0x{reloc_off:X}, payload size 0x{sec_size:X}',
  f'Blocks parsed: {blocks}',f'Absolute/padding entries skipped: {skipped_abs}',
  f'32-bit code relocations applied: {patched}',f'Data size: {data_size}',f'Data relocation offset: 0x{data_reloc_off:X}',
  'Relocation rule: each type-3 site held a pointer inside the original code segment; add the load-base delta.',
  'Caution: this loader handles only this simple ARM image shape; it is not a general Symbian loader.','']))
 print(report.read_text())
if __name__=='__main__':main()
