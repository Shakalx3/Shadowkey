# Shadowkey v8.4 — step17: deeper text-chain and geometry data-flow audit

## Scope

Static continuation from the step16 archive. The lifted ARM source was re-read around the complete caller functions, not just the import thunks. No guessed HLE handlers were added. This remains a host-side reverse-engineering milestone, not a native N95 launch.

## 1. CONE ordinal 160: hidden-result contract confirmed; TSize hypothesis weakened

The four sites continue to show the ARM hidden-result pattern (`r0` = caller temporary, `r1` = control object). A re-read of `0x10021400` in `sub_10021244` corrects the previous interpretation:

1. A pair of 32-bit values is returned into `sp+0x0c`.
2. EUSER ordinal 1086 is called with `r0=sp` and `r1=sp+0x0c`.
3. The caller then overwrites `sp[0]` and `sp[1]` with constants `176` and `233` before constructing the bitmap in display mode `10`.

Therefore the CONE 160 result is **not** the source of the bitmap dimensions at this site. That earlier claim was wrong and is withdrawn.

At `0x10021D8C` and `0x100282A8`, the returned pair is passed by pointer to a graphics-context virtual at vtable byte offset `+0xB8`. A third site passes the pair onward through another object virtual at `+0xC0`. This keeps a `TPoint`/`TSize`-like value-structure interpretation plausible, but does not distinguish the two. Since the receiver at the `+0xB8` sites is the `SystemGc()` result, `CCoeControl::Position() const` (returning `TPoint`) is now the stronger working candidate: graphics contexts use `TPoint` for coordinate origins. `CCoeControl::Size() const` remains possible until the exact `+0xB8` virtual slot is mapped. Neither name is confirmed. Exact vtable-slot semantics or the S60 3rd FP1 CONE export table are required before implementing the HLE.

## 2. EUSER ordinal 1575: confirmed transactional output pattern; semantic still unresolved

At the only call site (`0x1002290C` in `sub_10022898`):

- `r0 = sp+0x34`, an 8-byte caller-owned output/work pair initially seeded from `object+0x320`;
- `r1 = object+0x310`, the related 8-byte object field;
- `r0` return value is tested immediately; zero branches to cleanup/failure;
- only on nonzero success does the caller copy the two output words back to `object+0x310`.

After success, the caller reads the two words at `object+0x318`, computes their difference, calls EUSER ordinal 1557 with three pointers (`sp+0x2c`, `sp+0x34`, `object+0x310`), and updates `object+0x31c` from `object+0x318`. It also maintains a nine-entry pointer table at `object+0x330` and a byte-sized count/state at `object+0x358`.

This is more than a generic pair copy: the call is part of a stateful cache/list/descriptor operation. The exact type and EUSER API are not yet identified, so no behavior was implemented.

## 3. GDI 151 and 108: the next layer after input preparation

In `sub_10022b20` (and four structurally similar call sites):

- a 20-byte temporary is prepared;
- GDI ordinal 151 is called with `r0=sp+0x22c`, `r1=sp+0x26c`, `r2=0xD5`;
- GDI ordinal 108 is then called with `r0=sp+0x268` and `r1` selecting either a prepared object or null;
- the returned/prepared object is consumed by subsequent virtual calls, including a call through vtable offset `+0x44` on the object at engine offset `+0x2e8`.

The stable order and argument shapes support a character/font-data processing path. The exact GDI methods and the layout of the 60-byte output area are not proven. In particular, the fixed code `0xD5` should not be described as a full text string; it is only the explicit code argument observed at these call sites.

## 4. Text rendering frontier

The trace now distinguishes three layers:

1. font/character preparation via GDI 151 and GDI 108;
2. a later object-level virtual dispatch on the prepared data;
3. graphics-context operations through the already identified CONE `SystemGc` path and related graphics objects.

The remaining task is to recover the structures and object ownership across those boundaries. Implementing a fake glyph or no-op at either GDI import would hide the data flow rather than reproduce it.

## 5. Regression

`shadowkey_step17_text_chain_audit.py` checks the call-site contracts, including the corrected overwrite at `0x10021400`, and their ordering against the lifted source. It intentionally does not assert an exact export name. Existing `build_and_test.sh`, ARM core build, and ARM link-check remain the broader regression gates.

## Next work

1. Map CWindowGc vtable slot `+0xB8` against the exact S60 3rd FP1 GDI virtual-method order; this should distinguish `TPoint` from `TSize` use.
2. Acquire/import-map evidence for the exact S60 3rd FP1 `cone.lib`, `euser.lib`, and `gdi.lib` exports.
3. Identify the 20-byte input and 60-byte output structures around GDI 151.
4. Trace the result of GDI 108 through the virtual calls at `+0x44`, `+0x24`, and the graphics-context path.
5. Resolve EUSER 1575 and its adjacent EUSER 1557/1379/1515 calls as a connected stateful operation.
