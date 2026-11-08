# Step 51 — Next live-trace blocker: EIKCORE ordinal 222

Date: 2026-11-08

## Observed stop

The Step45 live VFS trace now advances beyond the earlier EUSER 1582
allocation request. Its current deliberate fail-closed stop is:

`EIKCORE[10004892].DLL ordinal=222`
- guest receiver: `r0 = 0x10110000`
- return address: `lr = 0x10028438`
- IAT slot: `0x1010057C`
- import thunk: `0x1009FA00`

The game import registry maps that thunk and slot to EIKCORE UID 10004892,
ordinal 222. Step46's ARM UREL archive-index report maps this ordinal to
`__15CEikApplication`, i.e. the `CEikApplication` constructor.

## SDK declaration evidence

The original N-Gage SDK header
`6.1/Series60/Epoc32/Include/eikapp.h` declares
`CEikApplication : public CApaApplication` and exposes a protected imported
default constructor `CEikApplication()`.

The base declaration in
`6.1/Series60/Epoc32/Include/apparc.h` is
`CApaApplication : public CBase`. It owns additional state including
`CApaDll* iApaDll` and `TInt iSpare`. The derived class declares members
`iCoeEnv`, `iResourceFileOffset`, `iProcess`, `iCaption`,
`iCapabilityBuf`, `iAppFlags`, and `iSpare`.

This confirms the semantic identity and inheritance chain, but header
declarations do not provide the constructor's executable initialization
sequence or the exact vtable address to install in the guest object.

## Reconstructed CEikApplication base layout

The SDK headers and the lifted caller provide enough evidence for a bounded
constructor HLE. The class layout is:

| Offset | Field | Initialization |
|---:|---|---|
| +0 | CBase/CEikApplication vptr | left for the caller; it writes the derived vtable immediately after the import returns |
| +4 | CApaApplication::iApaDll | null |
| +8 | CApaApplication::iSpare | 0 |
| +12 | CEikApplication::iCoeEnv | null |
| +16 | iResourceFileOffset | 0 |
| +20 | iProcess | null |
| +24 | iCaption | TBuf<256> descriptor header |
| +28 | iCaption maximum length | 256 |
| +32..+543 | iCaption inline storage | not written by the empty descriptor constructor |
| +544 | iCapabilityBuf | null |
| +548 | iAppFlags | 0 |
| +552 | iSpare | 0 |

The SDK defines TApaAppCaption as TBuf<KApaMaxAppCaption>, with
KApaMaxAppCaption = 0x100. A TBuf<256> occupies 520 bytes (8-byte descriptor
header plus 512-byte UTF-16 storage). The complete CEikApplication layout is
556 bytes (0x22c), exactly matching the allocation size passed to
CBase::operator new at the observed callsite.

The lifted function sub_1002841c performs this sequence:

1. Allocate 0x22c bytes through EUSER 1582.
2. Call EIKCORE 222 with r0=this and no constructor arguments.
3. Immediately write the game-derived vtable pointer 0x100fd9bc at object+0.

Thus the EIKCORE constructor's base vptr is not required after return; the
caller installs the derived vtable. The HLE helper
shadowkey_hle_eikcore222_ceikapplication initializes the documented pointer
and integer fields, sets the TBuf<256> descriptor header to type 3 / length 0
(0x30000000), and sets its maximum length to 256. It deliberately does not
invent or write a vtable address.

The Step50 integration test verifies the 556-byte layout, initialized fields,
and that the caller-owned vptr and caption storage are left untouched. The
VFS trace now passes EIKCORE 222 and proceeds through EUSER 3, EIKCORE 219
and CleanupStack PushL/Pop before reaching EIKCORE 224.

## Current conclusion

EIKCORE 222 is no longer the active blocker: a constrained constructor HLE is
implemented from the SDK class layout and lifted callsite evidence. This is
not a claim that the original EIKCORE ARM function body has been recovered.
EIKCORE 219 (CEikDocument) also has a constructor HLE based on its SDK fields.

The current unresolved constructor is EIKCORE ordinal 224,
CEikAppUi::CEikAppUi(). Its multiple-inheritance layout includes a secondary
vtable slot not overwritten by the lifted caller. That slot must not be
filled with a guessed pointer. See
[Step 50 ARM UREL report](STEP50_ARM_UREL_IMPORT_IDENTITY_BREAKTHROUGH.md)
and [Step 50 callsite context](STEP50_EIKCORE_CALLSITE_CONTEXT.md).

No physical Nokia N95 launch is claimed. The original N-Gage ARM UREL map
also remains distinct from the N95 RM-320 / Symbian OS 9.2 ROM export table.
