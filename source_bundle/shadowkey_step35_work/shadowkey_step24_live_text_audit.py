#!/usr/bin/env python3
"""Verify that the natural high-RAM live probe reaches DrawText with real text."""
from pathlib import Path
import sys

if len(sys.argv) != 2:
    raise SystemExit("usage: shadowkey_step24_live_text_audit.py TRACE_LOG")
log = Path(sys.argv[1]).read_text(errors="replace")
checks = [
    ("HLE ESTLIB ordinal 317 UTF16 copy dst=102fedb4 src=100ad464 old=0 appended=0", "UTF-16 destination initialization was not reached"),
    ("HLE ESTLIB ordinal 315 UTF16 append dst=102fedb4 src=100ad984 old=0 appended=1", "space append was not reached"),
    ("HLE ESTLIB ordinal 315 UTF16 append dst=102fedb4 src=101e06b8 old=1 appended=19", "main UTF-16 text append was not reached"),
    ('HLE EUSER248 TDes16::Copy(TUint16*) dst=102fe8e8 src=102feaf0 length=19/max=256 text="has paused the game"', "first non-empty TBuf16 copy was not observed"),
    ('HLE EUSER248 TDes16::Copy(TUint16*) dst=102fe6e0 src=102fedc8 length=10/max=256 text="d the game"', "second non-empty TBuf16 copy was not observed"),
    ("GFX HLE: DrawText(gc=10110770 desc=102fe8e8 rect=102fecf0", "first DrawText call was not reached"),
    ("GFX HLE: DrawText(gc=10110770 desc=102fe6e0 rect=102fecf0", "second DrawText call was not reached"),
    ("TRACE EUSER711 out-before @102fecf0", "EUSER 711 output was not captured"),
]
for needle, message in checks:
    if needle not in log:
        raise SystemExit("FAIL: " + message)
if "UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 711" not in log:
    raise SystemExit("FAIL: EUSER 711 unexpectedly stopped being visible as unresolved")
if "GFX HLE: DrawText" not in log or "no glyph rasterization" not in log:
    raise SystemExit("FAIL: DrawText diagnostic boundary not preserved")
print("PASS: ESTLIB 317/315 produce a non-empty UTF-16 message")
print("PASS: EUSER 248 copies 'has paused the game' (19) and 'd the game' (10)")
print("PASS: both non-empty descriptors reach DrawText")
print("LIMIT: EUSER 711 remains unresolved; DrawText does not rasterize pixels")
