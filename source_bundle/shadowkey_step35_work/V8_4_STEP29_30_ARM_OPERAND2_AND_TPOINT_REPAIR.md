# Shadowkey v8.4 — Step29/30: ARM Operand2 and DrawText TPoint repair

Date: 2026-11-04

## Major correction: the lifted ARM code had dropped shifted Operand2 values

The original lift generator (`shadowkey_llvm_lift_v2.py`) parsed data-processing instructions such as `ADD`, `ORR`, `MOV`, `CMP`, etc. but used the raw source register and silently discarded the ARM shifter operand. For example:

- `ADD r4, r0, r4, ASR #1` was emitted as `r4 = r0 + r4`.
- `ADD r4, r4, r4, LSR #31` was emitted as `r4 = r4 + r4`.

This was not isolated to the text path. The generated file contained **4,961 shifted data-processing instructions** affected by this omission.

### Repair

- Added `shadowkey_arm_shift.h` implementing ARM Operand2 semantics for LSL, LSR, ASR, ROR and RRX, for both immediate and register-specified shifts.
- The helper implements ARM special cases (`LSR/ASR #0` meaning 32, immediate `ROR #0` as RRX, register shifts by 0/32, sign extension) and optional shifter carry updates.
- Updated `shadowkey_llvm_lift_v2.py` to preserve shifted Operand2 for MOV/MVN, ADC/SBC/RSC, ADD/SUB/RSB, logical operations, CMP/CMN/TST/TEQ. The one previously unsupported shifted `RSC` instruction is now emitted correctly as well.
- Repaired all 4,961 affected data-processing instructions in `shadowkey_lifted_v6.c` using the corrected generator logic.
- Added a static audit that confirms all 4,961 shifted data-processing instructions now use the ARM shifter helper.

## DrawText ABI correction: point overload, not rectangle overload

The previous EUSER 711 implementation incorrectly treated the output as a 16-byte `TRect` and consumed `r3` plus `[sp]`.

Reinspection of all callsites shows:

- EUSER 711 receives `r0=this`, `r1=x`, `r2=y`; `r3` and `[sp]` are leftovers.
- The object is 8 bytes and is passed to the `CGraphicsContext` virtual slot `+0xA8` as a `TPoint`.
- The slot call has `r3` as baseline and two stack arguments for alignment and margin, matching the `DrawText(const TDesC&, const TPoint&, TInt, TTextAlign, TInt)` overload.
- EUSER 1373 at five callsites has the same two-coordinate write pattern and is followed by use of the same object as a DrawText point.
- EUSER 530 at four paired callsites returns the second coordinate, which is then used in the font baseline calculation.

The HLE now implements these callsite-specific behaviors:

- EUSER 1373: set `TPoint(x,y)` at verified callsites.
- EUSER 530: return `TPoint::Y()` at verified paired callsites.
- EUSER 711: set `TPoint(x,y)` and preserve the following 8 bytes.

The exact export names/ordinal identities are still inferred from ABI and dataflow, not proven against the target FP1 export table.

## Host live-path result

With the natural high-RAM constructor path (no forced write to `engine+0x34`):

- The game reaches the actual `DrawText` virtual call with descriptor text `has paused the game` (19 UTF-16 characters).
- The first point is `(0,160)`; the calculated baseline is `83`.
- The subsequent point construction sets `(0,13)` for the next DrawText call.
- `DiscardFont` and the bitmap/font callback are reached.
- The second descriptor in this particular pass is empty; this is not counted as successful second-line text rendering.

A large 15,073,516-byte allocation now succeeds in the host diagnostic memory model at `0x10400000`. The host map was expanded to 32 MiB and the new heap segment begins after the reserved FBS shared/large chunk range (`0x10300000–0x10400000`). This is a host model, not a measurement of free RAM on the N95.

## Validation

Passed:

- `build_and_test.sh`
- `shadowkey_arm_shift_test.sh`
- `shadowkey_step29_shift_operand_audit.py` (4,961 shifted instructions)
- `shadowkey_step23_drawtext_abi_test.sh`
- `shadowkey_step28_euser711_tpoint_test.sh`
- `shadowkey_step30_point_import_test.sh`
- `shadowkey_frontier_regression.py` against the natural high-RAM trace
- HAL high-RAM threshold audit at 32 MiB
- HAL low-RAM branch audit at 4 MiB (does not reach DrawText)
- ARM11 EABI5 core build
- Static ARM ELF linkcheck with no undefined symbols

## Still unresolved

- EUSER 1407 and GDI 151 are still experimental/incompletely identified in the default path. The 60-byte `TFontSpec` layout and `Swiss` descriptor handling remain provisional.
- GDI 108 remains unresolved.
- The host `CFont` object is still a diagnostic model; the real target font store and glyph metrics are not recovered.
- `DrawText` records valid arguments but does not rasterize glyphs. No pixel-buffer changes have been demonstrated from text drawing.
- The bitmap/font callback remains diagnostic only.
- Direct `RunL` invocation still bypasses the full Symbian `CActiveScheduler`.
- No E32Image/SIS has been produced, and no real N95 launch/test has occurred.

This checkpoint is a substantial correction to the ARM lift and text-call ABI, not a claim that Shadowkey is already running on the phone.
