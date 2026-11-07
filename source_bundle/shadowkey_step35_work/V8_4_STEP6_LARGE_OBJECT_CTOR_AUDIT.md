# Shadowkey v8.4 — step 6: large object constructor / missing member audit

Date: 2026-11-02

## Scope

Continued from step 5 using the extracted v8.4 project tree. No external SDK/ROM export table was available in this work session. No runtime behavior was changed.

## New static finding: exact constructor of 0x10111208

Fresh VFS trace records:

- `EUSER ordinal 1505` call at return address `0x10023D38`, with `r0=0x14E14`.
- HLE allocator returns `0x10111208`; allocated size is `0x14E14` (85,524 bytes), end `0x10126020`.
- In `sub_10023AD0`, caller then sets `r1=r4` (mode/type selector) and `r2=r7` (parent engine object) and calls `sub_1000FA7C` at `0x10023D44`.
- Constructor `sub_1000FA7C` sets the object's vtable at `+0x04`, a pointer at `+0x10`, and initializes many embedded structures/arrays. The object base is retained in `r8` throughout the constructor.
- Later `sub_100298A4` receives parent/control object `0x10138798`; its `+0x14` field points to `0x10111208`. It allocates a 0x9C-byte child and calls `sub_1001F9AC(child, 0x10111208)`.
- `sub_1001F9AC` computes `0x14800 + 0x23C = 0x14A3C`, loads `[source+0x14A3C]`, and immediately reads fields at offsets `+0x80`, `+0x84`, `+0x88`, etc.

## Important negative result

A static audit of `sub_1000FA7C` found no explicit store to base `r8 + 0x14A3C`. Its direct fixed-offset stores cover early header fields and embedded members such as `+0x5A0`, `+0x5A4`, `+0x5A8`, `+0x5B4..+0x5CC`, `+0x610..+0x620`, `+0x630`, `+0xA58`, and `+0x14C00+...` substructures. The only dynamic-offset stores in the constructor have not yet been fully symbolically evaluated, so this is not a proof that no computed store can reach `+0x14A3C`.

The fresh trace harness has a write watch on the exact absolute target `0x10125C44` (the runtime address of `0x10111208 + 0x14A3C`). No `WATCH source+14a3c WRITE32` event appears before the fault. Thus the field remains allocator-zeroed throughout the observed execution; it is not merely written and later overwritten with zero.

This narrows the issue beyond the earlier generic “missing initialization”: the large object's primary constructor is now identified, and the target member is not explicitly initialized by its obvious top-level setup. The next likely place to investigate is a later second-stage setup path or an indirect initializer reached through the parent object's virtual dispatch.

## Fresh test reproduction

Commands executed from the project directory:

- `./build_and_test.sh` — exit 0. AppUi/engine regression assertions and CONE ordinal-226 callsite analysis PASS.
- `./trace_asset_loader_vfs.sh` — wrapper exit 0. Fresh `.build/asset_vfs_trace.log` generated; guest diagnostic stops at `OOB 00000080/4`, exit 90. Four named assets open; one empty-path open fails. This is not a successful game launch.
- `python3 shadowkey_gc_trace_regression.py .build/asset_vfs_trace.log` — PASS against the newly generated log.
- `./build_arm11_core.sh` — PASS, ARM EABI5 relocatable core object.
- `./build_arm11_linkcheck.sh` — PASS, statically linked ARM EABI5 linkcheck ELF with no undefined symbols; `E32Main` remains a no-op stub.

## Evidence discipline / limitations

- `FBSCLI ordinal 17` remains unresolved by an exact S60 3rd Edition FP1 export table. It must not be assigned a guessed name.
- The separate FBSCLI result path is not proven to initialize `source+0x14A3C`.
- No fake pointer or diagnostic replacement was introduced in this step.
- The N95 RM-320 physical device has not been used for execution.

## Next concrete step

Perform a complete def-use audit of the object base passed to `sub_1000FA7C`: resolve all dynamic-offset stores and every helper/callback that receives the object or an interior pointer; then trace the parent object's virtual calls between construction at `0x10023D44` and the later call at `0x10024A84`. The goal is to identify the second-stage initializer that should publish the manager/descriptor pointer at `+0x14A3C`, or prove the game path is missing a required platform service call.
