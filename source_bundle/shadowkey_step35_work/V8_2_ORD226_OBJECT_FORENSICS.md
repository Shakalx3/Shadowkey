# Shadowkey v8.2 — CONE ordinal 226 receiver-object forensics

Date: 2026-10-31

## What changed

The v8.1 trace only recorded the import arguments and the null return. This pass added a narrowly scoped diagnostic dump for `CONE[10003a41].DLL` ordinal 226 in `shadowkey_hle_vfs_trace.c`. It records the receiver object's first 0x80 bytes and, where addressable, the first 0x100 bytes of its vtable. No emulated return value or guest state was changed by this instrumentation.

## Reproduced runtime state

At the failing call:

- caller: `sub_10022898`
- BL: `0x100228A4`
- LR: `0x100228A8`
- thunk: `0x1009F540`
- import: `CONE[10003a41].DLL`, ordinal `226`
- receiver (`r0`): `0x101102C8`
- other argument registers: `r1=0xAF`, `r2=0`, `r3=0xD0`
- current HLE fallback writes `r0=0`; next instruction `0x100228AC` executes `ldr r4,[r9]` and faults.

The receiver is not an arbitrary uninitialized address. The runtime dump is:

```text
OBJ+00: 68 cf 0f 10 74 bb 0f 10 00 00 00 00 00 00 00 00
OBJ+30: 08 12 11 10 00 00 00 00 01 80 ff ff 00 00 00 00
OBJ_VTABLE=100fcf68
```

The object begins with a guest-code vtable pointer `0x100FCF68` and a secondary pointer `0x100FBB74` at offset `+4`. The runtime object bytes and vtable are inside the guest address space and were read directly from the same execution that loads `global.spr`.

## Receiver class construction identified

The lifted code establishes that `0x100FCF68` is installed by the game's own constructor `sub_10021648`:

- `sub_10021648` stores `0x100FBB74` at object `+4` and `0x100FCF68` at object `+0`.
- `sub_100282F8` allocates `0x444` bytes, calls `sub_10021648`, then calls `sub_10021244` to complete initialization.
- The live receiver `0x101102C8` is therefore an application-defined game object with a known constructor/vtable lineage, not a pointer that should be fabricated by the CONE shim.

This is a useful distinction: ordinal 226 is being called *with* the game's object as its receiver/first argument, and the game expects a separate polymorphic object back. It is not simply a request to allocate the game object itself.

## All static call sites

The import-callsite table contains four calls to this same ordinal:

| Caller | BL address | Return address |
|---|---:|---:|
| `sub_10021B98` | `0x10021D78` | `0x10021D7C` |
| `sub_1002256C` | `0x100226A0` | `0x100226A4` |
| `sub_10022898` | `0x100228A4` | `0x100228A8` |
| `sub_10028260` | `0x10028294` | `0x10028298` |

The third call is the one reached in the current resource-decoder trace. The other three must be accounted for before any shared ordinal implementation is accepted.

## What is still not established

- The exact C++ export name/signature for CONE ordinal 226 is still unresolved.
- `r1=0xAF` and `r3=0xD0` coincide with the loaded image's 176x208 dimensions only in the current trace; that is a clue, not proof of the API semantics.
- The returned object's concrete class, ownership, destruction path, and required vtable entries remain unknown.
- No guessed object/vtable has been introduced. The diagnostic trace still halts at the same null-return fallback.

Symbian links DLL functions by ordinal, so a mapping from another CONE binary/firmware revision cannot be assumed to match this target. The next decisive evidence is the export directory or import-library symbol map for the exact target CONE build, ideally extracted from the RM-320 v35.0.001 ROM or matching S60 3rd FP1 SDK.

## Validation

- `./build_and_test.sh` — PASS after the diagnostic instrumentation was added.
- `./trace_asset_loader_vfs.sh` — reaches the same real `global.spr` resource, emits the receiver/vtable dump above, and then stops at the known unimplemented ordinal 226. This remains a diagnostic harness, not a game-launch test.
