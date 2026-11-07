# Shadowkey v8.4 — step16: EUSER 1575, CONE 160 and text/GDI call-site audit

## Scope and input

Input: v8.4 step15 graphics-chain archive. This is a host-side forensic continuation, not a native N95 launch. No ordinal was assigned a guessed implementation.

## 1. CONE ordinal 160: return type and semantic narrowed

The four known static call sites all use the ARM hidden-result convention:
- r0 = address of caller-owned temporary storage;
- r1 = `this` pointer (control object).

The caller-visible result is 8 bytes. The strongest evidence is call site `0x10021400` in `sub_10021244`: immediately after the import, the caller copies exactly two 32-bit words from the returned temporary and passes that pair as dimensions to an internal bitmap constructor. Other call sites pass the same 8-byte pair to control virtuals (`+0x48`, `+0xB8`, `+0xC0`).

This makes `CCoeControl::Size() const` / a `TSize`-returning control query the leading semantic identification. This is a call-site inference, not a verified S60 FP1 CONE export-table name. Do not implement until the target FP1 export table or an independent call-site/API match confirms it.

Call sites recorded in `step12_forensics/cone160_callsites.csv`:
- `0x10021400`, `sub_10021244`: hidden result `sp+0x0c`, `this=r7`; returned pair copied as dimensions.
- `0x10021D8C`, `sub_10021B98`: hidden result `sp+0x430`, `this=r7`; pair later consumed by virtuals `+0x48` and `+0xB8`.
- `0x10022AD4`, `sub_10022898`: hidden result `sp+0x3c`, `this=r8`; pair passed through virtual `+0xC0`.
- `0x100282A8`, `sub_10028260`: hidden result `sp+0x204`, `this=r6`; pair later consumed by virtuals `+0x48` and `+0xB8`.

Live diagnostic trace confirms the third site is reached with `r0=0x102fed24`, `r1=0x101102c8`; r2/r3 are caller leftovers and not reliable formal arguments.

## 2. EUSER ordinal 1575: ABI confirmed, identity still open

Only static call site: `0x1002290C` in `sub_10022898`.

Argument setup:
- `r0 = r10 = sp+0x34`: an 8-byte output/work area;
- `r1 = r5 = object+0x310`;
- call returns to `0x10022910`;
- caller immediately compares `r0` with zero; zero takes failure/cleanup branch `0x10022A4C`.

On success, later code copies two words from the 8-byte area into `object+0x310`, while related state at `object+0x318` is read and rewritten. This proves a status-returning operation that transforms/copies an 8-byte descriptor-like or pair structure. It does not uniquely identify an EUSER API. No handler was added.

Live trace: `r0=0x102feae0`, `r1=0x101105d8`, `r2=0`, `r3=0x101105e8`, `lr=0x10022910`.

## 3. Text/GDI import call shapes

### GDI ordinal 151

Five static call sites in the same UI/text path: `0x10022BA0`, `0x10022DCC`, `0x10023008`, `0x1002325C`, `0x10023698`.

At the first site:
- `r0 = sp+0x22c` (caller-owned output structure);
- `r1 = sp+0x26c` (temporary input structure);
- `r2 = 0xD5` (character/code argument);
- call at `0x10022B9C`.

The repeated 3-argument shape is consistent with character/font metrics or glyph data acquisition, but no exact GDI method name is proven. Preserve as unresolved.

### GDI ordinal 108

Five static call sites in the same path: `0x10022BD4`, `0x10022E00`, `0x1002303C`, `0x10023290`, `0x100236D8`.

At the first site:
- `r0 = sp+0x268` (output/result structure);
- `r1` selects one of two previously prepared objects (`r5` or `r10`);
- no extra explicit arguments are set before the call.

The call follows the ordinal-151 glyph/character operation and precedes bitmap-device/context virtual calls. This suggests a second stage of glyph/font data processing, but does not establish whether it returns a glyph bitmap, metrics, or a cache object.

### EUSER 248 and 711

Both are in the later descriptor/text path and remain unresolved. Their thunks are registered, but the available current trace does not yet provide enough argument/side-effect evidence for a faithful implementation. No no-op handlers added.

## 4. Verification

Executed against this archive:
- `bash build_and_test.sh` — PASS.
- `bash trace_asset_loader_vfs.sh` — exit 0; real asset opens/reads and existing frontier regressions pass. The harness explicitly states it is not a game-launch test.
- `bash build_arm11_core.sh` — PASS (ARM EABI5 relocatable core).
- `bash build_arm11_linkcheck.sh` — PASS (static ARM ELF, no undefined symbols; E32Main remains a no-op linkcheck stub).

The trace still reaches the diagnostic/forced resource path; it is not a natural full application launch. No physical Nokia N95 run has been performed.

## 5. Next evidence needed

1. Obtain the exact S60 3rd FP1 CONE/EUSER/GDI export tables or matching FP1 ROM DLLs; do not transplant ordinal names from a different Symbian release without checking.
2. Inspect producer/consumer code for `object+0x310/+0x318` and the 8-byte output at EUSER 1575 to identify its concrete descriptor/structure type.
3. Trace the data passed through GDI 151 then GDI 108 and the virtual calls after them; identify glyph metrics/bitmap/cache ownership before implementing rasterization.
4. Only then add minimal behavior-backed HLE and regression tests.
