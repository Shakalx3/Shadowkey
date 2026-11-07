# Shadowkey v8.4 — step25: EUSER 711 rectangle ABI and ARM-core HLE parity

## Result

EUSER ordinal 711 is no longer an unresolved call in the host live VFS harness. The recovered call ABI is:

- `r0`: pointer to a 16-byte caller-owned object;
- `r1`, `r2`, `r3`: first three `TInt` values;
- `[sp]`: fourth `TInt` value.

All four static call sites have this member-call shape. The object is subsequently passed as the rectangle argument to the `CGraphicsContext::DrawText` candidate at vtable byte offset `+0xA8`. The HLE writes the four values, in order, to offsets `+0`, `+4`, `+8`, and `+12`.

This is compatible with a four-coordinate `TRect` initialization/set operation. The exact FP1 EUSER export name and whether the underlying C++ method is a constructor or setter are not established by the available export table, so the implementation is intentionally described by its observed ABI and data effect rather than an asserted SDK symbol.

## Live evidence

In the high-RAM diagnostic RunL trace:

- the first DrawText occurs before this EUSER 711 call and still sees stale rectangle memory;
- EUSER 711 then writes `[0, 13, -15, 0]` to `0x102fecf0`;
- the following DrawText receives that same initialized object and the non-empty descriptor `d the game` (10 UTF-16 code units).

The coordinates are preserved exactly as supplied, including the negative right coordinate. The code does not normalize or reinterpret them. Whether the downstream GDI accepts/reorients this rectangle remains open.

## ARM-core parity

The same observed behavior has been ported into `shadowkey_hle_bootstrap_v2.c`, which is compiled into the ARM11 core. The step25 core-HLE test covers:

- EUSER 248: raw UTF-16 pointer to inline TBuf16 copy;
- ESTLIB 317: UTF-16 replacement;
- ESTLIB 315: UTF-16 append;
- EUSER 711: four-int member ABI and all 16 output bytes.

The host VFS trace implementation retains diagnostics; the ARM-core implementation performs the same guest-memory writes without host-only logging.

## Verification

- `build_and_test.sh` — PASS.
- step17, step18, step19, step20 and step21 static audits — PASS.
- step23 DrawText ABI test — PASS; still confirms no fake pixel writes.
- step24 EUSER 248 test — PASS.
- step24 ESTLIB wide-string test — PASS.
- step25 EUSER 711 focused ABI test — PASS.
- step25 ARM-core HLE parity test — PASS.
- natural high-RAM constructor/RunL VFS probe — PASS; still a direct RunL diagnostic, not a CActiveScheduler run.
- step25 live EUSER 711 audit — PASS.
- ARM11 EABI5 relocatable core build — PASS.
- static ARM ELF linkcheck — PASS with no undefined symbols.

## Limits and next frontier

- The first DrawText in the observed pair precedes EUSER 711 and still receives stale rectangle bytes.
- The second DrawText receives the initialized rectangle, but DrawText remains diagnostic only: no glyph rasterization or pixel writes are implemented.
- The configurable 32 MiB HAL free-RAM model is only in the host trace harness. The ARM-core HLE still does not implement a real device HAL query; do not treat the host high-RAM branch as proof of N95 memory behavior.
- No full CActiveScheduler, E32Image/SIS package, or physical N95 launch exists yet.
- Next investigate the post-rectangle font acquisition path (GDI 108 and returned font object), then connect a real font/glyph representation to DrawText and verify an actual pixel-buffer diff.
