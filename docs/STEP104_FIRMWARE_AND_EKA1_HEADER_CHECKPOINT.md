# Step104 — firmware extraction and legacy E32 header checkpoint

Date: 2026-11-11

## Firmware extraction

The requested run 42604419519 failed before filesystem parsing: the unpacker link step could not find -lunix++. The later workflow revision installs, links, and loads libunix++ consistently from /usr/local/lib64.

Run 43016244579 completed the extraction and analysis steps. The Actions job concluded success, but the diagnostic artifact upload hit the repository's Actions storage quota. The text-only audit remained in the job summary, and the Step102 test ZIP was published separately as a prerelease asset.

- UDA FPSX: parser output is a 41,206,272-byte userarea.img. The separate FAT16 inspection in Step73 found SYS/BIN and 432 files. This is user-area content, not ROM.
- PPM SOS+ROFX: carved size 18,904,576 bytes; magic ROFx (0x78464F52). The current unpacker rejects it as wrong ROFS magic and emits zero files. This is an unsupported ROFX path, not evidence of corruption.
- C0R SOS+ROFS: carved size 21,660,672 bytes; parser emits a partial 1,441-file tree but exits with cannot skip bytes. Completeness is not validated.
- C0R SOS+CORE: carved size 43,360,768 bytes; reconstructed demand-paged ROM size 60,600,320 bytes; 12,671 pageable pages; zero BytePair decode failures; 2,726 ROM directory entries; 25 XIP target modules.

The generic unpacker's large PPM/C0R rofs.img outputs are not complete filesystem extractions. The ROM module inventory comes from the separate SOS+CORE reconstruction.

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

There are 5,061 selected ROM/SDK-symbolized export rows and 43 ROM-only exports across these seven modules: EUSER 19, CONE 1, GDI 4, FBSCLI 1, EIKCORE 0, WS32 2, EFSRV 16. SDK DSO symbolization is a name cross-check, not proof of runtime ABI equivalence. No ROM image or protected system DLL was committed.

## Step96 / Step102

Run 43016244579 completed the target GCCE ABI probe, minimal E32 DLL conversion, EKA2 RLibrary loader-probe build, and package validation. This is compile/structure evidence only; no device test occurred.

The reversible Step102 package is published at:
https://github.com/Shakalx3/Shadowkey/releases/tag/shadowkey-step102-43016244579

ZIP SHA-256:
6f219261da182f5ce5fb610000b3038ff518cc53811b9b7b11681125e75f2f65

It contains only ShadowkeyCompat.dll, ShadowkeyAbiProbe.exe, a readme, and checksums. It does not contain game code and does not patch 6R51.APP. Do not install until a device is available and its firmware/transfer method are confirmed.

## Step103 local-shim analysis

The exact unmatched import is EUSER UID3 0x100039E5 ordinal 1575. Its global IAT index is 298, slot 0x101007E8; its ARM thunk is 0x1009F240 and the sole pointer literal is at file offset 0x0009F2C8.

A candidate local-DLL patch would remove only this EUSER import, append a one-entry custom-DLL block at ordinal 1, preserve the total 415 IAT slots, and redirect the thunk. It requires 48 additional import-table bytes, places the new slot at 0x101009B8, and rebases later IAT-pointer literals. It remains unapplied.

Step103's relocation interpretation is not valid for the legacy header candidate. The Symbian E32IMAGE.H definition places CPU at 0x14, code checksum at 0x18, data checksum at 0x1C, code relocation offset at 0x70, data relocation offset at 0x74, and process priority at 0x78. Step103 instead treats 0x74 as a relocation size and 0x78 as another relocation offset.

Reference:
https://github.com/loociano/symbian-build-tools/blob/master/e32tools/INC/E32IMAGE.H

The stored code checksum is 0x67F7151E; the current text-size word-sum is 0x63829213. The raw word at 0x78 is 0xEA00A113. Both need further explanation. Step104 adds a read-only check of checksum ranges, the EKA1 relocation offsets, relocation-section header bytes, and the raw header words. No patch is authorized.

## Next checkpoint

1. Inspect Step104 checksum candidates, relocation header, and raw header tail.
2. Correct Step103 to use EKA1 fields only after the header interpretation is validated.
3. Prototype only on a separate copy; verify every IAT literal rewrite and byte-compare untouched ranges.
4. Continue PPM ROFX format support and C0R SOS+ROFS completeness as separate tasks.
5. No phone is currently available; keep the Step102 package staged and do not request device actions.
