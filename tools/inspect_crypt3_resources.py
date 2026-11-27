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


def inspect_entities(path):
    data=path.read_bytes()
    if len(data)<4: return
    count=struct.unpack_from("<I",data,0)[0]
    print(f"\n=== entity table {path.name}: count={count}, bytes={len(data)} ===")
    if count and 4+count*72==len(data):
        print("Confirmed exact 72-byte record tiling.")
        for i in range(count):
            off=4+i*72
            rec=data[off:off+72]
            strings=runs(rec,3)
            words=struct.unpack_from("<18I",rec,0)
            floats=struct.unpack_from("<18f",rec,0)
            print(f"ENT[{i:03d}] off={off:04d} u32={words[:8]} f32={[round(x,3) if abs(x)<1e7 else str(x) for x in floats[:8]]} strings={strings}")
    else:
        print("No exact 72-byte tiling; first bytes:",data[:128].hex(" "))

def inspect_path_table(path):
    data=path.read_bytes()
    print(f"\n=== path table {path.name}: bytes={len(data)} ===")
    if len(data)>=2:
        print("leading u16:",struct.unpack_from("<H",data,0)[0])
    print("ASCII runs:",json.dumps(runs(data,3),ensure_ascii=True))
    print("u32 words:",[hex(x) for x in struct.unpack_from("<"+"I"*(len(data)//4),data,0)[:64]])


def export_entity_table(path):
    data=path.read_bytes()
    count=struct.unpack_from("<I",data,0)[0]
    if 4+count*72 != len(data):
        raise ValueError("Crypt3.ent is not a 72-byte record table")
    rows=[]
    for i in range(count):
        off=4+i*72
        rec=data[off:off+72]
        def cstr(start,end):
            return rec[start:end].split(b"\0",1)[0].decode("ascii","replace").replace("\xcc","")
        x,y,z=struct.unpack_from("<iii",rec,0)
        yaw=struct.unpack_from("<i",rec,20)[0]
        label=cstr(32,40)
        script=cstr(40,72)
        rows.append({"index":i,"x_raw":x,"y_raw":y,"z_raw":z,
                     "x":x/256.0,"y":y/256.0,"z":z/256.0,
                     "yaw_raw":yaw,"yaw_candidate":yaw/256.0,
                     "label":label,"script":script})
    import csv
    out=path.parent/"Crypt3_entities.csv"
    with out.open("w",newline="",encoding="utf-8") as f:
        w=csv.DictWriter(f,fieldnames=list(rows[0]))
        w.writeheader();w.writerows(rows)
    (path.parent/"Crypt3_entities.json").write_text(json.dumps(rows,indent=2),encoding="utf-8")
    print(f"\nExported {len(rows)} entities to {out.name}; coordinates are raw signed 8.8 candidates, not yet independently calibrated.")
    print("Entity type/script counts:",json.dumps(collections.Counter(r["script"] for r in rows).most_common(30)))

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
    ent=root/"Crypt3.ent"
    if ent.exists():\n        inspect_entities(ent)\n        export_entity_table(ent)
    pth=root/"Crypt3.pth"
    if pth.exists(): inspect_path_table(pth)
if __name__=="__main__": main()
