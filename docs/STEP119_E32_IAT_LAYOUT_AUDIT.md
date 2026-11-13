# Step119 — E32 import/export offset and IAT layout audit

Date: 2026-11-13

## Baseline and result

- Default branch: main
- Workflow: [43416057247](https://github.com/Shakalx3/Shadowkey/actions/runs/43416057247), completed successfully.
- Step117 decompressed all 135 EPOC candidates (134 Deflate, one BytePair).
- Step118 matched all 135 outputs to the Step109 scan: zero missing, zero extra.
- Step119's 2 synthetic absolute/relative offset tests passed.
- The diagnostic classified all 135 files as NEEDS_LAYOUT_REVIEW under a PE-style IAT/export-value model. This was a useful failure signal, not a module-validity verdict.

## Root cause found in the format definitions

The pinned upstream elf2e32 E32 header defines:
- KImageImpFmtMask = 0xF0000000
- KImageImpFmt_ELF = 0x10000000
- KImageImpFmt_PE = 0x00000000
- KImageImpFmt_PE2 = 0x20000000

It explicitly documents that E32ImportBlock::Imports() contains code-section offsets for ELF format, imported ordinals for PE format, and no ordinal list for PE2. The upstream parser locates the PE-style IAT at iCodeOffset + iTextSize. It also resolves the ELF export-symbol-info address as code_offset + absolute_export_address - code_base, which is consistent with ELF export entries being absolute runtime addresses.

This explains the Step109/Step119 symptoms:
- 128 modules had a parseable absolute import table, but Step119 incorrectly treated ELF code offsets as a PE ordinal list and demanded an IAT. Their iTextSize equalled iCodeSize, so the invented PE-style IAT overflowed the declared code segment.
- Seven modules had no DLL references and are now represented as NO_IMPORTS rather than a failed import-offset parse.
- Most export values failed the PE-style code-offset test because ELF exports use absolute runtime addresses.

## Next step

Step120 parses import/export tables according to the import-format nibble in iFlags. It will validate ELF import patch offsets and absolute export addresses, while retaining the PE and PE2 IAT rules for those formats. No bounds are relaxed and no binary is rewritten.

A format-aware VALID result remains static structure only; it is not loader acceptance, ABI compatibility, or a real N95 launch.

No firmware binaries, ROM pages or protected system DLLs are committed. No handset action is requested.
