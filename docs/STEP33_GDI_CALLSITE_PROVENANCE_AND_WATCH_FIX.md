# Step 33 — complete GDI108 write watch and callsite quarantine

Date: 2026-11-06

## Corrections made

The step32 live harness had watched 8-bit and 32-bit stores but its 16-bit helper did not emit events. The watcher was corrected to log `ngage_w16` stores intersecting the GDI108 receiver range. On the rerun, no guest CPU WRITE8/WRITE16/WRITE32 intersected the watched 24-byte range before GDI108. The EUSER1282 HLE copy is separately tracked and is not a guest CPU store.

A conflicting generic GDI151 60-byte layout experiment was gated behind:

`SHADOWKEY_EXPERIMENTAL_GDI151_LEGACY_LAYOUT=1`

The active 72-byte TFontSpec candidate remains restricted to the observed callsite. Unresolved GDI108/GDI151 callsites fail closed rather than falling through to a generic zero-return shim.

## Five GDI108 callsites

| Callsite | Receiver | `r1` source | Evidence |
|---|---|---|---|
| `0x10022BD0` | `sp+0x268` | `r10` or `r5` | static |
| `0x10022DFC` | `sp+0x268` | `*(sp+8)` or `r5` | static |
| `0x10023038` | `sp+0x268` | `r10` or `r5` | static |
| `0x1002328C` | `sp+0x680` | `*(sp+28)` or literal 1 | dynamic path observed with 0 |
| `0x100236D4` | `sp+0x678` | `r10` or literal 1 | static |

All five receiver addresses are structurally `TFontSpec_candidate + 0x3C`, based on preceding GDI151 destination calculations. This does not identify the exported function or full signature.

## Reproduction result in supplied archive

- `build_and_test.sh` — PASS.
- Live VFS trace — PASS; reached two diagnostic DrawText calls and returned from direct RunL probe.
- Step32 and step33 forensic audits — PASS.
- ARM11 cross-build — PASS; output is still an ARM EABI relocatable object, not a Symbian E32 executable.

## Limits

GDI 108/151 ordinals, signatures and FP1 semantics remain unverified. Typeface internal layout and capacity remain cross-target hypotheses. The current CFont is synthetic and DrawText does not rasterize glyphs. The direct RunL probe bypasses CActiveScheduler. No EKA2 executable or physical N95 launch exists.
