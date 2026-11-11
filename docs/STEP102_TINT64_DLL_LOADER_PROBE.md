# Step102 — target TInt64/TTrap ABI and isolated EKA2 DLL loader probe

Date: 2026-11-11

## Step96/Step100: target ABI conclusion

The firmware workflow run **43006595394** at commit 403af1de5e0863bb57a0684391aac57cb439f6bf reached and passed the target GCCE probes:

- The focused S60 3.1 FP1 header scan covered 1,720 SDK headers. It found no class TInt64 or struct TInt64.
- Step96 compiled against the pinned target headers. sizeof(TInt64) == 8; sizeof(TTrap) == 76; TTrap offsets are iState=0, iNext=64, iResult=68, iHandler=72.
- GCCE resolves TTrap::Trap(TInt&) as an instance method and TTrap::UnTrap() as static. The probe object contains undefined references _ZN5TTrap4TrapERi and _ZN5TTrap6UnTrapEv; this is not a runtime trap test. The EKA2 host source therefore avoids the SDK TRAP macro until its private helper dependency is separately handled.
- Step100's type traits prove the target TInt64 is a signed, 8-byte non-class type. The ARMv5TE disassembly for inequality loads the low word at [r0] / [r1], then the high word at [r0,#4] / [r1,#4], and returns the boolean in r0. Equality uses the same two-word comparison; subtraction uses SUBS/SBC.
- The target compiler emits __aeabi_ldivmod for 64-bit division. Do not assume every 64-bit operation is helper-free; the inequality shim itself has no such dependency.

The target e32def.h explicitly documents the compatibility break: from Symbian OS 8.1b onward, TInt64 became a built-in type instead of the old class, and the old class member functions ceased to be exported from EUSER.LIB. This explains the missing target signature for the N-Gage ARM UREL import EUSER!1575 (TInt64::operator!=(TInt64 const&) const). The N95's same-numbered EUSER ordinal 1575 is a different API (RSubSessionBase::DoSendReceive); it must not be substituted.

The call-site evidence remains consistent with a local shim: the old member call passes this and the other operand in r0/r1, with the boolean result consumed from r0. The N-Gage 6.1 class stores iLow then iHigh; the target GCCE-generated primitive comparison reads the same two 32-bit words at offsets 0 and 4. This makes the two-pointer comparison a strong ABI candidate, not yet a loader- or game-runtime-proven patch.

## Step99: E32 DLL conversion result

In run 43006595394, Step99 did build the isolated test DLL. The run was marked failed only because the final Actions artifact upload hit the repository's storage quota; the compile, link, ELF export discovery, and elf2e32 conversion steps had already succeeded.

Observed E32 header:

| Field | Value |
|---|---:|
| File size | 244 bytes |
| UID1 | 0x10000079 (DLL) |
| UID2 | 0x1000008D (shared-library UID) |
| UID3 / SID | 0xE000BEEF |
| Flags | 0x12000029 |
| Export count | 1 |
| DLL reference count | 0 |
| Code size | 64 bytes |
| Entry-point offset | 0x30 |
| Code base | 0x00010000 |

elf2e32 --dump=hi identified an ARMV5 DLL, ARM EABI, built against EKA2, uncompressed, with no imported DLL references. The DLL entry point is _E32Dll; the one intended export is Step98TInt64NotEqual at ordinal 1. The previous workflow did not yet assert the raw export-table address, so the next build adds that check rather than treating the count alone as sufficient.

This is only an E32 container/build proof. The DLL has not yet been passed to RLibrary::Load on Symbian, and no device execution is claimed.

## Step102: loader test being added

source_bundle/host/step102_tint64_loader_probe.cpp and tools/step102_build_loader_probe.sh build a tiny EKA2 EXE linked to the target EUSER DSO. At runtime it:

1. calls RLibrary::Load("ShadowkeyCompat.dll");
2. resolves ordinal 1 with RLibrary::Lookup(1);
3. calls the export with equal operands, a low-word difference, and a high-word difference;
4. displays SK DLL PASS only if all three checks succeed.

The test EXE does not use the target TRAP macro and does not import the legacy TInt64 member operator. It is deliberately separate from 6R51.APP and contains no game code.

## Device safety boundary

Symbian OS 9+ requires executable binaries to be under \sys\bin; the loader refuses binaries from ordinary folders. Access to \sys is restricted. The package README therefore requires an already-authorized way to place the two uniquely named test binaries in a writable drive's \sys\bin. If access is denied, stop; do not bypass controls, overwrite ROM, or flash firmware.

The first-device package is intended to contain only:
- ShadowkeyCompat.dll — the custom 244-byte test DLL;
- ShadowkeyAbiProbe.exe — the EKA2 loader test;
- a README and SHA-256 checksums.

Rollback is deletion of those two files only. No system DLL or original game binary is replaced. Before any device step, reconfirm the handset's *#0000# firmware string and the available cable / memory-card transfer method.

## Current status

- Step96 target GCCE compile-time ABI checks: PASS.
- Step100 target primitive TInt64 code generation: PASS.
- Step98 host semantics and ARMv5TE comparison code generation: PASS.
- Step99 minimal EKA2 E32 DLL conversion: PASS; artifact upload failed due storage quota, not DLL build.
- Step102 EKA2 RLibrary loader test: added; CI result pending.
- Symbian loader acceptance: not tested.
- Physical RM-320 test: not performed.
- Shadowkey game launch: not achieved.
