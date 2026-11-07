#!/usr/bin/env python3
"""Resolve original Symbian 6.1 SDK PE export ordinals from WINS DLLs."""
from pathlib import Path
import struct, sys, subprocess, re

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

symptoms=("TDes","TBuf","HBuf","CFont","TFont","CGraphicsContext","CCoeControl","RFile","RFs","TParse","TPoint","TSize","Format","Copy","SetLength")
# Decode COFF short-import members: they carry the ordinal and decorated C++ symbol.
def parse_coff_import_lib(path):
    data=Path(path).read_bytes()
    if not data.startswith(b"!<arch>\n"):
        return []
    records=[]
    pos=8
    while pos+60<=len(data):
        header=data[pos:pos+60]
        try: size=int(header[48:58].decode("ascii").strip())
        except Exception: break
        obj=data[pos+60:pos+60+size]
        if len(obj)>=20 and u16(obj,0)==0 and u16(obj,2)==0xffff:
            version=u16(obj,4); machine=u16(obj,6); data_size=u32(obj,12)
            ordinal_or_hint=u16(obj,16); type_info=u16(obj,18)
            name_type=(type_info>>2)&0x7
            strings=obj[20:20+data_size].split(b"\0")
            symbol=strings[0].decode("ascii","replace") if strings else ""
            dllname=strings[1].decode("ascii","replace") if len(strings)>1 else ""
            records.append({"ordinal":ordinal_or_hint if name_type==0 else None,
                            "name_type":name_type,"symbol":symbol,"dll":dllname,
                            "machine":machine,"version":version})
        pos += 60+size+(size&1)
    return records

debugroot=root.parent/"udeb"
dispatch_path=Path("source_bundle/shadowkey_step35_work/shadowkey_import_dispatch.c")
dispatch_text=dispatch_path.read_text(errors="replace")
entry_re=re.compile(r'\{\s*(0x[0-9a-fA-F]+)u?,\s*(0x[0-9a-fA-F]+)u?,\s*"([A-Z0-9]+)\[[^]]+\]\.DLL",\s*(\d+)u\s*\}')
entries=[]
for thunk,slot,dll,ordtext in entry_re.findall(dispatch_text):
    entries.append((int(thunk,16),int(slot,16),dll.lower(),int(ordtext)))
game_dlls=sorted(set(e[2] for e in entries))
out += ["## WINS UDEB COFF import-library ordinal map","",
        "The short-import records are parsed directly. NameType=0 means the 16-bit field is an export ordinal.",""]
for dll in game_dlls:
    lib=debugroot/f"{dll}.lib"
    records=parse_coff_import_lib(lib) if lib.exists() else []
    ordinals=sorted(set(e[3] for e in entries if e[2]==dll))
    out += [f"### {dll.upper()}.LIB","",
            f"- Import-object records: {len(records)}; imports used by game: {len(ordinals)}"]
    for ordinal in ordinals:
        names=sorted(set(r["symbol"] for r in records if r["ordinal"]==ordinal))
        types=sorted(set(r["name_type"] for r in records if r["ordinal"]==ordinal))
        out.append(f"- Ordinal {ordinal}: {', '.join(names) if names else '<no ordinal import record>'}; NameType={types}")
    out.append("")

# Join every original game import slot to the exact N-Gage SDK symbol.
out += ["## Exact symbol map for imports used by 6R51.APP","",
        f"- Game import slots: {len(entries)}",
        f"- DLLs referenced: {len(game_dlls)}",
        "| Thunk | Slot | DLL | Ordinal | Original SDK symbol |",
        "|---:|---:|---|---:|---|"]
lib_cache={}
for thunk,slot,dll,ordinal in entries:
    if dll not in lib_cache:
        lib=debugroot/f"{dll}.lib"
        lib_cache[dll]=parse_coff_import_lib(lib) if lib.exists() else []
    names=sorted(set(r["symbol"] for r in lib_cache[dll] if r["ordinal"]==ordinal))
    symbol="; ".join(names) if names else "<NO MATCH / library absent>"
    out.append(f"| 0x{thunk:08x} | 0x{slot:08x} | {dll.upper()} | {ordinal} | {symbol} |")
out.append("")
# Inspect ARM import libraries for C++ symbol names that WINS DLLs omit.
import subprocess
libroot=root.parent.parent/"armi"/"urel"
symptoms=("TDes","TBuf","HBuf","CFont","TFont","CGraphicsContext","CCoeControl","RFile","RFs","TParse","TPoint","TSize","Format","Copy","SetLength")
out += ["## ARM import library symbol scan","",
        "The WINS PE DLLs export by ordinal only. The ARM import libraries are scanned for symbol names to recover the ordinal/name map.",""]
for dll in ("efsrv","euser","cone","gdi"):
    lib=libroot/f"{dll}.lib"
    out += [f"### {dll.upper()}.LIB","",f"- File: {lib} ({lib.stat().st_size} bytes)"]
    try:
        kind=subprocess.run(["file",str(lib)],capture_output=True,text=True,check=False)
        out.append(f"- file(1): {kind.stdout.strip()} {kind.stderr.strip()}")
        nm=subprocess.run(["nm","-A","-C",str(lib)],capture_output=True,text=True,check=False)
        nmlines=nm.stdout.splitlines()
        out.append(f"- nm exit={nm.returncode}; stdout lines={len(nmlines)}; stderr={nm.stderr.strip()[:500]}")
        matches=[line for line in nmlines if any(token.lower() in line.lower() for token in symptoms)]
        out += [f"- nm symbol-name matches: {len(matches)}",""]
        out.extend(f"  - {line}" for line in matches[:120])
        strings=subprocess.run(["strings","-a",str(lib)],capture_output=True,text=True,check=False)
        strlines=strings.stdout.splitlines()
        smatches=[line for line in strlines if any(token.lower() in line.lower() for token in symptoms)]
        out.append(f"- strings lines={len(strlines)}; relevant matches={len(smatches)}")
        out.extend(f"  - {line}" for line in smatches[:160])
        if not matches and not smatches: out.append("  - No recognizable C++ names in symbol or strings scan")
    except Exception as exc:
        out.append(f"- nm scan failed: {exc}")
    out.append("")
report.write_text("\n".join(out)+"\n")
print("\n".join(out))
