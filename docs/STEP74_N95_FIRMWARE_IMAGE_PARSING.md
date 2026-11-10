# STEP74 — N95 firmware image parsing and ROM reconstruction

Date: 2026-11-10

## Firmware package and UDA

The RM-320 v35.0.001 installer was opened with Inno Setup and yielded:

- RM-320_35.0.001_PR.C0R — 72,855,701 bytes
- RM-320_35.0.001_PR.v05 — 18,907,888 bytes
- RM320_31.0.002_025_xxx_U01_uda.fpsx — 41,212,787 bytes

The UDA FPSX parser produces userarea.img (41,206,272 bytes). A separate FAT16 inspection confirmed a valid directory tree with SYS/BIN and 432 extracted files. This is the user-data/preloaded-content area, not the phone's ROM OS image; its DLLs must not be used as substitutes for ROM EUSER/CONE/GDI.

## PPM and C0R partition carving

The initial generic parser did not expose the PPM/C0R filesystems as ordinary top-level ROFS images. The corrected path follows the BB5 FPSX block descriptors and carves the embedded SOS partitions:

- C0R SOS+CORE: starts at 0x00A40000, partition length 43,360,768 bytes.
- C0R SOS+ROFS: starts at 0x03A40000, carved partition length 21,660,672 bytes.
- PPM SOS+ROFX: starts at 0x05140000, carved partition length 18,904,576 bytes.

The carved C0R SOS+ROFS image is accepted by the parser (magic `ROFS`, format version 2) and produces a populated filesystem tree, including `SYS/BIN` E32 files. The parser nevertheless exits with code 1 and warns that the directory count in the image does not match the number of parsed entries (`20812<>310`); treat the tree as useful but not yet completeness-validated.

The carved PPM partition has magic `ROFx`, not `ROFS`. The current parser explicitly rejects it with `wrong ROFS magic number`; this is an isolated format-support gap, not evidence of a damaged PPM image. The generic FPSX parser's large `rofs.img` outputs (104,101,376 bytes from PPM and 82,740,224 bytes from C0R) are not valid ROFS filesystems and must not be confused with the custom-carved SOS partitions.

## Demand-paged ROM reconstruction breakthrough

The system ROM is in the C0R SOS+CORE partition. The reconstruction now has a structural ROM header and a fully decoded pageable area:

- ROM base: 0x80000000
- ROM size: 0x03A00000
- reconstructed uncompressed image: 60,600,320 bytes
- pageable pages: 12,671
- BytePair decode failures: 0
- ROM directory: 1 root, 2,726 directory entries
- target system-module entries: 25
- raw ROM export-address rows: 15,412

The subsequent comparison against the pinned S60 3.1 FP1 ARMv5 SDK found 24 corresponding SDK DSO modules, 11 exact export-count matches, and 15,325 symbolized ROM/SDK export-map rows. The selected modules EUSER, CONE, GDI, FBSCLI, EIKCORE, WS32 and EFSRV are all present in the reconstructed ROM. Step92 independently parsed the 24 SDK DSOs and confirmed all 24 ordinal/name maps with zero mismatches. Their exact counts and per-ordinal evidence are recorded in Step91.

## Diagnostic artifact hygiene

Run 55 exposed a cleanup-path mismatch: the compact Actions artifact still contained the 60,600,320-byte reconstructed ROM file named rom-reconstructed.bin. It was not committed to Git history. The workflow now removes both reconstructed-ROM filename variants and fails the cleanup step if any .bin, .dll, .img, .fpsx, .rofs or .c0r file remains. Run 57 passed the stricter artifact check: the uploaded diagnostic artifact is 940,327 bytes and the raw-binary guard found no remaining .bin, .dll, .img, .fpsx, .rofs or .c0r files.

## Interpretation constraints

- The original UDA, PPM and C0R containers are not themselves E32 modules.
- ROM export addresses are read from the reconstructed target ROM; SDK symbol names are a cross-check and require special review where export counts differ.
- A count match is not proof that every ordinal has the same meaning.
- N-Gage WINS ordinals must not be treated as N95 OS 9.2 ordinals.
- No physical N95 launch or runtime compatibility test has been performed.

## Next steps

1. Complete the PPM ROFx filesystem parser or determine whether its format differs materially from ROFS v2.
2. Validate the completeness of the C0R SOS+ROFS tree despite the parser's directory-count warning.
3. Resolve remaining import signatures and wrappers; Step90 now provides a validated EKA2 host EXE and Step93 records actual call sites for the key imports.
4. Keep raw firmware and system DLLs out of Git history and diagnostic artifacts.
