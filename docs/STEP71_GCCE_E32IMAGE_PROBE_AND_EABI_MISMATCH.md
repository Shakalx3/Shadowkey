# Step 71 — GCCE/elf2e32 minimal E32Image probe

Date: 2026-11-09

## 1. What was successfully generated

A Windows GitHub Actions job used:
- pinned S60 3.1 FP1 devkit;
- GCCE4Symbian Windows toolchain, GCC 14.2.0;
- the target SDK's `elf2e32.exe`.

Probe source:
`int E32Main(void) { return 0; }`

Confirmed:
- GCCE compile exit: 0;
- ARM ELF link exit: 0;
- elf2e32 conversion exit: 0;
- E32 output exists;
- E32 size: 196 bytes;
- E32 SHA-256: `87bb29e8f55a4f89291b4bf7e10874fb44b5d1fcdf1f8f36ab5b2bfa82762900`.

The first 20 bytes decode as:
- UID1: `0x1000007A` (EXE);
- UID2: `0x20000001`;
- UID3: `0x20000001`;
- UID checksum follows;
- signature bytes: `45 50 4F 43` = `EPOC`.

This confirms that the target SDK's converter generated an E32Image container from the compiler's ELF input.

## 2. Critical limitation: default compiler output is EABI5

The GCCE 14.2 compiler's default output is not yet suitable evidence for the N95 target:

ELF header:
- ELF32, little-endian, ARM;
- CPU attributes: ARMv5TE;
- float ABI: soft;
- `e_flags = 0x05000200`;
- ABI: **Version 5 EABI**.

The target S60 3.1 FP1 SDK import libraries used elsewhere in this project are identified as EABI4. elf2e32 accepting the EABI5 input does not prove that Symbian OS 9.2's loader will accept the result. This EABI mismatch is now an explicit blocker.

## 3. Follow-up EABI4 probe

A follow-up probe is being added with GCC's `-meabi=4` option. It will record:
- whether GCCE 14.2 accepts `-meabi=4`;
- the resulting ELF header flags;
- whether the ELF links;
- whether elf2e32 converts the result;
- target `cone.dso` and `euser.dso` ELF header flags for direct comparison.

If GCCE cannot emit EABI4, the next route is an older Symbian GCCE toolchain or a different compiler configuration. Do not patch the EABI version bits in an EABI5 ELF and call that an EABI4 build.

## 4. Reproducibility

- Tool: `tools/step71_windows_e32_toolchain_probe.ps1`.
- Workflow: `.github/workflows/symbian-e32-toolchain-probe.yml`.
- First successful conversion run: `42572164977`.
- First-pass artifact: `symbian-e32-toolchain-probe`, ID `13654100756` (large because it included the extracted SDK/toolchain).
- Compact probe run: `42573136500`, completed successfully.
- Compact artifact: `symbian-e32-toolchain-probe`, ID `13653933310`.
- Compact artifact SHA-256: `843baf770b40972c2c7d8f3fbb1c8b2c1f9c5b26cbe4d43b7f1f4a8e3d0d1a`.
- GCCE toolchain ZIP SHA-256: `e5a387eda154777a4d1203d6275bb09b90aebb9baf492ed9f4d252526ec86433`.
- Pinned SDK SHA-256: `7ed8b62b15f191ca47d2f6ca97ee5ce74cd02ce3e42b74bc7b1f9513d7df87b5`.

No Shadowkey binary was built. No N95 launch is claimed.
