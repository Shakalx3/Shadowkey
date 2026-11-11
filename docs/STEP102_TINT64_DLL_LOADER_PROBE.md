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

elf2e32 --dump=hi identified an ARMV5 DLL, ARM EABI, built against EKA2, uncompressed, with no imported DLL references. The DLL entry point is _E32Dll; the one intended export is Step98TInt64NotEqual at ordinal 1.

Run 43010636058 added a raw export-table check and exposed an important format detail: the single export-table word is 0x00010000, equal to the linked code base 0x00010000. It is a linked virtual address in this image, not a zero-based offset. The converter had already produced the same 244-byte E32 DLL; run104 failed only because the new assertion incorrectly expected zero. The parser now checks that the export VA lies inside the code segment and resolves to the first code byte. Run105 is verifying this corrected interpretation.

This remains an E32 container/build proof. The DLL has not yet been passed to RLibrary::Load on Symbian, and no device execution is claimed.

## Step102: target EKA2 loader probe build

The loader probe source is `source_bundle/host/step102_tint64_loader_probe.cpp`; the build is driven by `tools/step102_build_loader_probe.sh`. It compiles a target EKA2 EXE against the pinned S60 3.1 FP1 EUSER DSO and checks the actual EABI imports.

Run **43013640871** first exposed a diagnostics bug: host `readelf -s` truncated long mangled names (for example `_ZN8RLib[...]`), so the demangler could not recognize `RLibrary::Load`. The next commit switched target EABI names to GNU `c++filt`; run **43014127693** then passed after `readelf --wide -s` preserved the complete names. The final demangled imports include:

- `RLibrary::Load(TDesC16 const&, TDesC16 const&)`
- `RLibrary::Lookup(int) const`
- `RLibrary::Close()`
- `User::InfoPrint(TDesC16 const&)`
- `User::After(TTimeIntervalMicroSeconds32)`

The target EUSER DSO check also passed: no `TInt64::operator!=` or `TTrap::Trap/UnTrap` legacy member export is present.

Observed Step102 test EXE header in run 43014127693:

| Field | Value |
|---|---:|
| File size | 667 bytes |
| UID1 | 0x1000007A (EXE) |
| UID2 | 0x100039CE |
| UID3 / SID | 0xE000BEF0 |
| Flags | 0x12000028 |
| Code size | 708 bytes |
| Entry-point offset / VA | 0x20 / 0x00010020 |
| DLL reference count | 1 (EUSER) |
| Export count | 0 |

The EXE's source loads `ShadowkeyCompat.dll`, looks up ordinal 1, and checks equal, low-word-different and high-word-different operands. This is compile/link/E32-structure evidence only. It has not been executed by an EKA2 loader on an emulator or a physical N95.

## Step102 first-device probe package

Run **43014127693** built and published the prerelease asset:

- [Shadowkey Step102 first-device loader probe](https://github.com/Shakalx3/Shadowkey/releases/tag/shadowkey-step102-43014127693)
- Asset: `Shadowkey-Step102-FirstDeviceTest.zip`
- Size: 2,675 bytes
- SHA-256: `a976772f3a402e05c6fce4b6bbd68a41db6f5fdd06d56ffed97b69fb7f1f8b64`

The ZIP contains only the custom test DLL, the test EXE, a README and SHA-256 sums. It contains no game binary, ROM image, firmware or system DLL. The Actions artifact upload was rejected because the repository's Actions storage quota was full; the separate GitHub prerelease asset upload succeeded and its release metadata reports the exact asset digest above.

The EXE is a bare `E32Main` test harness, not a registered S60 menu application. It requires an existing trusted launcher that can start a raw E32 EXE. No automatic menu icon or SIS installer is included. If no such launcher is already available, the next packaging task is a registered S60 shell rather than asking the user to try an unverified launch route.

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
- Step99 minimal EKA2 E32 DLL conversion: PASS.
- Step102 EKA2 loader-probe EXE build and E32 validation: PASS in run 43014127693.
- Step102 prerelease ZIP: published and SHA-256 verified in the workflow log.
- Symbian loader acceptance: not tested.
- Physical RM-320 test: not performed.
- Shadowkey game launch: not achieved.

The package README requires an already-authorized way to write the two unique test binaries to a writable drive's `\\sys\\bin`. It also requires an existing launcher capable of starting the bare E32 EXE. Before any live device instructions, reconfirm the handset's `*#0000#` firmware string and the available cable / memory-card transfer method. If access to `\\sys\\bin` is denied, stop; do not bypass controls, overwrite ROM, or flash firmware.
