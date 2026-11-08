#!/usr/bin/env python3
"""Map ARM UREL import-library archive members to game import ordinals."""
from pathlib import Path
import os, re, subprocess, tempfile, shutil

ROOT=Path("source_bundle/shadowkey_step35_work")
DISPATCH=ROOT/"shadowkey_import_dispatch.c"
WINS_REPORT=Path("docs/STEP44_SYMBIAN61_EXPORT_ORDINAL_AUDIT.md")
ARM_ROOT=Path(os.environ.get("SHADOWKEY_ARM_SDK_ROOT", "/tmp/ngagesdk-sdk"))/"6.1/Series60/Epoc32/Release/armi/urel"
OUT=Path("docs/STEP46_ARM_IMPORTLIB_ORDINAL_MAP.md")

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

def run(args):
    return subprocess.run(args,stdout=subprocess.PIPE,stderr=subprocess.PIPE,check=False)

def strings(data):
    with tempfile.NamedTemporaryFile() as f:
        f.write(data);f.flush()
        p=run(["strings","-a",f.name])
        return p.stdout.decode("utf-8","replace").splitlines()

out=[
 "# Step 46 — ARM UREL import-library ordinal cross-check","",
 "This report inspects ARM UREL import-library members and compares their extracted symbol evidence with the WINS UDEB COFF import-library names recorded in Step 44. A dsNNNNN.o member name alone is only an ordinal candidate, not proof of symbol identity.","",
 f"- Game import slots: {len(entries)}",
 f"- Distinct DLLs: {len(set(e[2] for e in entries))}",
 "- ARM member naming convention is checked against archive tables; a member named dsNNNNN.o is treated as candidate ordinal NNNNN, not assumed to be correct until its contents are inspected.",""
]
for dll in sorted(set(e[2] for e in entries)):
    lib=ARM_ROOT/f"{dll}.lib"
    out += [f"## {dll.upper()}.LIB",""]
    if not lib.exists():
        out += ["- ARM UREL import library absent from this SDK tree.",""]
        continue
    listing=run(["ar","t",str(lib)])
    if listing.returncode:
        out += [f"- ar t failed: {listing.stderr.decode('utf-8','replace')[:500]}",""]
        continue
    members=listing.stdout.decode("utf-8","replace").splitlines()
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
    out += [f"- Archive members: {len(members)}; dsNNNNN ordinal-like members: {len(byord)}",
            "| Ordinal | WINS UDEB symbol | ARM member | Member size | Extracted strings / symbol evidence |",
            "|---:|---|---|---:|---|"]
    for ordinal in wanted:
        member=byord.get(ordinal)
        if not member:
            out.append(f"| {ordinal} | {wins.get((dll,ordinal),'<no WINS map>')} | MISSING | 0 | — |")
            continue
        blob=run(["ar","p",str(lib),member])
        if blob.returncode:
            out.append(f"| {ordinal} | {wins.get((dll,ordinal),'<no WINS map>')} | {member} | 0 | ar p failed |")
            continue
        found=strings(blob.stdout)
        candidates=[x for x in found if len(x)>2 and (('@' in x) or ('_' in x) or re.search(r'[A-Za-z]{4,}',x))]
        candidates=candidates[:6]
        symbol_lines=[]
        tool_notes=[]
        with tempfile.NamedTemporaryFile() as obj:
            obj.write(blob.stdout);obj.flush()
            # The SDK's ARM import objects are not recognized by the host GNU nm.
            # Try LLVM and ARM-aware tools before falling back to GNU nm.
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
        evidence_items=symbol_lines[:12] + candidates[:6]
        if not evidence_items:
            evidence_items=["<no decoded symbols>", "header="+blob.stdout[:24].hex(), *tool_notes]
        evidence="; ".join(evidence_items).replace("|","/") or "<no symbol strings>"
        out.append(f"| {ordinal} | {wins.get((dll,ordinal),'<no WINS map>')} | {member} | {len(blob.stdout)} | {evidence} |")
    out.append("")
OUT.write_text("\n".join(out))
print(f"Wrote {OUT} ({OUT.stat().st_size} bytes)")
