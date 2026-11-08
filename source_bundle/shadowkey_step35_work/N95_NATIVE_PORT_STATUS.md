# Latest milestone — Step 52 (2026-11-08)

A real EKA2/ARMv6 E32 build pipeline is now validated. The upstream Symbian Platform 0.3.0 SDK successfully built its own control GUI application and generated a native-inspected E32 EXE (kernel=eka2, architecture=armv6, UID3 0xE0000830, code base 0x8000, 7 import DLLs / 170 import slots). This is the first verified EKA2 image generation path in this project; it is a control application, not Shadowkey and not yet tested on the N95. Exact FP1 firmware import/ordinal compatibility and the Shadowkey C-source build remain open. Details and CI artifact: [Step 52](../../docs/STEP52_EKA2_ARMV6_E32_TOOLCHAIN_VALIDATED.md).

---

# Shadowkey → Nokia N95: native-port status (v8.4)

## Latest milestone (2026-11-01)

A diagnostic-only CONE graphics-context shim now lets the recovered code cross the prior ordinal-226 null-return stop. The trace returns a synthetic guest `CWindowGc` and drawable-window identity, dispatches the observed `Activate` (`+0xD8`) and `Deactivate` (`+0xDC`) calls, and proceeds to open `entities.txt` and `menu_sprites.txt`. The old fault at `0x100228AC` is absent.

The next failure is a null pointer read from `source + 0x14A3C` inside `sub_1001f9ac`: source object `0x10111208` has a 0x14E14-byte allocation, but that field is zero in the current trace; the subsequent dereference at `0x80` stops execution. Its semantic name and the constructor/import responsible for populating it remain unresolved. See `V8_4_GC_BACKEND_BREAKTHROUGH.md`.

**Important:** the new GC/window are diagnostic synthetic objects, not native Symbian objects and not a real rendering backend. This is not yet a playable build or an N95-installable E32Image.

---

# Shadowkey → Nokia N95: native-port status (v8)

## Current result

The restored ARM code can now load and process a real image resource from the original `global.spr` when run inside the diagnostic harness. The previous stop was partly caused by the harness's artificially small heap, not solely by game code or file I/O.

### Verified observations

- `StringTable.eng` opens successfully from the supplied game assets (338,078 bytes).
- `global.spr` opens successfully (1,646,707 bytes).
- The resource index `0xF8` yields `0x9444` (37,956 bytes), used by the recovered loader as the resource buffer size.
- The loader seeks to file offset `0x163B1F` and reads 37,956 bytes into guest memory.
- The first four bytes of this resource are `B0 00 D0 00`, which the recovered caller reads as dimensions 176 × 208.
- With the diagnostic heap end extended only after AppUi construction, the allocation and read succeed. Extending the heap from process start changes bootstrap allocation paths and breaks the existing smoke test, so that is deliberately avoided.
- The recovered image-decoder function is entered. Because the diagnostic run does not initialize the real platform graphics surface, a diagnostic-only buffer override was added at the resource-child constructor call. With this override, execution advances beyond the prior null-buffer read.
- The next reproducible failure is `CONE[10003a41].DLL` ordinal 226 returning a null pointer; the guest then dereferences that pointer at `0x100228AC` (call-site return address `0x100228A8`). This is now the next focused HLE/framework blocker.
- A separate path-construction issue remains: one attempted `RFile::Open` receives an empty path before the loader reopens `global.spr` successfully.
- `./build_and_test.sh` still passes: app factory, document vtable dispatch, AppUi construction, engine back-pointer, allocation-failure path, and IAT-slot dispatch.

## Latest ordinal-226 finding (v8.3)

Static call-site analysis now strongly identifies CONE ordinal 226 as `CCoeControl::SystemGc()` and ordinal 55 as `CCoeControl::DrawableWindow()`. Two callers execute the exact documented sequence `gc.Activate(*DrawableWindow())`, using the returned graphics-context object's vtable slot `+0xD8`. The other callers use slots `+0x48` and `+0xB8`. This is not yet proven against the exact FP1 export table, but it is a high-confidence semantic identification from the original ARM code. See `V8_3_ORD226_SYSTEMGC_RESOLUTION.md`.

