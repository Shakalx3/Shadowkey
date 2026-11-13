# Step115 — instrument the RM-320 UDA FPSX H2E block

Date: 2026-11-13

## Baseline and evidence

- Branch: main
- Baseline commit: 821a97117adda539665e37bc073a7962f1287e85
- Prior run: [43409312931](https://github.com/Shakalx3/Shadowkey/actions/runs/43409312931)
- Step114's field-order swap produced a zero-byte UDA output and is explicitly rejected; see STEP114_UDA_FPSX_FIELD_ORDER_CORRECTION.md.
- The original parser run showed H2E / SOS-USER values 115,200 and 41,091,072, but the field meanings and header boundary are not yet established.

## Step115 change

The workflow now applies tools/step115_instrument_uda_h2e.py to the temporary upstream unpacker source before compilation. The instrumentation is restricted to BLOCK_TYPE_H2E and:

1. Copies the H2E header reader and logs the raw header bytes, including the extra trailing byte read by the upstream parser.
2. Logs the absolute source cursor and remaining source bytes at the start of the H2E payload.
3. Logs only the first 64 payload bytes.
4. Preserves the original length/offset read order and the original extraction behavior.
5. Fails closed if the upstream branch anchors or expected read order change.

This should distinguish a wrong field interpretation from a header-size / cursor / block-boundary problem without changing the UDA data.

## Step112 audit

The FAT16 scanner now searches up to 128 MiB rather than stopping after 2 MiB. Its self-tests pass 3/3, including a synthetic FAT16 volume whose BPB begins at 3 MiB. This is a scanner test only; it does not prove the real UDA contains FAT16.

## Next decision gate

Use the raw header and payload prefix from the next run to identify the H2E field boundaries. Only then implement a dedicated extractor. Accept a filesystem result only after validating the BPB geometry, FAT chains, directory tree and SYS/BIN inventory. Do not infer success from a nonzero image size or a successful CI job.

No firmware binaries or protected DLLs are committed. No ROM files are overwritten and no flashing is requested.
