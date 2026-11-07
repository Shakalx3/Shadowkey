# Shadowkey v8.4 — step 10: FBS chunk mapping and Bitmap DataAddress

## Result

The FBS bitmap-data pointer path is now implemented in the host HLE and the current trace passes the previous null-buffer frontier.

The guest call sequence at startup is:

1. `FBSCLI ordinal 135`, `r0=0x10110718`: constructor for a 24-byte bitmap handle object (high-confidence inference).
2. `FBSCLI ordinal 16`, `r0=0x10110718`, `r1=0x102FED04`, `r2=10`: the pointed `TSize` is `{176,233}`. The signature matches `CFbsBitmap::Create(TSize&,TDisplayMode)` (high-confidence inference).
3. `FBSCLI ordinal 17`, with only `r0=0x10110718` deliberately set at all three call sites: returns a direct pixel-data address. The signature and consumer behavior match `CFbsBitmap::DataAddress()` (high-confidence inference).

The `r1` value visible at the ordinal-17 call is stale from the preceding helper; it is not a filename parameter. The three call sites establish that only the bitmap receiver is intentionally passed.

## Chunk model

The cross-version Symbian FBS architecture reference documents two separate named chunks:

- `FbsSharedChunk`: a 64 KiB shared heap containing bitmap metadata/header structures.
- `FbsLargeChunk`: a separate, initially disconnected chunk used for larger pixel allocations.

A client-visible pixel pointer is reconstructed as `FbsLargeChunk.Base() + dataOffset`. The local implementation models that observable behavior, rather than returning a host pointer or borrowing memory from the EUSER heap.

The HLE guest address map reserves non-overlapping guest ranges above the original 3 MiB image map:

| Region | Guest address | Current role |
|---|---:|---|
| Shared chunk | `0x10300000` | 64 KiB; internal bitmap metadata record at `0x10300100` |
| Large chunk | `0x10310000` | pixel allocations; current first allocation at offset `0x1000` |
| Returned pixel address | `0x10311000` | `largeBase + 0x1000` |

For this observed object, Create receives size `176×233`, mode value `10`. The implementation uses a two-byte pixel stride (352 bytes) because the guest consumer explicitly clears `176×208×2 = 73,216` bytes. The full created surface therefore reserves `176×233×2 = 82,016` bytes, enough for that clear. The mode value is kept as an observed numeric value; its exact old-SDK enum name is not proven.

The shared-chunk metadata record used by this HLE is an internal model, not a byte-for-byte copy of the Symbian `CBitwiseBitmap` header. It carries the size/mode/stride and the large-chunk-relative data offset; ordinal 17 reads that offset and returns `largeBase + offset`.

## Verification

- `./build_and_test.sh` — PASS, including a new FBS chunk unit test.
- `./trace_asset_loader_vfs.sh` — PASS against the new frontier regression.
  - `StringTable.eng` is loaded and sized.
  - `global.spr` resource is read completely.
  - Bitmap object `0x10110718` is constructed and created as `176×233`, mode `10`.
  - DataAddress returns `0x10311000`, inside the mapped FbsLargeChunk region.
  - The image decoder is entered with this non-null pointer; the old `OOB 00000000/2` null-destination failure is gone.
  - The run advances to a new frontier: EIKCORE ordinal 243 is called with a null receiver and the next fault is `OOB 00000000/4`, LR `0x10023214`.
- `./build_arm11_core.sh` — PASS.
- `./build_arm11_linkcheck.sh` — PASS; statically linked ARM ELF, no undefined symbols.

The diagnostic re-fetch after the decoder path still sees zero-filled pixel contents (`0/82016` nonzero bytes). Thus the address/size/chunk mapping is verified, but successful image pixel decoding is NOT yet verified. The next EIKCORE failure and the decoder's pixel population remain separate tasks.

## Limits / what is not claimed

- This is an HLE model of the client-visible FBS chunk semantics. It does not yet emulate the full Font & Bitmap Server IPC protocol, kernel global-chunk handles, heap defragmentation/locking, or dynamic large-chunk growth.
- The exact N-Gage S60 1st Edition FP1 export names for ordinals 135/16/17 are inferred from call ABI and dataflow; no FP1 export-address-table proof is available in the workspace.
- No real Nokia N95 device launch has been performed. This is not a complete game boot.

## Changed files

- `shadowkey_fbs_hle.c`, `shadowkey_fbs_hle.h`: two-chunk metadata/data model and constructor/Create/DataAddress handlers.
- `shadowkey_fbs_chunk_test.c`: unit test for header offset → large-chunk base+offset resolution and surface bounds.
- `shadowkey_hle_bootstrap_v2.c`, `shadowkey_hle_vfs_trace.c`: route FBSCLI 135/16/17 into the shared HLE.
- `shadowkey_runtime_core.c`, `shadowkey_engine_init_test.c`, `shadowkey_appui_construct_test.c`, `shadowkey_efsrv_size_test.c`: extend the test guest map to 4 MiB.
- `build_and_test.sh`, `trace_asset_loader_vfs.sh`, `build_arm11_core.sh`, `arm11_freestanding_stubs.c`: build/test integration and ARM link helper.
- `shadowkey_frontier_regression.py`, `shadowkey_fbscli17_abi_audit.py`: assert the new FBS milestone and inferred call contracts.
