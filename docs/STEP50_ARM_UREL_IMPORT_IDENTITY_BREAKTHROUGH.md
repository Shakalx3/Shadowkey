# Step 50 — ARM UREL import identities recovered

Date: 2026-11-08

## Executive result

The ARM UREL import-library archive index has now been parsed member-by-member.
For the original ARM game imports, this is the relevant symbol-to-ordinal
mapping. It is distinct from the WINS UDEB short-import mapping previously
used in Steps 47–49.

The Step46 parser now self-checks the ARM archive-index symbol names for the
imports below. The Step46 GitHub Actions run completed successfully and
committed the generated map:
`docs/STEP46_ARM_IMPORTLIB_ORDINAL_MAP.md`.

## ARM UREL mappings for game imports

| DLL | Ordinal | ARM UREL archive-index symbol | C++ interpretation |
|---|---:|---|---|
| EUSER | 3 | `newL__5CBaseUi` | `CBase::newL(TUint)` |
| EUSER | 1407 | `__7TPtrC16PCUs` | `TPtrC16::TPtrC16(const TUint16*)` |
| EUSER | 1575 | `__ne__C6TInt64RC6TInt64` | `TInt64::operator!=(const TInt64&) const` |
| EUSER | 1582 | `__nw__5CBaseUi` | `CBase::operator new(TUint)` |
| EUSER | 1373 | `__5TRectiiii` | `TRect::TRect(TInt,TInt,TInt,TInt)` |
| EUSER | 530 | `Height__C5TRect` | `TRect::Height() const` |
| EUSER | 711 | `Move__5TRectii` | `TRect::Move(TInt,TInt)` |
| CONE | 160 | `Rect__C11CCoeControl` | `CCoeControl::Rect() const` |
| GDI | 101 | `SetPosture__10TFontStyle12TFontPosture` | `TFontStyle::SetPosture(TFontPosture)` |
| GDI | 108 | `SetStrokeWeight__10TFontStyle17TFontStrokeWeight` | `TFontStyle::SetStrokeWeight(TFontStrokeWeight)` |
| GDI | 151 | `__9TFontSpecRC7TDesC16i` | `TFontSpec::TFontSpec(const TDesC16&,TInt)` |

The WINS UDEB names remain valid for that configuration only. Examples of
the mismatch include EUSER 1407 (WINS: TDblQueBase::SetOffset; ARM: TPtrC16
constructor), CONE 160 (WINS: Position; ARM: Rect), and GDI 108 (WINS:
CPalette::NewL; ARM: TFontStyle::SetStrokeWeight).

## Callsite consistency

### EUSER 1407

The Step39 ARM callsites load a pointer to the UTF-16 literal `Swiss` into
r1 and a stack temporary into r0 before calling thunk `0x1009F0F0`.
That is consistent with `TPtrC16(const TUint16*)`: r0 is the descriptor
object and r1 is the source string pointer.

The old diagnostic HLE printed the literal as `TBuf16<6>` and made the
string visible to downstream probes, but that was not the correct object
layout. A `TPtrC16` is a non-owning descriptor with a pointer to the
source buffer; it is not a formatted inline `TBuf16`. The old
Format-literal handler must not be restored.

### Font construction chain

The ARM UREL GDI mappings now explain the earlier Step42 observations:

- GDI 151 constructs a `TFontSpec` from a `TDesC16` name and an integer
  height.
- GDI 108 sets `TFontStyle` stroke weight.
- GDI 101 sets `TFontStyle` posture.

The Step42 receiver observation at `TFontSpec base + 0x3c` is consistent
with the SDK class layout: `TFontSpec::iFontStyle` begins at offset 60.
However, the old 12-byte GDI108 zero-write is not correct: `TFontStyle`
contains one `TUint32 iFlags`, so the setter should update only that
32-bit field.

### TFontSpec size and layout from SDK headers

The original N-Gage SDK headers in
`ngagesdk/sdk/6.1/Series60/Epoc32/Include/gdi.h` declare:

- `KMaxTypefaceNameLength = 0x18` (24 UTF-16 code units).
- `TTypeface::iName` is `TBufC<24>`: 4-byte descriptor header plus
  48 bytes of inline UTF-16 storage = 52 bytes.
