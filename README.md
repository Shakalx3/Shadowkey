# Shadowkey — Nokia N95 compatibility research

Technical project to run **The Elder Scrolls Travels: Shadowkey** on Nokia N95 8GB RM-320 (Symbian OS 9.2 / S60 3rd Edition FP1).

## Target and deliverable

- Target handset: Nokia N95 8GB RM-320, firmware reported as V 35.0.001.
- Desired output: a modified executable and/or compatible EKA2 support DLLs that can be copied to the phone.
- A SIS installer is not required.
- No successful launch on a physical N95 has been demonstrated.

## Current verified state — step 36

The step35 archive was checked on 2026-11-07:

- SHA-256: `6b263d86210eff452f2c00cd099ed9cac475bbca6bff9f60782b41c61263384d`
- 2,191 ZIP entries; 112,885,393 bytes uncompressed.
- `shadowkey_step35_e32_patch_test.sh`: PASS.
- `build_and_test.sh`: PASS.
- The ARM11 cross-build is a relocatable ARM EABI object, not a Symbian executable.
- The old-E32 patcher proves structural image rewriting only; its no-op stub is not a working compatibility shim and does not make the old App-DLL image EKA2-compatible.

The strongest toolchain candidate is [hpnkv/symbian-platform v0.3.0](https://github.com/hpnkv/symbian-platform). Its documentation explicitly advertises EKA2 ARMv6 libraries and ELF-to-E32 EXE/DLL conversion. The full Linux x86_64 SDK archive is about 326 MB and has not yet been downloaded or tested against Shadowkey or the RM-320 firmware.

See:
- [Archive import status](docs/ARCHIVE_IMPORT_STATUS.md)
- [Step 35 structural patch test](docs/STEP35_STRUCTURAL_PATCH_TEST.md)
- [Step 36 EKA2 toolchain audit](docs/STEP36_EKA2_TOOLCHAIN_AUDIT.md)
- [Step 36 native ARM build validation](docs/STEP36_NATIVE_ARM_BUILD_VALIDATION.md)
- [Step 34 GDI108 call-boundary audit](docs/STEP34_GDI108_CALL_BOUNDARY_ARGUMENTS.md)
- [Step 33 GDI callsite/write-watch audit](docs/STEP33_GDI_CALLSITE_PROVENANCE_AND_WATCH_FIX.md)
- [Step 32 TFontSpec structural finding](docs/STEP32_GDI108_TFONTSPEC72.md)
- [Legacy E32 research tools](tools/e32/README.md)

## Public repository boundary

This repository is public. Original game executables, proprietary game assets, audio, models, textures and lifted/decompiled game-code outputs from the supplied archive are intentionally not mirrored here. The repository contains project-authored analysis and format-research utilities. The complete supplied archive remains the separately held source input. See [archive import status](docs/ARCHIVE_IMPORT_STATUS.md).

## Working rules

1. Distinguish diagnostic shims from real Symbian implementations.
2. Treat static analysis and synthetic traces as evidence, not proof of device compatibility.
3. Verify imports against the exact N95/S60 3rd FP1 export tables.
4. Record milestones and reproducible tests in separate commits.
5. Never claim a real-device launch until it has been observed on the handset.
