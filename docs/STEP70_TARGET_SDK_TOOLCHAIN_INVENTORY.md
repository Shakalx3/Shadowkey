# Step 70 — target SDK build-tool inventory

Date: 2026-11-09

## 1. What the pinned S60 3.1 FP1 devkit actually contains

The pinned devkit was inspected in the Linux runtime workflow.

- SDK headers: 689 files.
- Target ARMv5 import libraries: 1,060 files.
- Files under Epoc32/tools: 1.
- The one relevant executable is `elf2e32.exe`, a 32-bit Windows PE executable.
- No ARM compiler or native Linux elf2e32 executable is included in the devkit.

The Linux GitHub runner had Clang 21 but no Wine and no Symbian ARM GCC. Clang's `armv5-none-symbianelf` target spelling was rejected. Its generic `arm-none-eabi` ARMv5TE probe produced EABI5, not the target SDK's EABI4 import-library environment. That generic output is not accepted as a substitute for a Symbian-target compiler.

## 2. Toolchain alternatives identified

Two public GCCE/Symbian toolchain projects were inspected:

- `fedor4ever/GCC4Symbian` builds a Linux-hosted `arm-none-symbianelf` toolchain from GCC 12.1/binutils 2.35. Its README notes that it is not compatible with the classic `abld` build system and reports testing against S60 5th Edition; it is a candidate for manual compilation, not yet validated for FP1.
- `GCCE4Symbian` distributes a Windows `arm-none-symbianelf` GCC toolchain. Its published compatibility list explicitly mentions S60 3rd FP2 and later, but does not explicitly list FP1. A minimal compile/conversion probe was therefore required before relying on it.

The SDK's Windows `elf2e32.exe` can be invoked natively from a Windows runner, so Wine is not required for the initial proof.

## 3. Result and remaining qualification

The first Windows probe using the prebuilt GCCE4Symbian 14.2 toolchain completed:
- GCCE compile exit code 0;
- ARM ELF link exit code 0;
- SDK elf2e32 conversion exit code 0;
- output E32 file created.

That proves the pinned target SDK's elf2e32 can consume at least one ELF produced by this toolchain and generate an E32 output. It does not yet prove that the output's EABI flags, header, imports, capabilities, startup sequence or loader behavior are suitable for the N95. Step71 performs a compact-artifact rerun and explicitly dumps the generated E32 header.

## 4. Reproducibility

- Tool: `tools/step70_e32_toolchain_inventory.py`.
- Toolchain probe: `tools/step71_windows_e32_toolchain_probe.ps1`.
- Linux SDK inventory run: `42571778531`, completed successfully.
- Linux inventory artifact: `step70-clang-wine-probe`, ID `13653348510`.
- Windows first-pass E32 probe run: `42572164977`, completed successfully.
- First-pass artifact ID: `13654100756` (large because it also contained the extracted SDK and compiler; the follow-up script now stores only reports and probe outputs).

No Shadowkey binary was built in this step. No N95 device launch is claimed.
