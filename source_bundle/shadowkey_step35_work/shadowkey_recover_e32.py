#!/usr/bin/env python3
"""Experimental ARM function recovery for an E32Image with export-table roots.

This tool reuses the Shadowkey IDA-free CFG walker and adds every E32 export
entry as a function candidate. It supports the old EKA1-style uncompressed
ARM images present in 6R51.APP and SIMKIN.DLL; it is not a general E32 loader.
"""
import argparse, csv, hashlib, json, struct
from pathlib import Path
from shadowkey_recover_vtables_v2 import Recover, is_in_code

def u32(data, off): return struct.unpack_from('<I', data, off)[0]

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('image',type=Path)
    ap.add_argument('-o','--out',type=Path,required=True)
    ap.add_argument('--max-functions',type=int,default=10000)
    args=ap.parse_args()
    data=args.image.read_bytes()
    if len(data)<0x80 or data[0x10:0x14]!=b'EPOC': raise SystemExit('not an E32Image')
    flags=u32(data,0x2c); code_size=u32(data,0x30); base=u32(data,0x4c)
    exp_off=u32(data,0x58); exp_count=u32(data,0x5c); code_off=u32(data,0x64)
    if not code_size or code_off+code_size>len(data): raise SystemExit('invalid code offset/size')
    if exp_off+4*exp_count>len(data): raise SystemExit('invalid export table bounds')
    code=data[code_off:code_off+code_size]
    exports=[]
    for i in range(exp_count):
        value=u32(data,exp_off+4*i)
        target=base+(value&~1)
        thumb=bool(value&1)
        exports.append({'ordinal':i+1,'raw_value':value,'address':target,'thumb':thumb})
    arm_exports=[e for e in exports if not e['thumb'] and is_in_code(e['address'],base,code_size) and not (e['address']&3)]
    if not arm_exports: raise SystemExit('no aligned ARM export roots found')
    root=arm_exports[0]['address']
    rec=Recover(data,base,code_off,code_size)
    prologues,thunks,bl_targets=rec.scan_candidates(root)
    for e in arm_exports:
        rec.known_starts.add(e['address'])
        rec.candidate_reason.setdefault(e['address'],'export-table')
    candidates=sorted(rec.known_starts)
    for va in candidates:
        if len(rec.funcs)>=args.max_functions: break
        rec.analyze_function(va)
    funcs=sorted(rec.funcs.values(),key=lambda f:f['start'])
    exp_by_addr={}
    for e in arm_exports: exp_by_addr.setdefault(e['address'],[]).append(e['ordinal'])
    for f in funcs:
        ords=exp_by_addr.get(f['start'],[])
        if ords:
            f['export_ordinals']=ords
            f['name']=f"export_{ords[0]:03d}_{f['start']:08x}"
    payload={
      'functions':funcs,
      'segments':[{'name':'.text','start':base,'end':base+len(code),'perm':5,'bytes':code.hex()}],
      'exports':exports,
      'recovery':{
        'method':'IDA-free ARM CFG walk plus every E32 export as a root',
        'root':root,'base':base,'code_file_offset':code_off,'code_size':code_size,
        'export_table_file_offset':exp_off,'export_count':exp_count,'flags':flags,
        'input_sha256':hashlib.sha256(data).hexdigest(),
        'function_count':len(funcs),'arm_exports':len(arm_exports),
        'thumb_exports':sum(e['thumb'] for e in exports),
        'instruction_heads':sum(len(f['heads']) for f in funcs),
        'direct_call_edges':len(rec.call_edges),
        'warning':'Experimental ARM-only recovery. Some exported addresses may be thunks or leaf functions; function bounds are heuristic. Relocations and runtime imports are not executed by this script.'
      }
    }
    args.out.write_text(json.dumps(payload,separators=(',',':')))
    exp_csv=args.out.with_name(args.out.stem+'_exports.csv')
    with exp_csv.open('w',newline='') as fh:
        w=csv.DictWriter(fh,fieldnames=['ordinal','raw_value','address','thumb','function_candidate','function_size','function_heads'])
        w.writeheader()
        fmap={f['start']:f for f in funcs}
        for e in exports:
            f=fmap.get(e['address'])
            w.writerow({'ordinal':e['ordinal'],'raw_value':f"0x{e['raw_value']:08X}",'address':f"0x{e['address']:08X}",'thumb':int(e['thumb']),'function_candidate':int(f is not None),'function_size':f['size'] if f else '', 'function_heads':len(f['heads']) if f else ''})
    summary=args.out.with_suffix('.summary.txt')
    summary.write_text('\n'.join([
      f'Image: {args.image}', f'SHA-256: {payload["recovery"]["input_sha256"]}',
      f'Code base: 0x{base:08X}', f'Code file offset: 0x{code_off:X}', f'Code size: {code_size:,} bytes',
      f'Export table: file+0x{exp_off:X}, {exp_count} entries',
      f'ARM exports: {len(arm_exports)}, Thumb exports: {payload["recovery"]["thumb_exports"]}',
      f'Function candidates: {len(funcs)}', f'Instruction heads: {payload["recovery"]["instruction_heads"]:,}',
      f'Direct call edges: {payload["recovery"]["direct_call_edges"]:,}',
      f'Exports with recovered function candidates: {sum(bool(fmap.get(e["address"])) for e in arm_exports)}',
      '', payload['recovery']['warning'], ''
    ]))
    print(summary.read_text())
    print(f'Wrote {args.out} ({args.out.stat().st_size:,} bytes)')
    print(f'Wrote {exp_csv} ({exp_csv.stat().st_size:,} bytes)')
if __name__=='__main__': main()
