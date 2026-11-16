# Step104 — firmware extraction and E32 header checkpoint

Date: 2026-11-11

## Firmware extraction

Run 42604419519 failed before filesystem parsing because the unpacker link step could not find -lunix++. The later workflow revision uses /usr/local/lib64 consistently for installation, linking, and runtime lookup.

Run 43016244579 completed extraction and analysis. The Actions job concluded success, but diagnostic artifact upload hit the repository Actions storage quota. The text audit remained in the job summary, and the Step102 test ZIP was published separately as a prerelease asset.

- UDA FPSX: parser output is a 41,206,272-byte userarea.img. Step73 FAT16 inspection found SYS/BIN and 432 files. This is user-area content, not ROM.
- PPM SOS+ROFX: carved size 18,904,576 bytes; magic ROFx (0x78464F52). The current unpacker rejects it at the magic check.
- C0R SOS+ROFS: carved size 21,660,672 bytes; parser emits a partial 1,441-file tree but exits with cannot skip bytes. Completeness is not validated.
- C0R SOS+CORE: carved size 43,360,768 bytes; reconstructed demand-paged ROM size 60,600,320 bytes; 12,671 pageable pages; zero BytePair decode failures; 2,726 ROM directory entries; 25 XIP target modules.

The ROM module inventory comes from the separate SOS+CORE reconstruction, not the generic rofs.img outputs.

## Seven target ROM modules

| Module | UID3 | ROM exports | Matching SDK DSO exports |
|---|---:|---:|---:|
| EUSER | 0x100039E5 | 2,229 | 2,210 |
| CONE | 0x10003A41 | 722 | 721 |
| GDI | 0x10003B15 | 348 | 344 |
| FBSCLI | 0x10003A15 | 241 | 240 |
| EIKCORE | 0x10004892 | 590 | 590 |
| WS32 | 0x10003B21 | 580 | 578 |
| EFSRV | 0x100039E4 | 351 | 335 |

There are 5,061 selected ROM/SDK-symbolized export rows and 43 ROM-only exports across these modules. SDK DSO symbolization is a name cross-check, not proof of runtime ABI equivalence. No ROM image or protected system DLL was committed.

## Step96 / Step102

Run 43016244579 completed the target GCCE ABI probe, minimal E32 DLL conversion, EKA2 RLibrary loader-probe build, and package validation. This is compile/structure evidence only; no device test occurred.

The reversible Step102 package is published at:
https://github.com/Shakalx3/Shadowkey/releases/tag/shadowkey-step102-43016244579

ZIP SHA-256:
6f219261da182f5ce5fb610000b3038ff518cc53811b9b7b11681125e75f2f65

It contains only ShadowkeyCompat.dll, ShadowkeyAbiProbe.exe, a readme, and checksums. It does not contain game code and does not patch 6R51.APP. Do not install until a device is available and its firmware/transfer method are confirmed.

## Step104 EKA1 header result

Run 43017898222 passed the read-only structural audit:

- CPU marker at 0x14: 0x00002000 (ARM).
- Code offset: 0x7C; code size: 1,051,076; text size: 1,049,408.
- Code section ends exactly at import offset 1,051,200.
- Import table size: 2,248; import end: 1,053,448.
- EKA1 code relocation offset at 0x70: 1,053,448, exactly the import-table end.
- EKA1 data relocation offset at 0x74: zero.
- EKA1 process priority at 0x78: 0x0000015E (350).

The code relocation section begins at 0x101308. Its first two words are 0x54E0 and 0x2778: size candidate 21,728 bytes and 10,104 relocations. There are 21,736 bytes available from that offset. Step103 now tests both size conventions by parsing every relocation block and checking the IAT literal references.

The code checksum remains unresolved. Stored value at 0x18 is 0x67F7151E. Computed little-endian word sums are:
- text-size range: 0x63829213
- code-size range: 0x6387532B
- code through import end: 0x984BF933

None matches. The data checksum is zero and matches the empty data segment. This discrepancy must be explained before rewriting code bytes or claiming checksum-valid output. The previous 0xEA00A113 value is the first ARM instruction at file offset 0x7C, not the process priority.

## Step103 import-patch state

