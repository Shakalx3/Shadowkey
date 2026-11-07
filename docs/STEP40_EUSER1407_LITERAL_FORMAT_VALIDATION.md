# Step 40 — EUSER1407 literal-only implementation validation

The host regression suite and a fresh VFS trace were run from the extracted archive.

## Host suite

---
  VFS RFile::Size wrote 252 to 1017f530 for /home/runner/work/Shadowkey/Shadowkey/source_bundle/shadowkey_step35_work/game_assets/The_Elder_Scrolls_Travels_Shadowkey/system/apps/6R51/menu_sprites.txt
IMPORT dll=EFSRV[100039e4].DLL ord=15 r0=1017f534 r1=1017f530 r2=1017f54c r3=00000002 sp=00000000 lr=00000000 cpsr=00000000
  EFSRV probe ord=15 args: r0=1017f534[00000000 00000000 00000000 00000000] r1=1017f530[000000fc 00000000 00000000 00000000] r2=1017f54c[30000024 00000100 003a0065 0073005c] r3=00000002
  VFS EFSRV ordinal 15 close /home/runner/work/Shadowkey/Shadowkey/source_bundle/shadowkey_step35_work/game_assets/The_Elder_Scrolls_Travels_Shadowkey/system/apps/6R51/menu_sprites.txt (preserve r0=1017f534; Close is void)
PASS: EFSRV ordinal 185 call-site ABI writes RFile::Size(TInt&) output without changing the file handle
PASS: CONE ordinal 226 has four this-only call sites
PASS: ordinal 55 has two matching this-only call sites
PASS: both paired sites call returned object's vtable slot +0xD8 with ordinal-55 result
PASS: remaining ordinal-226 sites use returned object's graphics-context slots +0x48 / +0xB8
INFERENCE: ordinal 226 = CCoeControl::SystemGc() (high confidence, not export-table proven)
INFERENCE: ordinal 55 = CCoeControl::DrawableWindow() (high confidence, not export-table proven)
PASS: FBSCLI ordinal 17 maps to thunk 0x1009FD40 and has exactly three guest call sites
PASS: all three sites pass the engine bitmap-object field at +0x2E4
PASS: two sites store the return as a pixel-buffer pointer at engine-child +0x480
PASS: first consumer zero-fills 0x11E00 bytes through that return pointer
PASS: third site stores the same return in engine +0x300 for later propagation
PASS: ordinal 17 is called with only the bitmap receiver deliberately set
INFERENCE: ordinal 135 = CFbsBitmap construction; ordinal 16 = Create(TSize&,TDisplayMode)
INFERENCE: ordinal 17 = CFbsBitmap::DataAddress() (high confidence; no FP1 EAT proof)
  GFX HLE: DrawText(gc=10100000 desc=10100100 point=10100200 (-2,3) baseline=-15 align=2 margin=7) [diagnostic only; no glyph rasterization]
  GFX RAW descriptor @10100100: 05 00 00 30 00 01 00 00 48 00 45 00 4c 00 4c 00 4f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  GFX RAW point @10100200: fe ff ff ff 03 00 00 00
  GFX RAW stack-args @10100300: 02 00 00 00 07 00 00 00
PASS: DrawText ABI register/stack decode; TPoint coordinates; no unintended pixel writes
IMPORT dll=EUSER[100039e5].DLL ord=711 r0=10100000 r1=00000000 r2=0000000d r3=fffffff1 sp=10101000 lr=00000000 cpsr=00000000
  HLE EUSER711 TPoint init point=10100000 (0,13)
IMPORT dll=EUSER[100039e5].DLL ord=711 r0=10100000 r1=00000017 r2=0000000d r3=fffffff8 sp=10101000 lr=00000000 cpsr=00000000
  HLE EUSER711 TPoint init point=10100000 (23,13)
