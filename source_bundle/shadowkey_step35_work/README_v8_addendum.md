# v8 addendum

This iteration adds real-resource tracing and a focused diagnosis of the next startup blocker.

- The harness now allocates a 37,956-byte resource buffer and reads the original resource at `global.spr` offset `0x163B1F`.
- Resource header bytes decode to 176 × 208.
- The earlier heap-end failure is avoided by extending the diagnostic heap only after AppUi construction.
- A clearly marked diagnostic-only buffer override allows the image-decoder path to proceed beyond a null graphics pointer.
- The next failure is a null return from `CONE` ordinal 226, followed by a dereference at guest address zero.
- The standard smoke test passes.

The diagnostic override is not part of a real phone build and must be replaced by proper graphics initialization.


## v8.4 diagnostic graphics-context milestone

The v8.4 trace crosses the prior CONE ordinal-226 null return using a clearly isolated synthetic diagnostic `CWindowGc`/drawable-window shim. It reaches the original `Activate` and `Deactivate` virtual calls and opens `entities.txt` and `menu_sprites.txt`. The next stop is a null pointer at source object `0x10111208 + 0x14A3C` inside `sub_1001f9ac`. The shim is not a native Symbian graphics backend and does not render pixels. See `V8_4_GC_BACKEND_BREAKTHROUGH.md`.
