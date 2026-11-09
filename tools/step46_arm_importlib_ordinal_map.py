#!/usr/bin/env python3
"""Map ARM UREL import-library archive members to game import ordinals."""
from pathlib import Path
import os, re, subprocess, tempfile, shutil, struct, csv

ROOT=Path("source_bundle/shadowkey_step35_work")
DISPATCH=Path(os.environ.get("SHADOWKEY_IMPORT_DISPATCH", str(ROOT/"shadowkey_import_dispatch.c")))
WINS_REPORT=Path("docs/STEP44_SYMBIAN61_EXPORT_ORDINAL_AUDIT.md")
ARM_ROOT=Path(os.environ.get("SHADOWKEY_ARM_SDK_ROOT", "/tmp/ngagesdk-sdk"))/"6.1/Series60/Epoc32/Release/armi/urel"
OUT=Path(os.environ.get("SHADOWKEY_IMPORT_OUT", "docs/STEP46_ARM_IMPORTLIB_ORDINAL_MAP.md"))

entry_re=re.compile(r'\{\s*(0x[0-9a-fA-F]+)u?,\s*(0x[0-9a-fA-F]+)u?,\s*"([A-Z0-9]+)\[[^]]+\]\.DLL",\s*(\d+)u\s*\}')
entries=[]
for thunk,slot,dll,ordtext in entry_re.findall(DISPATCH.read_text(errors="replace")):
    entries.append((int(thunk,16),int(slot,16),dll.lower(),int(ordtext)))
wins={}
current_dll=None
for line in WINS_REPORT.read_text(errors="replace").splitlines():
    section=re.match(r"^### ([A-Z0-9]+)\.LIB$", line)
    if section:
        current_dll=section.group(1).lower()
        continue
    # Step 44 records ordinal-backed WINS short-import names as:
    # - Ordinal 1407: ?Symbol@@...; NameType=[0]
    m=re.match(r"^- Ordinal (\d+): (.*?); NameType=\[0\]$", line)
    if current_dll and m:
        wins[(current_dll,int(m.group(1)))]=m.group(2)

# Guard the parser against silently reverting to the old incompatible table format.
expected_wins={
    ("euser",1407): "?SetOffset@TDblQueBase@@QAEXH@Z",
    ("euser",1575): "?Val@TLex8@@QAEHAAVTInt64@@ABV2@@Z",
    ("cone",160): "?Position@CCoeControl@@QBE?AVTPoint@@XZ",
    ("gdi",101): "?JustificationInPixels@CGraphicsContext@@SAHAAH0@Z",
    ("gdi",108): "?NewL@CPalette@@SAPAV1@H@Z",
    ("gdi",151): "?StoreL@CPicture@@UBE?AVTStreamId@@AAVCStreamStore@@@Z",
}
for key,symbol in expected_wins.items():
    actual=wins.get(key)
    if actual != symbol:
        raise SystemExit(f"WINS ordinal parser self-check failed for {key}: {actual!r} != {symbol!r}")

# ARM UREL archive-index names are distinct from the WINS UDEB names above.
expected_arm={
    ("euser",1407): "__7TPtrC16PCUs",
    ("euser",1575): "__ne__C6TInt64RC6TInt64",
    ("euser",1582): "__nw__5CBaseUi",
    ("euser",1373): "__5TRectiiii",
    ("euser",530): "Height__C5TRect",
    ("euser",711): "Move__5TRectii",
    ("cone",160): "Rect__C11CCoeControl",
    ("gdi",101): "SetPosture__10TFontStyle12TFontPosture",
    ("gdi",108): "SetStrokeWeight__10TFontStyle17TFontStrokeWeight",
    ("gdi",151): "__9TFontSpecRC7TDesC16i",
}

def run(args):
    return subprocess.run(args,stdout=subprocess.PIPE,stderr=subprocess.PIPE,check=False)

def strings(data):
    # Equivalent printable-ASCII extraction without spawning one process per member.
    return [x.decode("ascii","replace") for x in re.findall(rb"[\x20-\x7e]{4,}",data)]

