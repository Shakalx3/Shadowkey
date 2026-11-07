#!/usr/bin/env python3
"""Resolve original Symbian 6.1 SDK PE export ordinals from WINS DLLs."""
from pathlib import Path
import struct, sys

TARGETS={
 "efsrv": [18,136,137,138,139,140,141,142,143,185],
 "euser": [1407,1575],
 "cone": [160],
 "gdi": [101,108,151],
}
def u16(b,o): return struct.unpack_from("<H",b,o)[0]
def u32(b,o): return struct.unpack_from("<I",b,o)[0]
def cstr(b,o):
    e=b.find(b"\0",o)
    if e<0: e=len(b)
    return b[o:e].decode("ascii","replace")
def parse_exports(path):
    b=Path(path).read_bytes()
    if b[:2]!=b"MZ": raise ValueError(f"{path}: not PE/MZ")
    pe=u32(b,0x3c)
    if b[pe:pe+4]!=b"PE\0\0": raise ValueError(f"{path}: missing PE signature")
    nsec=u16(b,pe+6); optsz=u16(b,pe+20); opt=pe+24
    magic=u16(b,opt)
    if magic==0x10b: dd=opt+96
    elif magic==0x20b: dd=opt+112
    else: raise ValueError(f"{path}: unsupported optional-header magic {magic:#x}")
    exp_rva=u32(b,dd); exp_size=u32(b,dd+4)
    secbase=opt+optsz; sections=[]
    for i in range(nsec):
        s=secbase+i*40
        vsize=u32(b,s+8); va=u32(b,s+12); rawsize=u32(b,s+16); raw=u32(b,s+20)
        sections.append((va,max(vsize,rawsize),raw,rawsize))
    def rvaoff(rva):
        if rva<u32(b,opt+28): return rva
        for va,span,raw,rawsize in sections:
            if va<=rva<va+span:
                off=raw+(rva-va)
                if off<len(b): return off
        raise ValueError(f"{path}: RVA {rva:#x} not mapped")
    eo=rvaoff(exp_rva)
    base=u32(b,eo+16); nf=u32(b,eo+20); nn=u32(b,eo+24)
    funcs=rvaoff(u32(b,eo+28)); names=rvaoff(u32(b,eo+32)); ords=rvaoff(u32(b,eo+36))
    by_ord={}
    for i in range(nn):
        nrva=u32(b,names+i*4); oi=u16(b,ords+i*2); ordinal=base+oi
        by_ord.setdefault(ordinal,[]).append(cstr(b,rvaoff(nrva)))
    result={}
    targets=sorted(set(sum(TARGETS.values(),[])))
    for ordinal in targets:
        index=ordinal-base
        if index<0 or index>=nf:
            result[ordinal]=("<OUT_OF_RANGE>",0)
        else:
            frva=u32(b,funcs+index*4)
            name=" | ".join(by_ord.get(ordinal,[])) or "<NONAME>"
            result[ordinal]=(name,frva)
    return base,nf,nn,result

root=Path(sys.argv[1] if len(sys.argv)>1 else "/tmp/ngagesdk-sdk/6.1/Series60/Epoc32/Release/wins/urel")
out=["# Step 44 — Symbian 6.1 SDK export ordinal audit","",
     "Resolved against the original N-Gage/S60 1.2 SDK WINS/UREL DLL export directories, not inferred from newer Symbian releases.",""]
for dll,ordinals in TARGETS.items():
    path=root/f"{dll}.dll"
    base,nf,nn,items=parse_exports(path)
    out += [f"## {dll.upper()}.DLL","",
            f"- File: {path} ({path.stat().st_size} bytes)",
            f"- Export ordinal base: {base}; functions: {nf}; named exports: {nn}","",
            "| Ordinal | Export name | RVA |",
            "|---:|---|---:|"]
    for ordinal in ordinals:
        name,rva=items[ordinal]
        out.append(f"| {ordinal} | {name} | 0x{rva:08x} |")
    out.append("")
report=Path("docs/STEP44_SYMBIAN61_EXPORT_ORDINAL_AUDIT.md")
report.parent.mkdir(parents=True,exist_ok=True)
report.write_text("\n".join(out)+"\n")
print("\n".join(out))
