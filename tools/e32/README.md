# Legacy E32 research tools

These utilities are retained as format-research tools for the supplied pre-OS-9 `6R51.APP` image.

- `shadowkey_e32_inject_arm_stub.py` inserts a small ARM stub before the IAT, moves the legacy E32 tables, adjusts relocation-backed IAT pointers, recalculates the additive code checksum, and can redirect one import veneer with a PC-relative ARM branch.
- `shadowkey_extract_e32_imports.py` parses the legacy E32 import blocks and maps recognized import veneers to DLL ordinals.

## Important limitations

- This code supports only the narrow old-E32 layout described in the step35 report.
- It is not an EKA2 image builder and does not create a runnable Nokia N95 executable.
- The default stub is only `bx lr`; it does not implement any Symbian API.
- The original game image is intentionally not stored in this public repository. Supply a legally obtained local copy of `6R51.APP` when running these utilities.
- The original image's checksum mismatch remains unresolved; compare against a fresh extraction before producing a patch.
- Do not use the output on a phone. Target-loader acceptance and game behavior have not been tested.

See [Step 35 structural patch test](../../docs/STEP35_STRUCTURAL_PATCH_TEST.md) and [Step 36 EKA2 toolchain audit](../../docs/STEP36_EKA2_TOOLCHAIN_AUDIT.md).
