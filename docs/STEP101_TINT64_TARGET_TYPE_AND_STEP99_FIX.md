# Step101 — target TInt64 type and Step99 DLL-link correction

Date: 2026-11-11

## Verified target compiler evidence

The latest firmware workflow run at commit `d42b801ee68ee94937340f1067b40cbe243ba70a` reached the target GCCE probes:

- Step95 scanned 1,720 S60 3.1 FP1 SDK headers. It found no `class TInt64` / `struct TInt64`, two typedef matches, and the internal `TTrap` declaration.
- Step96 compiled successfully against the pinned target headers with `sizeof(TInt64) == 8`, `sizeof(TTrap) == 76`, offsets `iState/iNext/iResult/iHandler = 0/64/68/72`, and the expected member/static function signatures for `TTrap::Trap(TInt&)` and `TTrap::UnTrap()`. This is compile-time ABI evidence only; it does not test leave/trap runtime behavior.
- Step100 compiled successfully with the target GCCE compiler. Its type-trait assertions passed: target `TInt64` is an 8-byte signed non-class type. Native comparison, equality, subtraction, division, construction and conversion-to-`TInt` code were emitted. The prior run did not preserve the focused header excerpt or disassembly in the job log, so the workflow now prints both and includes them in a small diagnostic artifact.

## Why EUSER ordinal 1575 has no matching N95 export

The N-Gage 6.1 SDK defines `TInt64` as a class containing two 32-bit words (`iLow`, then `iHigh`) and declares the imported member `TInt64::operator!=(const TInt64&) const`. The original ARM UREL import table therefore legitimately names the legacy member function at EUSER ordinal 1575.

The S60 3.1 FP1 target compiler instead treats `TInt64` as a primitive signed 64-bit type. Its operators are compiled as language-level operations, not as the same imported member symbol. This explains why the target EUSER DSO has no named `TInt64::operator!=` export. The same-numbered target EUSER ordinal 1575 is a different API (`RSubSessionBase::DoSendReceive`), so it must never be used as a substitute.

A compatibility shim is still plausible at the call boundary: ARM passes the legacy member's `this` pointer in r0 and the other operand pointer in r1; a two-pointer C function can receive those same registers and return the boolean/integer result in r0. The shim must compare both 32-bit words. This remains a candidate, not yet a loader-verified or game-runtime-tested patch.

## Step99 failure diagnosis

The latest Step99 attempt failed before invoking `elf2e32`. The linker reported a duplicate `_E32Dll` symbol: it was defined once in `step98_tint64_shim_probe.cpp` and again in `step99_e32_dll_marker.cpp`. This is a workflow/source composition error, not evidence that the E32 conversion tool rejected the DLL.

The marker has now been removed from the Step98 comparison probe; Step99 keeps the dedicated E32 DLL entry object. The workflow also prints the exact target header excerpt, Step96 symbols, Step98/Step100 ARM disassembly, and Step99 E32 header/dump into the job log. The artifact selection is narrowed to the relevant ABI reports and the generated test DLL, with shorter retention, to avoid repeatedly uploading the full firmware diagnostic directory.

## Current limits and next gate

- No E32 DLL was produced by the failed run.
- No Symbian loader test, import-table patch, or physical-device test has passed.
- No ROM DLL or firmware image is modified.
- Next: verify the new workflow gets past the duplicate-symbol link, inspect the actual ARM codegen/helper symbols and exact typedef lines, then validate the generated E32 DLL with a tiny EKA2 `RLibrary::Load` / `Lookup(1)` test before considering any reversible copy of `6R51.APP`.
