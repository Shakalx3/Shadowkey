# Step118 — bulk Symbian-native E32 decompression and audit

Date: 2026-11-13

## Baseline

- Default branch: `main`
- Baseline commit: `89d73bdacdf56bfa3dc9ef2a9de25a186392d4df`
- Latest firmware workflow: [43414529084](https://github.com/Shakalx3/Shadowkey/actions/runs/43414529084), completed successfully.
- Historical run [42604419519](https://github.com/Shakalx3/Shadowkey/actions/runs/42604419519) failed before parsing at link time because `ld` could not find `libunix++`; later workflows corrected the library search path. It is not a firmware-format failure and should not be rerun.

## Verified Step117 result

The pinned upstream `fedor4ever/elf2e32` tool at `ecfc39742dce03f3a5f4d83db18e8c1f395f3c47` successfully decompressed one sample for each compression UID:

- Deflate UID `0x101F7AFC`: `sys/bin/20009B76.dll`, 5,767 → 9,976 bytes.
- BytePair UID `0x102822AA`: `sys/bin/NmSchemeHandler.dll`, 1,685 → 2,448 bytes.

Both passed Step117's UID preservation, zero-compression-UID, code-offset and output-size checks. This establishes that the upstream native decompression path works for at least one real image of each format. It does not yet establish that every candidate is decodable.

The follow-on Step109 parser found two EPOC candidates in the decompressed sample tree but classified both as REJECTED. The previous workflow printed only aggregate status counts, not the per-file reasons. Step118 therefore expands the decompression run to all 135 candidates and emits a text-only per-module reason table from the Step109 flat-image audit.

## UDA result

The UDA FPSX container is parsed into a 41,206,272-byte sparse `userarea.img`, but Step112 finds no valid FAT16 BPB at offset zero, an MBR FAT16 partition start, or any 512-byte-aligned offset in the image. Step115 records the H2E/SOS-USER payload as 115,200 bytes at source offset 41,097,587, with a structured binary prefix beginning:

`6004000002000000C800000024000000C0000000260000003000000001000000`

The prefix is not a FAT boot sector. The payload's internal format remains unidentified; do not label UDA corrupt or claim that its filesystem was extracted. Next UDA work should identify the H2E payload format and check whether the package's UDA asset is a complete user-volume image or only a small provisioning/metadata block.

## Step118 acceptance criteria

- Run the native decoder against all Step109 `COMPRESSED_UNDECODED` candidates (limit 0 means no per-compression cap).
- Preserve source SHA-256 checks and output-only writes in the temporary workflow workspace.
- Independently parse the decompressed tree with Step109 and publish all module status/reason rows, export/import row counts and any missing candidates.
- Do not commit firmware, ROM pages or protected system DLL binaries.
- A structural PASS is not a loader test and is not proof of N95 runtime compatibility.

No handset actions are requested by this checkpoint.
