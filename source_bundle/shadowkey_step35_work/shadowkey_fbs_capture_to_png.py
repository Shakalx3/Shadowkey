#!/usr/bin/env python3
"""Convert the unmodified guest FBS EColor64K framebuffer capture to PNG."""
from pathlib import Path
import struct, sys, zlib

raw_path=Path(sys.argv[1] if len(sys.argv)>1 else ".build/live_run_bitmap.rgb565")
meta_path=Path(sys.argv[2] if len(sys.argv)>2 else ".build/live_run_bitmap.meta")
out_path=Path(sys.argv[3] if len(sys.argv)>3 else ".build/live_run_bitmap.png")
values=[int(x,16) if i>=5 else int(x) for i,x in enumerate(meta_path.read_text().split())]
w,h,stride,mode,expected_bytes,bitmap,pixels=values
raw=raw_path.read_bytes()
if mode != 10:
    raise SystemExit(f"Refusing unknown display mode {mode}; expected EColor64K (10)")
if w<=0 or h<=0 or stride<w*2 or len(raw)!=expected_bytes or expected_bytes!=stride*h:
    raise SystemExit(f"Invalid capture metadata: {w}x{h} stride={stride} raw={len(raw)} expected={expected_bytes}")
rows=[]
nonzero=0
for y in range(h):
    row=bytearray([0])
    line=raw[y*stride:y*stride+w*2]
    for x in range(w):
        v=line[x*2] | (line[x*2+1]<<8)
        if v: nonzero+=1
        r=(v>>11)&31; g=(v>>5)&63; b=v&31
        row.extend(((r*255+15)//31,(g*255+31)//63,(b*255+15)//31))
    rows.append(bytes(row))
def chunk(kind,data):
    return struct.pack(">I",len(data))+kind+data+struct.pack(">I",zlib.crc32(kind+data)&0xffffffff)
png=b"\x89PNG\r\n\x1a\n"
png+=chunk(b"IHDR",struct.pack(">IIBBBBB",w,h,8,2,0,0,0))
png+=chunk(b"IDAT",zlib.compress(b"".join(rows),9))
png+=chunk(b"IEND",b"")
out_path.write_bytes(png)
print(f"PNG {out_path}: {w}x{h}, RGB565 mode={mode}, stride={stride}, nonzero_pixels={nonzero}/{w*h}, bitmap=0x{bitmap:08x}, pixels=0x{pixels:08x}")
