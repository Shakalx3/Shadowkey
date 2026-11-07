# Shadowkey v8.4 — diagnostic CONE graphics-context breakthrough

Date: 2026-11-01

## Milestone

The v8.3 trace stopped immediately after `CONE[10003a41].DLL` ordinal 226 returned null. A deliberately diagnostic-only CONE shim now returns a stable guest-side graphics-context object for ordinal 226 and a stable drawable-window identity for ordinal 55. The recovered ARM then performs the expected virtual dispatch sequence:

1. ordinal 226 returns guest object `0x102FE100`;
2. ordinal 55 returns guest window identity `0x102FE200`;
3. virtual slot `+0xD8` dispatches to the diagnostic `Activate` handler;
4. virtual slot `+0xDC` dispatches to the diagnostic `Deactivate` handler.

The previous immediate null dereference at `0x100228AC` is gone. This is the first demonstrated advance past the v8.3 CONE/SystemGc boundary.

## More original assets reached

The trace now opens, in addition to the previously verified `StringTable.eng` and `global.spr`:

- `entities.txt` (22,064 bytes)
- `menu_sprites.txt` (252 bytes)

The original game code continues through the graphics-context setup and proceeds into additional startup/resource parsing code.

## Exact next blocker

The next reproducible stop is:

```text
OOB 00000080/4
TRACE sub_1001f9ac ctor obj=10176b38 source=10111208 source+0x14a3c=00000000
```

The zero dereference occurs inside the recovered constructor `sub_1001f9ac` after it reads a pointer from `source + 0x14A3C` and then attempts to read the object's vtable at offset `+0x80`.

The source object at `0x10111208` was allocated earlier as an 85,524-byte (`0x14E14`) block, so `0x14A3C` is inside that allocation. Its value is currently zero in this harness. The exact semantic name of this field is not established yet. It may be a resource/manager subobject that should have been populated by an earlier constructor or import; do not patch it with an arbitrary pointer.

The next investigation is to trace all writes/constructor paths for the large object at `0x10111208`, identify the expected source of its `+0x14A3C` field, and resolve the preceding unimplemented imports that may be responsible for populating it.

## Scope and limitations

- The new `CWindowGc` and drawable-window objects are **synthetic diagnostic objects**, not native Symbian framework objects.
- `Activate` and `Deactivate` are no-op probes that preserve execution and log arguments. They do not create a real N95 screen surface and do not render pixels.
- The vtable handlers at `+0x48` and `+0xB8` are present as observed-call-site probes but were not reached in this trace and their semantics remain unresolved.
- This does not produce a playable build or an N95-installable E32Image.

## Validation

- `./build_and_test.sh` — PASS.
- `./trace_asset_loader_vfs.sh` — passes the new milestone regression: SystemGc, DrawableWindow, Activate, Deactivate, `entities.txt`, and `menu_sprites.txt` are observed; old null-return crash is absent.
- The trace intentionally terminates at the next bounds-checked failure `0x80/4`, localized to the null `source+0x14A3C` pointer described above.
