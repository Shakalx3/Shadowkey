#!/usr/bin/env python3
"""Assert the asset/bitmap milestones and the corrected return-chain frontier."""
from pathlib import Path
import re
import sys

if len(sys.argv) != 2:
    raise SystemExit("usage: shadowkey_frontier_regression.py TRACE_LOG")
log = Path(sys.argv[1]).read_text(errors="replace")
source = Path("shadowkey_lifted_v6.c").read_text(errors="replace")
engine_test = Path("shadowkey_engine_init_test.c").read_text(errors="replace")

def require(condition, message):
    if not condition:
        raise SystemExit("FAIL: " + message)

require("0x101d0000u" not in source and "0x101d0000u" not in engine_test,
        "synthetic 0x101D0000 graphics pointer still present")
for size, name in [(338078, "StringTable.eng"), (37956, "global.spr"),
                    (22064, "entities.txt"), (252, "menu_sprites.txt")]:
    require(f"VFS EFSRV ordinal 136 read {size}/{size} bytes" in log,
            f"{name} was not read completely")
require("VFS RFile::Size wrote 338078" in log,
        "StringTable.eng size was not obtained")
match = re.search(r"WATCH source2\+14a3c WRITE32 at=10125cc4 value=([0-9a-fA-F]{8})", log)
require(match is not None and int(match.group(1), 16) != 0,
        "resource conversion did not populate active source+0x14A3C")
require("FBS HLE: Create 176x233 mode=10 stride=352 bytes=82016 header=10300100 pixels=10311000" in log,
        "CFbsBitmap Create did not allocate the observed mode-10 surface")
require("FBS HLE: DataAddress object=10110718 shared=10300100 offset=00001000 -> 10311000 (82016 bytes)" in log,
        "DataAddress did not resolve the shared-header offset")
match = re.search(r"IMGDEC RESULT dest=10311000 nonzero_bytes=(\d+) buffer_bytes=82016", log)
require(match is not None and int(match.group(1)) > 0,
        "decoded bitmap buffer is empty or decoder did not finish")
match = re.search(r"FBS HLE: DataAddress re-fetch #2 after guest use: nonzero=(\d+)/(\d+)", log)
require(match is not None and int(match.group(1)) > 0,
        "pixel data did not remain in bitmap buffer")
require("GFX HLE: CFbsBitmapDevice::NewL bitmap=10110718" in log,
        "BITGDI bitmap-device construction was not reached")
require("GFX HLE: CFbsDevice::CreateContext device=" in log,
        "BITGDI graphics-context construction was not reached")
require("GFX HLE: CFont model=" in log,
        "CFont diagnostic model was not reached")
require("TRACE sub_100231b4 entry obj=101102c8 +2e4=10110718 +2e8=10110730 +2ec=10110770" in log,
        "engine bitmap/device/context object chain was not verified")
require("GFX HLE: DrawText(gc=" in log and
        "point=102fecf0 (0,160) baseline=83" in log and
        "GFX HLE: DiscardFont(gc=" in log,
        "graphics-context DrawText/DiscardFont handlers were not reached")
require("GFX HLE: bitmap/font callback diagnostic" in log and
        "unimplemented 10311000" not in log,
        "bitmap/font callback was confused with the pixel-buffer address")
require("HLE EUSER1373 TPoint set" in log and "HLE EUSER530 TPoint::Y" in log and
        "HLE EUSER711 TPoint init" in log,
        "text-position TPoint constructor/getter callsites were not restored")
require("HLE extended heap alloc size=15073516 -> 10400000" in log,
        "32 MiB guest heap did not service the large asset allocation after the FBS reservation")
require("IMPORT dll=CONE[10003a41].DLL ord=160" in log,
        "execution did not reach CONE ordinal 160")
require("HLE EUSER1431 zero-fill dst=" in log and "UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1431" not in log,
        "EUSER ordinal 1431 zero-fill callsite contract was not applied")
require("ENGINE RUNL live-state returned" in log,
        "natural high-RAM RunL did not return to its harness")
require("ARM fallback BX out-of-range" not in log and "ARM fallback INVALID BX" not in log,
        "invalid BX was silently converted into a synthetic return or remains unresolved")
require("OOB 00000004/4 pc=102fdc68" not in log,
        "old bogus stack-address OOB remains")
for helper, end_marker in [("void sub_1000df3c(ngage_cpu_t *c) {", "void sub_1000dfc4(ngage_cpu_t *c) {"),
                           ("void sub_1006c730(ngage_cpu_t *c) {", "void sub_1006c768(ngage_cpu_t *c) {")]:
    block = source[source.index(helper):source.index(end_marker, source.index(helper))]
    require("ngage_call(c, c->r[12]); return;" not in block,
            f"recursive tail-return emulation remains in {helper}")
print("PASS: assets, StringTable conversion, FBS shared chunks and RGB444 (12-bit values in 16-bit storage) decode")
print("PASS: bitmap device/context and diagnostic font model reached")
print("PASS: +0x2E4/+0x2E8/+0x2EC object chain and DrawText/DiscardFont handlers verified")
print("PASS: bitmap/font callback is separated from the FBS pixel buffer")
print("PASS: CONE ordinal 160 callsites reached without fake BX tail-return")
print("PASS: EUSER ordinal 1431 zero-fill callsite contract applied")
print("PASS: no OOB at 0x102FDC68; caller continuation is handled by lifted C caller")
print("FRONTIER: natural high-RAM constructor path reaches DrawText; text rasterization remains unimplemented")
print("NOTE: host diagnostic trace only; not a complete game launch or N95 test")
