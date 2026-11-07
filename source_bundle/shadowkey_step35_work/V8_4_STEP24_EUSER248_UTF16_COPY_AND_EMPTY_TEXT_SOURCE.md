# Shadowkey v8.4 — step24: EUSER 248 UTF-16 copy and the empty text source

## Result

EUSER ordinal 248 now has a behavior-backed host implementation for the observed call shape: `TDes16::Copy(const TUint16*)`. This is a call-site/API-shape identification, not proof from the exact N95 FP1 EUSER export table. The handler accepts a writable inline `TBuf16` destination in `r0` and a zero-terminated UTF-16 source pointer in `r1`, copies code units, updates the destination length, and rejects invalid ranges or overflow rather than silently fabricating text.

The upstream string source was then traced one layer farther. Two previously unimplemented ESTLIB calls are used in this exact path:

- ESTLIB ordinal 317 is called as a two-pointer UTF-16 string replacement/copy operation.
- ESTLIB ordinal 315 is called as a two-pointer UTF-16 append operation.

The handlers now model those observed semantics as UTF-16 `copy` and `append`. Their exact export names are still not confirmed against the FP1 ESTLIB export table; the mapping is based on 84/25 static call sites, argument patterns, UTF-16 literals, and the live data effect.

## Evidence

- There are 12 static EUSER-248 call sites in the recovered image.
- The relevant text-path calls use a TBuf-style destination in `r0`; `r1` is a raw UTF-16 data pointer, not a descriptor object.
- In the live high-RAM path at `lr=0x10023488`:
  - `r0=0x102fe8e8`: descriptor header `0x30000000`, max length 256, inline data contains stale UTF-16 bytes spelling `titles.txt`;
  - `r1=0x102feaf0`: 512-byte workspace, all zero at call time;
  - `r2=0x102fedb4` is not used by this two-argument call.
- The handler therefore correctly sets descriptor length to zero. The stale `titles.txt` bytes remain outside the logical descriptor length and must not be displayed.
- The next text-path call at `lr=0x10023544` copies a substring from `0x102fedc8` into `0x102fe6e0`, producing length 10 and the text `d the game`.
- The 512-byte source workspace is zeroed immediately before the text-conversion loop. The original step23 path left it empty because ESTLIB ordinals 315/317 were unimplemented.
- With the new UTF-16 copy/append handlers, the source is now populated before conversion. The live parser reads the text `has paused the game`; the first DrawText descriptor receives length 19. A second descriptor receives length 10 (`d the game`).
- This confirms that the earlier zero-length descriptor was an HLE gap upstream of EUSER 248, not evidence that the game itself intentionally passed an empty string.

## EUSER 711 remains unresolved

Four static call sites pass `r0` as the output area later consumed as a `TRect`, with four coordinate-sized arguments split across `r1`, `r2`, `r3`, and `[sp]`. The live values are `(0, 13, -15, 0)`. The output buffer is stale before the call. This is consistent with a TRect construction/set operation, but the overload and exact ordinal identity are not proven. No implementation was added.

## Tests

- `shadowkey_step24_euser248_test.sh` — PASS: non-empty UTF-16 copy, empty source, overflow guard.
- `shadowkey_step24_estlib_wide_strings_test.sh` — PASS: UTF-16 replace and append semantics.
- `trace_asset_loader_live_vfs.sh` — PASS with the new handlers.
- Live path reaches DrawText with non-empty descriptors (lengths 19 and 10), then DiscardFont. The rectangle is still stale; no glyph rasterization or pixel writes are claimed.

## Next frontier

1. Resolve EUSER 711's exact TRect operation and output semantics. Its four call sites pass an output object followed by four coordinate-sized values; the live call is `(0, 13, -15, 0)`. A TRect construction/set operation is likely, but the overload is not proven.
2. Trace the remaining DrawText call path and determine whether the current descriptor strings and rectangle are intended to be visible text or a font/atlas measurement path.
3. Only after the rectangle and font object are valid, proceed to GDI 151/108 and actual pixel writes.

This remains a host diagnostic run with a direct RunL probe, not a full Symbian active-scheduler run and not a physical N95 launch.
