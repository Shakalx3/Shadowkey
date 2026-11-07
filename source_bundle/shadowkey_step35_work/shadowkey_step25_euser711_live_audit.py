#!/usr/bin/env python3
from pathlib import Path
import sys
p=Path(sys.argv[1] if len(sys.argv)>1 else '.build/live_hal_vfs_trace.log')
s=p.read_text(errors='replace')
checks={
 'two live EUSER711 sites reached': s.count('HLE EUSER711 TRect init rect=102fecf0 [0,13,-15,0]') >= 2,
 'first rect initialization occurs after the earlier DrawText': s.find('GFX HLE: DrawText') < s.find('HLE EUSER711 TRect init'),
 'later DrawText consumes initialized rectangle': 'rect=102fecf0 [0,13..-15,0]' in s,
 'later DrawText retains non-empty UTF-16 descriptor': 'desc=102fe6e0 rect=102fecf0 [0,13..-15,0]' in s and 'length=10/max=256 text="d the game"' in s,
 'EUSER711 no longer reported unimplemented': 'UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 711' not in s,
 'DrawText still explicitly diagnostic (no false rasterization claim)': '[diagnostic only; no glyph rasterization]' in s,
}
for k,v in checks.items(): print(('PASS' if v else 'FAIL')+': '+k)
if not all(checks.values()): raise SystemExit(1)
print('LIMIT: the first DrawText in this path precedes the EUSER711 setup and still sees stale rect memory; the subsequent DrawText uses the initialized 16-byte object.')
