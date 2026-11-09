# Step 72 — original CodeSourcery GCCE 2005Q1C matches target EABI4

Date: 2026-11-09

## 1. Exact compiler identified

The original CodeSourcery ARM toolchain was retrieved from the archived Symbian developer mirror:

`gnu-csl-arm-2005Q1C-arm-none-symbianelf-i686-pc-linux-gnu.tar.bz2`

- Toolchain size: 10,896,869 bytes.
- MD5: `622e4db70cfae6a9eec26892a9932633`.
- Compiler: `arm-none-symbianelf-gcc 3.4.3 (CodeSourcery ARM Q1C 2005)`.
- It is a 32-bit Linux executable; the workflow installed the required i386 runtime dependencies.

Historical Symbian SDK documentation identifies GCCE 2005Q1 (GCC 3.4.3) as the default compiler for publicly released S60 3rd Edition and later SDKs.

## 2. ABI match confirmed

A minimal `E32Main` C source was compiled and linked with the original GCCE toolchain.

| Input/output | ELF flags | ABI |
|---|---:|---|
| GCCE 2005Q1C relocatable object | 0x04000000 | Version4 EABI |
| GCCE 2005Q1C linked ARM ELF | 0x04000000 | Version4 EABI |
| Target `euser.dso` | 0x04000004 | Version4 EABI |
| Target `cone.dso` | 0x04000004 | Version4 EABI |
| Target `gdi.dso` | 0x04000004 | Version4 EABI |

This resolves the compiler-side EABI version mismatch. The different low flag bits on target DSOs are not an EABI version difference; both report Version4 EABI.

The old compiler's ELF is ARM, little-endian, and the linked probe has entry point 0x10000. Compilation and linking completed successfully.

## 3. Converter build follow-up

The first Step72 run reached the portable `fedor4ever/elf2e32` source build, but modern CMake rejected its historical `cmake_minimum_required(VERSION 2.8)` declaration.

The workflow was updated to set `CMAKE_POLICY_VERSION_MINIMUM=3.5` and rerun the build. The EABI4 compiler result above is already confirmed; E32 conversion with the portable converter remains pending until that rerun completes.

## 4. Reproducibility

- Tool: `tools/step72_gcce_2005q1c_probe.sh`.
- Workflow: `.github/workflows/symbian-gcce-2005q1c-probe.yml`.
- First run: `42573913824`, failed only at the CMake compatibility step after successful GCCE compile/link.
- First-run artifact: `gcce-2005q1c-eabi-probe`, ID `13653914490`.
- Artifact SHA-256: `079ca682ded92d36c4a2ace21b38570aa196ab5954fa71212bad9b2ce13b2099`.
- SDK SHA-256: `7ed8b62b15f191ca47d2f6ca97ee5ce74cd02ce3e42b74bc7b1f9513d7df87b5`.

No Shadowkey code was compiled in this step. No N95 launch is claimed.
