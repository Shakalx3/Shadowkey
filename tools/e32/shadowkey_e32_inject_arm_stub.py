#!/usr/bin/env python3
"""Inject position-independent ARM stubs into legacy E32 code before the IAT.

This deliberately narrow writer supports the project's uncompressed ARM E32
images with no initialized data. It preserves existing code addresses, moves
the IAT and trailing E32 tables, and adjusts every type-3 relocation target
that points into the moved IAT. It refuses any layout it cannot prove safe.

Optional --patch-thunk replaces one 16-byte import veneer with a direct ARM B
to the injected stub. The branch is PC-relative and needs no new relocation.
"""
import argparse, csv, hashlib, struct
from pathlib import Path

U32=struct.Struct('<I')

def u32(b,o): return U32.unpack_from(b,o)[0]
def w32(b,o,v): U32.pack_into(b,o,v & 0xffffffff)
def s32(x): return x if x < 0x80000000 else x-0x100000000

def parse_relocs(b, code_off, text_size, code_size, reloc_off):
    size,count=struct.unpack_from('<II',b,reloc_off)
    end=reloc_off+8+size
    if end>len(b): raise ValueError('relocation section outside file')
    pos=reloc_off+8; sites=[]; blocks=0; types={}
    while pos<end:
        if pos+8>end: raise ValueError('truncated relocation block')
        page,bs=struct.unpack_from('<II',b,pos)
        if bs<8 or pos+bs>end or (bs-8)&1: raise ValueError('invalid relocation block')
        blocks+=1
        for q in range(pos+8,pos+bs,2):
            raw=struct.unpack_from('<H',b,q)[0]
            typ=raw>>12; off=raw&0xfff
            types[typ]=types.get(typ,0)+1
            if typ==3:
                site=page+off
                if site+4>code_size: raise ValueError(f'relocation site outside code: {site:#x}')
                if site>=text_size:
                    raise ValueError(f'relocation site is not in original text: {site:#x}')
                sites.append(site)
            elif typ not in (0,):
                raise ValueError(f'unsupported relocation type {typ}')
        pos+=bs
    if pos!=end or len(sites)!=count: raise ValueError('relocation count/section mismatch')
    return sites,blocks,types,end

