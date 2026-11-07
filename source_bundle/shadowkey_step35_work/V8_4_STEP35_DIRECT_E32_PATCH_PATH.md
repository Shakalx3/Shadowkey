# Shadowkey v8.4 step35 — direct binary patch path

Date: 2026-11-06

## User target clarified

The deliverable is **not a SIS/install package**. The target is a modified application executable and/or patched compatibility DLLs that can be copied to the phone. SIS generation is out of scope.

## Binary facts

- `6R51.APP` has UID1 `0x10000079`, E32 flags `0x01000003`, and one export. This is consistent with the pre-Symbian-OS-9 App-DLL application model.
- It has 20 imported DLL blocks and 415 imported ordinals.
- Its GDI dependency consists of exactly ordinals 101, 108, and 151. Each has one import veneer and five callsites in the recovered code.
- `SIMKIN.DLL` is also an old E32 DLL. The current ARM11 build recompiles recovered game and SIMKIN logic into a relocatable ARM ELF object, but that is not an EKA2 executable.

## Structural patch experiment

`shadowkey_e32_inject_arm_stub.py` inserts position-independent ARM stub bytes at the end of the old E32 text section, moves the IAT/export/import/relocation file offsets, updates every relocation-backed absolute pointer into the moved IAT, and can replace an import veneer with a PC-relative ARM `B` to the injected stub. The direct branch requires no new relocation entry.

The test redirected the GDI ordinal-101 veneer at `0x100A00B0` to a temporary `mov r0,#0; bx lr` stub at `0x10100340`. It did **not** implement GDI semantics; the generated probe image is deleted after the test.

Verified on the temporary output:

- E32 code/text sizes and trailing table offsets increased by 8 bytes.
- All 415 IAT-target relocation values were adjusted.
- Existing import blocks still parse as 20 DLL blocks / 415 ordinals.
- 413 import veneers are pattern-recognized because the selected GDI veneer is now a direct branch; the GDI ordinal remains in the import table.
- Original text bytes are unchanged except for the selected veneer and relocation-backed IAT pointers; the injected stub bytes are present at the new text end.
- The additive E32 code checksum is recalculated and matches the patched code segment.
- `shadowkey_step35_e32_patch_test.sh` passes.

### Checksum caveat

The legacy E32 header field at `0x18` is the additive code checksum over the complete code segment. This calculation matches `SIMKIN.DLL` exactly. The supplied `6R51.APP` baseline does **not** match its stored checksum (`0x67F7151E` stored versus `0x6387532B` calculated over its declared code segment). The patch writer recalculates the checksum for its output, but the reason for the baseline mismatch is unresolved and should be checked against a fresh original copy before any phone test.

## Critical target-format distinction

The structural rewrite test does **not** make the old image suitable for the N95. `6R51.APP` uses the pre-OS-9 App-DLL model. Symbian OS 9 / S60 3rd Edition changed the application model to EKA2/ARM EABI executables and broke binary compatibility with earlier Symbian OS releases. The N95 deliverable therefore needs to be emitted as an EKA2-compatible executable (plus optional EKA2 support DLLs), not merely as a patched pre-OS-9 `6R51.APP`.

## Next steps

1. Keep the direct-patch writer as a verified low-level research tool, but do not present its EKA1-era probe as an N95-ready binary.
2. Continue the EKA2 native build path: produce an actual Symbian OS 9.2 E32 executable from the recovered ARM code, with real startup/runtime and platform imports.
3. Implement GDI/FBS compatibility behavior in the EKA2 build or a support DLL once the target FP1 exports/signatures are verified.
4. Resolve the stale baseline checksum and compare `6R51.APP` with a fresh original extraction before creating a user-facing binary patch.

## Validation

Run `./shadowkey_step35_e32_patch_test.sh`. This validates only the old-E32 rewrite mechanics; it does not validate EKA2 loader acceptance, rendering, or game launch.

## EKA2 post-linker candidate discovered

A public `elf2e32` implementation based on Symbian source is available in `SymbianRevive/elf2e32` (and its upstream `fedor4ever/elf2e32`). Its stated role is to convert compiler-produced ARM ELF files into Symbian E32Image executables and DLLs; it is not a SIS builder. The published tool documentation confirms this ELF-to-E32 post-link stage. A newer `symbian-platform` project also advertises a Linux Clang/LLD + ELF-to-E32 toolchain and EKA2 runtime, but it is a recent single-maintainer project and has not been independently audited or tested here. The current container cannot resolve external download hosts, so neither toolchain has been downloaded or run in this checkpoint.

References:
- https://github.com/SymbianRevive/elf2e32
- https://github.com/fedor4ever/elf2e32
- https://cortex.p.gen.nz/nokia/symbian/Nokia%20Symbian3%20Developer%27s%20Library%20v0.8/GUID-CAC07A47-1475-5152-83AA-E59FD3AFF321.html
- https://github.com/hpnkv/symbian-platform
