# Step111 — ROFx merge, RM-320 ROM exports, and E32 inventory gate

Date: 2026-11-12

## Historical run 42604419519

The requested historical firmware run [42604419519](https://github.com/Shakalx3/Shadowkey/actions/runs/42604419519) completed with failure at the final link of the Nokia unpacker:

```text
ld.bfd: cannot find -lunix++
make: *** [Makefile:29: unpacker] Error 1
```

The unpacker objects had compiled. This was a CI dependency/library-search-path problem, not evidence that the UDA, PPM, or C0R firmware payloads were malformed. Later workflow revisions installed libunixpp under /usr/local/lib64 and supplied the library path. The old run is superseded by the successful firmware run below; it should not be rerun.

## Latest successful firmware reconstruction

The latest fully successful firmware baseline is workflow [43212434654](https://github.com/Shakalx3/Shadowkey/actions/runs/43212434654), commit `da975370f972f2acec11a75cb5ad54e1c427ca89`. It completed the extraction, Step96 ABI, Step99 DLL conversion, Step102 EKA2 loader-probe build, Step109 merge, and ROM-export inventory. The earlier [43210325818](https://github.com/Shakalx3/Shadowkey/actions/runs/43210325818) run also passed and published the first Step102 probe release.

### UDA, PPM, and C0R interpretation

| Input | Verified output | Interpretation |
|---|---|---|
| UDA FPSX | `uda/userarea.img`, 41,206,272 bytes | User-area image, not the system ROM. The current workflow emits the image but does not yet produce a verified directory tree. A read-only FAT16 audit has been added as Step112 and still needs to run against this image. |
| PPM FPSX | `ppm/rofs.img`, 104,101,376 bytes | Sparse flash-address image, not a directly extracted filesystem. Its SOS+ROFx extension is carved and reconstructed separately. |
| C0R / CORE FPSX | `core/rofs.img`, 82,740,224 bytes, plus PAPUBKEYS | Sparse flash-address image. It contains separate SOS+ROFS and SOS+CORE partitions. |

The generic unpacker still rejects the carved PPM ROFx magic and stops on the C0R ROFS tree with `cannot skip bytes`. These are parser limitations, not failed firmware acquisition. The independent Symbian-layout parser and bounded extractor now handle the metadata and local extents.

### C0R base ROFS and PPM ROFx merge

The successful Step106/108/109 results in run 43210325818 are:

| Image | Directories | Entries | Local files | External references |
|---|---:|---:|---:|---:|
| C0R SOS+ROFS | 275 | 1,441 | 1,441 | 0 |
| PPM SOS+ROFx | 315 | 5,909 | 4,468 | 1,441 |

Step109 resolved all 1,441 ROFx external references against the C0R base by the exact tuple of file address, case-insensitive full path, size, and UID bytes. The production merge result was:

- Status: PASS
- Resolved external references: 1,441
- Unresolved external references: 0
- Extension-local files: 4,468
- Extension overrides: 0
- New extension files: 4,468
- Base files absent from extension tree: 0
- Merged tree: 5,909 files, 40,035,661 bytes
- EPOC-signature candidates: 135

This is a verified merged filesystem tree for the supplied matching C0R/PPM package. It is not a ROM flash image and does not authorize writing anything to the handset.

## Reconstructed RM-320 v35.0.001 SOS+CORE ROM

The separate C0R SOS+CORE reconstruction passed:

- ROM base: `0x80000000`
- ROM size: `0x03A00000`
- Reconstructed bytes: 60,600,320
- Pageable pages decoded: 12,671
- Decode failures: 0
- ROM directory entries: 2,726
- XIP target modules: 25
- Raw export rows: 15,412

Step91 found all seven requested target modules and cross-checked their export counts against the pinned S60 3.1 FP1 SDK DSOs:

| N95 ROM module | UID3 | ROM exports | SDK DSO exports | ROM-only exports |
|---|---:|---:|---:|---:|
| EUSER | 0x100039E5 | 2,229 | 2,210 | 19 |
| CONE | 0x10003A41 | 722 | 721 | 1 |
| GDI | 0x10003B15 | 348 | 344 | 4 |
| FBSCLI | 0x10003A15 | 241 | 240 | 1 |
| EIKCORE | 0x10004892 | 590 | 590 | 0 |
| WS32 | 0x10003B21 | 580 | 578 | 2 |
| EFSRV | 0x100039E4 | 351 | 335 | 16 |

Across all 25 target modules, Step91 symbolized 15,325 of 15,412 raw export rows against SDK DSO names. The selected import audit contains 5,061 rows. Step94 disassembled and inventoried the 43 ROM-only exports in the seven focus modules. The SDK-name match is evidence for a candidate symbol identity, not proof of runtime ABI compatibility.

Key ARM UREL import results:

| Original N-Gage import | N95 target result |
|---|---|
| EUSER 1407, TPtrC16 constructor | EUSER 1169, signature match |
| EUSER 1575, TInt64::operator!=(TInt64 const&) const | No target signature |
| CONE 160, CCoeControl::Rect() const | CONE 276, signature match |
| EIKCORE 224, CEikAppUi constructor | EIKCORE 178, signature match |
| GDI 151, TFontSpec constructor | GDI 169, signature match |
| GDI 101, TFontStyle::SetPosture | GDI 12, signature match |
| GDI 108, TFontStyle::SetStrokeWeight | GDI 14, signature match |

Step95/96/100 independently confirm that target S60 3.1 FP1 GCCE treats TInt64 as an 8-byte signed built-in type, while the N-Gage ARM UREL import refers to the old two-word TInt64 class member. The target EUSER DSO has no matching legacy member export. Do not redirect ordinal 1575 to the unrelated N95 API at the same ordinal.

## Candidate E32 files: next validation

Step108/109 originally labelled the 32-bit word at file offset 0x14 as `cpu`. That was incorrect for these EKA2 filesystem images: the existing EKA2 inspectors identify offset 0x14 as the E32 header CRC; the legacy EKA1 header uses a different layout. The TSV/manifest field is corrected to `header_crc` in both extractors.

Added `tools/step111_validate_rofs_e32_candidates.py`. It will validate the 135 merged EPOC-signature candidates using the S60 3.1 FP1 EKA2 header layout, bounds-check export tables, inspect import descriptors and compare uncompressed IAT values to import ordinals. It emits text/JSON/TSV inventories only. Its five synthetic tests are included in the next firmware workflow run. Compressed payloads will be classified as partially validated unless decompressed; header CRC values are recorded but not recomputed.

The first Step111 validator run ([43212434654](https://github.com/Shakalx3/Shadowkey/actions/runs/43212434654)) found that all 135 candidates carry a nonzero compression UID. It therefore reported 0 structurally valid files while still reading 1,104 candidate export rows; the common errors were offsets outside the compressed on-disk file. This is not evidence that all 135 files are corrupt. For compressed E32 images, the section offsets are interpreted after inflation, not against the compressed byte stream. The parser has to inflate the payload first.

The existing Step109 inventory has now been extended to inflate Deflate (UID 0x101F7AFC) and BytePair (UID 0x102822AA) E32 payloads before checking export/import tables. For compressed images, the 0x7C word carries the uncompressed size and the compressed stream starts at 0x80; section offsets are interpreted against the inflated image, not the compressed byte stream. The implementation records the original compression UID, inflates the payload, then validates export/import bounds and IAT ordinal values against the flat image. Its synthetic tests cover both algorithms. The first workflow attempt stopped in the self-test because an old fixture used an unsupported compression UID without an uncompressed-size field; that fixture was corrected. The current follow-up run is the first production test of the decompression path.

Format references: [BinaryBacktrace Symbian & N-Gage format notes](https://binarybacktrace.com/symbian-bible) (measured compressed E32 header and inflation behavior); [Symbian OS loader description](https://ips.gizmolord.com/topic/2523-symbian-os-the-loader/) (the loader detects and decompresses compressed E32 images).

The 135 filesystem candidates are separate from the seven XIP ROM modules above. An EPOC marker alone is not treated as proof of a valid E32 image.

## Artifact and hardware boundaries

The firmware job's final diagnostic artifact upload was rejected because GitHub Actions storage quota was full. The job log and GitHub job summary preserve the text audit. The small Step102 prerelease ZIP was published separately at [shadowkey-step102-43210325818](https://github.com/Shakalx3/Shadowkey/releases/tag/shadowkey-step102-43210325818); its SHA-256 is `9b5b1ea9305e0a31ada1c6d3f96d8fefd8fdcf5fdc1ad67bf7a9926d5c5def21`. That package is only an EKA2 DLL loader/ABI probe, not a Shadowkey game build.

No physical N95 test or Shadowkey launch has been performed. The user currently has no handset available. Do not request device actions, overwrite ROM DLLs, or flash firmware. The next useful gate is the Step111 E32-candidate validation followed by continued import/runtime analysis; a device test remains deferred until a concrete reversible package and rollback instructions exist.

## 2026-11-13 update — firmware/E32 inventory completed

The earlier historical run 42604419519 failed only because the final link could not find libunix++; later workflow revisions corrected the library path. The latest successful format-aware run is [43416779432](https://github.com/Shakalx3/Shadowkey/actions/runs/43416779432).

- PPM/C0R extraction and ROFx merge remain verified: 1,441 external references resolved, 0 unresolved, merged tree 5,909 files / 40,035,661 bytes.
- Step117 decompressed all 135 EPOC candidates: 134 Deflate and one BytePair.
- The format-aware Step109 parser reports 135/135 PASS, 2,752 export entries and 26,485 imports. All exports are valid.
- Step120 independently reports 135/135 VALID, all ELF import format, and the same export/import counts; synthetic tests PASS 3/3.
- Step119's PE-style IAT diagnostic is retained as a negative control only. It is not a validity verdict for ELF-format images.
- The seven requested XIP ROM modules remain separately inventoried above: EUSER has 2,229 exports (19 ROM-only), CONE 722 (1 ROM-only), GDI 348 (4), FBSCLI 241 (1), EIKCORE 590 (0), WS32 580 (2), and EFSRV 351 (16).
- Target GCCE ABI validation passed: TInt64 is 8 bytes; TTrap is 76 bytes with offsets 0/64/68/72; Trap(TInt&) is an instance method and UnTrap() is static. The N95 EUSER DSO has no legacy TInt64::operator!= export, so do not guess an ordinal replacement.
- The isolated E32 DLL and Step102 EKA2 loader-probe package were built. Release: [shadowkey-step102-43416779432](https://github.com/Shakalx3/Shadowkey/releases/tag/shadowkey-step102-43416779432), SHA-256 4f5f55f86cfe17c65e8e181f2a81c341e81b7d4900ae7e89ef31fe610d53aea3. This is not a game build and has not been loaded on a physical N95.
- UDA remains unresolved at the filesystem level: sparse userarea.img is 41,206,272 bytes, no FAT16 volume was found, and the H2E/SOS-USER payload is 115,200 bytes at image offset 41,091,072. Its internal format is still unknown.
- No firmware, ROM page or protected system DLL was committed. No handset action is requested; the user currently has no phone available.
