#!/usr/bin/env python3
"""Map ARM UREL import-library archive members to game import ordinals."""
from pathlib import Path
import re, subprocess, tempfile

ROOT=Path("source_bundle/shadowkey_step35_work")
DISPATCH=ROOT/"shadowkey_import_dispatch.c"
WINS_REPORT=Path("docs/STEP44_SYMBIAN61_EXPORT_ORDINAL_AUDIT.md")
ARM_ROOT=Path("/tmp/ngagesdk-sdk/6.1/Series60/Epoc32/Release/armi/urel")
OUT=Path("docs/STEP46_ARM_IMPORTLIB_ORDINAL_MAP.md")

entry_re=re.compile(r'\{\s*(0x[0-9a-fA-F]+)u?,\s*(0x[0-9a-fA-F]+)u?,\s*"([A-Z0-9]+)\[[^]]+\]\.DLL",\s*(\d+)u\s*\}')
entries=[]
for thunk,slot,dll,ordtext in entry_re.findall(DISPATCH.read_text(errors="replace")):
    entries.append((int(thunk,16),int(slot,16),dll.lower(),int(ordtext)))
wins={}
for line in WINS_REPORT.read_text(errors="replace").splitlines():
    m=re.match(r'^\|\s*0x[0-9a-f]+\s*\|\s*0x[0-9a-f]+\s*\|\s*([A-Z0-9]+)\s*\|\s*(\d+)\s*\|\s*(.*?)\s*\|$',line)
    if m:wins[(m.group(1).lower(),int(m.group(2)))]=m.group(3)

def run(args):
    return subprocess.run(args,stdout=subprocess.PIPE,stderr=subprocess.PIPE,check=False)

def strings(data):
    with tempfile.NamedTemporaryFile() as f:
        f.write(data);f.flush()
        p=run(["strings","-a",f.name])
        return p.stdout.decode("utf-8","replace").splitlines()

out=[
 "# Step 46 — ARM UREL import-library ordinal cross-check","",
 "This report inspects the actual ARM UREL import-library members, not only the WINS UDEB COFF import libraries used in Step 44.","",
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
        candidates=candidates[:8]
        evidence="; ".join(candidates).replace("|","/") or "<no printable symbol strings>"
        out.append(f"| {ordinal} | {wins.get((dll,ordinal),'<no WINS map>')} | {member} | {len(blob.stdout)} | {evidence} |")
    out.append("")
OUT.write_text("\n".join(out))
print(f"Wrote {OUT} ({OUT.stat().st_size} bytes)")
