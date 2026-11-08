# Step 48 — EUSER 1407 HLE audit and font-trace quarantine

Date: 2026-11-08

## Scope

This pass follows Step 47 into the committed source tree. It checks the actual import registry and the current EUSER/CONE HLE implementation rather than treating the earlier diagnostic font trace as an ABI oracle.

## Verified source facts

The game's generated import registry identifies:
- EUSER UID 100039E5 ordinal 1407 at thunk 0x1009F0F0, IAT slot 0x101007A4.
- EUSER UID 100039E5 ordinal 1575 at thunk 0x1009F240, IAT slot 0x101007E8.
- CONE UID 10003A41 ordinal 160 at thunk 0x1009F510, IAT slot 0x1010040C.
- GDI UID 10003B15 ordinals 101, 108 and 151 are separate imports (see the registry and Step 44 SDK report).

The Step 44 WINS UDEB SDK short-import records identify:
- EUSER 1407: `?SetOffset@TDblQueBase@@QAEXH@Z`.
- EUSER 1575: `?Val@TLex8@@QAEHAAVTInt64@@ABV2@@Z`.
- CONE 160: `?Position@CCoeControl@@QBE?AVTPoint@@XZ`.
- GDI 101: `?JustificationInPixels@CGraphicsContext@@SAHAAH0@Z`.
- GDI 108: `?NewL@CPalette@@SAPAV1@H@Z`.
- GDI 151: `?StoreL@CPicture@@UBE?AVTStreamId@@AAVCStreamStore@@@Z`.

The current `shadowkey_symbian61_hle.h` already implements EUSER 1407 as `TDblQueBase::SetOffset(TInt)`: it treats r0 as `this`, r1 as the integer offset, and writes the value at object +8. The same header implements CONE 160 as a hidden-result TPoint return, reading the CCoeControl position at +0x0c/+0x10. These implementations are consistent with the SDK symbol names, but their object-layout assumptions still require confirmation against the exact N-Gage SDK headers/source or a native trace.

The import registry and the HLE source therefore independently confirm that EUSER 1407 is not a descriptor conversion API in this project. EUSER 1575 is a lexer conversion API and is a distinct thunk.

## Important consequence: quarantine the previous font trace

The bundled `source_bundle/shadowkey_step35_work/README.md` still documents a diagnostic chain named EUSER1407 -> EUSER1282 -> GDI151 -> GDI108 -> GetNearestFont -> DrawText and instructs enabling `SHADOWKEY_EXPERIMENTAL_EUSER1407_FONT`.

That label is now known to be semantically wrong for the imported EUSER 1407 symbol. The old trace may have conflated:
- the real SetOffset call with a nearby descriptor operation;
- an HLE experiment selected by an environment flag rather than by the imported symbol identity;
- caller temporaries and nearby object memory;
- later GDI operations whose import identities were also misassigned.

The old trace remains useful as a record of what the diagnostic harness did, but it is not evidence that EUSER 1407 parses or initializes a font descriptor. Do not use the old command block as a semantic reproduction of the real import chain. Keep the experimental handler disabled until its exact import dispatch path is reconciled.

## New next experiment

1. Add an entry/exit trace for thunk 0x1009F0F0 that records r0/r1, the 12-byte object prefix at r0, and the 4-byte field at r0+8 before/after. Do not alter the receiver.
2. Enumerate every callsite to 0x1009F0F0 and determine whether r0 is the TDblQueBase subobject; trace the owning object and its iHead links.
3. Trace thunk 0x1009F240 separately. Decode the TLex8 receiver, TInt64 output reference, source descriptor and return error code; do not reuse any EUSER1407 descriptor assumptions.
4. Trace the font path from the first actual GDI/FBS import boundary. Record DLL UID, ordinal, thunk, registers, stack arguments and caller return address for each event. Identify font construction by the exact SDK import symbol, not by nearby object size.
5. Verify GDI ordinal signatures against the same SDK's ARM UREL library and then compare against N95 RM-320 / S60 3rd FP1 exports. Step 46 ARM UREL output is not yet present, so no ARM/WINS cross-check is claimed.

## Limits

- WINS UDEB ordinal identity is strong evidence for the original N-Gage SDK, not proof that the same ordinal on Symbian OS 9.2 has the same meaning.
- The TDblQueBase +8 field and CCoeControl position offsets are currently HLE layout assumptions; they need header/source or trace confirmation.
- The Step 46 ARM UREL cross-check has not produced a report. No workflow run was returned for the commit that touched the trigger file.
- No N95 E32 executable, physical launch, actual FBS font-provider integration, or glyph rasterization is demonstrated.

## Status

- Game thunk/slot/ordinal association: verified from committed import registry.
- WINS UDEB names: verified from Step 44 report.
- Current EUSER 1407 and CONE 160 HLE code: inspected.
- Prior EUSER1407 font interpretation: withdrawn/quarantined.
- ARM UREL and N95 firmware verification: pending.


## Step 49 correction — prior quarantine conclusion is withdrawn as an ARM identity claim

The WINS UDEB mapping is valid for that library configuration, but it does not establish the ARM game's import identity. Step39 contains ARM callsites where the `Swiss` format literal is passed in r1 to thunk 0x1009F0F0; Step42 also preserves the old format-specific diagnostic experiment. These facts conflict with applying the WINS-only SetOffset signature to the ARM game. The active SetOffset dispatch has been disabled. The old font trace is not accepted as a complete native implementation either; the correct ARM API remains unresolved until Step46 member-level evidence is inspected. See [Step 49](STEP49_WINS_ARM_ORDINAL_CONFLICT.md).