- `TTypeface::iFlags` follows at offset 52.
- `TFontSpec::iHeight` follows the 56-byte `TTypeface`, at offset 56.
- `TFontSpec::iFontStyle` follows at offset 60 and contains one 32-bit
  flags word.

Therefore the SDK-declared `TFontSpec` size is **64 bytes**, not 72.
The old 72-byte observation included bytes beyond the actual object.
The 60-byte prefix and style receiver at +0x3c were useful observations;
the assumed 12-byte style object was not.

### CONE 160

The ARM symbol is `CCoeControl::Rect() const`, not Position. The hidden
result is a `TRect` (16 bytes), not a `TPoint` (8 bytes).

SDK header:
`6.1/Series60/Epoc32/Include/coecntrl.h` declares the fields in order:
`iCoeEnv`, `iContext`, `iPosition`, `iSize`. The runtime object prefix
shows two base vtable pointers before these members, consistent with the
multiple inheritance from `CBase` and `MObjectProvider`. Under that layout:

- `iPosition` begins at object +0x10 (two TInt coordinates).
- `iSize` begins at object +0x18 (width and height).
- `Rect()` returns left/top = position and right/bottom = position + size.

The former Position helper read the wrong offsets and wrote only eight
bytes. It must remain disabled until replaced by a 16-byte Rect helper and
tested against the observed object layout.

### EUSER 1373, 530, 711 and 1582

The ARM mappings invalidate the old Step30 point assumptions:

- EUSER 1373 is a four-integer `TRect` constructor. The fourth integer is
  passed on the stack under the ARM calling convention.
- EUSER 530 returns `TRect::Height()`, not `TPoint::Y()`.
- EUSER 711 is `TRect::Move(dx,dy)`, which updates all four rectangle
  coordinates, not a two-field TPoint constructor.
- EUSER 1582 is `CBase::operator new(TUint)`. The current VFS trace stops
  there with r0 = 0x22c (556 bytes), consistent with an allocation request.

EUSER 1575 is a 64-bit inequality comparison, not `TLex8::Val`. Its
previous forensic register labels need to be reinterpreted as two
`TInt64` operands, with the result in r0.

## SDK header evidence

Relevant original N-Gage SDK headers:

- `6.1/Series60/Epoc32/Include/e32des16.h`, lines 18–89:
  `TDesC16` descriptor header and `TPtrC16(const TUint16*)`.
- `6.1/Series60/Epoc32/Include/e32std.h`, lines 1868–1910:
  `TRect` constructors, `Move`, `Height`, and its two TPoint fields.
- `6.1/Series60/Epoc32/Include/e32base.h`, lines 13–27:
  `CBase::operator new(TUint)`.
- `6.1/Series60/Epoc32/Include/coecntrl.h`, lines 114–259:
  `CCoeControl` API and member order.
- `6.1/Series60/Epoc32/Include/gdi.h`, lines 234–306:
  `TTypeface`, `TFontStyle`, and `TFontSpec` layout.

## Current HLE state and next work

The following ARM-identity handlers are implemented and exercised by the
passing host regression suite:

- EUSER 3: CBase::newL(TUint); allocation failure halts the harness because
  Symbian leave unwinding is not emulated.
- EUSER 1582: CBase::operator new(TUint).
- EUSER 1407: bounded TPtrC16 constructor (type-1 descriptor + source pointer).
- EUSER 1575: TInt64 inequality comparison.
- EUSER 1373/530/711: TRect constructor (fourth argument on stack), Height and Move.
- EUSER 858/828: CleanupStack::PushL(CBase*) and Pop using a bounded LIFO
  model. EUSER 824/825 PopAndDestroy remain unresolved because virtual
  destructor dispatch has not been reconstructed.
- CONE 160: CCoeControl::Rect hidden-result TRect using position + size.
- GDI 151: 64-byte TFontSpec constructor with TBufC<24> typeface name.
- GDI 108/101: TFontStyle stroke-weight/posture setters updating one flags word.
- EIKCORE 222: CEikApplication constructor field initialization, including
  TApaAppCaption as TBuf<256>. The caller writes the derived vtable at +0
  immediately after the constructor returns.
