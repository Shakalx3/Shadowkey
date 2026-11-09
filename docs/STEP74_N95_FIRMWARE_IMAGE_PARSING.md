# STEP74 — N95 firmware image parsing stage

Date: 2026-11-09

## Verified extraction result

The GitHub Actions extraction workflow successfully opened the user's original N95 installer with Inno Setup 5.2.3. It extracted:

- `RM-320_35.0.001_PR.C0R` — 72,855,701 bytes
- `RM-320_35.0.001_PR.v05` — 18,907,888 bytes
- `RM320_31.0.002_025_xxx_U01_uda.fpsx` — 41,212,787 bytes

The installer was identified as `Nokia N95-8Gb RM-320_Gr.RUS_35.0.001_v7.0`. The extracted files are firmware images, not yet extracted Symbian file systems.

SHA-256 values from the workflow artifact:

- C0R: `018dc62b2378801d26aa86e76e019236c57ac756925dc00a99b354f5ecbccf95`
- UDA FPSX: `35d314692a19f7b31c702fce5959d89e81e1d5eeaefeb3f867ab77cc965d670c`

The PPM image begins with BB5/XSR metadata and includes `OMAP2420 UNISTORE-II-1.5.1 ALG`; the C0R also includes BB5/XSR and OMAP-related metadata. These headers are not E32 module headers.

## New parsing experiment

Added a controlled workflow stage to build the open-source `saur0n/unpacker` and its `libunixpp` dependency, then independently attempt parsing of:

1. UDA `.fpsx`
2. PPM `.v05`
3. MCU/core `.C0R`

Each attempt records its own exit code and log; a parser failure on one image must not suppress results from the others. The extracted output tree and logs are included in the Actions artifact.

Workflow update commit: `6f3dd30a8873d3a3ae8671bf6b0fa8a43a35b13d`.

## Interpretation constraints

- The upstream unpacker documents support for BB5 FPSX and ROFS extraction, with ROFS support described as unstable.
- Its documented scope does not establish support for the MCU C0R image. A C0R parser failure is therefore not evidence that the image is corrupt.
- No system DLL or E32 executable has yet been confirmed extracted from the N95 images.
- Do not use the N-Gage WINS export ordinals as N95 OS 9.2 ordinals. The next target is the actual N95 EUSER/CONE/GDI binaries or a trustworthy export table extracted from this firmware.

## Next steps

1. Inspect the new parser workflow logs and output tree.
2. If UDA/PPM yields a filesystem, inventory `Z:\sys\bin\` and `Z:\sys\hash\` (and the corresponding ROM drive layout) for EUSER, CONE, GDI, FBSCLI, EIKCORE, WS32, EFSRV and related modules.
3. Parse candidate E32 images and collect UID, module version, export count, export names/ordinals where available, and hashes.
4. If the parser does not recover a filesystem, inspect FPSX block boundaries and XSR/ROFS structures independently; do not treat raw ASCII strings or unaligned UID byte patterns as proof of extracted modules.
5. Preserve original firmware assets only as release inputs/artifacts; do not commit full firmware images or extracted copyrighted system binaries into Git history.
