#!/usr/bin/env python3
"""Find every direct caller of the recovered guest image decoder."""
from pathlib import Path
p=Path("shadowkey_lifted_v6.c")
lines=p.read_text(errors="replace").splitlines()
needles=("ngage_call(c, 0x1006a488u)","ngage_call(c, 0x1006a488)")
hits=[i for i,line in enumerate(lines) if any(n in line for n in needles)]
print(f"sub_1006a488 direct callsites: {len(hits)}")
for symbol in ("sub_100275e4","sub_10081030","sub_10024b3c"):
    start=p.read_text(errors="replace").find(f"void {symbol}")
    if start<0:
        print(f"\\n## {symbol}: not found")
        continue
    full=p.read_text(errors="replace")
    end=full.find("void sub_",start+len("void sub_"))
    if end<0: end=len(full)
    body=full[start:end].splitlines()
    print(f"\\n## Function {symbol}: {len(body)} source lines")
    for i,line in enumerate(body,1):
        print(f"{i}: {line}")
for n,hit in enumerate(hits,1):
    start=max(0,hit-70); end=min(len(lines),hit+35)
    fn="unknown"
    for i in range(hit,-1,-1):
        if lines[i].startswith("void sub_") or lines[i].startswith("static void sub_"):
            fn=lines[i].split("(")[0].replace("void ","").replace("static ","")
            break
    print(f"\n## Call {n}: caller={fn}, lifted_line={hit+1}")
    for i in range(start,end):
        print(f"{i+1}: {lines[i]}")
