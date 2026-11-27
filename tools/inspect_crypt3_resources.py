#!/usr/bin/env python3
"""Inspect decoded Shadowkey Crypt3 payloads and companion zone files."""
from __future__ import annotations
import pathlib, struct, zlib, re, json, collections

FILES = ["Crypt3.zmp", "Crypt3.ztx", "Crypt3.zlu", "Crypt3.zfg", "Crypt3.zsk", "Crypt3.zcp"]
COMPANIONS = ["Crypt3.ent", "Crypt3.pal", "Crypt3.pth", "Crypt3.stn", "Crypt3.sur", "Crypt3.zon"]

def runs(data, minimum=4):
    out=[]
    for m in re.finditer(rb"[\x20-\x7e]{%d,}" % minimum, data):
        out.append((m.start(), m.group().decode("ascii", "replace")[:100]))
    return out[:100]

def inspect(path):
    blob=path.read_bytes()
    declared=struct.unpack_from("<I", blob)[0]
    raw=zlib.decompress(blob[4:])
    if len(raw)!=declared:
        raise ValueError(f"{path.name}: declared {declared}, actual {len(raw)}")
    path.with_name(path.name+".raw").write_bytes(raw)
    print(f"\n=== {path.name} ===")
    print(f"compressed={len(blob)} decoded={len(raw)} ratio={len(blob)/len(raw):.3f}")
    print("first 128 bytes:", raw[:128].hex(" "))
    print("ASCII runs:", json.dumps(runs(raw), ensure_ascii=True))
    for fmt in ("H","I","f"):
        vals=[]
        for off in range(0,min(len(raw)-3,256),4):
            v=struct.unpack_from("<"+fmt,raw,off)[0]
            if fmt=="f":
                if v==v and abs(v)<1e7: vals.append(round(v,4))
            else: vals.append(v)
        print(f"{fmt} @ 4-byte stride:", vals[:24])

def inspect_companion(path):
    data=path.read_bytes()
    print(f"\n=== companion {path.name} ===")
    print(f"bytes={len(data)} unique_bytes={len(set(data))}")
    print("first 128 bytes:",data[:128].hex(" "))
    print("ASCII runs:",json.dumps(runs(data,3),ensure_ascii=True))
    print("byte frequencies:",collections.Counter(data).most_common(16))
    if path.suffix==".zon":
        print("16-bit words:",[struct.unpack_from("<H",data,i)[0] for i in range(0,min(len(data),96),2)])

def main():
    import argparse
    ap=argparse.ArgumentParser()
    ap.add_argument("zone",type=pathlib.Path)
    root=ap.parse_args().zone
    for name in FILES:
        p=root/name
        if p.exists(): inspect(p)
        else: print(f"missing: {p}")
    for name in COMPANIONS:
        p=root/name
        if p.exists(): inspect_companion(p)
        else: print(f"missing companion: {p}")
if __name__=="__main__": main()
