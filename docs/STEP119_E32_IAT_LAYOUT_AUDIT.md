# Step119 — E32 import/export offset and IAT layout audit

Date: 2026-11-13

## Verified diagnostic result

- Workflow: [43416779432](https://github.com/Shakalx3/Shadowkey/actions/runs/43416779432), completed successfully.
- Step119's two synthetic absolute/relative offset tests passed.
- The diagnostic reported 135/135 NEEDS_LAYOUT_REVIEW, 128 absolute import-table locations and seven modules with no imports.
- This was a PE-style diagnostic assumption, not a firmware validity result. All 135 modules are ELF import format, confirmed by Step120 and the Step109 format-aware parser.

## Correct interpretation

The pinned upstream E32 header defines:
- KImageImpFmtMask = 0xF0000000
- KImageImpFmt_ELF = 0x10000000
- KImageImpFmt_PE = 0x00000000
- KImageImpFmt_PE2 = 0x20000000

For ELF format, E32ImportBlock::Imports() is a list of code-section relocation places, not imported ordinals. The loader resolves the import at each relocation place; there is no PE-style contiguous ordinal IAT to validate. The relocation word encodes the imported ordinal in its low 16 bits and addend in its high 16 bits. Named-lookup images may also carry a trailing zero slot.

ELF export entries are absolute runtime addresses. They must be translated to code-relative/file offsets using iCodeBase and iCodeOffset. Treating them as small code-relative offsets caused Step119 to report 100 files with no valid export-offset interpretation.

The format-aware Step109 parser now handles ELF, PE and PE2 formats, including the ELF relocation-site ordinal/addend and PE2's absent ordinal list. Its self-tests pass 7/7. Production result: all 135 modules PASS, 2,752 exports and 26,485 imports. Step120 independently reports all 135 VALID and the same export/import row counts; its format tests pass 3/3.

## Use of this checkpoint

Keep Step119 as a diagnostic demonstrating why a PE-only parser is wrong for this firmware. Do not use its NEEDS_LAYOUT_REVIEW status as an acceptance gate. The authoritative static inventory is Step109, cross-checked by Step120. Neither proves device loader acceptance.
