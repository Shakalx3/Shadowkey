# Step92 — independent S60 DSO dynsym validation

Date: 2026-11-10

## Purpose

Step80 currently obtains S60 3.1 FP1 DSO exports with `readelf -Ws` and derives a Symbian ordinal as `st_value / 4 + 1` for aligned, defined GLOBAL DEFAULT symbols. Step92 independently reads ELF32 program headers and `PT_DYNAMIC` entries, then follows `DT_SYMTAB`, `DT_STRTAB` and the SysV/GNU hash table to enumerate dynamic symbols. It does not use readelf to enumerate symbols. The first prototype assumed standard 40-byte ELF32 section headers; the pinned Symbian DSOs instead report `e_shentsize=32` and `e_shnum=2`, so that path was rejected and replaced with the program-header/dynamic-table parser.

## Checks

- ELF class and endianness are ELF32 little-endian.
- Machine is ARM (EM_ARM).
- `PT_LOAD` and `PT_DYNAMIC` segments are structurally in range.
- Each export is defined, GLOBAL, DEFAULT visibility and word-aligned.
- Ordinal maps and unique-export counts are compared with the Step80 readelf-derived map.
- Duplicate ordinal aliases and unaligned global symbols are reported, not silently discarded.

Outputs:
- `STEP92_DSO_DYNSYM_VALIDATION.json`
- `STEP92_DSO_DYNSYM_MODULES.tsv`
- `STEP92_DSO_DYNSYM_MISMATCHES.tsv`

A mismatch is evidence that the earlier readelf-derived symbol map needs review. A pass independently validates the SDK DSO ordinal derivation, but does not by itself prove that the SDK DSOs are byte-identical to the RM-320 ROM or that a patched E32 image will load.

## Scope boundary

The ROM export addresses themselves are recovered from the RM-320 v35.0.001 SOS+CORE ROM reconstruction. SDK DSO symbol names are used to label those ROM export ordinals. Step92 checks the SDK symbol-to-ordinal side of that process; it does not replace target-ROM code disassembly for disputed symbols, ABI review, or a real-device test.
