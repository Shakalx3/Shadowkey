# Step118 — bulk Symbian-native E32 decompression and flat-image audit

Date: 2026-11-13

## Verified result

- Latest successful full workflow: [43416779432](https://github.com/Shakalx3/Shadowkey/actions/runs/43416779432), commit 0858d383d855621718371b9954ede598c8779845.
- Step117 selected 135 EPOC candidates from the merged PPM-over-C0R ROFS tree.
- All 135/135 were decompressed by the pinned upstream elf2e32 tool:
  - Deflate UID 0x101F7AFC: 134 modules.
  - BytePair UID 0x102822AA: 1 module.
- Step109 found exactly 135 flat-image candidates: zero missing and zero extra.
- The format-aware Step109 parser classified all 135 as PASS, with 2,752 export rows and 26,485 import rows. All 2,752 export entries were valid; no zero or invalid export entries were recorded.
- Independent Step120 cross-check: 135/135 VALID, all 135 use ELF import format, 2,752 export rows, 26,485 import rows; synthetic format tests PASS 3/3.
- Decompressed binaries remained in the ephemeral workflow workspace. No firmware or system binary was committed.

## Why Step119 initially looked like a failure

Step119 is a PE-style offset/IAT diagnostic, not the authoritative parser. It expected imported ordinals plus a contiguous PE IAT and code-relative export entries. These RM-320 filesystem modules use ELF import format: their import lists contain code-section relocation places, and their export entries are absolute runtime addresses. Their iTextSize equals iCodeSize, so there is no PE-style IAT to check. Step109 was corrected to parse ELF relocation places and decode the embedded ordinal/addend; Step120 independently verifies the code-offset and absolute-export ranges. Do not interpret Step119's NEEDS_LAYOUT_REVIEW status as malformed firmware.

## UDA status

The UDA FPSX container is parsed into a 41,206,272-byte sparse userarea.img. Step112 found no FAT16 volume at the image start, in an MBR partition, or at any scanned 512-byte-aligned offset. Step115 records a 115,200-byte H2E/SOS-USER payload at image offset 41,091,072. Its prefix is structured binary data, not a FAT boot sector. The internal H2E payload format remains unidentified; do not claim that a user filesystem has been extracted.

## Historical run 42604419519

The requested run [42604419519](https://github.com/Shakalx3/Shadowkey/actions/runs/42604419519) failed at the final linker step because ld.bfd could not find libunix++. The unpacker objects had compiled; this was a CI library-search-path problem, not a malformed UDA/PPM/C0R payload. Later workflows installed libunixpp under /usr/local/lib64 and supplied the runtime/linker paths. The old run is superseded and should not be rerun.

## Interpretation limits and next work

- A format-aware structural PASS is not Symbian loader acceptance, ABI compatibility, or proof of a real Shadowkey launch.
- The seven XIP ROM modules and their export tables are separately inventoried in Step111; the 135 ROFS/ROFx modules are not those seven ROM modules.
- The small Step102 prerelease package is only an EKA2 DLL loader/ABI probe, not a game build.
- No handset action is requested; the user currently has no phone available.
- Next useful work: identify the H2E/SOS-USER payload format, continue the game-import-to-ROM-export mapping, and keep the reversible device probe separate from the game port.
