# Step 45 — SDK-mapped import correction and validation

- Original Symbian 6.1 SDK import libraries were parsed into docs/STEP44_SYMBIAN61_EXPORT_ORDINAL_AUDIT.md.
- Step44 names are WINS UDEB reference identities only; they do not prove ARM game import identities.
- ARM UREL now maps EUSER1407 to TPtrC16 construction and CONE160 to CCoeControl::Rect; old WINS helpers remain disabled until corrected HLE implementations are installed.
- EFSRV path/read behavior is supported by the current guest trace, but is not proof of N95 firmware export identity.

## Host regression suite

BEGIN HOST LOG
26
27
'
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
IMPORT dll=EUSER[100039e5].DLL ord=711 r0=10100000 r1=00000017 r2=fffffff8 r3=deadbeef sp=10101000 lr=00000000 cpsr=00000000
  HLE ARM EUSER711 TRect::Move this=10100000 dx=23 dy=-8
PASS: ARM UREL EUSER711 TRect::Move translates top-left and bottom-right
PASS: ARM UREL TPtrC16, TInt64, TRect, CCoeControl::Rect and TFontStyle helpers
PASS: ARM Operand2 LSL/LSR/ASR/ROR/RRX immediate and register semantics, including shifter carry
PASS: 4961 shifted ARM data-processing instructions now use full Operand2 semantics; generator cases pass
IMPORT dll=EUSER[100039e5].DLL ord=1373 r0=10100000 r1=fffffffb r2=00000007 r3=00000064 sp=10101000 lr=10022c60 cpsr=00000000
  HLE ARM EUSER1373 TRect ctor this=10100000 (-5,7)-(100,160)
IMPORT dll=EUSER[100039e5].DLL ord=530 r0=10100000 r1=fffffffb r2=00000007 r3=00000064 sp=10101000 lr=10022c68 cpsr=00000000
  HLE ARM EUSER530 TRect::Height this=10100000 -> 153
IMPORT dll=EUSER[100039e5].DLL ord=711 r0=10100000 r1=00000017 r2=fffffff8 r3=00000064 sp=10101000 lr=1002350c cpsr=00000000
  HLE ARM EUSER711 TRect::Move this=10100000 dx=23 dy=-8
PASS: ARM UREL EUSER1373 TRect ctor, EUSER530 Height, EUSER711 Move
IMPORT dll=EUSER[100039e5].DLL ord=1407 r0=10001000 r1=10002000 r2=00000000 r3=00000000 sp=00000000 lr=00000000 cpsr=00000000
  HLE ARM EUSER1407 TPtrC16 this=10001000 source=10002000 length=5
IMPORT dll=GDI[10003b15].DLL ord=151 r0=10003000 r1=10001000 r2=000000d5 r3=00000000 sp=00000000 lr=00000000 cpsr=00000000
  HLE ARM GDI151 TFontSpec this=10003000 nameDesc=10001000 heightTwips=213 size=64
IMPORT dll=GDI[10003b15].DLL ord=108 r0=1000303c r1=00000001 r2=000000d5 r3=00000000 sp=00000000 lr=00000000 cpsr=00000000
  HLE ARM GDI108 TFontStyle::SetStrokeWeight this=1000303c value=1 flags=00000002
IMPORT dll=GDI[10003b15].DLL ord=101 r0=1000303c r1=00000001 r2=000000d5 r3=00000000 sp=00000000 lr=00000000 cpsr=00000000
  HLE ARM GDI101 TFontStyle::SetPosture this=1000303c value=1 flags=00000003
IMPORT dll=CONE[10003a41].DLL ord=160 r0=10005000 r1=10004000 r2=000000d5 r3=00000000 sp=00000000 lr=00000000 cpsr=00000000
  HLE ARM CONE160 CCoeControl::Rect this=10004000 -> (17,-23)-(97,22)
IMPORT dll=EUSER[100039e5].DLL ord=1575 r0=10006000 r1=10006010 r2=000000d5 r3=00000000 sp=00000000 lr=00000000 cpsr=00000000
  HLE ARM EUSER1575 TInt64::operator!= lhs=10006000 rhs=10006010 -> 1
IMPORT dll=EUSER[100039e5].DLL ord=1582 r0=0000022c r1=10006010 r2=000000d5 r3=00000000 sp=00000000 lr=00000000 cpsr=00000000
  HLE ARM EUSER1582 CBase::operator new size=556 -> 10120000
PASS: ARM UREL TPtrC16, TFontSpec64, TFontStyle, CCoeControl::Rect, TInt64 and CBase::operator new
END HOST LOG

## Live trace runner


Live trace exit code: 95. Exit 95 is an intentional fail-closed stop.

## Selected trace evidence

HALT UNIMPLEMENTED Shadowkey import: EIKCORE[10004892].DLL ordinal=222 r0=10110000 r1=00000000 r2=00000000 r3=00000000 sp=102feff8 lr=10028438

## Interpretation limits

- Earlier framebuffer capture is real guest memory, but its source asset path is unverified because earlier EFSRV/ESTLIB ordinal mappings were wrong.
- This report does not claim a Symbian OS 9.2 runtime or physical N95 launch.
