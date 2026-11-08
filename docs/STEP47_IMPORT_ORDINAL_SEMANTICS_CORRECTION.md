# Step 47 — Import ordinal semantics correction

Date: 2026-11-08

## Purpose

Reconcile the game image's actual DLL+ordinal imports with the original N-Gage / Symbian 6.1 SDK WINS UDEB import-library records. This check is required before assigning C++ types or implementing HLE handlers. Several earlier GDI and EUSER hypotheses were based on observed call shapes and synthetic consumers rather than export-name evidence.

## Evidence used

1. `source_bundle/shadowkey_step35_work/shadowkey_import_dispatch.c` contains the game's import registry, including thunk address, IAT slot, DLL name/UID, and ordinal.
2. `docs/STEP44_SYMBIAN61_EXPORT_ORDINAL_AUDIT.md` records names parsed from the SDK's WINS UDEB COFF import-library short-import records. These are ordinal-backed records (NameType 0), not guesses from newer Symbian releases.
3. The exact DLL UIDs in the game import registry were checked for the relevant entries.

The WINS UDEB mapping is strong symbol evidence for the N-Gage SDK ABI. It is not yet a proof that a same-numbered export in the N95's Symbian OS 9.2 firmware has identical semantics or ABI. ARM UREL archive-member verification and target-firmware comparison remain separate gates.

## Corrected mappings

| Game DLL import | Game thunk | IAT slot | SDK import-library symbol | Interpretation |
|---|---:|---:|---|---|
| EUSER UID 100039E5 ordinal 1407 | 0x1009F0F0 | 0x101007A4 | `TDblQueBase::SetOffset(TInt)` | Member method taking an integer offset; not a descriptor parser/converter |
| EUSER UID 100039E5 ordinal 1575 | 0x1009F240 | 0x101007E8 | `TLex8::Val(TInt64&, const TInt64&)` | 8-bit lexer numeric conversion into TInt64; not a font/descriptor initializer |
| CONE UID 10003A41 ordinal 160 | 0x1009F510 | 0x1010040C | `CCoeControl::Position() const -> TPoint` | Value-returning method; consistent with the observed hidden-result TPoint return path |
| GDI UID 10003B15 ordinal 101 | 0x100A00B0 | 0x10100888 | `CGraphicsContext::JustificationInPixels(TInt&, TInt&)` | Static justification query; not DrawText |
| GDI UID 10003B15 ordinal 108 | 0x100A00C0 | 0x1010088C | `CPalette::NewL(TInt)` | Palette factory; not a TFontSpec/font-object constructor |
| GDI UID 10003B15 ordinal 151 | 0x100A00A0 | 0x10100890 | `CPicture::StoreL(CStreamStore&) const -> TStreamId` | Picture serialization; not a TFontSpec constructor |

The symbol spellings above are taken from the Step 44 EUSER/CONE/GDI import-library tables. The exact thunk and IAT values are taken from the game's import registry.

## Consequences for prior analysis

### EUSER 1407

The previous descriptor-format investigation around EUSER ordinal 1407 must be re-scoped. The SDK import symbol identifies it as `TDblQueBase::SetOffset(TInt)`. Any traces that appeared to show descriptor reads/writes at the same point must be checked for:
- incorrect thunk-to-ordinal association;
- a different nearby EUSER import (for example EUSER 1575);
- a caller-side descriptor operation preceding/following SetOffset;
- confusion between the import's receiver and a nearby object.

Do not continue treating EUSER 1407 itself as a descriptor conversion routine.

### GDI 101 / 108 / 151

The earlier GDI text/font chain hypothesis is not supported by the SDK import-library evidence:
- GDI 101 is a justification query.
- GDI 108 is a palette factory.
- GDI 151 serializes a picture to a stream store.

Consequently, the 60-byte object observed around GDI 151 and the 72-byte TFontSpec candidate associated with GDI 108 must not be identified as those imports' formal arguments solely from size or proximity. Re-open those traces and establish whether the observed object belongs to another call, a hidden return buffer, a caller temporary, or an emulator-side instrumentation artifact.

The earlier diagnostic DrawText observations remain separate: this mapping does not identify an imported GDI DrawText ordinal.

### CONE 160

The import-library symbol `CCoeControl::Position() const -> TPoint` fits the hidden-result return ABI previously observed at CONE 160 much better than a generic helper interpretation. The observed return pointer should be validated as a caller-provided TPoint result buffer, including the two coordinate writes and object lifetime. Do not infer that the pointed-to address is an unrelated helper object solely because it appears as a return address in a trace.

## Required next experiments

1. Trace all calls through thunk `0x1009F0F0` and verify the receiver plus the integer argument at the actual call boundary. Confirm that the target is the TDblQueBase subobject and identify which queue owner contains it.
2. Trace thunk `0x1009F240` separately; verify the TLex8 receiver, output TInt64 reference, source descriptor and returned error code.
3. For GDI 101, 108 and 151, re-decode register/stack arguments according to the mapped signatures. Keep the existing experimental font handlers disabled.
4. Confirm the ARM UREL import-library members against the WINS symbols and inspect their relocation/thunk shape. This verifies that the ARM and WINS SDK libraries agree on ordinal identity.
5. Obtain matching N95 RM-320 / S60 3rd FP1 export data before transferring any ordinal mapping to the target firmware.

## Status

- WINS UDEB import-library symbol mapping: **verified from Step 44 report**.
- Exact game DLL UIDs, ordinals, thunks and IAT slots: **verified from game import registry**.
- ARM UREL symbol cross-check: **pending** (Step 46 report was not present at the time of this audit).
- N95 firmware export comparison: **pending**.
- Real-device behavior: **not tested**.

This correction intentionally invalidates earlier speculative GDI 101/108/151 font semantics. It does not establish a working N95 binary.


## Step 49 follow-up — WINS names are not yet ARM game identities

This report's symbol names are confirmed for the WINS UDEB import-library records only. They must not be treated as the names of the corresponding imports in the ARM game binary until the ARM UREL member-level comparison is complete. In particular, the Step39 ARM callsites pass the `Swiss` format literal in r1 through EUSER 1407 thunk 0x1009F0F0, which conflicts with the WINS-only `TDblQueBase::SetOffset(TInt)` signature. See [Step 49](STEP49_WINS_ARM_ORDINAL_CONFLICT.md).

## Step 50 superseding result

This report is a WINS UDEB-only mapping and must not be used as the ARM game's import map. Step50 recovered the ARM UREL archive-index identities: EUSER 1407 is TPtrC16 construction, EUSER 1575 is TInt64 inequality, CONE 160 is CCoeControl::Rect, and GDI 101/108/151 are TFontStyle/TFontSpec operations. See [Step50](STEP50_ARM_UREL_IMPORT_IDENTITY_BREAKTHROUGH.md).
