# Step 37 — EKA2 toolchain target-compatibility audit

Date: 2026-11-07

## Scope

This checkpoint audits the strongest candidate discovered in step 36, `hpnkv/symbian-platform` v0.3.0, against the actual target: Nokia N95 8GB RM-320, Symbian OS 9.2 / S60 3rd Edition FP1, ARM11/ARMv6. It also reruns the archive's two ARM ELF link checks from a clean file-permission state.

## Candidate toolchain: confirmed capabilities

The upstream project currently documents:

- ARMv5T and ARMv6 application builds for EKA2.
- Clang/LLD, native ELF-to-E32 conversion, frozen-ordinal import proxies, and EXE/DLL output.
- An application startup/runtime which calls ordinary `main()`.
- Native SDK distributions containing ARMv5T/ARMv6 EKA2 libraries, LLVM, resource tools, CMake and Ninja.
- Original OS firmware DLL implementations are not redistributed; import libraries do not replace those DLLs.

Sources:
- https://github.com/hpnkv/symbian-platform
- https://github.com/hpnkv/symbian-platform/blob/main/RELEASE_NOTES_0.3.0.md
- https://github.com/hpnkv/symbian-platform/blob/main/doc/docs/guides/native-distributions.md
- https://github.com/hpnkv/symbian-platform/blob/main/doc/docs/reference/sdk.md

## Target compatibility: not established

The SDK's documented executable matrix covers E71/RM-346 and 6120c/RM-243 (ARMv5T), C7/RM-675 and E6/RM-609 (ARMv6), and Nokia 808/RM-807 (ARMv6 with an exact ROM/EUSER executive profile). It does **not** list N95/RM-320 or S60 3rd FP1. Its native facilities inventory explicitly marks the availability of platform libraries such as FBSCLI, CONE, EIKCORE and ETEXT as `unknown_firmware`. AVKON is additionally marked selection-blocked in that inventory because its generated resource inputs are not currently reproducibly supplied.

The SDK itself states that firmware compatibility is determined by the target firmware's DLL exports and services, and that unknown firmware must be checked against its actual exports. Its import-proxy source definitions are not proof that an older N95 ROM implements the same ordinal map or all required entry points.

Therefore:
- The SDK is a credible EKA2/ARMv6 image-generation candidate.
- It is not yet a verified N95 RM-320 toolchain profile.
- Do not link Shadowkey against its default OS import set and assume the result will load on N95.
- Before a device-target build, compare every required import against the exact RM-320 firmware's DLL export tables, beginning with EUSER, EFSRV, CONE, FBSCLI, GDI, WS32, EIKCORE, AVKON and the required multimedia/audio services.

The firmware matrix and compatibility caveats are documented at:
https://github.com/hpnkv/symbian-platform/blob/main/doc/docs/capabilities/firmware.md

## Host environment fit and download gate

This execution environment reports:
- x86_64 host.
- Python 3.13.5 (within the toolchain's documented Python 3.11–3.14 range).
- glibc 2.41 (meets the native Linux SDK archive's glibc >= 2.39 requirement).

The native Linux SDK archive was not downloaded. Direct host DNS resolution for github.com failed in the build container, so the archive could not be fetched and validated here. The upstream guide names the Linux x86_64 distribution as `symbian-sdk-0.3.0-linux-x86_64.tar.gz`. This remains the next external dependency, not a verified installed toolchain.

## Archive build-script portability fix

Two scripts invoked `./build_arm11_core.sh`, relying on its executable bit. The supplied ZIP does not preserve that bit in this environment, so clean extraction can fail before compilation. Both callers were changed in the working extraction to invoke the script explicitly through `sh`:

- `build_arm11_linkcheck.sh`
- `build_arm11_symbian_base.sh`

Both scripts were then run with `build_arm11_core.sh` deliberately non-executable. Results:

| Check | Result | Interpretation |
|---|---|---|
| `sh build_arm11_linkcheck.sh` | PASS | Static ARM EABI ELF; no undefined symbols |
| `sh build_arm11_symbian_base.sh` | PASS | Static ARM EABI ELF linked at requested base; no undefined symbols |

The outputs are still ELF files, not E32 images. The `E32Main` symbol disassembles to `mov r0, #0; bx lr`: a deliberate no-op. The ELF entry is therefore not a usable Symbian process entry point. The script's own limitation message is accurate: a real Symbian startup/runtime and ELF-to-E32 conversion are still required.

This patch is a build-script portability correction only. It does not change game behavior or create a device-ready binary.

The archive's `shadowkey_step35_e32_patch_test.sh` and `build_and_test.sh` were also rerun during this checkpoint; both passed. The patch test still reports the original 6R51.APP additive-checksum discrepancy and explicitly leaves target-loader acceptance unverified. The host suite still emits unimplemented import diagnostics and uses synthetic FBS/GDI/CONE behavior in places; its PASS result remains a host-harness regression result only.

## Current conclusion

The toolchain route is now better specified but remains gated by two missing proofs:

1. Obtain and run the native SDK toolchain, then build and inspect a minimal EKA2 ARMv6 test executable.
2. Obtain exact N95 RM-320 OS 9.2 export tables (or a matching S60 3rd FP1 SDK/DEF set) and prove the selected imports and ABI against them.

Only after both gates pass should the recovered Shadowkey code be moved from the current no-op ELF link harness into a real EKA2 application target.
