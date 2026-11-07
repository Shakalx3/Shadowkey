# Shadowkey v8.4 — step21: identify DrawText overload and font discard

## Result

The four contiguous text-rendering sites now match the public Symbian `CGraphicsContext::DrawText` rectangle overload with high confidence:

`DrawText(const TDesC& aText, const TRect& aBox, TInt aBaseline, TTextAlign aAlign = ELeft, TInt aMargin = 0)`

The immediately following no-argument virtual call at context vtable byte offset `+0x28` matches `CGraphicsContext::DiscardFont()` with high confidence.

This is a caller-side ABI identification. The exact S60 3rd Edition FP1 vtable map/export table was not present in this workspace, so the names are not claimed as ROM/export-table proof.

## ABI evidence at the four sites

The four functions are:

- `sub_10022b20`
- `sub_10022d48`
- `sub_10022f88`
- `sub_100231b4`

At each `CGraphicsContext` virtual call loaded from byte offset `+0xA8`, the caller prepares:

- `r0`: graphics context (`engine+0x2EC`)
- `r1`: descriptor-like text object
- `r2`: pointer to a 16-byte rectangle record (`TRect`-compatible)
- `r3`: baseline offset
- `[sp]`: alignment argument
- `[sp+4]`: margin argument

This matches the five-parameter C++ method after the implicit `this` pointer. The stack arguments distinguish it from a simpler `DrawText(text, point)` overload.

Observed trailing arguments:

| Caller | alignment | margin |
|---|---:|---:|
| `sub_10022b20` | 0 | 0 |
| `sub_10022d48` | 1 | 0 |
| `sub_10022f88` | 2 | 0 |
| `sub_100231b4` | dynamic value loaded from `[sp+0x0C]` | same dynamic value |

The first three values are consistent with the `TTextAlign` enum's left/center/right values. The fourth call passes a runtime value, not a hard-coded alignment.

The call at byte offset `+0x28` immediately follows the draw call at all four sites and has no explicit arguments beyond `this`. The documented `UseFont -> DrawText -> DiscardFont` usage sequence matches the observed call ordering.

## Font and geometry flow

The `CFont*` returned by the bitmap device is passed to the graphics context at slot `+0x24`, consistent with `UseFont(CFont*)`.

The font object is then queried through its own virtual methods at `+0x10` and `+0x14`; those return values participate in baseline calculation. The caller prepares the rectangle record after the `TFontSpec` has been consumed by `GetNearestFontInTwips`, reusing the same local stack area. The text descriptor is a separate object.

## HLE diagnostic update

`shadowkey_bitgdi_hle.c` now:

- labels the `+0xA8` operation as a `DrawText`-compatible diagnostic call;
- reads and logs the four rectangle coordinates, baseline, alignment, and margin from the guest ABI locations;
- labels `+0x28` as `DiscardFont` and clears the selected font in the diagnostic context record.

It deliberately does **not** rasterize glyphs or modify the bitmap pixels. This avoids fabricating a rendered result without a real font backend.

## Important execution limitation discovered

`sh trace_asset_loader_vfs.sh` still exits nonzero because its diagnostic application run does not reach the graphics-context virtual-call chain (`FAIL: graphics-context virtual call chain was not reached`). The script's internal app-run reports exit code 0, but that is not evidence that the DrawText handler ran. The previous trace excerpts containing virtual-call logs are from a separate earlier diagnostic path and do not replace this current reachability failure.

Therefore:

- static caller ABI audit: PASS;
- ARM EABI5 core build: PASS;
- static ARM ELF linkcheck: PASS, but it still has a no-op `E32Main`;
- actual HLE DrawText execution in the current end-to-end VFS run: NOT REACHED;
- real font lookup, glyph rasterization, pixel writes, E32Image packaging, and physical N95 launch: NOT VERIFIED.

## Next work

1. Find why the engine's current diagnostic RUNL path is forced to zero before the text sites; make the app progress through the actual initialization path without bypassing required state.
2. Trace the descriptor's concrete type and text contents at the four DrawText sites.
3. Add a controlled unit test for the diagnostic DrawText ABI logger, separate from end-to-end app reachability.
4. Then implement a real glyph path or connect to the Symbian FBS/GDI backend. Do not claim text is rendered until the 176x233 backing pixels change and a resulting image is inspected.
5. Continue the native E32 startup/toolchain track separately; current ELF is not installable on N95.

## Reference API evidence

The Symbian graphics examples show the sequence `UseFont`, `DrawText(text, rect, baseline, alignment, margin)`, `DiscardFont`, and font release. The caller's argument placement and post-call cleanup match that API sequence.
