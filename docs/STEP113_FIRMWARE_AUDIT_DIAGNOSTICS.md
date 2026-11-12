# Step113 — UDA audit and compressed E32 diagnostics

Date: 2026-11-12

## Baseline inspected before this change

- Default branch: main
- Baseline commit: f1de8990a9033fc9ac4b88ba9fcfc5d0ecbbd46c
- Latest firmware workflow: [43214005239](https://github.com/Shakalx3/Shadowkey/actions/runs/43214005239), completed successfully at commit f1de8990a9033fc9ac4b88ba9fcfc5d0ecbbd46c.
- Historical run [42604419519](https://github.com/Shakalx3/Shadowkey/actions/runs/42604419519) failed at link time with ld.bfd: cannot find -lunix++. The unpacker objects had compiled; this was a CI library-search-path problem, not proof that UDA/PPM/C0R payloads were malformed. Later runs corrected the library path. Do not rerun the historical failure.

## Verified firmware reconstruction

The successful firmware pipeline has established:

- UDA FPSX produces firmware-parsed/uda/userarea.img, 41,206,272 bytes. This is the user-area image, not the system ROM. The earlier Step73 FAT16 scan found SYS/BIN and 432 files, but the dedicated Step112 audit had not yet been wired into the current workflow.
- PPM FPSX produces a 104,101,376-byte sparse flash-address image; C0R produces an 82,740,224-byte sparse image. Their carved SOS+ROFx and SOS+ROFS partitions are parsed separately.
- The matching C0R base ROFS has 1,441 local files. The PPM ROFx has 4,468 local files and 1,441 external references. Step109 resolved all 1,441 references using the exact tuple (file address, case-insensitive full path, size, UID bytes), producing a 5,909-file merged tree (40,035,661 bytes). No unresolved references remain.
- The separate C0R SOS+CORE path reconstructs a 60,600,320-byte ROM with 12,671 pageable pages, zero decode failures, 25 XIP modules and 15,412 raw export rows.

The seven target ROM modules and their raw export counts remain:

| Module | UID3 | ROM exports |
|---|---:|---:|
| EUSER | 0x100039E5 | 2,229 |
| CONE | 0x10003A41 | 722 |
| GDI | 0x10003B15 | 348 |
| FBSCLI | 0x10003A15 | 241 |
| EIKCORE | 0x10004892 | 590 |
| WS32 | 0x10003B21 | 580 |
| EFSRV | 0x100039E4 | 351 |

These are metadata/export inventories from the reconstructed XIP ROM; protected system DLL binaries are not committed.

## Step96 / Step100 target ABI — complete

The latest successful run again compiled the pinned S60 3.1 FP1 GCCE probes:

- sizeof(TInt64) == 8.
- sizeof(TTrap) == 76; member offsets iState/iNext/iResult/iHandler = 0/64/68/72.
- TTrap::Trap(TInt&) is an instance method and TTrap::UnTrap() is static. The object has unresolved references to those target imports; this is compile-time ABI evidence, not a runtime leave/trap test.
- Step100 proves target TInt64 is a signed, non-class 64-bit built-in. The ARMv5TE disassembly for inequality loads words at [r0] / [r1], compares them, then loads [r0,#4] / [r1,#4] if needed; the boolean result is returned in r0. The inequality routine has no helper import. 64-bit division separately emits __aeabi_ldivmod.

This matches the key reason the N-Gage ARM UREL import EUSER ordinal 1575 has no direct N95 export: the legacy N-Gage 6.1 SDK declared a two-word TInt64 class member, whereas S60 3.1 FP1 GCCE treats TInt64 as a built-in type. The N95 ordinal 1575 is a different API and is not a safe alias.

## Step109 compressed E32 inventory — unresolved production decode

The latest run found 135 EPOC-signature E32 candidates in the merged filesystem:

- 134 use compression UID 0x101F7AFC (Deflate).
- 1 uses 0x102822AA (BytePair).
- The current Step109 parser's synthetic tests pass 7/7, but production decoding still yielded zero inflated modules, zero structurally valid modules, and zero decoded export/import rows.

The existing parser tries zlib-wrapped and raw Deflate and has a bounded BytePair decoder. That does not prove its interpretation of the compressed-image header is correct. The next run now records the actual decoder failure counts plus only short compression-header and payload prefixes (no module code) in the text report. Use those concrete bytes/errors to decide whether the uncompressed-size field, payload start, wrapper, or BytePair header interpretation is wrong. Do not guess offsets or mark candidates valid based only on EPOC/UID fields.

## Step112 UDA FAT16 audit — now wired into CI

The read-only Step112 tool already has two synthetic tests for a FAT16 volume and an MBR-partitioned volume. The first integration run, 43219534563, exposed a CLI contract: --image is required even when --self-test is supplied. The workflow now invokes the self-tests and the actual UDA image audit in one command, satisfying both requirements. The audit validates the BPB, FAT16 cluster chains, directory tree and presence of SYS/BIN; it does not modify or extract files.

A valid UDA tree is independent of the C0R/PPM ROFS/ROFx system filesystem and must not be mistaken for system ROM content.

## Step103 local-shim patch — structural progress, checksum gate remains closed

The latest read-only Step103 audit confirms:

- Legacy import: EUSER UID3 0x100039E5, ordinal 1575; import block 9, ordinal index 95; global IAT index 298.
- IAT slot VA 0x101007E8; ARM thunk 0x1009F240; one literal at file offset 0x0009F2C8 points to the IAT slot.
- 415 IAT slots across 20 DLL blocks. A proposed split-and-append import-table layout grows the table by 48 bytes without changing IAT slot count.
- The selected EKA1 code-relocation parse (size field excludes the 8-byte relocation header) consumes 168 blocks and exactly 10,104 relocation entries. All 415 word-aligned IAT literal references have matching relocation records. A separate unaligned byte scan also finds 40 incidental matches; these are not counted as IAT relocation coverage.

However, the stored code checksum is 0x67F7151E, while the current code computes 0x63829213 over text_size and 0x6387532B over code_size. Public PETRAN source documents E32ImageFile::CheckSumCode() as summing iCodeSize 32-bit words from iCodeOffset, and its HMem::CheckSum adds those words. The observed mismatch is still unexplained. It may indicate a post-link modification or a remaining layout/coverage error; neither is established. Do not write a patched 6R51.APP until this discrepancy is resolved and a separate-copy checksum/relocation verification is available.

Reference source: https://github.com/loociano/symbian-build-tools/blob/master/e32tools/PEFILE/PE_IMG.CPP and https://github.com/loociano/symbian-build-tools/blob/master/e32tools/HOST/H_MEM.CPP

## Step102 first-device package boundary

The latest workflow published [shadowkey-step102-43214005239](https://github.com/Shakalx3/Shadowkey/releases/tag/shadowkey-step102-43214005239), asset Shadowkey-Step102-FirstDeviceTest.zip, SHA-256:

28bafa3b60a7e4db64e80358fab97d8950de4741e0e01f0526e5910d5a2223c2

It contains only a custom test DLL, a bare E32Main loader-probe EXE, a README and checksums. It is not a Shadowkey build and is not a registered S60 menu application. It requires an already-authorized writable sys/bin and an existing trusted launcher capable of starting a raw E32 EXE. No live loader test or game launch has occurred. Do not ask the user to install it until the authorized transfer/launch path and rollback steps are concretely confirmed.

The Actions diagnostic artifact upload is still rejected because repository Actions storage quota is full; text results remain in the job log/summary and the small Step102 release asset is published separately.

## Next gates

1. Run Step112 against the actual UDA image and review the FAT16 tree/errors.
2. Use the new Step109 decompression diagnostics to identify the actual Deflate/BytePair format mismatch; then validate real export/import tables.
3. Preserve the exact 43 ROM-only exports and continue import remapping without guessing ordinals.
4. Resolve the EKA1 code-checksum discrepancy before generating any import-table patch.
5. Keep all firmware inputs read-only; do not commit protected ROM binaries/system DLLs, overwrite ROM DLLs, or flash firmware.