This corrects the earlier speculative interpretation of `r1=0xAF` and `r3=0xD0`: those registers are not prepared as ordinal-226 arguments at the call sites and should not be treated as dimensions.

## Important limitations

This is a diagnostic static-recompilation harness, not a playable build. The synthetic graphics buffer is only a probe to expose the next code path; it is not a substitute for Symbian's real graphics objects. The E32Image conversion, real S60/Symbian UI environment, graphics backend, input/audio integration, and several imported APIs remain unfinished. No executable suitable for launching on the N95 has been produced yet.

## Next work

1. Identify `CONE` ordinal 226 from a matching S60 3rd Edition FP1 SDK/import map and implement its real semantics or an accurate harness substitute.
2. Trace the vtable call at offset `0xD8` and the subsequent `CONE` calls needed to establish the UI/rendering context.
3. Fix the empty-path descriptor handling in the VFS shim.
4. Replace the diagnostic buffer override with a real graphics surface setup compatible with N95's S60 environment.
5. Only then return to producing and validating an E32Image for Symbian OS 9.2.

## Step35 — direct binary patch route and target-format correction (2026-11-06)

The user explicitly does not want a SIS/install package. The intended output is a modified application binary and/or patched compatibility DLLs for direct placement on the device.

A structural E32 patch experiment now proves that the old `6R51.APP` image can be rewritten in-place at the image-format level: inject ARM stub bytes at the text end, move the IAT/export/import/relocation offsets, update 415 relocation-backed IAT pointers, and redirect a selected import veneer with a PC-relative branch. The temporary test image is discarded; the stub is only a no-op probe, not a GDI implementation.

Important distinction: `6R51.APP` is an old App-DLL-style E32 image. The N95 runs Symbian OS 9.2 / S60 3rd Edition, whose EKA2 / ARM EABI application format is not binary-compatible with pre-OS-9 application binaries. Therefore this experiment is a rewriting proof, **not** a candidate N95 binary. The deliverable must be a newly generated EKA2 executable (plus optional EKA2 support DLLs), not merely the old APP with a patched import veneer.

The baseline `6R51.APP` also has a pre-existing code-checksum mismatch: header field `0x18` is `0x67F7151E`, while the additive sum over its declared code segment is `0x6387532B`. The same checksum calculation matches `SIMKIN.DLL` exactly. This discrepancy needs comparison against a fresh original extraction before any final patch is made.

## Step35 — direct binary output and target-format correction (2026-11-06)

The user explicitly does not want a SIS/install package. The intended output is a modified application executable and/or patched compatibility DLLs for direct placement on the device.

A structural old-E32 patch experiment now proves that the supplied `6R51.APP` can be rewritten at the image-format level: inject ARM stub bytes at the text end, move the IAT/export/import/relocation offsets, update 415 relocation-backed IAT pointers, and redirect a selected import veneer with a PC-relative branch. The temporary test image is deleted after testing; the stub is only a no-op probe, not a GDI implementation.

Important distinction: `6R51.APP` is a pre-Symbian-OS-9 App-DLL image. The N95 runs Symbian OS 9.2 / S60 3rd Edition, which uses the EKA2 / ARM EABI executable model and is not binary-compatible with earlier Symbian OS releases. Therefore this experiment is a rewriting proof, **not** a candidate N95 binary. The deliverable must be a newly generated EKA2 executable (plus optional EKA2 support DLLs), not merely the old APP with a patched import veneer.

The baseline `6R51.APP` also has a pre-existing code-checksum mismatch: header field `0x18` is `0x67F7151E`, while the additive sum over its declared code segment is `0x6387532B`. The same checksum calculation matches `SIMKIN.DLL` exactly. This discrepancy needs comparison against a fresh original extraction before any final patch is made.

A viable EKA2 post-linker candidate has now been identified: the public SymbianRevive `elf2e32` source, which converts ARM ELF into E32Image EXE/DLL outputs without requiring SIS creation. A newer Linux/macOS `symbian-platform` SDK also advertises native EKA2 builds, but it is a recent single-maintainer project and remains unvetted. Neither was downloaded because external host resolution is unavailable in this runtime. This does not change the current status: no EKA2 E32 output has yet been produced.
