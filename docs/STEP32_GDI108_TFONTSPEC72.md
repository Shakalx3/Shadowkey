# Step 32 — GDI108 receiver is the TFontSpec style subobject

Date: 2026-11-05

## Structural finding

The earlier step31 interpretation of the GDI108 receiver as a separate 24-byte polymorphic object is withdrawn. All five GDI108 callsites pass a receiver at exactly `TFontSpec_candidate + 0x3C`:

| GDI108 callsite | Caller | Receiver offset from GDI151 destination |
|---|---|---:|
| `0x10022BD0` | `sub_10022b20` | +0x3C |
| `0x10022DFC` | `sub_10022d48` | +0x3C |
| `0x10023038` | `sub_10022f88` | +0x3C |
| `0x1002328C` | `sub_100231b4` | +0x3C |
| `0x100236D4` | `sub_10023608` | +0x3C |

The offset matches `iFontStyle` in a 72-byte TFontSpec cross-reference: 56-byte typeface, height at +0x38, 12-byte style at +0x3C. FBS serialization in the diagnostic model consumes those ranges. This is strong structural corroboration, not proof of identical N95 OS 9.2 ABI layout.

## Dynamic write watch and experimental handlers

The trace arms a 24-byte watch at `0x102FED2C`. No guest CPU writes to the range occur before GDI108. EUSER1282's HLE copy writes the descriptor at receiver +4; the first word in the pre-call snapshot is stale scratch data, not proof of a vtable.

Two narrowly gated experiments reached the diagnostic consumer:

1. GDI151 writes a 60-byte TFontSpec prefix candidate with inline typeface candidate and height at +0x38.
2. GDI108 initializes 12 bytes at TFontSpec+0x3C to zero, only at return address `0x10023290` with `r1=0`.

The consumer recognizes `Swiss`, 213 twips, style (0,0,0), and reaches two DrawText diagnostics. The provisional conversion to 14 px uses a host-only 96-dpi assumption.

## Verification

- `build_and_test.sh` — PASS.
- Live VFS trace with EUSER1407, GDI151 and GDI108 experimental gates — PASS.
- Both DrawText diagnostics reached at points (0,160) and (0,13).
- Live RunL returned without a forced engine+0x34 write.

## Remaining blockers

Exact GDI 108/151 and EUSER1407 export identities remain unverified against the N95 FP1 ROM/SDK. Typeface inner layout and buffer capacity are cross-target hypotheses. CFont remains synthetic; glyph rasterization is absent. Direct RunL bypasses CActiveScheduler. No EKA2 image or physical N95 test exists.

Next: obtain the exact N95/S60 3rd FP1 GDI export table or ROM DLL, verify the 72-byte layout, then implement the actual FBS font-provider request and glyph rasterization.
