# Step119 — E32 import/export offset and IAT layout audit

Date: 2026-11-13

## Baseline

- Default branch: main
- Baseline commit: 12de3a5a04c569a7dc4dacaf706f8df2f5ec0495
- Firmware workflow [43415137097](https://github.com/Shakalx3/Shadowkey/actions/runs/43415137097) completed successfully.
- Step117's pinned upstream elf2e32 decompressor produced uncompressed output for all 135 EPOC candidates: 134 Deflate UID 0x101F7AFC, one BytePair UID 0x102822AA.
- Step109 then classified all 135 flat images as REJECTED. The dominant reason was IAT block 0 exceeds code segment; seven additional files had an import offset outside the file. It emitted 2,752 export rows, of which 117 were within the declared code-size range and 2,635 were outside. The previous Step118 summary also had a path-prefix join bug; that is corrected in the next run.

## Why another audit is needed

The upstream E32ImageHeader definition documents:
- iExportDirOffset and iImportOffset as file offsets;
- iCodeOffset as the code-section file offset/header size;
- iTextSize as the offset of the IAT relative to the code section;
- iCodeSize as the size of code, IAT, constant data and export directory.

The pinned upstream parser locates the IAT at iCodeOffset + iTextSize. Step109 follows that layout. Therefore the IAT overflow is not to be fixed by silently relaxing bounds. Step119 reads the actual decompressed headers and import descriptors, tests absolute offsets first, and records code-relative interpretations only as diagnostics. It reports the computed IAT end and compares IAT values to import ordinals without modifying any file.

## Acceptance boundary

A candidate is only marked STRUCTURAL_CANDIDATE when one unique offset interpretation is bounded, the code range is in-file, the IAT fits the declared code size and its values match the import ordinal list. Any ambiguous or inconsistent case remains a review item. This is not a Symbian loader test or device compatibility proof.

## UDA note

The UDA FPSX container is parsed to a 41,206,272-byte sparse userarea.img; Step112 found no FAT16 volume. Step115 identifies a 115,200-byte H2E/SOS-USER payload at image offset 41,091,072. Its raw prefix is structured data, not a FAT boot sector. The internal payload format remains unidentified.

No firmware binaries, ROM pages or protected system DLLs are committed. No handset action is requested.
