# Step106 — ROFS/ROFx extraction diagnosis and Symbian-layout audit

Date: 2026-11-12

## Repository and workflow state

The default branch is main. The audited head before this checkpoint was ef447ad01d501b185cb3833a8dc53929ddc3e98c. The latest firmware workflow run at that head, 43199071044, completed successfully. It generated the firmware and import reports, but the diagnostic artifact upload was rejected because the GitHub Actions artifact-storage quota was full. The text summary remains in the run log/job summary; no raw firmware image or protected system DLL was committed.

The requested historical run 42604419519 is conclusively diagnosed: it failed in the unpacker link step because the linker could not find -lunix++. This was a build-environment/library-path failure, not a firmware-format failure. Later workflow revisions install libunixpp under /usr/local/lib64, link with -L/usr/local/lib64, and set LD_LIBRARY_PATH. The latest run passed the parser build and proceeded through firmware reconstruction and the later compatibility audits.

## What the latest run actually extracted

- UDA FPSX: the unpacker produced userarea.img, 41,206,272 bytes. This is user-area content, not the system ROM. Earlier FAT16 inspection found SYS/BIN and 432 files.
- PPM FPSX: the generic unpacker produced a 104,101,376-byte sparse flash-address rofs.img. That file is not a validated filesystem image.
- C0R/CORE FPSX: the generic unpacker produced PAPUBKEYS and an 82,740,224-byte sparse rofs.img. The latter is not the reconstructed system ROM.
- C0R SOS+ROFS: carved partition size 21,660,672 bytes. The generic parser emitted 1,441 files totaling 21,545,554 bytes, then exited with "cannot skip bytes". This is a partial tree, not a completeness-validated filesystem.
- PPM SOS+ROFX: carved partition size 18,904,576 bytes. The generic parser rejects the ROFx magic. A reversible magic-only probe changed only byte 0x403 in a temporary copy; it parsed 4,468 files totaling 18,490,107 bytes, then exited with "cannot skip bytes". The original image SHA-256 remained unchanged: c73e758536cdf4341d4600a80b99cc000b30d1d6236f06497546e63d96c2963d.

The PPM probe header is internally coherent: header size 48, format version 0x0200, directory-tree offset/size 0x01700030/32,284, file-entry offset/size 0x01707E4C/374,188. The official extension adjustment is 0x01700000, mapping the root directory to payload offset 0x30 and the file-entry block to 0x7E4C. The fact that thousands of entries parse after the one-byte magic change confirms that the existing parser's ROFx offset model is close; it does not establish that its final entry handling is correct.

## Independent format reference

The published Symbian source in SymbianRevive/symbian-headers/rofs.h defines the 48-byte TRofsHeader/TExtensionRofsHeader, TRofsDir and TRofsEntry structures. The corresponding SymbianRevive/symbian-build/imgtools/romtools/rofsbuild/r_coreimage.cpp implements the authoritative walk:

- ROFx adjustment = iDirTreeOffset minus the file position immediately after reading the extension header.
- Directory file blocks are read at iFileBlockAddress minus the adjustment.
- Subdirectories are read at iFileAddress minus the adjustment.
- Subdirectory entries advance by their declared iStructSize and are rounded to a 32-bit boundary.
- File-block entries advance by their declared iStructSize without that extra subdirectory alignment.
- The official ROFx file reader treats file addresses at or below iDirTreeOffset as references outside the extension image rather than local files.

The third-party unpacker uses a bounded BinaryReader window for each entry. Its "cannot skip bytes" exception is raised when a requested skip exceeds the current entry window. The current logs show the exception after the last printed root file entry, but do not identify the exact offending byte/entry. It is therefore premature to attribute this to damaged firmware. The next audit must identify the exact entry offset and distinguish a short trailing block from a malformed entry or a parser cursor/alignment mistake.

## Step106 implementation

Added tools/step106_audit_rofs_tree.py. It is read-only and independently parses both ROFS and ROFx directory structures using the Symbian field layout and offset-adjustment rule. It records per-entry offsets, directory/file counts, local file ranges, external ROFx references, trailing bytes, and the first structural error. It does not extract or alter firmware files.

Its synthetic tests cover a minimal ROFS image and a minimal ROFx extension image; both passed (2/2) before the commit. The firmware workflow now runs those tests and audits both carved C0R SOS+ROFS and PPM SOS+ROFX images. Structural anomalies are written to a report rather than hiding later workflow stages.

## System ROM and export tables already verified

The separate C0R SOS+CORE reconstruction succeeded:

- ROM base 0x80000000; ROM size 0x03A00000.
- Reconstructed image size 60,600,320 bytes.
- 12,671 pageable pages decoded; zero BytePair decode failures.
- ROM directory: 1 root and 2,726 entries; 25 XIP target modules; 15,412 raw export-address rows.

The seven requested target ROM modules are present. Their ROM/SDK export counts are:

| Module | UID3 | ROM exports | S60 3.1 FP1 SDK DSO exports |
|---|---:|---:|---:|
| EUSER | 0x100039E5 | 2,229 | 2,210 |
| CONE | 0x10003A41 | 722 | 721 |
| GDI | 0x10003B15 | 348 | 344 |
| FBSCLI | 0x10003A15 | 241 | 240 |
| EIKCORE | 0x10004892 | 590 | 590 |
| WS32 | 0x10003B21 | 580 | 578 |
| EFSRV | 0x100039E4 | 351 | 335 |

The latest workflow summary reports 5,061 selected symbolized export rows and 43 ROM-only export rows across the seven modules. These are address/export-table and SDK-name cross-checks; a matching name is not proof of runtime ABI equivalence. Raw ROM images and system DLL binaries remain excluded from Git.

## Next checkpoint

1. Inspect the Step106 audit output for both carved ROFS partitions and identify the first failing entry/block offset.
2. If the directory walk is structurally sound, add a separate, bounded extractor for local file extents only; preserve external ROFx references as unresolved base-image links.
3. Keep the C0R SOS+CORE export inventory as the authoritative source for N95 ROM exports. Do not substitute PPM/UDA content for ROM modules.
4. Do not request device actions until a concrete reversible package and rollback path are ready. No physical N95 launch has been demonstrated.
