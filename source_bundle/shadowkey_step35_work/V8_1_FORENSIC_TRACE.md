# Shadowkey v8.1 forensic trace — CONE ordinal 226

Date: 2026-10-31

## Reproduction

Commands run from the extracted project root:

- `./build_and_test.sh` — PASS. The AppUi smoke test reports the factory/document/AppUi/engine back-pointer/allocation-failure/IAT dispatch checks passing.
- `./trace_asset_loader_vfs.sh` — deterministic diagnostic stop, exit code 90.

## Verified resource path

The diagnostic run opens the original `StringTable.eng` (338,078 bytes) and `global.spr` (1,646,707 bytes). It seeks to `global.spr` offset `0x163B1F`, reads `0x9444` (37,956) bytes, and reaches the image-decoder entry with the resource header `B0 00 D0 00` (176 × 208).

The VFS log also confirms one malformed/empty path attempt between valid `global.spr` opens. It is not the immediate stop in this run.

## Exact failing import

Dynamic trace:

`CONE[10003a41].DLL ordinal 226`

- Import thunk: `0x1009F540`
- Caller: `sub_10022898`
- BL instruction: `0x100228A4`
- Return address / LR: `0x100228A8`
- Immediate failing dereference: `0x100228AC` (`ldr r4, [r9]`)
- Input `r0`: `0x101102C8`
- Other live args at import: `r1=0xAF`, `r2=0`, `r3=0xD0`
- HLE currently logs the import as unimplemented and leaves `r0=0`; the next instruction then dereferences address zero.

This confirms the immediate cause: the current HLE default response is null. It does **not** establish that the real Symbian function itself returns null.

## Caller contract inferred from recovered ARM

At `0x100228A0`, the caller saves its input object in `r8`. It invokes ordinal 226 with that object in `r0`, saves the return value in `r9`, and immediately loads `[r9]` as a vtable pointer. It then calls a virtual slot at vtable offset `0xD8`.

Therefore the call-site contract is at least:

- one object pointer passed in `r0`;
- a pointer to a valid polymorphic object expected back in `r0`;
- returned object must have a readable vtable and a callable slot at `+0xD8`.

This is a strong structural constraint, but it is not enough to name the exported C++ method or safely synthesize the object.

## Important distinction

The import-callsite database contains another use of the same ordinal at `0x10028294`, with a different caller and argument state. The observed failing execution is the call at `0x100228A4`. Any implementation must account for all call sites, not only the first static hit.

## Why no fake object was added

Returning a fabricated pointer or vtable could make the trace pass the null dereference while causing invalid virtual dispatch, corrupting the app's UI state, or masking the wrong ABI. No ordinal-to-symbol mapping for the exact target CONE build has yet been verified. Public Symbian references confirm that ordinal numbers are binary-version-specific; mappings from a different device/OS build cannot be assumed to match the N95 target.

## Next required evidence

1. Obtain the exact S60 3rd Edition FP1 / Symbian OS 9.2 `CONE` export map (matching the target import library/ROM build), or extract the corresponding export directory from an N95 firmware ROM.
2. Resolve ordinal 226 to its mangled symbol and signature.
3. Resolve the other ordinal-226 call site and ordinal 160/55 interactions to establish ownership/lifetime and expected object class.
4. Implement a real HLE equivalent or move the UI framework execution to a compatible Symbian runtime; do not use a guessed vtable.

## Current milestone

The project reproducibly loads a real game image resource and reaches the decoder's platform-framework dependency. It is still a diagnostic static-recompilation harness, not a playable build or an N95 E32Image.
