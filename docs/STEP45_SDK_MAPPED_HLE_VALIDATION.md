# Step 45 — SDK-mapped import correction and validation

- Original Symbian 6.1 SDK import libraries were parsed into docs/STEP44_SYMBIAN61_EXPORT_ORDINAL_AUDIT.md.
- The current HLE uses verified identities for EUSER1407, CONE160, EFSRV162 and EFSRV185; false Swiss/font mappings were removed.

## Host regression suite

BEGIN HOST LOG
FBS HLE: DataAddress object=10110718 shared=10300100 offset=00001000 -> 10311000 (82016 bytes)
PASS: HLE shared-chunk metadata + large-chunk pixels; DataAddress resolves Base()+offset; mode-10 buffer covers the 176x208 two-byte clear
IMPORT dll=EFSRV[100039e4].DLL ord=230 r0=10103000 r1=00000000 r2=00000000 r3=00000000 sp=00000000 lr=00000000 cpsr=00000000
IMPORT dll=EFSRV[100039e4].DLL ord=185 r0=10103000 r1=10100000 r2=00000000 r3=00000000 sp=00000000 lr=00000000 cpsr=00000000
  HLE SDK EFSRV185 TParse::Set this=10103000 name=10100000 related=00000000 default=00000000 rc=0
IMPORT dll=EFSRV[100039e4].DLL ord=121 r0=10103000 r1=10100000 r2=00000000 r3=00000000 sp=00000000 lr=00000000 cpsr=00000000
  HLE SDK EFSRV121 TParseBase::NamePresent this=10103000 -> 1
IMPORT dll=EFSRV[100039e4].DLL ord=146 r0=10103000 r1=10100000 r2=00000000 r3=00000000 sp=00000000 lr=00000000 cpsr=00000000
  HLE SDK EFSRV146 TParseBase::PathPresent this=10103000 -> 1
IMPORT dll=EFSRV[100039e4].DLL ord=162 r0=10104000 r1=10103018 r2=00000000 r3=10101000 sp=10102000 lr=00000000 cpsr=00000000
  HLE SDK EFSRV162 RFs::ReadFileSection path='e:\system\apps\6R51\menu_sprites.txt' offset=0 requested=252 got=252 out=10101000 data=10101008 max=512
PASS: SDK EFSRV230/185 TParse, EFSRV121/146 fields, EFSRV162 ReadFileSection; bytes=252 prefix='20
21
22
23
24
25
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
IMPORT dll=EUSER[100039e5].DLL ord=711 r0=10100000 r1=00000000 r2=0000000d r3=fffffff1 sp=10101000 lr=00000000 cpsr=00000000
  HLE EUSER711 TPoint init point=10100000 (0,13)
IMPORT dll=EUSER[100039e5].DLL ord=711 r0=10100000 r1=00000017 r2=0000000d r3=fffffff8 sp=10101000 lr=00000000 cpsr=00000000
  HLE EUSER711 TPoint init point=10100000 (23,13)
PASS: EUSER 711 TPoint ABI writes only this->x/this->y; r3 and stack are not arguments
PASS: isolated WINS-UDEB reference helpers only; not active ARM game dispatch
PASS: ARM Operand2 LSL/LSR/ASR/ROR/RRX immediate and register semantics, including shifter carry
PASS: 4961 shifted ARM data-processing instructions now use full Operand2 semantics; generator cases pass
IMPORT dll=EUSER[100039e5].DLL ord=711 r0=10100000 r1=00000000 r2=0000000d r3=fffffff8 sp=10101000 lr=1002350c cpsr=00000000
  HLE EUSER711 TPoint init point=10100000 (0,13)
PASS: EUSER711 TPoint constructor writes x/y only; EUSER1373 and EUSER530 remain unresolved pending ARM UREL identity
END HOST LOG

## Live trace runner


Live trace exit code: 95. Exit 95 is an intentional fail-closed stop.

## Selected trace evidence

HALT UNIMPLEMENTED Shadowkey import: EUSER[100039e5].DLL ordinal=1582 r0=0000022c r1=00000000 r2=00000000 r3=00000000 sp=102feff8 lr=10028428

## Interpretation limits

- Earlier framebuffer capture is real guest memory, but its source asset path is unverified because earlier EFSRV/ESTLIB ordinal mappings were wrong.
- This report does not claim a Symbian OS 9.2 runtime or physical N95 launch.
