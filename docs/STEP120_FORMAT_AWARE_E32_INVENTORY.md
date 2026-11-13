# Step120 — format-aware E32 module inventory

Date: 2026-11-13

## Baseline and finding

- Step117 decompressed all 135 compressed EPOC candidates (134 Deflate, one BytePair).
- Step118 matched all 135 outputs to the independent Step109 scan with no missing/extra candidates.
- Step109's blanket REJECTED result was a parser-format mismatch, not a decompression failure: it treated ELF-format imports as PE ordinals/IAT entries and ELF exports as code-relative offsets.
- Step119 measured the symptom: all 135 had IAT overflow under the PE-style interpretation; 2,635/2,752 export values failed the PE-style code-offset test.

## Format evidence

The pinned upstream elf2e32 header defines:
- KImageImpFmtMask = 0xF0000000
- KImageImpFmt_ELF = 0x10000000
- KImageImpFmt_PE = 0x00000000
- KImageImpFmt_PE2 = 0x20000000

The same header explicitly states that E32ImportBlock::Imports() is a list of code-section offsets for ELF format, a list of imported ordinals for PE format, and absent for PE2. The upstream parser locates the PE-style IAT at iCodeOffset + iTextSize. It also derives ELF export-symbol-info addresses using code offset + absolute export address - code base, confirming that ELF export values are absolute runtime addresses.

Step120 uses the import-format nibble in iFlags to select the correct parser. It does not relax bounds or rewrite the images.

## Acceptance boundary

- ELF imports: validate each code-section patch offset against iCodeSize; do not demand a PE ordinal IAT.
- ELF exports: validate absolute addresses against [iCodeBase, iCodeBase + iCodeSize), then translate to file offsets.
- PE imports: parse ordinals and verify the IAT range and contents.
- PE2 imports: parse descriptors without reading a nonexistent ordinal list; bounds-check the IAT.
- PE/PE2 exports: validate code-relative offsets.

A VALID result remains static structure only. It is not loader acceptance, ABI compatibility, or a real N95 launch.

No firmware binaries, ROM pages or protected system DLLs are committed. No handset action is requested.
