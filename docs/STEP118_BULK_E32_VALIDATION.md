# Step118 — bulk Symbian-native E32 decompression and flat-image audit

Date: 2026-11-13

## Verified result

- Baseline workflow: [43416057247](https://github.com/Shakalx3/Shadowkey/actions/runs/43416057247), completed successfully.
- Step117 selected **135** EPOC candidates from the merged PPM-over-C0R ROFS tree.
- All **135/135** were decompressed by the pinned upstream elf2e32 tool:
  - Deflate UID 0x101F7AFC: 134 modules.
  - BytePair UID 0x102822AA: 1 module.
- Step109's independent scan found exactly 135 candidates after decompression: zero missing and zero extra.
- The workflow retained only metadata reports; decompressed E32 binaries stayed in the ephemeral runner workspace.

## Important parser correction

Step109 classified all 135 decompressed files as REJECTED. This is not evidence that the images are malformed. The parser applied PE-style assumptions to the E32 import/export tables:
- it treated every import list as a list of ordinals and expected a contiguous IAT;
- it treated every export entry as a code-relative offset.

The N95 E32 format flags select the import format. For ELF-format images, import-block entries are code-section offsets, not ordinals; the PE-style IAT check is not applicable. ELF export entries are absolute runtime addresses and must be translated through code_base. Step120 implements the format-aware rules from the pinned upstream E32 headers/parser.

The Step118 path-prefix join is corrected: the 135 decompressed outputs now match the 135 Step109 rows with no missing or extra paths.

## UDA status

The UDA FPSX container is parsed into a 41,206,272-byte sparse userarea.img. Step112 found no FAT16 volume at the image start, in an MBR partition, or at any scanned 512-byte-aligned offset. Step115 records a 115,200-byte H2E/SOS-USER payload at image offset 41,091,072. Its prefix is structured binary data, not a FAT boot sector. The internal H2E payload format remains unidentified; do not claim that a user filesystem has been extracted.

## Interpretation limits

- DECOMPRESSED means the pinned upstream parser emitted an uncompressed image and Step117's basic UID/code-offset/size checks passed.
- Format-aware export/import validation is a separate Step120 task.
- No decompressed binary, ROM page, firmware image or protected system DLL is committed.
- Static structural checks are not Symbian loader acceptance or proof of device compatibility.
- No handset action is requested.