PASS: EUSER 711 TPoint ABI writes only this->x/this->y; r3 and stack are not arguments
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=10100000 r1=100b1068 r2=00000000 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1407 (r0=10100000 r1=100ac718 r2=00000000 r3=00000000)
PASS: EUSER1407 Swiss literal-only subset at all five font callsites; non-font/unknown inputs fail closed
PASS: ARM Operand2 LSL/LSR/ASR/ROR/RRX immediate and register semantics, including shifter carry
PASS: 4961 shifted ARM data-processing instructions now use full Operand2 semantics; generator cases pass
IMPORT dll=EUSER[100039e5].DLL ord=1373 r0=10100000 r1=00000000 r2=000000a0 r3=00000000 sp=00000000 lr=10023314 cpsr=00000000
  EUSER1373 object forensic @10100000
  TRACE EUSER font/spec object @10100000: ef be ad de ce fa ed fe 78 56 34 12 21 43 65 87 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  HLE EUSER1373 TPoint set site=10023314 point=10100000 (0,160)
IMPORT dll=EUSER[100039e5].DLL ord=530 r0=10100000 r1=00000000 r2=000000a0 r3=00000000 sp=00000000 lr=1002331c cpsr=00000000
  EUSER530 object forensic @10100000
  TRACE EUSER font/spec object @10100000: 00 00 00 00 a0 00 00 00 78 56 34 12 21 43 65 87 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  HLE EUSER530 TPoint::Y site=1002331c point=10100000 -> 160
IMPORT dll=EUSER[100039e5].DLL ord=711 r0=10100000 r1=00000000 r2=0000000d r3=fffffff8 sp=10101000 lr=1002350c cpsr=00000000
  HLE EUSER711 TPoint init point=10100000 (0,13)
PASS: EUSER1373 TPoint set, EUSER530 Y getter, EUSER711 TPoint constructor; callsite ABI and 8-byte writes verified
---

## Live trace runner

---
PASS: HAL free-RAM model crosses the original constructor threshold; unmodified engine state reaches DrawText
PASS: no forced engine+0x34 write in live harness; threshold=0x0068afff
LIMITATION: direct RunL invocation still bypasses CActiveScheduler; HAL free RAM is a configurable diagnostic model, not a measured N95 reading
---

## GDI forensic audit

---
PASS: all five GDI108 callsites are accounted for
PASS: each receiver is exactly TFontSpec candidate base + 0x3C; source descriptor starts at receiver + 4
PASS: conflicting legacy GDI151 layout is isolated behind a separate opt-in
PASS: live watch instruments guest WRITE8/WRITE16/WRITE32 paths
PASS: watch armed on receiver subobject
PASS: no guest CPU writes to receiver range before GDI108
PASS: pre-call first 12 bytes captured
PASS: GDI108 experimental default writes 12 zero bytes
PASS: post-call style block is zero
PASS: GDI151 candidate prefix is 60 bytes of a 72-byte spec
PASS: font lookup reads the 72-byte candidate
PASS: first DrawText reached
PASS: second DrawText reached
PASS: unmodified live-state RunL returned
PASS: GDI101 was skipped in this observed call path
LIMIT: the TFontSpec72/TBufC<24>/GDI108 mapping remains a cross-checked experiment, not N95 ROM-confirmed ABI
LIMIT: DrawText is diagnostic only; no glyph rasterization or physical N95 launch
---

## Selected live trace lines

