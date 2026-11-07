# Shadowkey v8.3 — CONE ordinal 226 semantic resolution

Date: 2026-10-31

## Result

The four call sites of `CONE[10003a41].DLL` ordinal 226 now strongly identify it as the `CCoeControl::SystemGc()` accessor, returning a reference/pointer to the standard `CWindowGc` owned by the control environment. The paired ordinal 55 is strongly identified as `CCoeControl::DrawableWindow()`. This is a call-site semantic resolution, not yet a direct ordinal-table proof: the exact S60 3rd FP1 `cone.lib`/DEF export map is still unavailable in this workspace.

## Evidence from the original lifted ARM control flow

Ordinal 226 is called at four locations:

| Caller | Call address | Receiver setup | Result use |
|---|---:|---|---|
| `sub_10021b98` | `0x10021D78` | `r0 = r7` | returned object virtual slot `+0x48` |
| `sub_1002256c` | `0x100226A0` | `r0 = r6` | paired with ordinal 55, then virtual slot `+0xD8` |
| `sub_10022898` | `0x100228A4` | `this` saved from entry `r0` into `r8` | paired with ordinal 55, then virtual slot `+0xD8` |
| `sub_10028260` | `0x10028294` | `r0 = r6` | returned object virtual slots `+0x48` and `+0xB8` |

Only two call sites use ordinal 55. In both, the sequence is structurally identical:

1. Call ordinal 226 with the control object in `r0`.
2. Retain the returned interface pointer.
3. Call ordinal 55 with the *same control object* in `r0`.
4. Move ordinal 55's result into `r1` and the ordinal 226 result into `r0`.
5. Load a virtual function pointer at byte offset `0xD8` from the returned object's vtable and invoke it with the ordinal 55 result.

This matches the documented Symbian drawing idiom:

```cpp
CWindowGc& gc = SystemGc();
gc.Activate(*DrawableWindow());
```

The match is not based on the `r1=0xAF` / `r3=0xD0` values from the failing trace. Those registers are not set up as arguments at the ordinal-226 call sites; the previous report's suggestion that they were meaningful dimensions was speculative and should be discarded.

The remaining two ordinal-226 call sites invoke the returned object's virtual slots `+0x48` and `+0xB8`, consistent with additional operations on a graphics context.

## External API corroboration

The Symbian API documentation describes `CCoeControl::SystemGc()` as the way for a control to obtain its standard `CWindowGc`, and the standard drawing sequence uses that context with the control's window. A Symbian programming reference also shows `gc.Activate(*DrawableWindow())` as the paired operation.

References:

- S60 programming reference: `CWindowGc` is the standard graphics context exposed by `CCoeControl::SystemGc()` — https://citeseerx.ist.psu.edu/document?doi=6b60e8e5e6fd061670c4f8430e618f56d1bc3260&repid=rep1&type=pdf
- Symbian C++ reference example showing `SystemGc()` followed by `Activate(*DrawableWindow())` — https://www.cnblogs.com/jason-jiang/archive/2006/11/03/549244.html
- Symbian C++ book describing `SystemGc()` and the window graphics context — https://girtel.upct.es/~eegea/pub/symbian_book.pdf

## Consequence for the port

This changes the implementation plan materially:

- Do **not** allocate an arbitrary new object for ordinal 226.
- Do **not** invent a fake vtable based on the receiver object's vtable.
- The result should be the process/control environment's existing standard graphics-context object (`CWindowGc`).
- Ordinal 55 should return the control's existing drawable-window object/reference.
- The `+0xD8` call is the graphics-context activation step. A real implementation must connect it to a window/surface backend, not merely return a non-null pointer.
- The `+0x48` and `+0xB8` virtual calls need their own argument/slot mapping before the GC shim can be considered complete.

The current diagnostic harness has no real CONE environment, window server session, screen device, or `CWindowGc`; therefore the null result is a missing framework object, not evidence that the game object itself is corrupt.

## Automated regression check

`shadowkey_cone_ordinal226_analysis.py` checks that:

- the lifted image still has four ordinal-226 call sites and two ordinal-55 call sites;
- both paired sites preserve the same control receiver;
- both paired sites call the returned object's vtable slot `+0xD8` with ordinal 55's result;
- the other ordinal-226 callers use the returned object's slots `+0x48` and `+0xB8`.

The check is now part of `build_and_test.sh`.

## Validation and remaining blocker

- `./build_and_test.sh` — PASS, including the new ordinal-226 semantic regression checks.
- `./trace_asset_loader_vfs.sh` — still reaches the same real `global.spr` image-decoder path and stops when the HLE returns null for ordinal 226.
- No actual `CWindowGc`/window-server backend has been implemented yet.
- No N95-installable E32Image has been produced.

Next step: recover the control's `CCoeEnv`/window relationship from the initialized AppUi/engine objects, then implement a minimal but correctly shaped `CWindowGc` + drawable-window backend for the diagnostic harness. After that, resolve slots `+0x48` and `+0xB8` from their call arguments and continue tracing the image decode/render path.