def arm_b(src_va,dst_va):
    delta=dst_va-(src_va+8)
    if delta&3: raise ValueError('ARM branch target is not word aligned')
    imm=delta>>2
    if not -(1<<23)<=imm<(1<<23): raise ValueError('ARM B target out of range')
    return 0xEA000000 | (imm & 0xFFFFFF)

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('image',type=Path)
    ap.add_argument('-o','--out',type=Path,required=True)
    ap.add_argument('--stub-hex',default='1eff2fe1',help='ARM stub bytes in hex; default bx lr')
    ap.add_argument('--patch-thunk',type=lambda x:int(x,0),help='optional import veneer VA to branch to first injected stub')
    args=ap.parse_args()
    src=args.image.read_bytes(); b=bytearray(src)
    if len(b)<0x80 or b[0x10:0x14]!=b'EPOC': raise SystemExit('not an E32 image')
    flags=u32(b,0x2c); code_size=u32(b,0x30); data_size=u32(b,0x34)
    base=u32(b,0x4c); exp_off=u32(b,0x58); text_size=u32(b,0x60)
    code_off=u32(b,0x64); imp_off=u32(b,0x6c); reloc_off=u32(b,0x70); data_reloc=u32(b,0x74)
    if data_size: raise SystemExit('initialized data is unsupported')
    if code_off+code_size>len(b) or text_size>code_size: raise SystemExit('invalid code bounds')
    if not (code_off+text_size<=exp_off<=code_off+code_size and imp_off>=code_off+code_size and reloc_off>=imp_off): raise SystemExit('unexpected E32 table order')
    stub=bytes.fromhex(args.stub_hex)
    if not stub or len(stub)&3: raise SystemExit('stub must be non-empty ARM words')
    if len(stub)>0x10000: raise SystemExit('stub too large for this helper')
    sites,blocks,types,reloc_end=parse_relocs(b,code_off,text_size,code_size,reloc_off)
    old_iat=base+text_size; old_code_end=base+code_size
    old_code_checksum=u32(b,0x18)
    original_sum=sum(struct.unpack_from('<'+'I'*(code_size//4),b,code_off)) & 0xffffffff if code_size%4==0 else None
    iat_targets=[]
    for site in sites:
        value=u32(b,code_off+site)
        if old_iat<=value<old_code_end:
            iat_targets.append((site,value))
    delta=len(stub)
    insertion=code_off+text_size
    new=bytearray()
    new += b[:insertion]
    new += stub
    new += b[insertion:]
    for off in (0x30,0x60,0x58,0x6c,0x70): w32(new,off,u32(new,off)+delta)
    if data_reloc: w32(new,0x74,data_reloc+delta)
    for site,value in iat_targets:
        w32(new,code_off+site,value+delta)
    branch_info=None
    if args.patch_thunk is not None:
        thunk=args.patch_thunk
        if thunk<base or thunk+16>base+text_size: raise SystemExit('thunk outside text')
        thunk_off=code_off+(thunk-base)
        stub_va=base+text_size
        instr=arm_b(thunk,stub_va)
        w32(new,thunk_off,instr)
        branch_info=(thunk,stub_va,instr)
    new_code_size=u32(new,0x30)
    if new_code_size & 3: raise SystemExit('code size is not word-aligned')
    new_code_checksum=sum(struct.unpack_from('<'+'I'*(new_code_size//4),new,code_off)) & 0xffffffff
    w32(new,0x18,new_code_checksum)
    args.out.write_bytes(new)
    out=bytes(new)
    if out[0x10:0x14]!=b'EPOC' or u32(out,0x30)!=code_size+delta or u32(out,0x60)!=text_size+delta:
        raise SystemExit('post-write E32 header validation failed')
    if u32(out,0x6c)!=imp_off+delta or u32(out,0x70)!=reloc_off+delta:
        raise SystemExit('post-write table offsets incorrect')
    for site,value in iat_targets:
        if u32(out,code_off+site)!=value+delta: raise SystemExit('IAT relocation update mismatch')
    report=args.out.with_suffix(args.out.suffix+'.report.txt')
    lines=[
      f'Input: {args.image}',f'Input SHA-256: {hashlib.sha256(src).hexdigest()}',
      f'Output: {args.out}',f'Output SHA-256: {hashlib.sha256(out).hexdigest()}',
      f'Image base: 0x{base:08X}',f'Original text size: 0x{text_size:X}',
      f'Injected stub VA: 0x{base+text_size:08X}',f'Injected bytes: {len(stub)}',
      f'Code size: 0x{code_size:X} -> 0x{code_size+delta:X}',
      f'Text size: 0x{text_size:X} -> 0x{text_size+delta:X}',
      f'Relocation blocks: {blocks}',f'Relocation entries: {len(sites)}',
      f'Relocation types: {types}',f'IAT-target relocations shifted: {len(iat_targets)}',
      f'Original code checksum field: 0x{old_code_checksum:08X}',
      f'Original additive code sum: {('0x%08X' % original_sum) if original_sum is not None else 'unaligned'}',
      f'Patched additive code checksum: 0x{new_code_checksum:08X}',
    ]
    if branch_info:
        lines += [f'Patched thunk VA: 0x{branch_info[0]:08X}',f'Branch target VA: 0x{branch_info[1]:08X}',f'ARM B opcode: 0x{branch_info[2]:08X}']
    lines += ['Limitations: this is a structural E32 image patch experiment, not a complete Symbian compatibility implementation.',
              'The additive code checksum at header offset 0x18 is recalculated. Target-loader acceptance remains unverified.','']
    report.write_text('\n'.join(lines))
    print('\n'.join(lines))
if __name__=='__main__': main()
