# Shadowkey recompilation progress — 2026-10-29

## Significant result

The static-lifting pipeline has been corrected far enough to execute the original app's factory/AppUi construction and enter the engine's resource-loading path in the diagnostic harness.

### Fixes made

1. **ARM jump-table lifting:** `LDR{cond} PC, [PC, Rm, LSL #2]` was incorrectly parsed as a PC-relative literal load because the parser picked up `#2` from `LSL #2`. That produced an unaligned bogus constant and an early C `return`, leaving guest stack/register state corrupted. The generator now computes the effective table address (`PC+8 + Rm*4`) and dispatches only to the table's recovered target labels, keeping generated C switches compact.
2. **Full basic-block instruction emission:** some recovered SIMKIN function maps listed block starts but not every instruction in the block. The old emitter treated a non-listed next instruction as a separate function call. The generator now walks fall-through paths through each block, adds all instruction addresses, and stops at control-flow terminators.
3. **SIMKIN import routing:** calls originating inside lifted SIMKIN code use `simkin_call`, not the main app dispatcher. The ARM fallback also recognizes SIMKIN import thunks/slots.
4. **ARM fallback:** an experimental ARM/Thumb interpreter handles code addresses missing from the static function map.

### Verified

`shadowkey_appui_construct_test` passes with the regenerated app and SIMKIN code. It verifies:
- `NewApplication` object construction;
- document and AppUi vtable dispatch;
- AppUi construction and engine object creation;
- the engine-to-AppUi back-pointer;
- the allocation-failure path;
- import-slot dispatch.

The clean-bundle build script was run successfully: the regenerated C sources compiled and `shadowkey_appui_construct_test` printed `PASS`. The diagnostic trace no longer fails immediately in SIMKIN's switch/copy/array paths. It reaches resource opens for:

- `z:\system\apps\6R51\StringTable.eng`
- `e:\system\apps\6R51\global.spr`

### Current blocker

The diagnostic harness does not mount the original game's resource files. Its `RFile::Open` HLE deliberately returns `KErrNotFound`; after the missing-file path, the app still enters an incompletely implemented error/cleanup path and hits a null read (`OOB 0x00000000/4`). This is the next engineering task: implement the relevant EFSRV/EUSER file and error paths and provide a virtual filesystem backed by the extracted assets.

### What this does *not* mean

No playable desktop build has been produced, and no Symbian 9.2/N95 SIS exists yet. The passing smoke test validates early object construction, not gameplay. Several imported ordinal shims are provisional and must be checked against the EKA1 ABI before they can be trusted as a general runtime.

## 2026-11-03 — v8.4 step 11

See `V8_4_STEP11_EIKCORE243_AND_DECODER_BREAKTHROUGH.md`.

Milestone: EIKCORE ordinal 243 is call-site-identified as a CFont-pointer provider (exact export name unresolved); BITGDI 86/23 are modelled as the bitmap-device/context construction sequence; `global.spr` now decodes into a persistent non-zero RGB444 (12-bit values in 16-bit storage) buffer; the active StringTable conversion object receives a real `source+0x14A3C` heap pointer (`0x1018AFD8`). Current frontier is a stack-region callback/return target (`0x102FDC68`) after later CONE/UI handling.
