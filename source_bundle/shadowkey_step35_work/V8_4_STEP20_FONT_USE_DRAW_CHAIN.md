# Shadowkey v8.4 — step20: font acquisition, context binding, and draw candidate

## Scope

This step follows the `CFont*` returned by the nearest-font request through the caller. It is static analysis of the lifted ARM caller; it does not emulate the Symbian graphics server and does not claim visible text was rendered.

## Confirmed call/data sequence at the five text sites

Across `sub_10022b20`, `sub_10022d48`, `sub_10022f88`, `sub_100231b4`, and `sub_10023608` the caller performs the same high-level sequence:

1. Load `engine+0x2e8` (`CFbsBitmapDevice*`) and call its vtable byte offset `+0x44` with `r1` pointing to a stack output slot for `CFont*` and `r2` pointing to the 60-byte font-spec object.
2. Load `engine+0x2ec` (`CGraphicsContext*`), load the returned `CFont*` from that output slot, and call context vtable byte offset `+0x24` with that font pointer in `r1`. This is strongly consistent with `CGraphicsContext::UseFont(CFont*)`.
3. Prepare a separate text/geometry record. The caller invokes methods on the descriptor-like object and computes a coordinate/extent value; this is not the 60-byte `TFontSpec` being passed as a glyph bitmap.
4. Call a method on the graphics context at vtable byte offset `+0xA8` (42nd 4-byte slot) with `r1` pointing at the prepared descriptor-like object and `r2/r3` carrying geometry-related arguments. In the first site, two zero-valued stack arguments are also prepared. This is the strongest draw-operation candidate in this chain, but its exact overload/name is not yet proven from a matching FP1 vtable.
5. Call the graphics-context vtable byte offset `+0x28` after the draw candidate. Its placement and receiver are consistent with font/context cleanup (possibly `DiscardFont`), but the exact method name is not yet confirmed.

## First-site instruction-level detail (`sub_10022b20`)

- `0x10022bd4..0x10022bf0`: `device->vtable[0x44/4]`, args `(device, &fontOut, &fontSpec)`.
- `0x10022bf4..0x10022c08`: `gc->vtable[0x24/4]`, args `(gc, fontOut)`.
- `0x10022c0c..0x10022c38`: builds a small packed geometry/metadata value and calls a method on the font object/descriptor path.
- `0x10022c3c..0x10022c84`: calculates a text extent/position using the returned values and a second descriptor method.
- `0x10022ca0..0x10022cc8`: invokes `gc->vtable[0x3c/4]` with a local geometry record. Exact method semantics unresolved.
- `0x10022ce0..0x10022d0c`: calls `gc->vtable[0xA8/4]` with descriptor-like text input and geometry values. This is the draw candidate.
- `0x10022d0c..0x10022d20`: calls `gc->vtable[0x28/4]` after the draw candidate.

## What is now known vs. still unknown

Known from caller-side data flow:

- the font object is acquired through the bitmap device;
- that returned object is explicitly installed into the graphics context before the drawing candidate;
- a descriptor-like text input and geometry are passed to the later graphics-context call;
- the context receives a cleanup call afterwards;
- the same pattern exists at all five text sites.

Not yet proven:

- exact S60 3rd FP1 names for vtable slots `+0x24`, `+0x28`, `+0x3c`, and `+0xA8`;
- concrete descriptor type and exact text contents;
- whether the `+0xA8` overload is `DrawText` or a related text-layout operation;
- successful font lookup, glyph rasterization, or pixels written by this path.

## Native-port implication

This closes the caller-side link between font lookup and a text-drawing call candidate. It does **not** remove the larger native-port blockers: the current harness still uses synthetic graphics objects, the real FBS/BITGDI/CONE backend is not connected, and the generated ARM ELF is not a Symbian E32Image. No N95 device launch has been performed.

## Verification

- `shadowkey_step20_font_draw_audit.py`: PASS for all five sites.
- `shadowkey_step19_tfont_device_audit.py`: PASS.
- `shadowkey_step18_text_chain_audit.py`: PASS.
- `shadowkey_step17_text_chain_audit.py`: PASS.
- `build_arm11_core.sh`: PASS (ARM EABI5 relocatable core).
- `build_arm11_linkcheck.sh`: PASS (static diagnostic ELF; `E32Main` remains a no-op stub).

## Correction to the previous five-site summary

The five call sites should not be described as five identical complete draw sequences. Four sites contain the contiguous `GetNearestFont -> UseFont -> +0xA8 draw candidate -> +0x28 post-draw call` chain. `sub_10023608` is a distinct per-character path: it contains the nearest-font request and a later `+0x28` context call, but the same contiguous `UseFont/+0xA8` pattern is not present in that function body. The step20 audit records this divergence explicitly.
