# Step 58 — S60 3.1 FP1 target export remapping

Date: 2026-11-08

## Executive result

The pinned Nokia S60 3.1 FP1 / Symbian OS 9.2 SDK contains ARMv5 EABI4 DSO export tables. They were compared with the original game's N-Gage ARM UREL import identities recovered in Step50.

The key result is that **the original N-Gage ARM ordinals cannot be passed unchanged to the N95 system DLLs**. At every examined disputed ordinal, the S60 target DSO exports a different function. The correct API symbols do exist under different target ordinals, with one exception: the original EUSER 1575 `TInt64::operator!=` has no matching named export in the target EUSER DSO.

## Confirmed target ordinal mappings

Ordinal values below are derived from the S60 DSO dynamic symbol table using `st_value / 4 + 1`, restricted to aligned, defined GLOBAL DEFAULT symbols.

| Original game import | Target API symbol | S60 3.1 FP1 target ordinal | What unchanged old ordinal calls instead |
|---|---|---:|---|
| EUSER 1407 — `TPtrC16(const TUint16*)` | `TPtrC16::TPtrC16(const TUint16*)` | **1169** (C1) | EUSER 1407 = `E32Loader::ProcessLoaded` |
| EUSER 1575 — `TInt64::operator!=` | No matching named EUSER export found | — | EUSER 1575 = `RSubSessionBase::DoSendReceive` |
| CONE 160 — `CCoeControl::Rect()` | `CCoeControl::Rect() const` | **276** | CONE 160 = `CCoeEnv::LeaveWithErrorText` |
| GDI 101 — `TFontStyle::SetPosture` | `TFontStyle::SetPosture(TFontPosture)` | **12** | GDI 101 = `MGraphicsDeviceMap` destructor |
| GDI 108 — `TFontStyle::SetStrokeWeight` | `TFontStyle::SetStrokeWeight(TFontStrokeWeight)` | **14** | GDI 108 = `TBidirectionalState::InternalizeL` |
| GDI 151 — `TFontSpec` constructor | `TFontSpec::TFontSpec(const TDesC16&,TInt)` | **169** (C1) | GDI 151 = `CPicture::SetSizeInTwips` |
| EIKCORE 224 — `CEikAppUi` constructor | `CEikAppUi::CEikAppUi()` | **178** (C2 candidate) | EIKCORE 224 = `CEikonEnv::DestroyEnvironment` |

The DSO also exports the alternate C++ constructor variants:
- EUSER TPtrC16 C2: ordinal 1173 (C1: 1169).
- GDI TFontSpec C2: ordinal 171 (C1: 169).
- EIKCORE CEikAppUi C1: ordinal 177; C2: ordinal 178.

For the game callsites, TPtrC16 and TFontSpec are standalone objects, so their C1 entries are the direct candidates. CEikAppUi is a base subobject, making C2/178 the semantically corresponding constructor variant. However, Step59's target-header audit proves that the S60 CCoeAppUi base grew by one 32-bit reserved field, shifting all CEikAppUi secondary vptrs and data members by four bytes. Therefore C2/178 is **not a safe direct replacement** for EIKCORE 224; it can only be used behind an old-layout compatibility wrapper.

## Target E32/OpenC runtime imports

The seven strong undefined symbols from the Step57 combined ARM object are present in the target SDK import libraries:

| Symbol | Target import library | Target ordinal |
|---|---|---:|
| `__stderr` | ESTLIB | 18 |
| `exit` | ESTLIB | 130 |
| `fprintf` | ESTLIB | 141 |
| `strcmp` | ESTLIB | 247 |
| `strncmp` | ESTLIB | 257 |
| `memmove` | EUSER | 1954 |
| `memset` | EUSER | 1955 |

Member-level inspection confirmed the symbols in `estlib.lib` and `euser.lib`; the target DSO tables confirmed the ordinals. Thus these seven are no longer unknown API dependencies for the target SDK. The three weak `ngage_runtime_*` instrumentation hooks remain optional and are not strong link blockers.

## Reproducible evidence

- Target export source: S60 3.1 FP1 SDK ARMv5 DSOs under `Epoc32/release/armv5/lib`.
- DSO export audit artifact: run `42484991957`, artifact `s60-fp1-vs-eka2-import-audit`, SHA-256 `b5a77708a5d5d9e137ae567ef94065e01ed1582317ebb65d2eb44d5d92c93ce5`.
- Runtime import-library probe: run `42499019718`, artifact `s60-3.1-fp1-runtime-import-probe`, SHA-256 `b03cb33fcce004933ef4c63eb020e28cdd3e71bb356459761278d2d6de056ee2`.
- Target export probe with framework-header capture: run `42499468136`, artifact `s60-3.1-fp1-runtime-import-probe`, SHA-256 `1d88a4f11f027e0d1bb843856ff6bdfc4959b92703f0f7e2cb7fc74884fd90c2`. Its export ordinal table completed successfully; the first attempt at header inventory failed due a `find` expression and was corrected afterward.
- Reproducible script: `tools/step58_s60_target_export_map.py`.
- Workflow: `.github/workflows/s60-runtime-import-probe.yml`.

The script validates the seven remap/collision rows and the seven runtime imports against the actual SDK DSOs. A later workflow run is being used to validate the script directly and capture the S60 `CEikAppUi` inheritance declaration.

## Immediate consequences

1. Any direct patch of the game's import table must remap the old ordinals to the target exports; leaving the original ordinal values unchanged is unsafe.
2. EUSER 1575 needs a local implementation or a carefully verified callsite patch. Do not redirect it to the target EUSER ordinal 1575.
3. EIKCORE 224 must not be dispatched as target EIKCORE 224. Target EIKCORE 224 is a different API. Directly remapping it to target CEikAppUi C2/178 is also unsafe because the target class layout is shifted by four bytes; see [Step59](STEP59_CEIKAPPUI_TARGET_LAYOUT_BREAK.md).
4. A compatibility DLL preserving the old import UID/ordinal surface remains a possible strategy, but it must provide correct ABI-compatible wrappers and preserve Symbian leave/cleanup behavior.
5. No import table or DLL binary has been patched in this step.

## Validation boundaries

- The DSO files are from the pinned S60 3.1 FP1 SDK, not a dump from the user's physical N95 RM-320 firmware. The actual ROM export tables still require confirmation when the device is available.
- The S60 target DSO is ARMv5 EABI4. The Step57 recovered object set is ARMv6 EABI5. Compatibility of the final link and resulting E32 image with Symbian OS 9.2 must be tested; successful compilation alone does not settle this.
- The CEikAppUi C2 mapping is a technically motivated candidate, not yet a completed EIKCORE 224 implementation. The target header layout and constructor behavior must be inspected before patching.
- No physical-device launch is claimed.
