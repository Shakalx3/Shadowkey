# Step 54 — both SDK generations pinned and available

Date: 2026-11-08

## SDKs now referenced by the Shadowkey repository

### Original N-Gage / Symbian 6.1

- Upstream: https://github.com/ngagesdk/sdk
- Pinned commit: `0a94b7655117f325a1729f5600093e4ad12c8d60`
- GitHub tree inventory: 9,936 files, 457,511,952 bytes (about 458 MB unpacked).
- Integrated at `third_party/ngage-sdk` as a Git submodule.
- Required ARM UREL import libraries are present upstream: `euser.lib`, `cone.lib`, `gdi.lib`, `eikcore.lib`, `bitgdi.lib`.
- Relevant headers include `eikapp.h`, `coecntrl.h`, `gdi.h`, `fbs.h`, and `bitmap.h`.

The upstream toolchain project states that its own MIT license does not cover the Nokia and third-party SDK components. Therefore this repository pins the upstream source rather than duplicating the SDK binaries into a second repository. The exact revision is recorded in the gitlink and `.gitmodules`. A normal clone can initialize it with `git submodule update --init --recursive`.

### Nokia S60 3.1 FP1 / Symbian OS 9.2 (N95 target)

- Curated devkit and full extracted payload are stored as permanent assets in the private GitHub Release:
  https://github.com/Shakalx3/Shadowkey/releases/tag/s60-sdk-3.1-fp1-20261108
- The curated devkit includes ARMv5 target headers, libraries, E32 tools, and documentation.
- Native Windows probes confirmed that the SDK's `elf2e32.exe`, `petran.exe`, and `makesis.exe` launch and report their versions/usage.
- The separate EKA2 ARMv6 pipeline was validated in Step 52.

## What each SDK contributes

| Resource | What it answers |
|---|---|
| N-Gage SDK headers | Original Symbian 6.1 class layouts, descriptors, API declarations, and framework contracts |
| N-Gage ARM UREL import libraries | Original ARM import symbols/ordinals and the legacy binary's expected exports |
| S60 3.1 FP1 headers and DSO/import libraries | N95-era API surface, target export table, and ARMv5 system-library expectations |
| EKA2 ARMv6 toolchain | Reproducible compilation and native E32 image generation for the target OS family |

Together they let us compare the old binary's imports and object assumptions against the N95 platform rather than infer them from WINS debug symbols or modern API documentation alone.

## Follow-up build validation (same day)

After wiring the N-Gage submodule into the ARMv6 CI checkout, all 14 recovered C translation units compiled successfully with the EKA2 ARMv6 compiler. This is an object-compilation milestone only: the units have not yet been linked into a complete E32 application, and no phone/emulator launch is claimed.

- Successful run: https://github.com/Shakalx3/Shadowkey/actions/runs/42485190637
- Artifact: `shadowkey-armv6-eka2-objects` (includes ARM object files and compiler report)
- The first attempt exposed a missing GCCE soft-float compatibility macro in the Clang build environment; adding the explicit empty `__SOFTFP` marker fixed that header-level issue. The target remains `armv6-none-eabi` with `-mfloat-abi=soft`.

## Expected development impact

The greatest acceleration should be in repeatable research and validation:
- API/ordinal lookups become direct, locally reproducible queries instead of manual searching.
- Class/descriptor layout questions can be checked against the correct generation of headers.
- Import compatibility can be checked with scripts across the old and target SDKs.
- Rebuilds and E32 inspection can run automatically in CI.

This does not translate into a reliable single percentage for the whole port. It should make individual SDK/ABI investigations several times faster once the scripts are in place, and save repeated hours or days of lookup and setup work over the project. It will not automatically bridge Symbian 6.1 to EKA2, implement FBS/CONE/AVKON semantics, or prove the binary runs on the N95. The remaining high-cost work is still the compatibility layer, startup/framework initialization, graphics and device testing.

## Reproducibility

- N-Gage SDK validation workflow: `.github/workflows/audit-ngage-sdk-submodule.yml`
- N-Gage SDK pinned-input artifact: `ngage-sdk-pinned-inputs`
- EKA2 ARMv6 E32 validation: [Step 52](STEP52_EKA2_ARMV6_E32_TOOLCHAIN_VALIDATED.md)