---
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000043 r1=00000003 r2=00000043 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000062 r1=00000003 r2=00000062 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000062 r1=00000003 r2=00000062 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000061 r1=00000003 r2=00000061 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000061 r1=00000003 r2=00000061 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=0000007f r1=00000003 r2=0000007f r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=0000007f r1=00000003 r2=0000007f r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000008 r1=00000003 r2=00000008 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000008 r1=00000003 r2=00000008 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1506 (r0=1027cbd8 r1=00000000 r2=00000020 r3=00000020)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=0000001b r1=00000003 r2=0000001b r3=00000000)
UNIMPLEMENTED Shadowkey import: ESTLIB[10003b0b].DLL ordinal 316 (r0=1027cd20 r1=1027d270 r2=00000008 r3=00000008)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1504 (r0=1027d260 r1=1027d260 r2=00000001 r3=00000080)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000025 r1=00000003 r2=00000025 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000025 r1=00000003 r2=00000025 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000035 r1=00000003 r2=00000035 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000035 r1=00000003 r2=00000035 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000047 r1=00000003 r2=00000047 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000047 r1=00000003 r2=00000047 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=0000003e r1=00000003 r2=0000003e r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=0000003e r1=00000003 r2=0000003e r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000047 r1=00000003 r2=00000047 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000047 r1=00000003 r2=00000047 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000041 r1=00000003 r2=00000041 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000041 r1=00000003 r2=00000041 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=0000005c r1=00000003 r2=0000005c r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=0000005c r1=00000003 r2=0000005c r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000031 r1=00000003 r2=00000031 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000031 r1=00000003 r2=00000031 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000068 r1=00000003 r2=00000068 r3=00000000)
UNIMPLEMENTED Shadowkey import: ESTLIB[10003b0b].DLL ordinal 316 (r0=1027ca98 r1=1027d500 r2=00000009 r3=00000009)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1504 (r0=1027d4f0 r1=1027d4f0 r2=00000001 r3=00000080)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000019 r1=00000003 r2=00000019 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000019 r1=00000003 r2=00000019 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=0000001f r1=00000003 r2=0000001f r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=0000001f r1=00000003 r2=0000001f r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=0000003c r1=00000003 r2=0000003c r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=0000003c r1=00000003 r2=0000003c r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=0000004d r1=00000003 r2=0000004d r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=0000004d r1=00000003 r2=0000004d r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=0000004b r1=00000003 r2=0000004b r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=0000004b r1=00000003 r2=0000004b r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=0000003e r1=00000003 r2=0000003e r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=0000003e r1=00000003 r2=0000003e r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000064 r1=00000003 r2=00000064 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000064 r1=00000003 r2=00000064 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000020 r1=00000003 r2=00000020 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000020 r1=00000003 r2=00000020 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000067 r1=00000003 r2=00000067 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000067 r1=00000003 r2=00000067 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000010 r1=00000003 r2=00000010 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000010 r1=00000003 r2=00000010 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000016 r1=00000003 r2=00000016 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000016 r1=00000003 r2=00000016 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000012 r1=00000003 r2=00000012 r3=00000000)
UNIMPLEMENTED Shadowkey import: ESTLIB[10003b0b].DLL ordinal 316 (r0=1027c878 r1=1027d888 r2=00000008 r3=00000008)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1504 (r0=1027d878 r1=1027d878 r2=00000001 r3=00000080)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000031 r1=00000003 r2=00000031 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000031 r1=00000003 r2=00000031 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=0000005f r1=00000003 r2=00000059 r3=0000001f)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=0000005f r1=00000003 r2=00000059 r3=0000001f)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000069 r1=00000003 r2=00000069 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000069 r1=00000003 r2=00000069 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000041 r1=00000003 r2=00000041 r3=00000000)
UNIMPLEMENTED Shadowkey import: ESTLIB[10003b0b].DLL ordinal 316 (r0=1027d418 r1=1027d9a8 r2=00000009 r3=00000009)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1504 (r0=1027d998 r1=1027d998 r2=00000001 r3=00000080)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000042 r1=00000003 r2=00000042 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000042 r1=00000003 r2=00000042 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000047 r1=00000003 r2=00000047 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1617 (r0=00000047 r1=00000003 r2=00000047 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1247 (r0=102fe7a4 r1=102fe7a4 r2=102febac r3=00000000)
UNIMPLEMENTED Shadowkey import: ESTLIB[10003b0b].DLL ordinal 178 (r0=102fe634 r1=100b3360 r2=1027da60 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 21 (r0=00002710 r1=100b3360 r2=1027da60 r3=00000000)
UNIMPLEMENTED Shadowkey import: ESTLIB[10003b0b].DLL ordinal 316 (r0=1027da70 r1=10223e80 r2=1027da70 r3=1027da60)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 21 (r0=00002710 r1=00000001 r2=00000000 r3=00001e00)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 933 (r0=101102c8 r1=00000001 r2=00000000 r3=10111288)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1408 (r0=102fe268 r1=1027daf0 r2=00000004 r3=102fe780)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 207 (r0=102fe268 r1=102223ac r2=00000004 r3=102fe780)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1506 (r0=1027dad0 r1=00000002 r2=00000080 r3=101002ec)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1504 (r0=1027db30 r1=00000003 r2=00008082 r3=10224408)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1506 (r0=1027da50 r1=00000002 r2=00000000 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 531 (r0=101105e8 r1=00000002 r2=00000080 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 531 (r0=101105e8 r1=10111288 r2=00000000 r3=00000000)
UNIMPLEMENTED Shadowkey import: GAMECOMMS[101f5ee2].DLL ordinal 9 (r0=00000000 r1=000000ff r2=00000000 r3=10111288)
  HLE EUSER1407 Format literal-only: TBuf16<6> length=5 text=Swiss lr=10023230
  GDI FORENSIC ordinal=151 args=(102fecf0,102fed30,000000d5,000000a0) stack=102fe6ac
  TRACE GDI151 TFontSpec before @102fecf0: 00 00 00 00 70 fe 0f 10 00 00 00 00 48 ed 2f 10 40 ed 2f 10 1c ed 2f 10 64 ef 2f 10 5c ef 2f 10 e8 4a 02 10 70 fe 0f 10 00 00 00 00 70 fe 0f 10 00 00 00 00 64 fe 0f 10 00 20 69 6e
  TRACE GDI151 descriptor @102fed30: 05 00 00 30 06 00 00 00 53 00 77 00 69 00 73 00 73 00 00 00
  EXPERIMENT GDI151 TFontSpec prefix: name-length=5 height=213 twips prefix=60 total=72; TBufC<24> candidate
  TRACE GDI151 experimental TFontSpec prefix @102fecf0: 05 00 00 40 18 00 00 00 53 00 77 00 69 00 73 00 73 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 d5 00 00 00
  EXPERIMENT GDI108 TFontStyle default: dst=102fed2c spec=102fecf0+0x3c fields={0,0,0} size=12
  GFX HLE GetNearestFontInTwips: TFontSpec72 name='Swiss' height=213 twips style=(0,0,0) -> provisional 14 px (96 dpi model)
  GFX HLE: DrawText(gc=10110770 desc=102fe8e8 point=102fecf0 (0,160) baseline=83 align=0 margin=0) [diagnostic only; no glyph rasterization]
  GFX HLE: DrawText(gc=10110770 desc=102fe6e0 point=102fecf0 (0,13) baseline=83 align=0 margin=0) [diagnostic only; no glyph rasterization]
  GFX HLE: DiscardFont(gc=10110770)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1506 (r0=10400000 r1=00000000 r2=00000000 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1504 (r0=1027db38 r1=00000000 r2=00000000 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1575 (r0=102feee4 r1=101105d8 r2=10111288 r3=101105e8)
UNIMPLEMENTED Shadowkey import: CONE[10003a41].DLL ordinal 160 (r0=102feeec r1=101102c8 r2=10111288 r3=00000000)
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 21 (r0=00000000 r1=102feeec r2=00000000 r3=10111288)
---

## Scope and limitations

- EUSER1407 is implemented only for the five statically identified Swiss font-name callsites with no format directives.
- Other EUSER1407 callsites remain unresolved; the generic variadic formatter is not implemented.
- GDI151 and GDI108 are still enabled only through their existing experimental downstream probes.
- This is host diagnostic execution, not a Symbian OS 9.2 runtime or physical N95 launch.
