# Step 52 — real EKA2 ARMv6 E32 toolchain validated

Date: 2026-11-08

## Result

The strongest current toolchain candidate, `hpnkv/symbian-platform v0.3.0`, has now been executed in GitHub Actions on Ubuntu 24.04 and its native EKA2 build path has passed a real control build.

Release asset:
- `symbian-sdk-0.3.0-linux-x86_64.tar.gz`
- Size: 325,624,796 bytes
- SHA-256: `9be830884a5fd1b9315ea1c11571810f7a50fa673851fa392bb397c6759fec3d`
- Source: https://github.com/hpnkv/symbian-platform/releases/tag/v0.3.0

Validation workflow:
- Successful run: https://github.com/Shakalx3/Shadowkey/actions/runs/42484330178
- Artifact: `symbian-platform-0.3.0-armv6-eka2-proof`
- Artifact ID: `13618314366`
- Artifact contains the linked ARM ELF, generated E32 image, full native inspection JSON and summary.

## Verified build facts

The SDK's own `examples/hello_time` GUI application was configured and built using its shipped Clang/LLD/CMake/Ninja and E32 converter.

- Compiler target: `armv6-none-eabi`
- ISA: ARMv6 (the SDK default for this build)
- Converter invocation includes `--kernel eka2`
- Generated ELF: ELF32 ARM EABI5, executable, entry address `0x8000`
- Generated E32: 790,240 bytes; E32 header begins with UID1 `0x1000007A`, UID3 `0xE0000830`, and `EPOC` signature.
- Native E32 inspector assertions passed:
  - kernel: `eka2`
  - architecture: `armv6`
  - UID3: `0xE0000830`
  - code base: `0x8000`
  - code size: 776,008 bytes
  - entry offset: `0` (valid for this SDK startup layout; not a missing entry-point test)
  - capabilities: `0`
  - imported DLL blocks: 7
  - imported slots: 170
  - exported functions: none (application EXE)

The seven import DLL names in this control image are:
`drtaeabi.dll`, `euser.dll`, `gdi.dll`, `libc.dll`, `libm.dll`, `libpthread.dll`, `ws32.dll`.

The SDK's E32 inspector decoded the generated image and import table. This is stronger than checking the EPOC magic bytes alone.

## What this proves — and what it does not

Proven:
1. A working EKA2/ARMv6 compiler + linker + E32 conversion pipeline is available.
2. The pipeline runs reproducibly in a clean Linux CI environment.
3. A control GUI application can be emitted as a structurally inspectable EKA2 E32 executable.
4. We no longer need to solve ELF-to-E32 conversion from scratch.

Not proven:
- The control image has not been run in EKA2L1 or on the physical Nokia N95 RM-320.
- Its seven import DLLs and ordinals have not yet been reconciled against the exact S60 3.1 FP1 / N95 firmware exports.
- The existing Shadowkey ARM objects have not yet been linked into an EKA2 process.
- No real native FBS, GDI, CONE, AVKON, audio, input or filesystem compatibility implementation has been completed.
- The output is not a Shadowkey binary and is not ready to copy to the phone.

## Earlier official S60 SDK tool probe

The Nokia S60 3.1 FP1 SDK's own Windows executables were also launched successfully on a Windows Server 2025 runner:
- `elf2e32.exe`: Symbian Post Linker V2.0; usage and complete option list captured.
- `makesis.exe`: version 4.0.0.5.
- `petran.exe`: PE preprocessor V02.01 (Build 564).

The Windows probe workflow exited nonzero because the diagnostic script deliberately passed invalid help flags to these legacy command-line tools; the tools themselves launched and printed their usage. No conversion attempt against the project's Linux/System-V ELF was made. The modern EKA2 SDK above is the selected route for the next build.

## Next gates

1. Compare the modern SDK's `euser/gdi/ws32` import proxies against the Nokia S60 3.1 FP1 ARMv5 `.dso` exports. Confirm exact DLL names, frozen ordinals and symbols; do not assume that an import proxy is firmware-compatible merely because the DLL name matches.
2. Build the recovered Shadowkey C sources with the validated ARMv6 toolchain, first as object files and then as a minimal EKA2 bootstrap image.
3. Replace the current synthetic HLE/diagnostic graphics and framework objects with EKA2-native implementations, preserving the verified call-site behavior.
4. Check the resulting E32 header/imports against N95 RM-320 firmware and then test loader acceptance on the actual device or a matching emulator.

The intended deliverable remains a modified executable and/or compatibility DLLs, not a SIS installer.
