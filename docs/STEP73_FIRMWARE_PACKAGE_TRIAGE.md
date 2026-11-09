# Step 73 — Firmware package triage (N-Gage QD RH-29 / N95 RM-320)

Date: 2026-11-09

## Inputs and integrity

Both Release assets were downloaded by GitHub Actions and SHA-256 checked.

| Target | Input | Bytes | SHA-256 |
|---|---|---:|---|
| N-Gage QD RH-29 v4.10 | RH-029.v.04.10.N-GAGE.QD.rar | 10,577,311 | 8984bd63e50c00b0d70b9f60f4a9b548606dfad0ee957f55082a4a7378bcd640 |
| N95 8GB RM-320 v35.0.001 | RM-320.v.35.00.N-95.exe | 82,467,650 | de9a283db13170286262bddbad3670664b353a8fcd22a3edd9a96970b0d156b2 |

The first extraction workflow completed successfully (run 42601099120; artifact 13665612454; artifact SHA-256 09dd753276189073af73ab98c73bbb14376f31698f232661227f252f897d583d).

## N-Gage QD findings

The RAR is valid and extracts two flash images:

- RH2941.0C1 — 18,454,871 bytes
- RH2941.026 — 1,386,311 bytes

Both begin with a structured binary header containing the ASCII tags `WD2 BT2` and `WD2 ALGORITHM`. These are Nokia WD2 flash images, not ordinary filesystem archives. Community flashing logs identify RH2941.0C1 as the MCU image and RH2941.026 as the PPM image, with UPP ASIC ID 1081 / RH-29. This is consistent with the filenames and header tags; no flash operation is being performed.

Useful external technical references:
- https://gsmforum.ru/threads/n-gage-qd-sistemnaya-oshibka.98790/ — example RH2941.0C1 / RH2941.026 processing log and UPP 1081.
- https://github.com/NGEmu/NGEmu/wiki — N-Gage firmware/OS preservation references.

Important limitation: these are flash-programming images. The extraction step has not yet reconstructed the internal Symbian ROM filesystem or individual DLLs. Need a read-only WD2 flash-image parser / filesystem reconstruction path. Do not treat raw image bytes or incidental embedded MZ signatures as extracted DLLs.

## N95 RM-320 findings

The EXE is a PE32 Windows GUI executable (Intel 80386, 8 sections), with an overlay beginning at file offset 0xD000. 7-Zip does not recognize the whole file as an archive. The PE overlay is ~82.4 MB and contains compressed-looking data; a late embedded string includes `Inno Setup`, which is a lead, not proof that the whole package is an Inno Setup installer.

The common firmware distribution for RM-320 v35.0.001 consists of at least:
- RM-320_35.0.001_PR.C0R (core/MCU image)
- RM-320_35.0.001_PR.vXX (language/variant image)
- RM320_31.0.002_025_xxx_U01_uda.fpsx (user-data/content image)

The supplied EXE has not yet yielded those payloads. The extraction workflow was extended to try Innoextract in addition to 7-Zip and will inventory any resulting files. If that fails, inspect the installer stub/overlay and identify the actual self-extractor; do not claim the N95 ROM is extracted.

Reference for expected RM-320 v35.0.001 package components:
- https://forum.gsmhosting.com/vbb/f299/all-nokia-flash-files-direct-download-links-all-models-2260295-print/index2.html

## Relevance to Shadowkey

The N-Gage QD flash images may eventually provide original-platform ROM modules and export tables, but the immediate task is to recover the WD2 filesystem safely. The N95 package must be unpacked to its BB5-era core/language firmware payloads before attempting ROM filesystem extraction.

Do not compare ordinal numbers until the actual target DLL/DSO images or authoritative import libraries are recovered. SDK/WINS ordinal mappings remain provisional and cannot substitute for the N95 RM-320 v35.0.001 exports.

## Next actions

1. Run the added Innoextract pass against the N95 EXE.
2. If it fails, investigate the PE installer stub and use the appropriate read-only extractor.
3. Identify or implement a parser for the WD2 MCU/PPM image record format; reconstruct only the ROM-resident partitions needed for EUSER/CONE/GDI/FBSCLI/EIKCORE/AVKON.
4. Parse E32 images and exports, then compare the original N-Gage platform with RM-320 OS 9.2.
5. Keep original firmware assets out of Git history; retain only scripts, metadata, hashes, and derived research notes.
