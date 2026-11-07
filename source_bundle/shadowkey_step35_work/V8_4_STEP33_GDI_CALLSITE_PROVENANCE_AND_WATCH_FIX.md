# Shadowkey v8.4 step33 — complete store watch and GDI callsite quarantine

Date: 2026-11-06

## Why this checkpoint exists

A second audit of step32 found two weaknesses in the evidence, not a new game-side failure:

1. `shadowkey_engine_init_live_test.c` watched 8-bit and 32-bit stores to the GDI108 receiver range, but its 16-bit store helper did not emit watch events. The step32 statement that no guest CPU writes occurred before GDI108 was therefore incomplete.
2. `shadowkey_hle_vfs_trace.c` contained two incompatible GDI151 experiments. The active, callsite-gated path models a 72-byte `TFontSpec` candidate with a 56-byte `iTypeface`, height at `+0x38`, and style at `+0x3C`; a later generic fallback still modeled a conflicting 60-byte layout with a `TBufC<20>` and fields at `+0x2C..+0x38`. The generic fallback could have silently applied the old hypothesis to other GDI151 callsites.

## Corrections

### 1. Full-width receiver write watch

The live harness now logs `ngage_w16` stores intersecting the watched receiver range, using the same `WATCH RANGE WRITE16` format as its 8-bit and 32-bit helpers.

The live trace was rebuilt and rerun with the same step32 environment. No guest CPU `WRITE8`, `WRITE16`, or `WRITE32` intersected the watched 24-byte range before the GDI108 import. The EUSER1282 HLE does write the copied descriptor into receiver `+4`; that is an HLE-side `memmove`, not a guest CPU store and is separately visible in the import trace. This distinction is now explicit.

This does not prove that no host/HLE helper wrote to the range; it proves only that the guest CPU store helpers did not write it before the import. The pre-call bytes remain: stale first word `0x100FFE70`, followed by the EUSER1282 descriptor bytes.

### 2. Conflicting GDI151 fallback quarantined

The older generic GDI151 experiment is now guarded by a separate environment variable:

`SHADOWKEY_EXPERIMENTAL_GDI151_LEGACY_LAYOUT=1`

The active step32 experiment remains callsite-gated to return address `0x1002325C`. Other GDI151 callsites no longer receive the conflicting 60-byte layout by default. Unresolved GDI108/GDI151 callsites now stop the diagnostic run with exit code 95 rather than falling through to the generic zero-return shim. They remain unresolved until their argument objects and actual call paths are observed.

### 3. All five GDI108 `r1` sources audited

A new static audit records the five callsites and their argument provenance:

| GDI108 callsite | `r0` receiver | `r1` source in the caller | Current evidence |
|---|---|---|---|
| `0x10022BD0` | `sp+0x268` | `r10` (0/1 path) or `r5` | static only |
| `0x10022DFC` | `sp+0x268` | `*(sp+8)` (initialized 0, later 1) or `r5` | static only |
| `0x10023038` | `sp+0x268` | `r10` (0/1 path) or `r5` | static only |
| `0x1002328C` | `sp+0x680` | `*(sp+28)` (initialized 0, later 1) or literal 1 | dynamic path observed with `r1=0` |
| `0x100236D4` | `sp+0x678` | `r10` (starts 0, then accumulates `+13`) or literal 1 | static only |

This is important: `r1` is not uniformly zero and not uniformly a pointer. The current GDI108 zero-style experiment is intentionally restricted to the one dynamically observed `r1=0` callsite. No semantics are assigned to the nonzero paths.

The five receivers still resolve to the same structural offset, `TFontSpec candidate + 0x3C`, based on the preceding GDI151 destination calculations. That structural observation does not identify the ordinal's exported function name or full signature.

## Reproduction and tests

```sh
./build_and_test.sh
SHADOWKEY_HLE_FREE_RAM_BYTES=33554432 \
SHADOWKEY_EXPERIMENTAL_EUSER1407_FONT_TBUF=1 \
SHADOWKEY_EXPERIMENTAL_GDI151_TFONTSPEC=1 \
SHADOWKEY_EXPERIMENTAL_GDI108_TFONTSTYLE=1 \
SHADOWKEY_WATCH_GDI108_RECEIVER=1 \
./trace_asset_loader_live_vfs.sh
python3 shadowkey_step32_gdi108_forensics.py
python3 shadowkey_step33_gdi108_callsite_audit.py
```

