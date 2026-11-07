# Shadowkey v8.4 — step 3: source subobject contract and ARM linkcheck repair

Date: 2026-11-02

## Reproduction status

Freshly extracted the supplied `shadowkey_recomp_bundle_v8_4_step2_euser_memset.zip` into a clean working directory.

- `./build_and_test.sh` — PASS. AppUi/engine-object tests pass; CONE ordinal 226/55 call-site analysis passes.
- `./trace_asset_loader_vfs.sh` — PASS as a milestone regression. It regenerates `.build/asset_vfs_trace.log`, opens the four expected resources, passes the synthetic GC dispatch checks, and deliberately stops at `OOB 00000080/4`.
- `./build_arm11_core.sh` — produced ARM11 relocatable core, but the original source list omitted `shadowkey_cone_gc_hle.c` even though `shadowkey_runtime_core.c` references `shadowkey_cone_gc_dispatch`.
- `./build_arm11_linkcheck.sh` — initially FAILED with `undefined symbol: shadowkey_cone_gc_dispatch`.

## Build harness correction

Changed only `build_arm11_core.sh`:

- added `shadowkey_cone_gc_hle.c` to the ARM compile list;
- added `shadowkey_cone_gc_hle.o` to the relocatable core link.

This is a build-manifest correction, not a new runtime implementation. The existing freestanding link stubs already provide the `fprintf` dependency needed by this diagnostic module.

After the correction:

- `./build_arm11_core.sh` — PASS;
- `./build_arm11_linkcheck.sh` — PASS; statically linked ARM EABI5 ELF, no undefined symbols.

The ELF remains a link-validation artifact with a no-op `E32Main`, not an E32Image or playable game.

## Corrected interpretation of `source+0x14A3C`

In `sub_1001f9ac` the lifted ARM sequence is:

1. `r3 = 0x14800`;
2. `r3 += 0x23C`, giving `0x14A3C`;
3. `LR = *(source + 0x14A3C)`;
4. `r2 = *(LR + 0x80)`;
5. store `r2` at `this + 0x14`;
6. copy further words from `LR + 0x84`, `+0x88`, `+0x8C`, `+0x90`, `+0x94`, `+0x98`, and `+0xA0` into the new 0x9C-byte object.

Thus the source field is a pointer to a structured descriptor/configuration object, not proven to be a vtable or manager table. The `+0x80` dereference is only the first member read. The exact type/name remains unknown.

The only static call site to `sub_1001f9ac` in the lifted image is in `sub_100298a4` (return address `0x100298C8`). That caller allocates 0x9C bytes, obtains its source from parent `+0x14`, then invokes the constructor. In the fresh trace, parent `0x10138798 + 0x14` is `0x10111208`.

## Source-object construction lead

The fresh trace shows:

- `0x10111208` is allocated as an 85,524-byte object (`0x14E14`), following a preceding allocation at `0x10110730`.
- It is the child passed to `sub_1000EA00` at `0x10023F48`.
- Immediately before that call, the trace records original arguments `r1=0`, `r2=0`; the lifted code then explicitly overwrites both with `0x101D0000` under a comment identifying this as a diagnostic stand-in for a missing platform surface.
- `sub_1000EB58` is later called on the same child at `0x10024EB0`.
- The recovered code in `sub_1000EA00` initializes many fields and calls internal helpers, but its visible direct writes do not reach offset `0x14A3C`. `sub_1000EB58` writes other fields (including offsets `0x5D4`, `0xC5C`, `0x68` and indexed arrays), but the current trace still shows no write to `0x14A3C` before the consumer.

This makes the explicit `0x101D0000` override a high-priority investigation lead, but does not yet prove it causes the missing `+0x14A3C` pointer. It may be unrelated to that far-offset member. No guessed pointer was inserted.

## External SDK limitation

The target N95 is S60 3rd Edition FP1 / Symbian OS 9.2; public sources corroborate that platform/SDK pairing and note the FP1 SDK supports the N95. However, this workspace does not contain the exact FP1 `epoc32/release/armi/urel` import libraries or an N95 ROM export dump. Web searches did not yield reliable ordinal-to-symbol tables for this game's `FBSCLI`, `CONE`, and `WS32` imports. Do not assign names to ordinals 17/160/109 based on another Symbian release.

## Legacy test scripts

`shadowkey_regression_tests.py` is a pre-v8 regression targeting `shadowkey_functions_v2.json` and `shadowkey_lifted_v4.c`, neither of which is included in this bundle. It fails with `FileNotFoundError` and is not a valid v8.4 test as currently packaged.

`shadowkey_gc_trace_regression.py` must be given the trace path (or run after the trace script creates `.build/asset_vfs_trace.log`); running it without that generated file fails by design. The current supported checks are `build_and_test.sh` and `trace_asset_loader_vfs.sh`.

## Next concrete step

Trace the producer of the 0x14A3C descriptor pointer and test whether the original `r1/r2` inputs to `sub_1000EA00` are semantically required. Start with the caller around `0x10023F3C–0x10023F48`, then inspect `sub_1000EA00`'s register use and every helper it calls. Do not remove the diagnostic override until the expected platform-object contract is known; do not populate `+0x14A3C` by hand.