def archive_symbol_index(path):
    """Decode GNU/SysV ar linker-member symbol index: symbol -> member header."""
    data=Path(path).read_bytes()
    if not data.startswith(b"!<arch>\n"):
        return {}
    pos=8
    longnames=b""
    members={}
    indexes=[]
    while pos+60<=len(data):
        header=data[pos:pos+60]
        try:
            size=int(header[48:58].decode("ascii").strip())
        except Exception:
            break
        rawname=header[:16].decode("ascii","replace").strip()
        payload=data[pos+60:pos+60+size]
        if len(payload)!=size:
            break
        if rawname=="//":
            longnames=payload
        elif rawname in ("/","/SYM64/"):
            indexes.append((rawname,payload))
        else:
            name=rawname
            if name.startswith("/") and name[1:].isdigit() and longnames:
                off=int(name[1:])
                end=longnames.find(b"/\n",off)
                if end<0: end=longnames.find(b"\0",off)
                if end<0: end=len(longnames)
                name=longnames[off:end].decode("utf-8","replace")
            elif name.endswith("/"):
                name=name[:-1]
            members[pos]=name
        pos += 60+size+(size&1)
    result={}
    for kind,payload in indexes:
        width=8 if kind=="/SYM64/" else 4
        if len(payload)<width:
            continue
        for endian in (">","<"):
            try:
                count=struct.unpack_from(endian+("Q" if width==8 else "I"),payload,0)[0]
                if count>200000 or width+count*width>len(payload):
                    continue
                offsets=[struct.unpack_from(endian+("Q" if width==8 else "I"),payload,width+i*width)[0] for i in range(count)]
                names_blob=payload[width+count*width:]
                names=names_blob.split(b"\0")
                if len(names)<count:
                    continue
                mapped=0
                for off,sym in zip(offsets,names):
                    member=members.get(off)
                    symbol=sym.decode("utf-8","replace")
                    if member and symbol:
                        result.setdefault(member,[]).append(symbol)
                        mapped+=1
                if mapped:
                    break
            except (struct.error,OverflowError):
                continue
    return result