Results:

- `build_and_test.sh` — PASS.
- Live VFS trace — PASS; it still reaches both diagnostic `DrawText` calls and returns from the direct `RunL` probe.
- Step32 forensic audit — PASS with the live trace now generated under `.build` rather than reusing a stale saved trace.
- Step33 callsite audit — PASS for all five GDI108 callers, `r1` provenance, full-width write-watch coverage, the separate legacy-layout opt-in, and fail-closed unknown GDI font imports.
- ARM11 core cross-build — PASS; output remains an ELF relocatable ARM EABI5 object, not a Symbian E32/SIS.

## Cross-reference only — not target ABI proof

- Public S60 GDI documentation describes `TFontSpec` through `iTypeface`, `iHeight`, and `iFontStyle` and gives the `TFontSpec(const TDesC&, TInt)` constructor shape.
- A separate Symbian OS 9.3 / Nokia 5320 ROM analysis independently reports a 72-byte TFontSpec sent to FBS, with height at `+0x38` and a 12-byte style block at `+0x3C`.
- A public S60 font example constructs a `TFontStyle` from posture, stroke weight, and print-position values. This is consistent with three 32-bit style fields, but does not identify GDI ordinal 108.

These sources corroborate the structure only. They do not replace the missing N95 RM-320 / Symbian OS 9.2 GDI export table or ROM disassembly.

## Remaining blockers

- GDI ordinals 108 and 151 still have no exact FP1 export-name/signature proof.
- `TTypeface`'s 56-byte internal representation and `TBufC<24>` candidate still need confirmation against the N95 target build.
- GDI108 nonzero-`r1` behavior is not implemented or inferred.
- The HLE font remains synthetic; FBS font-provider semantics and glyph rasterization are absent.
- The 14-pixel conversion is still a host-only 96-dpi approximation.
- The direct `RunL` probe bypasses `CActiveScheduler`; the free-RAM threshold is configurable, not measured on the handset.
- No E32/SIS or physical N95 launch exists yet.

## Next frontier

Do not widen the current GDI108 shim. First obtain the N95/S60 3rd FP1 GDI export table or `Z:\sys\bin\GDI.DLL` from the target phone, then resolve ordinals 108 and 151. In parallel, capture the nonzero-`r1` branches at the remaining four GDI108 sites and determine what the fifth site's `r10 += 13` represents. Only after those checks should the style handler be generalized or the real FBS font provider be modeled.

## Public documentation cross-checks used

- S60 5th Edition GDI API reference: `TFontSpec` constructor and its `iTypeface`, `iHeight`, `iFontStyle` members — <https://docs.huihoo.com/symbian/s60-5th-edition-cpp-developers-library-v2.1/GUID-35228542-8C95-4849-A73F-2B4F082F0C44/sdk/doc_source/reference/reference-cpp/GDI/TFontSpecClass.html> (cross-version documentation, not an FP1 binary source).
- S60 font example showing `TFontSpec(KtxtSwiss,213)` — <https://cortex.p.gen.nz/nokia/symbian/S60%205th%20Editiom%20C%2B%2B%20Developer%27s%20Library%20v2.1/GUID-35228542-8C95-4849-A73F-2B4F082F0C44/sdk/doc_source/examples/GraphicsEx/GraphicsExampleCode.guide.html>.
- S60 3rd Edition code example constructing `TFontStyle` with posture, stroke weight, and print-position values — <https://rootbiez.blogspot.com/2010/11/symbian-lap-trinh-voi-symbian-os-p5.html> (community tutorial; useful corroboration, not ordinal evidence).
- Independent Symbian OS 9.3 / Nokia 5320 ROM analysis reporting a 72-byte FBS TFontSpec request and fields at `+0x38` / `+0x3C` — <https://binarybacktrace.com/symbian-bible> (different device/OS build; cross-reference only).
