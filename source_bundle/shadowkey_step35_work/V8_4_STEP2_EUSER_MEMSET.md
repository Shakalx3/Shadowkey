# Shadowkey v8.4 — step 2: EUSER ordinal 1 and source-field watch

Date: 2026-11-02

## Confirmed export identity

`EUSER[100039e5].DLL` ordinal **1 is `memset`** for the Symbian 6.1 / Series 60 SDK export library.

Primary reference: SET ezine issue 33 (October 2006), article section that unpacks `euser.ids` and independently runs `AR2IDT.EXE` over the actual SDK library:

- `C:\Symbian\6.1\Series60\Epoc32\Release\armi\urel\euser.lib`
- The resulting export listing explicitly records ordinal 1 as `memset`, ordinal 2 as `memcpy`, and ordinal 3 as `newL__5CBaseUi`.
- Source URL: https://www.set-ezine.org/ezines/set/pdf/set33.pdf#page=1 (relevant extracted lines 7946–8003).

This also disproves the earlier allocator interpretation for ordinal 1. The 42 static call sites in Shadowkey agree with the C ABI: `r0=destination`, `r1=fill byte`, `r2=byte count`.

## Code changes

1. Implemented ordinal 1 in both runtime HLE paths:
   - `shadowkey_hle_bootstrap_v2.c`
   - `shadowkey_hle_vfs_trace.c`
2. The HLE applies the low byte of `r1` for `r2` bytes, validates the guest-memory range, and returns the destination in `r0`.
3. Added a direct ABI regression in `shadowkey_appui_construct_test.c`: 13 bytes are filled with `0xA5`, the following bytes must remain unchanged, and `r0` must return the destination.
4. Added a trace regression requiring the known zero-fill at `0x10162918` (`0x8F00` bytes) to execute through the recovered `memset` HLE.
5. Added a watch on `source+0x14A3C` and a call trace for the virtual entry into `sub_100298A4`.

## Reproduced initialization chain

Fresh trace confirms:

- Large source object allocated at `0x10111208`, size `0x14E14` (85,524 bytes).
- The allocator's initial zero-fill covers the object. The watched field address is `0x10125C44` (`0x10111208 + 0x14A3C`).
- The only write observed overlapping that field during this run is the allocator's initial zeroing. No later scalar write, `memset`, or `memcpy` overlapping the field was observed before the fault.
- Parent object `0x10138798` has vtable `0x100FB908`; vtable slot `+0x10` resolves to `sub_100298A4` at `0x100298A4`.
- Parent `+0x14` contains `0x10111208`, confirming the source pointer passed onward.
- The indirect call originates at return address `0x10024A84` in the engine initialization path.
- `sub_100298A4` allocates the nested object at `0x10176B38` and calls `sub_1001F9AC` with source `0x10111208`.
- `sub_1001F9AC` reads `source+0x14A3C == 0`, then faults when reading `[0 + 0x80]`.

The constructor path includes `sub_1000EA00`, `sub_1000EB58`, and `sub_1000ECBC`; none of the executed writes in this run populates the watched field. No field name or semantic type is assigned yet.

## Validation

- `./build_and_test.sh` — PASS.
- `./trace_asset_loader_vfs.sh` — PASS (milestone regression).
- `python3 shadowkey_gc_trace_regression.py .build/asset_vfs_trace.log` — PASS.
- The diagnostic VFS run still deliberately exits at the bounds-checked `OOB 00000080/4` on the null field. This is the expected current blocker, not a passing game launch.

## Next investigation

Trace the source object's missing subobject provider rather than patching the pointer. Prioritize the unresolved platform/framework calls on the startup path (including `FBSCLI` ordinal 17 and the `CONE`/`WS32` calls around `sub_10022898`) and determine whether an omitted native bitmap/window-server object or an unexecuted initialization callback should populate `0x10125C44`. These are leads only; none is yet proven to write the field.

The CONE GC objects remain synthetic diagnostic objects. There is no native rendering, E32Image install build, or real Nokia N95 launch in this step.
