#!/usr/bin/env python3
"""Extract old E32 import blocks and map import thunks to DLL ordinals."""
import argparse,csv,struct
from pathlib import Path

def u32(b,o):return struct.unpack_from('<I',b,o)[0]
def cstr(b,o):
 e=b.find(b'\0',o)
 if e<0: raise ValueError(f'unterminated string at {o:#x}')
 return b[o:e].decode('ascii','replace')

def main():
 ap=argparse.ArgumentParser();ap.add_argument('image',type=Path);ap.add_argument('-o','--out',type=Path,required=True);args=ap.parse_args()
 d=args.image.read_bytes()
 if len(d)<0x80 or d[0x10:0x14]!=b'EPOC':raise SystemExit('not E32')
 base=u32(d,0x4c);code_size=u32(d,0x30);code_off=u32(d,0x64);text_size=u32(d,0x60);dll_count=u32(d,0x54);imp_off=u32(d,0x6c);imp_size=u32(d,imp_off)
 code=d[code_off:code_off+code_size];iat_start=text_size
 pos=imp_off+4; blocks=[]
 for _ in range(dll_count):
  name_rel,n=struct.unpack_from('<II',d,pos); name=cstr(d,imp_off+name_rel); ords=list(struct.unpack_from('<'+'I'*n,d,pos+8));
  blocks.append({'dependency':name,'ordinals':ords,'base':base+iat_start})
  iat_start+=4*n;pos+=8+4*n
 for b in blocks:
  off=b['base']-base
  vals=list(struct.unpack_from('<'+'I'*len(b['ordinals']),code,off))
  if vals!=b['ordinals']:
   raise SystemExit(f'IAT mismatch for {b["dependency"]} at {b["base"]:#x}: {vals[:8]} != {b["ordinals"][:8]}')
 thunks=[]
 for off in range(0,len(code)-16+1,4):
  w0,w1,w2=struct.unpack_from('<III',code,off)
  if w0==0xE59FC004 and w1==0xE59CC000 and w2==0xE12FFF1C:
   slot=u32(code,off+12); found=None
   for b in blocks:
    begin=b['base']; end=begin+4*len(b['ordinals'])
    if begin<=slot<end and (slot-begin)%4==0:
     idx=(slot-begin)//4;found={'thunk_address':base+off,'slot_address':slot,'dependency':b['dependency'],'ordinal':b['ordinals'][idx],'position_in_dependency_block':idx+1};break
   if found: thunks.append(found)
 with args.out.open('w',newline='') as f:
  w=csv.DictWriter(f,fieldnames=['thunk_address','slot_address','dependency','ordinal','position_in_dependency_block']);w.writeheader()
  for r in thunks:w.writerow({**r,'thunk_address':f"0x{r['thunk_address']:08X}",'slot_address':f"0x{r['slot_address']:08X}"})
 blocks_out=args.out.with_name(args.out.stem.replace('_thunks','')+'_blocks.csv')
 with blocks_out.open('w',newline='') as f:
  w=csv.DictWriter(f,fieldnames=['dependency','array_base','import_count','ordinals']);w.writeheader()
  for b in blocks:w.writerow({'dependency':b['dependency'],'array_base':f"0x{b['base']:08X}",'import_count':len(b['ordinals']),'ordinals':','.join(map(str,b['ordinals']))})
 print(f'Image: {args.image}')
 print(f'DLL reference blocks: {len(blocks)}; total imports: {sum(len(b["ordinals"]) for b in blocks)}')
 print(f'IAT base: 0x{base+text_size:08X}; import thunks mapped: {len(thunks)}')
 for b in blocks:print(f'  {b["dependency"]}: {len(b["ordinals"])} imports')
 print(f'Wrote {args.out} and {blocks_out}')
if __name__=='__main__':main()
