# Step101 — target TInt64 type and isolated E32 DLL conversion

Date: 2026-11-11

## Verified target compiler evidence

The pinned S60 3.1 FP1 GCCE toolchain was used against the target headers:

- Step95 scanned 1,720 target SDK headers. It found no `class TInt64` / `struct TInt64` declaration; the target compiler treats `TInt64` as a primitive signed 64-bit type.
- Step96 compiled successfully with `sizeof(TInt64) == 8`, `sizeof(TTrap) == 76`, and offsets `iState/iNext/iResult/iHandler = 0/64/68/72`. It also confirmed the target signatures for `TTrap::Trap(TInt&)` and static `TTrap::UnTrap()`. This is compile-time ABI evidence, not a runtime leave/trap test.
- Step100 compiled successfully and its type-trait assertions confirmed that target `TInt64` is an 8-byte signed non-class type. The compiler emitted native comparison, equality, subtraction, division, construction and conversion-to-`TInt` code.

## Why N-Gage EUSER ordinal 1575 has no direct N95 export

The N-Gage 6.1 SDK defines `TInt64` as a class containing two 32-bit words (`iLow`, then `iHigh`) and declares the imported member `TInt64::operator!=(const TInt64&) const`. The original ARM UREL import table therefore names the legacy member at EUSER ordinal 1575.

The S60 3.1 FP1 target compiler instead treats `TInt64` as a primitive signed 64-bit type. Its operators are compiled as language-level operations, not as the same imported member symbol. This explains why the target EUSER DSO has no named `TInt64::operator!=` export. The same-numbered target EUSER ordinal 1575 is a different API (`RSubSessionBase::DoSendReceive`) and must not be used as a substitute.

A compatibility shim remains a plausible call-boundary strategy: ARM passes the legacy member's `this` pointer in r0 and the other operand pointer in r1; a two-pointer C function can receive those registers and return the boolean/integer result in r0. The shim must compare both 32-bit words. This is still a candidate ABI bridge, not proof that every legacy call site can be safely redirected.

## Step99 — minimal E32 DLL conversion now passes

Firmware workflow run [43006595394](https://github.com/Shakalx3/Shadowkey/actions/runs/43006595394), commit `403af1de5e0863bb57a0684391aac57cb439f6bf`, successfully compiled the isolated shim and converted it with `elf2e32` into an E32 DLL.

The generated test file passed the workflow's structural checks:

| Field | Value |
|---|---:|
| File size | 244 bytes |
| UID1 | `0x10000079` (DLL) |
| UID2 | `0x1000008D` |
| UID3 / SID | `0xE000BEEF` |
| Flags | `0x12000029` |
| Export count | 1 |
| Code size | 64 bytes |
| Entry point offset | `0x30` |
| Code base | `0x00010000` |
| Export directory offset | 216 |

The E32 dump identifies an ARMv5 DLL, ARM EABI, built against EKA2, uncompressed, with one export and no imported DLL references. The exact workflow result states: “minimal E32 DLL container created and has exactly one export.”

This supersedes the earlier duplicate-`_E32Dll` and converter-acquisition failures. Those were build-pipeline issues and were corrected; they are no longer the current Step99 blocker.

## Artifact-upload failure is separate from the build

Run 43006595394 completed all extraction, ABI, Step99 DLL-conversion, EKA2 host-build, ROM-export mapping and module-inventory steps successfully. The overall job was marked failed only when GitHub rejected the final diagnostic artifact upload because the Actions artifact storage quota had been hit. The log explicitly reports:

`Failed to CreateArtifact: Artifact storage quota has been hit. Unable to upload any new artifacts. Usage is recalculated every 6-12 hours.`

The firmware workflow now generates a text-only Step102 audit into the GitHub Actions job summary and treats the artifact upload as best-effort, so storage exhaustion will not erase the human-readable extraction checkpoint or make a successful build look like a technical extraction failure.

## Current limits and next gate

- Step99 proves that the toolchain can emit a structurally valid E32 DLL container. It does **not** prove that Symbian's loader accepts this DLL.
- No `RLibrary::Load` / `Lookup(1)` runtime test has passed yet.
- The isolated DLL is not a production replacement for EUSER and has not been patched into `6R51.APP`.
- No ROM image or protected system DLL is modified or committed.
- Next: run a minimal EKA2 executable that loads this DLL through `RLibrary`, resolves ordinal 1, calls the shim with controlled 64-bit values, and verifies the result. Only after that should a reversible game import patch be considered.
- No physical Nokia N95 test has been performed; host-harness and static E32 checks are not device-compatibility evidence.