The exact unmatched import is EUSER UID3 0x100039E5 ordinal 1575. Its global IAT index is 298, slot 0x101007E8; its ARM thunk is 0x1009F240 and the sole pointer literal is at file offset 0x0009F2C8.

A candidate local-DLL patch would remove only this EUSER import, append a one-entry custom-DLL block at ordinal 1, preserve the total 415 IAT slots, and redirect the thunk. It requires 48 additional import-table bytes, places the new slot at 0x101009B8, and rebases later IAT-pointer literals. It remains unapplied.

The corrected EKA1 patch analysis uses code relocation offset 0x70, data relocation offset 0x74, and priority 0x78. Since the code relocation section follows the import table, the candidate 48-byte import growth must move its file offset by 48 and update the header's code-relocation offset. The relocation records should remain byte-identical if their page offsets are relative to the unchanged code section; parsed-block and IAT-reference checks are now part of Step103.

Reference header definition:
https://github.com/loociano/symbian-build-tools/blob/master/e32tools/INC/E32IMAGE.H

## ROFx format finding

The official Symbian ROM reader recognizes both ROFS and ROFx. Its TExtensionRofsHeader carries directory-tree and file-entry offsets, and the reader computes an adjustment from the directory-tree offset to the file position immediately after the header. Directory and file-block references are adjusted by that amount. The current unpacker rejects ROFx at the magic check, but its existing base calculation resembles this adjustment.

Sources:
- https://github.com/SymbianRevive/symbian-build/blob/main/imgtools/romtools/rofsbuild/r_coreimage.cpp
- https://github.com/SymbianRevive/symbian-headers/blob/main/rofs.h
- https://github.com/SymbianRevive/symbian-build/blob/main/imgtools/romtools/readimage/src/rofs_image_reader.cpp

Step105 performs a reversible magic-only test on a temporary copy of the carved PPM ROFx image. The first run exposed an over-strict byte-diff assertion: ROFx to ROFS changes only the final identifier byte. The guard is corrected to require exactly offset 0x403 to change; the probe then runs the current unpacker, records extracted files, and checks that the source firmware remains unchanged. A successful probe would justify adding explicit ROFx recognition; a failed probe will isolate the next structural difference.

## Next checkpoint

1. Review Step105's parser result and add real ROFx support if the existing offset logic proves correct.
2. Review Step103 relocation-block parsing and IAT-literal coverage.
3. Resolve the stored code-checksum mismatch before any binary rewrite.
4. Keep C0R SOS+ROFS completeness as a separate parser task.
5. No phone is currently available; keep the Step102 package staged and do not request device actions.


## Step123 — correction to the code-checksum audit

Date: 2026-11-16

A review against the PETRAN/E32 header definition found that `iCheckSumCode` is defined as the additive sum of 32-bit words in the **text section**, not the complete code segment. The earlier Step103 audit computed both ranges but used the `iCodeSize` sum for its pass/fail gate. That gate was incorrect and has been corrected in `tools/step103_analyze_local_shim_patch.py` (commit `a680069108a9abaf1a4bb835786a9a5aba063959`).

The authoritative header definition lays out `iCheckSumCode` at 0x18, `iTextSize` at 0x60, `iCodeRelocOffset` at 0x70, `iDataRelocOffset` at 0x74, and `iPriority` at 0x78. The header comment explicitly describes the code checksum as the sum of all 32-bit words in `.text`.

For the current recorded 6R51.APP measurements:

- Stored code checksum: `0x67F7151E`.
- Little-endian sum over `iTextSize`: `0x63829213` — **does not match**.
- Little-endian sum over `iCodeSize`: `0x6387532B` — diagnostic only; not the checksum acceptance range.
- The checksum discrepancy therefore remains real and unresolved; it is not explained by choosing the correct section boundary.

No executable bytes were changed and no patched game image was produced. The next investigation must establish whether the measured source image is the exact uncompressed E32 byte stream expected by the header checksum routine, and whether the checksum uses a preprocessing/relocation convention not represented by the simple raw-file sum. Until that is resolved, no import-patched binary should be released.

Reference: [PETRAN E32ImageHeader definition](https://github.com/loociano/symbian-build-tools/blob/master/e32tools/INC/E32IMAGE.H); [E32 format checksum description](https://www.virusbulletin.com/virusbulletin/2005/09/symbian-os-mysterious-playground-new-malware).
