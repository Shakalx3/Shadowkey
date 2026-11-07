# Shadowkey v8.4 step32 — GDI108 is the TFontSpec style subobject

Date: 2026-11-05

## Result

Step31's interpretation of the GDI108 receiver as a separate 24-byte polymorphic object is withdrawn. The five GDI108 callsites all pass a receiver at exactly `TFontSpec_candidate + 0x3C`:

| GDI108 callsite | caller | receiver relative to GDI151 destination | descriptor copied for GDI151 |
|---|---|---:|---:|
| `0x10022BD0` | `sub_10022b20` | `+0x3C` | receiver `+4` |
| `0x10022DFC` | `sub_10022d48` | `+0x3C` | receiver `+4` |
| `0x10023038` | `sub_10022f88` | `+0x3C` | receiver `+4` |
| `0x1002328C` | `sub_100231b4` | `+0x3C` | receiver `+4` |
| `0x100236D4` | `sub_10023608` | `+0x3C` | receiver `+4` |

That offset is the `iFontStyle` position in the 72-byte `TFontSpec` shape seen in the Symbian OS 9.3 / Nokia 5320 cross-reference: 56 bytes of typeface, `iHeight` at `+0x38`, and 12 bytes of `iFontStyle` at `+0x3C`. The FBS client serializes exactly those ranges into its 72-byte request. The public S60 API also names `iTypeface`, `iHeight`, and `iFontStyle`, and documents the default style as upright / normal weight / normal print position. This is a strong structural cross-check, not proof that every field is identical on the target N95's Symbian 9.2 build.

## Dynamic write watch

The live-state diagnostic trace arms a 24-byte write watch at `0x102FED2C` when the Swiss descriptor is produced. No guest CPU writes to this range occur before GDI108. EUSER1282's HLE copy writes the descriptor at receiver `+4`; the first word `0x100FFE70` in the pre-call snapshot is therefore not evidence of a newly constructed vtable or a valid object. GDI101 is not called in this observed path.

The important correction is that the GDI108 receiver is the 12-byte style subobject, and its pre-call bytes are scratch/overlap data. The descriptor at `receiver+4` has already been consumed by GDI151 and can be overwritten by style construction.

## Experimental handlers

Two narrowly gated experiments now run on the observed path:

1. GDI151 writes a 60-byte `TFontSpec` prefix candidate: `iTypeface` modeled as inline `TBufC<24>`, then `iHeight` at `+0x38`. The exact `TTypeface` inner layout and capacity are not N95-ROM verified.
2. GDI108, only for caller return address `0x10023290` with `r1=0`, initializes 12 bytes at `TFontSpec+0x3C` to `{0,0,0}`. This is consistent with the documented default style values. Other GDI108 callsites and nonzero `r1` are intentionally left unimplemented.

With both experiments enabled, the consumer recognizes `TFontSpec72` as `Swiss`, 213 twips, style `(0,0,0)`, and the diagnostic path reaches both `DrawText` calls. The font-size conversion to 14 px is still a host-only 96-dpi model, not a measured N95 metric.

## Verification

- `./build_and_test.sh` — PASS.
- `trace_asset_loader_live_vfs.sh` with `SHADOWKEY_HLE_FREE_RAM_BYTES=33554432`, `SHADOWKEY_EXPERIMENTAL_EUSER1407_FONT_TBUF=1`, `SHADOWKEY_EXPERIMENTAL_GDI151_TFONTSPEC=1`, `SHADOWKEY_EXPERIMENTAL_GDI108_TFONTSTYLE=1`, and `SHADOWKEY_WATCH_GDI108_RECEIVER=1` — PASS.
- `python3 shadowkey_step32_gdi108_forensics.py` — checks all five callsites and the live diagnostic trace.

## Remaining blockers

- Exact GDI ordinal 108 identity and ABI are not verified from the N95 FP1 ROM or its matching SDK export library.
- `TTypeface`'s internal 56-byte layout / `TBufC<24>` capacity remain a cross-target hypothesis.
- EUSER1407's exact FP1 export identity is still unverified.
- The `CFont` returned by the current HLE is synthetic; FBS font-store/provider behavior is not implemented.
- Glyph rasterization remains absent; DrawText only records the arguments.
- The direct RunL probe bypasses `CActiveScheduler`; the free-RAM threshold is configurable, not measured on the phone.
- No E32/SIS or physical N95 launch exists yet.

## Next frontier

Obtain the N95/S60 3rd FP1 `GDI.dll` export table or ROM binary and map ordinals 108/151. Then verify the 72-byte `TFontSpec` layout against that exact build before promoting either HLE. After that, continue into the real FBS font-provider request and glyph rasterization.
