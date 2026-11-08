# Shadowkey static-recompilation experiment — 2026-10-29

This is a research bundle for the user's original Nokia N-Gage `The Elder Scrolls Travels: Shadowkey` files. It is **not a playable game build** and does not yet produce an SIS for the Nokia N95.

## Main technical change

`shadowkey_llvm_lift_v2.py` now handles ARM `LDR{cond} PC, [PC, Rm, LSL #2]` jump tables as dynamic control flow instead of mistaking `LSL #2` for an immediate displacement and returning early. It also expands recovered basic-block starts into complete instruction sequences, rather than treating the next instruction as a separate function. This fixed stack/register corruption in the recovered SIMKIN copy/array paths. SIMKIN-generated calls are routed through `simkin_call`, so its imported EUSER/ESTLIB calls do not get mistaken for guest code addresses.

`arm_fallback.c` is an experimental ARM/Thumb interpreter fallback for guest addresses that the static function map has not recovered.

## Build and regression test

Requirements: a C compiler with C11 support (Clang recommended), Python 3 for regenerating the lift, and the original files in this folder.

```sh
./build_and_test.sh
```

The script compiles the regenerated C sources and runs the AppUi smoke test. It currently passes. Compiler warnings are suppressed because the generated source is experimental.

## Trace the resource and font path

The older `./trace_asset_loader.sh` is a minimal missing-resource diagnostic. For the current VFS-backed path use `./trace_asset_loader_live_vfs.sh`; it opens the supplied `StringTable.eng`, `global.spr`, `entities.txt`, and `menu_sprites.txt` assets and runs one direct `RunL` probe. This still bypasses `CActiveScheduler` and is not a full Symbian runtime.

For the current font experiment, use the step33 command block below. It reaches `DrawText` with a synthetic host `CFont`; the HLE does not rasterize glyphs.

## Current checkpoint: v8.4 step33 (2026-11-06)

**Historical diagnostic trace; its HLE semantics are superseded by Step50 ARM UREL evidence.** The ARM import map now identifies EUSER1407 as `TPtrC16::TPtrC16(const TUint16*)`, GDI151 as the `TFontSpec(const TDesC16&,TInt)` constructor, GDI108 as `TFontStyle::SetStrokeWeight`, and GDI101 as `TFontStyle::SetPosture`. This validates the broad font-construction path seen in the old trace, but not its old HLE implementations: the EUSER1407 handler wrote an inline TBuf16 instead of a pointer descriptor, the TFontSpec is 64 bytes (not 72), and TFontStyle contains one 32-bit flags word (not 12 bytes). Preserve old logs as diagnostic history, but do not enable the old experimental handler. See `docs/STEP50_ARM_UREL_IMPORT_IDENTITY_BREAKTHROUGH.md`. N95 OS 9.2 ROM export identity and a real font-provider implementation remain separate tasks.

To reproduce the diagnostic font trace after building:

```sh
SHADOWKEY_HLE_FREE_RAM_BYTES=33554432 \
SHADOWKEY_EXPERIMENTAL_EUSER1407_FONT_TBUF=1 \
SHADOWKEY_EXPERIMENTAL_GDI151_TFONTSPEC=1 \
SHADOWKEY_EXPERIMENTAL_GDI108_TFONTSTYLE=1 \
SHADOWKEY_WATCH_GDI108_RECEIVER=1 \
./trace_asset_loader_live_vfs.sh
python3 shadowkey_step32_gdi108_forensics.py
python3 shadowkey_step33_gdi108_callsite_audit.py
```

## Current limits

- Not a playable desktop port.
- Not an SIS or N95-compatible binary.
- No full Symbian EFSRV/EUSER/AVKON/CONE/FBSCLI/BITGDI runtime.
- The resource VFS can open `StringTable.eng`, `global.spr`, `entities.txt`, and `menu_sprites.txt` in the diagnostic harness.
- Some HLE ordinals are only provisional shims; names/semantics must be verified before relying on them.

## Files

- `shadowkey_lifted_v6.c` — regenerated Shadowkey C code.
- `simkin_lifted_runtime_v4.c` — regenerated SIMKIN C code with jump-table/block-flow fixes.
- `shadowkey_llvm_lift_v2.py` — updated lift generator.
- `shadowkey_hle_trace.c` — diagnostic HLE with path logging and resource-open failure handling.
- `shadowkey_hle_bootstrap_v2.c` — smaller HLE used by the passing AppUi smoke test.
- `shadowkey_engine_init_test.c` / `shadowkey_appui_construct_test.c` — test harnesses.
- `SIMKIN_relocated.DLL` — test copy of SIMKIN relocated to guest base `0x10200000`.
- JSON/CSV files — recovered function maps, imports, exports, and call sites.

## ARM11 cross-compilation experiment

Run `./build_arm11_core.sh` to cross-compile the recovered C code for an ARM11-class CPU and combine it into `arm11_objects/shadowkey_arm11_core.o`. This confirms ARM code generation for the lifted game logic and runtime. **The result is an ELF relocatable object, not a Symbian E32 executable and not runnable on the N95 yet.** See `ARM11_BUILD_STATUS.md` for the remaining native-build blockers. `arm11_probe_headers/` are declaration-only compile probes, not OS headers or runtime implementations.

## New ARM static-link checkpoint (v5)

Run `./build_arm11_linkcheck.sh` to build `arm11_objects/shadowkey_arm11_linkcheck.elf`. This is a fully linked, static ARM ELF with no unresolved symbols, but its `E32Main()` is deliberately a no-op link-validation stub. It is **not** a runnable game or an N95-ready E32Image. See `N95_NATIVE_PORT_STATUS.md` for the remaining platform and runtime work.

### Step34 — GDI108 call-boundary argument audit

`V8_4_STEP34_GDI108_CALL_BOUNDARY_ARGUMENTS.md` resolves the fifth GDI108 callsite's actual second argument by following both direct callers of `sub_10023608` and its stack frame. Both callers pass outgoing stack words 0 and 1; the callee reads them as `r6=0` and `r5=1`. The GDI101 conditional branch is taken with `r1=1`, while GDI108 receives `r1=0`. The later `r10 += 13` increments occur after GDI108 and are not part of its argument. This is argument provenance only: GDI ordinal identities and semantics remain unverified.

### Step35 — direct binary output (no SIS)

The requested output is a modified application binary and/or patched compatibility DLLs, not an installer. See `V8_4_STEP35_DIRECT_E32_PATCH_PATH.md`. The new `shadowkey_e32_inject_arm_stub.py` and `shadowkey_step35_e32_patch_test.sh` verify structural E32 text/IAT injection and import-veneer redirection. The probe stub is not a working GDI shim and is not an N95-ready binary; the final target must be emitted in Symbian OS 9.2 / EKA2 format.

### Step35 — direct binary output (no SIS)

The requested output is a modified application executable and/or patched compatibility DLLs, not an installer. See `V8_4_STEP35_DIRECT_E32_PATCH_PATH.md`. The new `shadowkey_e32_inject_arm_stub.py` and `shadowkey_step35_e32_patch_test.sh` verify structural old-E32 text/IAT injection and import-veneer redirection. The probe stub is not a working GDI shim and is not an N95-ready binary; the final target must be emitted in Symbian OS 9.2 / EKA2 format.