- EIKCORE 219: CEikDocument constructor initializes iApplication,
  iApaProcess, iContainer, iAppUi, iEditStore, iChanged and iAppFileMode.
  The caller writes the derived vtable at +0 after the constructor.

The old WINS-derived SetOffset and Position helpers have been removed.
The VFS trace and bootstrap dispatchers now route the corrected ARM identities.
The host regression suite and Step48 static identity audit both pass.

The live VFS trace now reaches EIKCORE ordinal 224:

- ARM UREL symbol: `__9CEikAppUi` (CEikAppUi default constructor).
- Return address: `0x10021144`.
- r0 (this): `0x10110258`; r1: `0x10110000`; r2: 0; r3: `0x100fd828`.
- The object allocation size is 108 bytes.
- The lifted caller writes derived pointers/vtable entries at offsets
  +0x00, +0x14, +0x1c, +0x48 and +0x4c after the constructor.
- CEikAppUi inherits CCoeAppUi, MEikMenuObserver, MCoeMessageObserver and
  MObjectProvider. At least one secondary base/vtable slot is not overwritten
  by the caller. Its correct constructor value is not available in the ARM
  import library.

Step52 WINS probe result:

- The SDK WINS UDEB eikcore.dll is PE32/i386, 110,648 bytes, with 290
  unnamed exports and a stripped COFF symbol table.
- Its WINS import library has 293 archive members but no matching
  CEikAppUi/CEikApplication/CEikDocument constructor symbol strings.
- This cannot supply the ARM UREL secondary vtable or constructor body.

The Step53 layout analysis identifies the exact unresolved field:
CEikAppUi's MCoeMessageObserver secondary-base vptr at object+0x18. The
caller writes the other derived/base vtable entries at +0x00, +0x14 and
+0x1c, but leaves +0x18 to EIKCORE 224.

Next work:

1. Obtain the matching N-Gage QD ARM EIKCORE.DLL (or ROM dump) and recover
   the constructor's +0x18 vtable and any field initialization.
2. Obtain the N95 RM-320 EIKCORE.DLL separately to map target Symbian OS 9.2
   exports; do not substitute it for the N-Gage ARM library.
3. Implement EIKCORE224 only when its required base/vtable state is grounded.
4. Continue the live VFS trace after EIKCORE224, then address PopAndDestroy
   and any remaining FBS/GDI calls.

## Scope limits

These are import identities from the original N-Gage SDK ARM UREL libraries
and matching the game's ARM import slots. They are not proof that the same
ordinals have the same meanings in the Nokia N95 RM-320 Symbian OS 9.2 ROM.
The target firmware export table still needs a separate comparison.
No physical Nokia N95 launch is claimed.


## Step 51 follow-up — ARM handlers are implemented and regression-tested

The priority corrections listed above have since been implemented in the live
VFS dispatcher and the bootstrap path:

- EUSER 1407 now constructs an 8-byte non-owning `TPtrC16` descriptor
  (descriptor type/length plus source pointer); it does not copy the source
  string or treat it as a formatting operation.
- EUSER 1575 compares two 64-bit `TInt64` values and returns the boolean in
  r0.
- CONE 160 now returns a 16-byte `TRect` using the `CCoeControl` position
  and size members at +0x10 and +0x18.
- EUSER 1373/530/711 implement `TRect` construction, height and movement.
- GDI 151 constructs the SDK-sized 64-byte `TFontSpec`; GDI 108 and 101
  update the single `TFontStyle::iFlags` word while preserving unrelated bits.

The Step45 GitHub Actions host regression and live VFS trace completed
successfully as a workflow. The regression output exercises these handlers
with synthetic guest-memory fixtures. The live VFS trace advances past the
previous EUSER 1582 allocation stop and now halts deliberately at
`EIKCORE[10004892].DLL` ordinal 222, with LR `0x10028438`.

This is a substantial diagnostic milestone, not proof of a real Symbian
application launch. The host regression verifies our modeled behavior; the
live trace is still a partial emulation and stops at the next unresolved
import.
