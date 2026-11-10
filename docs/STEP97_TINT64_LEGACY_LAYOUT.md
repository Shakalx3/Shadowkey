# Step97 — legacy TInt64 layout and unresolved import

Date: 2026-11-10

## New primary-source evidence

The N-Gage 6.1 SDK header at `6.1/Series60/Epoc32/Include/e32std.h` declares `class TInt64` with protected fields `TUint iLow; TUint iHigh;` and the imported member `IMPORT_C TInt operator!=(const TInt64& aVal) const;` (header lines 476–521). This directly corroborates the ARM UREL import identity `TInt64::operator!=(TInt64 const&) const` found at legacy EUSER ordinal 1575.

The class layout is therefore two 32-bit words, low word first then high word, in the N-Gage SDK declaration. Step96 independently confirms that the target GCCE compiler treats `TInt64` as 8 bytes, but does not prove the target's class member layout or binary equivalence.

## ABI shape

- C++ member function: `TInt TInt64::operator!=(const TInt64&) const`.
- ARM member-call convention: `r0` carries `this`; `r1` carries the address of the second TInt64; integer/boolean result is returned in `r0`.
- The observed Shadowkey call at `0x1002290C` prepares `r0` and `r1`, branches through the EUSER!1575 thunk, then compares `r0` with zero.
- In the N-Gage SDK header, `iLow` precedes `iHigh`; any local compatibility implementation must compare both 32-bit words and return nonzero iff either differs.

## Important boundary

This is strong evidence for the legacy operand representation and operation semantics. It is not yet proof that a direct C++ shim is safe for the target build: inspect the target SDK's `TInt64` definition, confirm the object layout used by the game, and test a compiled ARM shim before changing the E32 import table. Do not patch EUSER!1575 to an arbitrary ROM ordinal.

## TTrap remains separate

Step96 confirms target GCCE compile-time size/offset/signature checks for `TTrap`. The target SDK's `TTrap::Trap` and `TTrap::UnTrap` are imported symbols in the probe object (`_ZN5TTrap4TrapERi` and `_ZN5TTrap6UnTrapEv`). This still does not prove their runtime behavior. Do not replace them with a no-op or treat the host-harness path as leave/trap compatibility.

## Next checks

1. Inspect the N-Gage ARM UREL EUSER import library to confirm ordinal 1575's symbol/ABI metadata.
2. Inspect the target SDK's exact `TInt64` declaration and whether its operators are built-in, inline, or imported.
3. Build an isolated ARM test object implementing only the two-word inequality operation, then inspect generated instructions and calling convention.
4. Only after those checks, evaluate a reversible import-thunk patch in a copy of the game executable.

No firmware or system DLL binaries are added to the repository. No real-device launch is claimed.