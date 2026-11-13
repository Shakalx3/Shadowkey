# Step114 — RM-320 UDA FPSX H2E field-order experiment (not validated)

Date: 2026-11-13

## Baseline

- Default branch: main
- Original baseline commit: 7d0fad184270e7bf37b33091ff34565ad2193bdf
- First experiment commit: 0b001ccabaf46a74ee67abb2252e382a22a882d6
- Follow-up implementation-fix commit: 4268c11c033d53b5c92c966ea72602e93177f2f3
- Validation run: [43409312931](https://github.com/Shakalx3/Shadowkey/actions/runs/43409312931), overall workflow completed successfully.

## Hypothesis and why it was tried

The upstream FPSX H2E branch reads two 32-bit values as length then offset and calls BinaryReader::extract(destination, offset, length). BinaryReader::extract seeks the output to offset, then copies length bytes from the current source cursor. The original parser log showed Length=115,200 and Offset=41,091,072, while the resulting sparse file size was 41,206,272 (= 41,091,072 + 115,200). Swapping the field interpretation appeared arithmetically plausible, but that alone was not proof of the actual H2E layout.

## Actual result — hypothesis rejected

The field-swap experiment did not produce a usable UDA image:

- The patched parser reported Destination offset=196,608, Payload length=0, Payload available=41,212,542 and Unknown=196.
- The UDA parser then encountered block type 0x90 and exited with an unknown-block-type error.
- The generated userarea.img was 0 bytes.
- Step112 reported NO_FAT16_VOLUME_FOUND on a 0-byte image.
- The complete workflow itself finished successfully, but that success only means the diagnostic pipeline completed; it does not mean UDA extraction succeeded.

Therefore the proposed first-field=destination-offset / second-field=payload-length interpretation is NOT accepted. The earlier arithmetic match was insufficient and may have been coincidental or affected by a header-boundary misunderstanding.

## Follow-up

Step115 supersedes this experiment. It restores the upstream H2E read/extract semantics and instruments the raw header bytes, the source cursor at payload start, the available payload length and the first 64 payload bytes. No further field-order changes should be made until those bytes are inspected.

The Step112 scanner now checks up to 128 MiB and its synthetic late-BPB test passes (3/3); the real UDA result remains unresolved.

## Safety

No firmware image or protected system DLL is committed. The field-swap script remains in the repository as a historical experiment only and is no longer invoked by the firmware workflow. No handset or flashing operation is involved.
