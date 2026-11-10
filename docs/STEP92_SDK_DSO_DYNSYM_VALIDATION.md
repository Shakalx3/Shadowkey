# Step92 — independent S60 DSO dynsym validation

Date: 2026-11-10

## Purpose

Step80 obtains S60 3.1 FP1 DSO exports with `readelf -Ws` and derives a Symbian ordinal as `st_value / 4 + 1` for aligned, defined GLOBAL DEFAULT symbols. Step92 independently reads ELF32 program headers and `PT_DYNAMIC` entries, follows `DT_SYMTAB`, `DT_STRTAB` and `DT_HASH`, and compares the resulting ordinal/name map with Step80. It does not use readelf to enumerate symbols.

## Finding from the first run

The first Step92 attempt reported 24 parse errors, all with the same structural pattern. For example, EUSER's DSO has:

- `PT_LOAD`: file offset `0x19C`, virtual address `0`, file size `0x228C`; this segment contains only `ER_RO`.
- `PT_DYNAMIC`: file offset `0x2428`, virtual address `0`.
- `DT_HASH=0x2478`, `DT_STRTAB=0x6410`, `DT_SYMTAB=0x16218`.
- The section headers independently show `.hash` at `0x2478`, `.strtab` at `0x6410`, and `.dynsym` at `0x16218`.

The initial parser incorrectly treated those dynamic pointer values as process virtual addresses that must be backed by `PT_LOAD`. In these S60 3.1 FP1 DSOs, the dynamic pointer values are zero-based file offsets, and the only `PT_LOAD` segment does not cover the dynamic tables. This is a parser address-model error, not evidence that the SDK DSO files are corrupt or incomplete.

## Corrected parser

The parser now:
- tries normal `PT_LOAD` VA-to-file translation first;
- falls back to direct file offsets only when all relevant `PT_LOAD` and `PT_DYNAMIC` virtual addresses are zero and the requested range is within the file;
- cross-checks `DT_HASH`, `DT_STRTAB`, and `DT_SYMTAB` against the corresponding section file offsets when section headers exist;
- checks `.dynsym` type, entry size, and byte size against `DT_SYMENT` and the SysV hash `nchain`;
- reports the address model used for each DSO and retains duplicate ordinals, unaligned exports, and symbol-map mismatches.

The corrected parser then completed all 24 DSO parses and matched every module's export count. Its first comparison still reported 343 name mismatches across 15 modules. Inspection showed that every one was an absent-export placeholder: the raw SDK symbol is quote-wrapped (for example, `"_._.absent_export_73"`), while Step80's hand-written TSV output failed to escape literal quotes. The TSV reader therefore removed the quote characters from the expected map. No ordinary exported API name differed. Step80's symbol-bearing TSV writers have now been changed to use CSV-compliant quoting; the next run must confirm that all 24 ordinal/name maps agree.

A passing SDK DSO audit validates the SDK symbol-to-ordinal extraction independently; it does not prove that SDK exports and RM-320 ROM code are byte-identical, nor that a patched E32 image will load.

## Scope boundary

The target export addresses and counts come from the reconstructed RM-320 v35.0.001 SOS+CORE ROM. SDK DSO symbols label those ROM export ordinals. The seven critical target modules (EUSER, CONE, GDI, FBSCLI, EIKCORE, WS32, EFSRV) are present in the reconstructed ROM. ROM export counts may exceed SDK DSO export counts; those extra ROM ordinals require direct ROM disassembly and must not be filled by guessing.

No N95 hardware launch has been performed; the phone is not currently available. Host-harness success is not device compatibility evidence.
