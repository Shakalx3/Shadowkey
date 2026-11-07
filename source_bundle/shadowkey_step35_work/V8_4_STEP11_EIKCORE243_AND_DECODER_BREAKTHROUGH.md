# Shadowkey v8.4 — Step 11: EIKCORE 243, bitmap graphics path, decoder output

## Outcome

The trace now passes the previous null bitmap-buffer frontier and reaches later UI/resource handling. The decoded `global.spr` payload is visibly non-empty, the resource-string conversion writes a real guest heap pointer, and the Bitmap graphics-device/context path is modelled far enough to continue.

This is a diagnostic emulator/HLE milestone. It is **not** a complete FBS/EIKCORE implementation, not a game launch, and not a physical Nokia N95 test.

## EIKCORE ordinal 243: call-site ABI

Observed call:

- DLL: `EIKCORE[10004892].DLL`
- ordinal: `243`
- callsite: `0x10023210`
- registers: `r0=0`, `r1=0x101E0518`, `r2=0`, `r3=0x28`
- return value is stored as a font pointer and passed to the graphics context's vtable slot `+0x24` (the `UseFont` role).
- The caller then invokes the returned object's vtable slots `+0x10` and `+0x14`, used as font height/ascent metrics.

Therefore the **return type/role is strongly identified as `CFont*`**. The exact EIKCORE export name and exact FP1 ordinal mapping are still not proven from the N95 ROM export table. The current host trace contains a deliberately narrow CFont HLE model (height 40, ascent 30) to continue the call chain; it must not be mistaken for the real EIKCORE implementation.

## BITGDI bitmap-device/context path

The import call shapes and the documented Symbian API sequence match:

1. BITGDI ordinal 86 — inferred as `CFbsBitmapDevice::NewL(CFbsBitmap*)`.
2. BITGDI ordinal 23 — inferred as `CFbsDevice::CreateContext(CFbsBitGc*&)`.

The observed objects in the current trace are:

- FBS bitmap object: `0x10110718`
- Bitmap device HLE object: `0x10110730`
- Graphics context HLE object: `0x10110770`
- Pixel address: `0x10311000`

The public API example shows this same sequence: create a `CFbsBitmap`, call `CFbsBitmapDevice::NewL`, then call `CreateContext` to obtain the graphics context. This supports the call-site inference but does not prove the exact FP1 ordinal/name mapping.

## Decoder result: confirmed non-zero pixels

The original decoder path had incorrect lifted ARM shifted-operand handling and palette/pixel addressing. Those operations were corrected. The current integration trace reports:

`IMGDEC RESULT dest=10311000 nonzero_bytes=6909 buffer_bytes=82016`

The buffer is a 176x233 RGB444 (12-bit values in 16-bit storage) surface (stride 352 bytes). The decoded `global.spr` payload is 176x208. The diagnostic image is included as `diagnostics/decoded_global.png`, with the raw RGB444 (12-bit values in 16-bit storage) surface and hashes alongside it.

The bitmap's data address was fetched again after the guest decoder path; the same buffer remained non-zero (`6909/82016` non-zero bytes). This proves the decoder writes into the Bitmap backing buffer rather than a temporary host-only image.

## StringTable conversion: real pointer restored

A second set of lost ARM shifted operands was found in `sub_10015878`, the resource/string conversion path. Six lifted operations were corrected to preserve the original `LSL #8` / `LSL #16` semantics.

The active large object in this trace is `0x10111288`; its `source+0x14A3C` field is at `0x10125CC4`. The trace confirms:

`WATCH source2+14a3c WRITE32 at=10125cc4 value=1018afd8`

The pointer `0x1018AFD8` is a real guest heap allocation. The older object instance at `0x10111208` still has a separate zero field in this run; the active resource conversion is for the `0x10111288` instance.

## Memory model adjustment for host tracing

The primary diagnostic heap (`0x10110000..0x101FF000`) is nearly exhausted once the UI/resource path progresses further. A secondary test-only allocation pool (`0x10230000..0x10300000`) was added, after the loaded SIMKIN image and before the FBS shared chunk. This is a non-contiguous host-test accommodation, **not** a claim about the original Symbian EUSER heap layout and not a native-device memory map.

## Current frontier

After the graphics/font path, the trace reaches later control/resource handling, including `CONE[10003a41].DLL` ordinal 160. That ordinal remains unimplemented; its exact export name and side effects are unresolved. Nearby calls to EUSER ordinals 1431, 1575 and 21 are also not fully modelled.

The current stop is:

`OOB 00000004/4 pc=102fdc68 lr=1003229c sp=102ff068 ... r12=102fd030`

The target `0x102FDC68` is in the current guest stack region, not an executable game-code address. The trace shows a return/callback path leaving the expected code region after the CWindowGc deactivate path. It is not yet proven which of the unimplemented control/descriptor operations is responsible for the bad return target. Do not attribute this fault to EIKCORE ordinal 243 alone: the CFont role is now modelled and the execution proceeds beyond that call.

## Verification

- `build_and_test.sh` — PASS.
- `trace_asset_loader_vfs.sh` — PASS for the new frontier regression; emulator diagnostic exit remains 90 at the documented OOB frontier.
- `build_arm11_core.sh` — PASS; ARM EABI5 relocatable core built.
- `build_arm11_linkcheck.sh` — PASS; statically linked ARM ELF, no undefined symbols.
- No physical Nokia N95 execution has been performed.

## References used for API-shape cross-check

- Symbian bitmap-device example (`CFbsBitmapDevice::NewL` followed by `CreateContext`): https://flylib.com/books/en/2.338.1.111/1/
- Symbian `CBitwiseBitmap` header, including `iDataOffset`: https://github.com/SymbianRevive/symbian-headers/blob/main/bitmap.h
- Symbian/N-Gage FBS chunk analysis: https://binarybacktrace.com/symbian-bible
