# Shadowkey v8.4 — step26: font-name descriptor provenance

## Scope

This checkpoint advances the font-selection path between the live text-building code and GDI ordinal 151. It does **not** render glyphs or claim a device launch.

## Confirmed findings

1. **GDI ordinal 151 is called with the shape of `TFontSpec(const TDesC&, TInt)`.** The observed arguments are a 60-byte destination at `0x102fecf0`, a 20-byte descriptor-like source at `0x102fed30`, and height `213` twips. The returned specification is passed to the graphics-device virtual slot `+0x44` to obtain a `CFont`.
2. The 20-byte source is built immediately before GDI 151:
   - EUSER ordinal 1407: `r0=0x102fe6d8`, `r1=0x100ac718`, `r2=0`, `r3=0xa0`.
   - EUSER ordinal 1282: `r0=0x102fed30`, `r1=0x102fe6d8`, `r2=20`.
3. The E32 image code offset is `0x7c`. Therefore VA `0x100ac718` maps to file offset `0x0ac794` in `6R51.APP`; the bytes there are UTF-16 `Swiss` followed by NUL. This is a direct binary mapping, not a guessed font name.
4. Other EUSER 1407 call sites pass actual formatting strings, including `%x`, with following arguments in registers/stack. Its call shape matches Symbian `TDes16::Format(TRefByValue<const TDesC16>, ...)`. The export name/ordinal association is still an inference until checked against the target FP1 EUSER export table.
5. EUSER ordinal 1282 is now implemented in both host VFS HLE and ARM-core bootstrap as a bounded three-argument byte-copy using overlap-safe `memmove`. The call shape is compatible with `Mem::Copy(dst, src, length)`, but the exact export name is not yet verified. Observed lengths include 20, 32, and 256 bytes. The step26 core test covers a 24-byte overlapping copy.
6. The live trace now confirms that EUSER 1282 copies the 20-byte object into the exact source address later passed to GDI 151.

## The current blocker

EUSER ordinal 1407 is still unresolved. The live trace shows its destination area containing stale UTF-16 path bytes (`apps\\6R51\\`) before the call. Because no handler formats/initializes that destination, the subsequent EUSER 1282 copy faithfully copies those stale bytes. GDI 151 consequently receives the stale path data instead of a valid typeface descriptor.

This establishes the immediate failure point in font selection: the copy operation is no longer missing; the producer of the 20-byte descriptor-like object is.

## Important limits

- EUSER 1407's observed ABI strongly matches `TDes16::Format`, but this is not yet a ROM-export-table-proven identity.
- The exact in-memory layout and maximum length of the 20-byte object must be decoded before implementing the formatter. No guessed descriptor header is written.
- GDI ordinal 108 remains unresolved. It is called immediately after GDI 151 with `r0` pointing four bytes before the descriptor copy; this is not evidence that it retrieves glyphs.
- `CFont` remains a synthetic host diagnostic object. GDI `DrawText` still does not rasterize characters and the pixel buffer is unchanged.
- ARM EABI5 core and static ELF linkcheck are not E32Image/SIS packages. No physical N95 launch has been performed.

## Tests

- `build_and_test.sh`: PASS.
- `shadowkey_step26_core_hle_test.sh`: PASS (includes EUSER 1282 overlapping Mem::Copy and prior HLE checks).
- `trace_asset_loader_live_vfs.sh`: PASS; the live path reaches GDI 151 with the 20-byte copied descriptor source.
- `shadowkey_step26_font_name_audit.py`: PASS; verifies E32 VA/file mapping, `Swiss` literal, call-site arguments, and live trace evidence.
- `build_arm11_core.sh`: PASS; ARM EABI5 relocatable core rebuilt.
- `build_arm11_linkcheck.sh`: PASS; static ARM ELF has no undefined symbols. `E32Main` remains a deliberate no-op stub.

## Next target

Recover EUSER 1407's exact descriptor/formatting ABI from the target FP1 EUSER export body or a matching import library. Then implement it with the actual Symbian descriptor representation, re-run GDI 151, and inspect the resulting `TFontSpec` fields before proceeding to the real font object and glyph rasterization.
