# Step114 — RM-320 UDA FPSX H2E field-order correction probe

Date: 2026-11-13

## Baseline inspected

- Default branch: main
- Baseline commit: 7d0fad184270e7bf37b33091ff34565ad2193bdf
- Latest firmware run before this checkpoint: [43220074735](https://github.com/Shakalx3/Shadowkey/actions/runs/43220074735), completed successfully.
- Historical requested run [42604419519](https://github.com/Shakalx3/Shadowkey/actions/runs/42604419519) failed while linking the unpacker because ld.bfd could not find -lunix++. Later workflow revisions fixed the library search path. That historical failure was not evidence of malformed UDA/PPM/C0R firmware.

## Current UDA result and discrepancy

The successful run 43220074735 extracted the UDA FPSX to userarea.img (41,206,272 bytes), but Step112 reported NO_FAT16_VOLUME_FOUND. Its earlier search window was limited to the first 2 MiB.

The UDA FPSX log reports an H2E block named SOS-USER with two 32-bit values:

- First value printed as Length: 115,200
- Second value printed as Offset: 41,091,072
- Output file size: 41,206,272 bytes

Inspection of the upstream parser shows the H2E branch reads the first value into length, the second into offset, then calls BinaryReader::extract(destination, offset, length). In the upstream BinaryReader::extract implementation, the output file is positioned at offset, then length bytes are read from the current source cursor and written. The resulting output length is therefore offset + length.

The observed file size is exactly:

41,091,072 + 115,200 = 41,206,272

The input UDA FPSX is 41,212,787 bytes. The alternative interpretation — destination offset 115,200 and payload length 41,091,072 — is consistent with the remaining input payload size and would place the user-area bytes near the start of the extracted image instead of at a sparse tail. This is strong format-consistency evidence, but remains a hypothesis until the corrected output passes the FAT16 BPB, FAT-chain and directory-tree checks.

Source inspected:
- [unpacker FPSX parser](https://github.com/saur0n/unpacker/blob/master/fpsx.cpp)
- [unpacker BinaryReader implementation](https://github.com/saur0n/unpacker/blob/master/REUtils.cpp)

## Step114 implementation

Added tools/step114_patch_uda_fpsx_unpacker.py. It patches only the BLOCK_TYPE_H2E / SOS-USER branch in the ephemeral CI clone:

1. Swap the two H2E 32-bit fields so the first is treated as destination offset and the second as payload length.
2. Require the payload length not to exceed the remaining FPSX input bytes.
3. Extract userarea.img with truncation enabled.
4. Leave all other FPSX block types unchanged.
5. Fail closed if the upstream source anchors or expected code sequence have changed.

The firmware workflow applies this patch before compiling the unpacker. PPM and C0R extraction use the same parser build, but their block type is unchanged by this patch.

Step112 now scans up to 128 MiB for a FAT16 BPB and adds a synthetic regression test with the BPB at 3 MiB. This avoids mistaking an arbitrary 2 MiB search cutoff for proof that no filesystem exists.

## Acceptance criteria

The field-order hypothesis is accepted only if the next firmware workflow reports all of the following from the corrected UDA image:

- A structurally valid FAT16 BPB
- Valid FAT16 geometry and bounded FAT table
- No FAT-chain or directory traversal errors
- A SYS/BIN directory
- A reproducible file/directory count and UDA image SHA-256

If those checks fail, retain both field interpretations as unresolved and inspect the actual H2E header bytes and payload boundary before changing the parser again.

## Safety and scope

- Firmware inputs remain read-only.
- Extracted UDA data is ephemeral CI output; no firmware image or protected DLL is committed.
- This is user-area extraction only, not ROM reconstruction.
- No firmware flashing or handset modification is involved.
- Step96 target GCCE checks remain compile-time ABI evidence: TTrap is 76 bytes with offsets 0/64/68/72; TTrap::Trap(TInt&) is an instance method and TTrap::UnTrap() is static. Step100 confirms target TInt64 is a signed built-in type, explaining why legacy N-Gage EUSER 1575 has no direct N95 signature.