tsv_rows=[]
out=[
 "# Step 46 — ARM UREL import-library ordinal cross-check","",
 "The ARM UREL archive linker index maps decorated symbol names to dsNNNNN.o members; this is the primary ARM import identity evidence. WINS UDEB names are shown separately for comparison only.","",
 f"- Game import slots: {len(entries)}",
 f"- Distinct DLLs: {len(set(e[2] for e in entries))}",
 "- ARM member naming convention is checked against archive tables; a member named dsNNNNN.o is treated as candidate ordinal NNNNN, not assumed to be correct until its contents are inspected.",""
]
for dll in sorted(set(e[2] for e in entries)):
    lib=ARM_ROOT/f"{dll}.lib"
    out += [f"## {dll.upper()}.LIB",""]
    if not lib.exists():
        out += ["- ARM UREL import library absent from this SDK tree.",""]
        for ordinal in sorted(set(e[3] for e in entries if e[2]==dll)):
            tsv_rows.append((dll,ordinal,"","","","ARM_LIB_MISSING"))
        continue
    listing=run(["ar","t",str(lib)])
    if listing.returncode:
        out += [f"- ar t failed: {listing.stderr.decode('utf-8','replace')[:500]}",""]
        continue
    members=listing.stdout.decode("utf-8","replace").splitlines()
    indexed_symbols=archive_symbol_index(lib)
    # ARM import archives contain two non-ordinal members (dt.o/dh.o).
    # Their symbol/string tables may hold the name-to-ordinal association
    # even when each dsNNNNN.o thunk member is ordinal-only.
    for metadata_member in ("dt.o","dh.o"):
        if metadata_member not in members:
            continue
        meta=run(["ar","p",str(lib),metadata_member])
        if meta.returncode:
            out.append(f"- {metadata_member}: extraction failed")
            continue
        meta_strings=strings(meta.stdout)
        named=[x for x in meta_strings if len(x)>3 and ("@" in x or x.startswith("_"))]
        meta_symbols=[]
        with tempfile.NamedTemporaryFile() as obj:
            obj.write(meta.stdout);obj.flush()
            for tool in ("llvm-nm","arm-none-eabi-nm","nm"):
                if not shutil.which(tool):
                    continue
                p=run([tool,"-C",obj.name])
                got=[x.strip() for x in p.stdout.decode("utf-8","replace").splitlines() if x.strip()]
                if got:
                    meta_symbols.extend(got[:100])
                    break
            if shutil.which("llvm-readobj"):
                p=run(["llvm-readobj","--symbols",obj.name])
                got=[x.strip() for x in p.stdout.decode("utf-8","replace").splitlines()
                     if "Name:" in x or "Symbol:" in x]
                meta_symbols.extend(got[:100])
        out += [f"- {metadata_member}: {len(meta.stdout)} bytes; strings={len(meta_strings)}; named strings={len(named)}"]
        out.extend(f"  - {x}" for x in (meta_symbols[:100] or named[:100]))
    byord={}
    for member in members:
        m=re.fullmatch(r"ds0*(\d+)\.o",member,re.I)
        if m:byord[int(m.group(1))]=member
    wanted=sorted(set(e[3] for e in entries if e[2]==dll))
    for (target_dll,target_ord),expected_symbol in expected_arm.items():
        if target_dll==dll:
            target_member=byord.get(target_ord)
            names=indexed_symbols.get(target_member,[]) if target_member else []
            if expected_symbol not in names:
                raise SystemExit(f"ARM UREL archive-index self-check failed for {(dll,target_ord)}: {names!r} does not contain {expected_symbol!r}")
    out += [f"- Archive members: {len(members)}; dsNNNNN ordinal-like members: {len(byord)}",
            "| Ordinal | ARM UREL symbol | WINS UDEB reference | ARM member | Size | Additional evidence |",
            "|---:|---|---|---:|---:|---|"]
    for ordinal in wanted:
        member=byord.get(ordinal)
        if not member:
            out.append(f"| {ordinal} | {wins.get((dll,ordinal),'<no WINS map>')} | MISSING | 0 | — |")
            tsv_rows.append((dll,ordinal,"",wins.get((dll,ordinal),""),"","ORDINAL_MEMBER_MISSING"))
            continue
        blob=run(["ar","p",str(lib),member])
        if blob.returncode:
            out.append(f"| {ordinal} | {wins.get((dll,ordinal),'<no WINS map>')} | {member} | 0 | ar p failed |")
            tsv_rows.append((dll,ordinal,"",wins.get((dll,ordinal),""),member,"AR_EXTRACT_FAILED"))
            continue
        found=strings(blob.stdout)
        candidates=[x for x in found if len(x)>2 and (('@' in x) or ('_' in x) or re.search(r'[A-Za-z]{4,}',x))]
        candidates=candidates[:6]
        symbol_lines=[]
        tool_notes=[]
        # Deep object decoding is limited to the six imports currently under
        # semantic dispute; archive-index extraction covers all imported ordinals.
        if ordinal in (1407,1575,160,101,108,151):
            with tempfile.NamedTemporaryFile() as obj:
                obj.write(blob.stdout);obj.flush()
                for tool in ("llvm-nm","arm-none-eabi-nm","nm"):
                    if not shutil.which(tool):
                        continue
                    nm=run([tool,"-C",obj.name])
                    got=[x.strip() for x in nm.stdout.decode("utf-8","replace").splitlines() if x.strip()]
                    tool_notes.append(f"{tool}:rc={nm.returncode}")
                    if got:
                        symbol_lines.extend(got[:12])
                        break
                if shutil.which("llvm-readobj"):
                    ro=run(["llvm-readobj","--file-headers","--sections","--symbols",obj.name])
                    ro_lines=[x.strip() for x in ro.stdout.decode("utf-8","replace").splitlines()
                              if "Name:" in x or "Symbol:" in x]
                    if ro_lines:
                        symbol_lines.extend(ro_lines[:12])
                    tool_notes.append(f"llvm-readobj:rc={ro.returncode}")
        # The archive linker index can preserve the decorated C++ name even
        # when the ordinal stub object itself contains only generic sections.
        index_names=indexed_symbols.get(member,[])
        arm_symbol=next((x for x in index_names if not x.startswith("__imp_") and not x.startswith("_imp_")),"<no archive-index symbol>")
        evidence_items=symbol_lines[:12] + candidates[:6]
        if not evidence_items:
            evidence_items=["header="+blob.stdout[:24].hex(), *tool_notes]
        evidence="; ".join(evidence_items).replace("|","/") or "—"
        wins_symbol=wins.get((dll,ordinal),'<no WINS map>')
        out.append(f"| {ordinal} | {arm_symbol} | {wins_symbol} | {member} | {len(blob.stdout)} | {evidence} |")
        tsv_rows.append((dll,ordinal,arm_symbol,wins_symbol,member,"OK" if arm_symbol!="<no archive-index symbol>" else "NO_SYMBOL"))
    out.append("")
OUT.parent.mkdir(parents=True,exist_ok=True)
OUT.write_text("\n".join(out))
tsv_path=OUT.with_suffix(".tsv")
with tsv_path.open("w",newline="",encoding="utf-8") as f:
    w=csv.writer(f,delimiter="\t")
    w.writerow(["dll","ordinal","arm_urel_symbol","wins_udev_reference","archive_member","status"])
    w.writerows(tsv_rows)
print(f"Wrote {OUT} ({OUT.stat().st_size} bytes)")
print(f"Wrote {tsv_path} ({tsv_path.stat().st_size} bytes)")
