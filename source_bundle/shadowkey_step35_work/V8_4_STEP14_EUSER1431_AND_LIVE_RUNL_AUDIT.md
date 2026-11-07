# Shadowkey v8.4 — step14: EUSER 1431 and live RunL audit

## Input

Started from `shadowkey_recomp_bundle_v8_4_step13_return_chain_fix.zip`.

## 1. EUSER ordinal 1431

Call-site evidence:

- `sub_10021244` calls it with `r0 = sp + 0x198`, `r1 = 0x100`.
- `sub_10022898` calls it three times with `r0 = sp + 0xD0 / 0x94 / 0x58`, `r1 = 50`.
- Additional live trace callsites pass 50-byte stack work buffers.
- The callers subsequently treat these regions as initialized scratch/descriptor workspaces.

Implemented a bounded zero-fill HLE for the observed two-argument contract (`r0=destination`, `r1=byte length`). It checks the guest address range, clears exactly the requested bytes, and returns the destination pointer. This is strongly consistent with `Mem::FillZ`; the exact S60 FP1 export-table name has not yet been independently verified, so the implementation/report intentionally records the call-site behavior rather than claiming EAT proof.

Regression now requires the zero-fill handler to appear in the trace and rejects a remaining unimplemented-1431 diagnostic.

## 2. Live RunL without forced state mutation

Created separate diagnostic probes that do not alter `engine+0x34` before calling RunL.

Observed initial state:

- `engine+0x30 = 0`
- `engine+0x34 = 1`
- `engine+0x3AC = 0`
- `engine+0x3AD = 0`

One natural RunL call increments `engine+0x34` from 1 to 2 and returns. A 160-tick pump advances the counter from 1 to 161 without an OOB or invalid BX. During the later ticks it repeatedly reaches the 10,000-microsecond wait path and EIKCORE ordinal 67. This is a host-side scheduler approximation, not a faithful active-scheduler implementation.

The asset-loading VFS harness still deliberately uses its prior forced-zero state to exercise the graphics/resource branch. It must not be confused with natural startup.

## 3. New diagnostic frontier after the forced branch

The trace now reaches the sprite/UI path after `global.spr` decoding and the bitmap/GC setup. The first unresolved cluster includes:

- EUSER ordinals 1575, 248, 711, 1407, 1282 and others;
- ESTLIB ordinals 315 and 317;
- GDI ordinals 151 and 108;
- GAMECOMMS ordinal 9;
- a virtual call path that reads the object at `r8+0x2EC`, then its vtable, and reaches target zero in this diagnostic run.

The zero target is downstream of an uninitialized/missing object path; no generic return-address workaround was added. The next investigation should trace the producer of the `+0x2EC` object for the specific receiver used by `sub_100231b4`, and recover GDI 151/108 from their argument setup before adding behavior.

## 4. Verification

- `build_and_test.sh` — PASS.
- `trace_asset_loader_vfs.sh` — PASS.
- `shadowkey_frontier_regression.py` — PASS, now also checks EUSER 1431 zero-fill.
- `build_arm11_core.sh` — PASS; ARM EABI5 relocatable core produced.
- `build_arm11_linkcheck.sh` — PASS; static ARM ELF has no undefined symbols.

The tests remain host-side lifted-code/HLE diagnostics. `E32Main` in the link-check image is a no-op test stub. This does not establish a complete game launch or a physical Nokia N95 test.

## 5. Files added/changed

- `shadowkey_hle_vfs_trace.c`: bounded EUSER 1431 zero-fill handler.
- `shadowkey_frontier_regression.py`: regression assertion for the handler.
- `shadowkey_engine_init_live_test.c`: live-state one-tick RunL probe.
- `shadowkey_engine_init_pump_test.c`: 160-tick RunL diagnostic pump.
- `.build/live_state_trace.log`, `.build/pump_trace.log`, `.build/asset_vfs_trace.log`: captured traces.
