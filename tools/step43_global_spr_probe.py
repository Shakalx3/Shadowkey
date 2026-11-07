#!/usr/bin/env python3
"""Verify the live image-decoder resource against the original global.spr pack."""
from pathlib import Path
import struct
root=Path("game_assets/The_Elder_Scrolls_Travels_Shadowkey/system/apps/6R51")
p=root/"global.spr"
data=p.read_bytes()
offset=0x9444
print(f"global.spr size={len(data)} bytes")
print(f"resource[0xF8] candidate offset=0x{offset:x}")
if offset+0x204>len(data):
    raise SystemExit("candidate resource header exceeds file")
w,h=struct.unpack_from("<HH",data,offset)
print(f"candidate dimensions={w}x{h}")
print("candidate header/palette prefix="+data[offset:offset+64].hex(" "))
print("candidate payload prefix="+data[offset+0x204:offset+0x244].hex(" "))
print("runtime header expected=b0 00 d0 00 01 0c 01 0b 11 0f 01 0b ...")
print(f"header_match_176x208={w==176 and h==208}")
matches=[]
for pos in range(0,len(data)-3,4):
    if struct.unpack_from("<I",data,pos)[0]==offset:
        base=pos-0xF8*4
        if base>=0 and base+0xFA*4<=len(data):
            prev=struct.unpack_from("<I",data,base+0xF7*4)[0]
            nxt=struct.unpack_from("<I",data,base+0xF9*4)[0]
            matches.append((pos,base,prev,nxt))
print(f"offset-table candidates containing entry[0xF8]=0x9444: {len(matches)}")
for pos,base,prev,nxt in matches[:12]:
    print(f"table_entry_filepos=0x{pos:x} table_base=0x{base:x} prev=0x{prev:x} this=0x{offset:x} next=0x{nxt:x} resource_bytes={nxt-offset if nxt>=offset else -1}")
    if nxt>offset and nxt<=len(data):
        nw,nh=struct.unpack_from("<HH",data,nxt) if nxt+4<=len(data) else (0,0)
        print(f"  next_resource_header={nw}x{nh}")
