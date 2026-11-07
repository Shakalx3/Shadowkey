# Shadowkey v8.4 — step 8: source buffer restored; bitmap output is the next blocker

## Major result: `source+0x14A3C` is now populated by the original game code

The exact writer is `sub_10015878`, called by `sub_1000FA7C` with the buffer returned from the game's resource loader. It allocates an array through EUSER ordinal 1507 and writes the returned guest address to `source+0x14A3C`.

A fresh trace now records:

- object base: `0x10111208`
- field address: `0x10125C44` (`source+0x14A3C`)
- actual write: `0x1018AF58`
- repeated subsequent reads of `0x1018AF58`

This is a real guest allocation and a write performed by the original lifted game path. No pointer was substituted into this field.

## Why the earlier OOB happened

The test harness had a heap/stack overlap. The guest stack was at `0x10180000`, while the test heap was extended through `0x101F0000`. Loading `StringTable.eng` allocated 338,078 bytes from `0x101386B8`; the allocation's zero-fill crossed the active stack and corrupted the saved frame/registers.

Corrected the test memory map:

- heap: `0x10110000 .. 0x101FF000`
- stack top: `0x102FF000`
- SIMKIN image begins at `0x10200000`, so the heap ends before it; the stack remains above the SIMKIN image.

Also removed the diagnostic `0x101D0000` graphics-buffer surrogate and the explicit `0x101D0000` argument override from the lifted path. The test no longer pretends a missing FBS object exists.

## Resource loader progress

Implemented EFSRV ordinal 185 as call-site-derived `RFile::Size(TInt&)` HLE. The call uses `r0=RFile`, `r1=TInt*`; the caller immediately uses the output value as allocation size. Symbian API documentation confirms `RFile::Size(TInt&)` returns the file size through the reference argument. The exact FP1 export ordinal/name pair is not yet confirmed by an FP1 export table, so the mapping remains high-confidence ABI inference rather than table proof.

The new unit test opens the actual `menu_sprites.txt`, checks that ordinal 185 writes 252, and closes the file. In the engine trace, `StringTable.eng` is measured at 338,078 bytes and read into its allocated buffer. A `global.spr` resource at offset `0x163B1F`, size `0x9444` (37,956 bytes), is also read completely.

## Current stop: missing bitmap output buffer from FBSCLI ordinal 17

The image decoder call is now reached with valid input data:

- `sub_1006A488` receives the `global.spr` resource buffer `0x101E94B0`.
- The encoded dimensions are `176 x 208` (`b0 00 d0 00`).
- Its output pointer argument is zero.
- It stops at `OOB 00000000/2` while processing the image.

The zero output pointer comes from the unresolved `FBSCLI ordinal 17` call. The trace shows that import returning zero. The caller stores the return in `engine+0x300`, then `sub_1000EA00` carries it into `large+0x47C/+0x480`.

Independent call-site evidence in `sub_1002256C` is stronger: it calls FBSCLI ordinal 17 with the bitmap-like object in `r0`, stores the return at `large+0x480`, then passes that value as the destination of a `memset` of `0x11E00` bytes (= 176*208*2). Therefore ordinal 17's return is used as the backing pixel-buffer pointer for a 176x208, 16-bit surface. The exact exported API name is still unknown; do not guess a symbol name or fabricate a pointer.

## Files changed

- `shadowkey_lifted_v6.c`: removed the explicit synthetic `0x101D0000` pointer override; original guest arguments are preserved.
- `shadowkey_engine_init_test.c`: moved stack to `0x102FF000`, extended heap only to `0x101FF000`, removed synthetic graphics surface injection.
- `shadowkey_appui_construct_test.c`: moved stack to `0x102FF000` for a consistent non-overlapping test map.
- `shadowkey_hle_vfs_trace.c`: added EFSRV ordinal 185 `RFile::Size(TInt&)` behavior; ordinal name remains ABI-inferred pending FP1 export table.
- `shadowkey_efsrv_size_test.c`: new focused test for the 252-byte `menu_sprites.txt` file size result.
- `build_and_test.sh`: compiles/runs the new EFSRV size test.
- `shadowkey_frontier_regression.py`: checks the no-synthetic-pointer frontier and expected FBSCLI17 stop.
- `trace_asset_loader_vfs.sh`: now runs the frontier regression rather than the obsolete regression that expected synthetic CONE/GC stubs.

## Verification

- `build_and_test.sh`: PASS.
- `build_arm11_core.sh`: PASS.
- `build_arm11_linkcheck.sh`: PASS; statically linked ARM ELF has no undefined symbols.
- `trace_asset_loader_vfs.sh`: reaches and verifies the new diagnostic frontier. The emulator still intentionally stops at `OOB 00000000/2` in `sub_1006A488` because FBSCLI ordinal 17 is unresolved. The frontier regression PASS means the trace reached the expected blocker, not that the game launched.

## Next step

Resolve FBSCLI ordinal 17 from the exact S60 3rd Edition FP1 `fbscli.lib`/ROM export table, or continue an ABI audit of the bitmap object and all three ordinal-17 call sites. Only after its real semantics are established should a bitmap-buffer HLE be implemented. No fake pointer or arbitrary surface allocation should be used.

No real Nokia N95 launch has been tested.
