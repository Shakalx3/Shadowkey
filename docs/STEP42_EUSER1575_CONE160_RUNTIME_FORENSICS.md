# Step 42 — EUSER1575 and CONE160 runtime forensics

Read-only probes were added at the import boundary. They dump caller-owned output and receiver memory before the unresolved imports; they do not write guest memory or force success.

## Host regression suite

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

## Runtime evidence

---
  CONE160 FORENSIC hidden-result=102fed24 this=101102c8 sp=102fed18 lr=10021404\n  TRACE CONE160 hidden-result PRE @102fed24: 53 70 61 63 65 20 69 6e
  TRACE CONE160 control object prefix @101102c8: 68 cf 0f 10 74 bb 0f 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 80 ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
UNIMPLEMENTED Shadowkey import: CONE[10003a41].DLL ordinal 160 (r0=102fed24 r1=101102c8 r2=0000039c r3=000003ad)
  EUSER1575 FORENSIC r0(out)=102feae0 r1(obj+310)=101105d8 r2=00000000 r3=101105e8 sp=102feaac lr=10022910\n  TRACE EUSER1575 arg0/out-candidate PRE @102feae0: 00 00 00 00 00 00 00 00 63 3a 5c 73 79 73 74 65
  TRACE EUSER1575 arg1 object fields around +310 @101105c8: 00 10 31 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  TRACE EUSER1575 arg3 object @101105e8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  TRACE EUSER1575 caller stack args @102feaac: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 72 74 00 73 79 73 74 65 6d 5c 61 70 70 73 5c 36 52 35 31 5c 64 72 61 67 6f 6e 73 74 61 72 2e 73
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1575 (r0=102feae0 r1=101105d8 r2=00000000 r3=101105e8)
  CONE160 FORENSIC hidden-result=102feae8 this=101102c8 sp=102feaac lr=10022ad8\n  TRACE CONE160 hidden-result PRE @102feae8: 63 3a 5c 73 79 73 74 65
  TRACE CONE160 control object prefix @101102c8: 68 cf 0f 10 74 bb 0f 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 88 12 11 10 00 00 00 00 01 80 ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
UNIMPLEMENTED Shadowkey import: CONE[10003a41].DLL ordinal 160 (r0=102feae8 r1=101102c8 r2=00000000 r3=00000000)
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
  EUSER1575 FORENSIC r0(out)=102feee4 r1(obj+310)=101105d8 r2=10111288 r3=101105e8 sp=102feeb0 lr=10022910\n  TRACE EUSER1575 arg0/out-candidate PRE @102feee4: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  TRACE EUSER1575 arg1 object fields around +310 @101105c8: 00 10 31 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  TRACE EUSER1575 arg2 pointee @10111288: 00 00 00 00 a4 f9 0f 10 c8 02 11 10 00 00 00 00 14 01 10 10 00 f8 00 3c c2 01 8a 02 80 00 c8 00 00 00 00 00 00 00 00 00 30 7b 23 10 40 00 00 00
  TRACE EUSER1575 arg3 object @101105e8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  TRACE EUSER1575 caller stack args @102feeb0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal 1575 (r0=102feee4 r1=101105d8 r2=10111288 r3=101105e8)
  CONE160 FORENSIC hidden-result=102feeec this=101102c8 sp=102feeb0 lr=10022ad8\n  TRACE CONE160 hidden-result PRE @102feeec: 00 00 00 00 00 00 00 00
  TRACE CONE160 control object prefix @101102c8: 68 cf 0f 10 74 bb 0f 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 88 12 11 10 00 00 00 00 01 80 ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
UNIMPLEMENTED Shadowkey import: CONE[10003a41].DLL ordinal 160 (r0=102feeec r1=101102c8 r2=10111288 r3=00000000)
---

## Interpretation limits

- EUSER1575 remains unimplemented; its nonzero-success branch is not fabricated.
- CONE160 remains unimplemented; its hidden-result ABI is observed, but the returned TPoint/TSize semantics are not assumed.
- GDI151/GDI108 remain opt-in experimental probes; DrawText remains diagnostic-only.
- Host trace calls RunL directly and does not instantiate CActiveScheduler or represent a physical N95 launch.
