# v8.4 step 1 — reproducibility and next-blocker audit

Date: 2026-11-01

## Reproduction

From the bundle root:

```sh
./build_and_test.sh
./trace_asset_loader_vfs.sh
```

Both scripts completed their expected diagnostic checks in a fresh extraction.

## Verified results

- The native host build and app/UI construction regression pass.
- The CONE ordinal-226 analysis reports four this-only call sites and infers `CCoeControl::SystemGc()` with high confidence (the export-table identity is not independently proven in this bundle).
- The VFS trace returns a stable synthetic GC object and synthetic drawable window; diagnostic Activate/Deactivate dispatches complete.
- `StringTable.eng`, `global.spr`, `entities.txt`, and `menu_sprites.txt` are opened by the trace. The blank-path open is also visible and fails.
- The trace advances past the old ordinal-226 null-return crash and halts at `OOB 00000080/4`.

This is a host-side diagnostic trace, not a native Symbian launch or a rendering test.

## Exact next failure

The trace records:

```text
TRACE sub_1001f9ac ctor obj=10176b38 source=10111208 source+0x14a3c=00000000 lr=100298c8
OOB 00000080/4 ... r0=10176b38 r1=10111208 r3=00014a3c ...
```

At `0x100298c4`, the caller passes `[r7 + 0x14]` as `r1` to `sub_1001f9ac`. The lifted routine then:

1. loads `[r1 + 0x14A3C]`;
2. loads `[that_pointer + 0x80]`;
3. stores the resulting value in the newly allocated 0x9C-byte object.

The source object is `0x10111208`, and the missing field address in this trace is `0x10125C44`.

## New observations

- The source object is created in the child-initialization path at `0x10023F3C`–`0x10023F44`; the harness reports its backing pointer as zero before the constructor call.
- The test harness then overwrites the child-constructor arguments with `0x101D0000` as a diagnostic platform-surface stand-in. This is explicitly a harness substitution, not recovered Symbian state.
- `sub_1000EA00` initializes many early fields and allocates buffers at offsets `0x5B4` and `0x5B8`, but the inspected constructor body contains no explicit scalar store to `this + 0x14A3C`.
- A temporary scalar-write watchpoint for `0x10125C44` did not trigger during the trace. Temporary instrumentation was removed after the test.
- The import call-site table shows 42 uses of `EUSER[100039e5].DLL` ordinal 1 through thunk `0x1009F0D0`. Several call sites have `(r0=destination, r1=0, r2=length)`-like arguments, consistent with a fill/clear helper, but its exact export identity and ABI have not been proven. It remains unimplemented in the VFS HLE and must not be guessed into production code.

## Next work item

Resolve EUSER ordinal 1 against an authoritative Symbian EUser export table or firmware image. Then inspect the initialization path that should populate `0x10125C44`, including indirect/bulk writes and the object graph passed into the child constructor. Do not patch the field with a fabricated pointer. The next milestone is a trace that proves the correct owner/table object is constructed and that the nested constructor passes the `+0x80` read without a memory fault.
