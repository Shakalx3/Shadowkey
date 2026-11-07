# Shadowkey v8.4 — step19: TFontSpec, CFbsBitmapDevice and virtual slot +0x44

## Scope

Static analysis of the lifted ARM caller and import table. No new HLE handler was added. This is not a physical N95 test or a claim that the game now renders text.

## 1. The 60-byte object is a TFontSpec

At the first site (`sub_10022b20`, ARM VA `0x10022b20`):

- `r0 = SP+0x22c`
- `r1 = SP+0x26c`
- `r2 = 0xD5` (213)
- call target `0x100a00a0` maps to GDI ordinal 151.

The call shape is `TFontSpec::TFontSpec(const TDesC&, TInt)`: destination object, typeface-name descriptor, height in twips. The documented constructor initializes the default font style as well. The constructed object occupies `[SP+0x22c, SP+0x268)`, exactly 60 bytes in this caller's frame.

The later virtual call passes:

- `r0 = *(engine+0x2e8)` — graphics device object
- `r1 = SP+0x18` — address of the output `CFont*`
- `r2 = SP+0x22c` — const reference to the constructed `TFontSpec`
- target loaded from `[device->vtable + 0x44]`.

The caller does not directly inspect the fields of the 60-byte object. The observed data flow is constructor write -> const-reference argument to the device's font-selection virtual method. The 60-byte region is not a glyph bitmap or raster buffer.

The same high-level pattern occurs at all five call sites (`sub_10022b20`, `sub_10022d48`, `sub_10022f88`, `sub_100231b4`, `sub_10023608`), although later functions use different stack-frame offsets for their local TFontSpec and CFont* output.

## 2. engine+0x2e8 is CFbsBitmapDevice*

Construction chain in `sub_10021244`:

1. `sub_1000b9c8` creates a `CFbsBitmap` using width 176, height 233 and display mode 10; result stored at `engine+0x2e4`.
2. `sub_1000ba7c` calls BITGDI ordinal 86 with the bitmap pointer and returns the created device; result stored at `engine+0x2e8`.
3. `sub_1000bab8` calls BITGDI ordinal 23 with that device and an output pointer; result stored at `engine+0x2ec` as the graphics context.

This matches the documented Symbian sequence `CFbsBitmap` -> `CFbsBitmapDevice::NewL(bitmap)` -> `CreateContext(gc)`.

Thus `engine+0x2e8` is not a font provider/cache object. It is the bitmap graphics device backing the off-screen bitmap.

## 3. Virtual slot +0x44

The method ABI at the five sites is `device, CFont*& out, const TFontSpec& spec`. That matches `MGraphicsDeviceMap::GetNearestFontInTwips(CFont*&, const TFontSpec&)` / its implementation on the concrete graphics device. The vtable byte offset `0x44` is therefore identified as the nearest-font lookup method with high confidence.

This method selects/returns a `CFont*`; it does not itself draw a glyph. The next object in the engine (`+0x2ec`, the graphics context) is then used for subsequent operations. This corrects the previous working assumption that slot +0x44 consumed a glyph image record.

## 4. Read/write accounting for the 60-byte span

Across the five text sites:

- GDI ordinal 151 receives the destination address and constructs the `TFontSpec`.
- The caller subsequently passes the same object address as `r2` to the device virtual method at vtable byte offset `+0x44`.
- No caller-side field reads or writes into the 60-byte object were found between construction and that call; the structure is treated opaquely by the lifted caller.
- The virtual method is the first consumer visible at this layer. Its internal implementation is not in the lifted game module; it belongs to the imported/device-side implementation.

The 20-byte source object is passed as `const TDesC&` to the constructor. Its exact concrete descriptor class and contents still need to be traced; do not assume it is a NUL-terminated C string.

## 5. Remaining unknowns

- Exact S60 3rd FP1 export name for GDI ordinal 151 has not been checked against the matching SDK export table; the constructor signature is inferred from the ARM ABI and matches the public API.
- GDI ordinals 101 and 108 remain unresolved. Their 4-byte work/result slot is separate from the 60-byte `TFontSpec`.
- The exact concrete type of the 20-byte descriptor object remains unresolved.
- Font lookup does not yet prove successful glyph acquisition or rasterization. Next trace: returned `CFont*`, context `UseFont`, and subsequent draw/measure calls.

## 6. Verification

- `shadowkey_step17_text_chain_audit.py`: PASS.
- `shadowkey_step18_text_chain_audit.py`: PASS.
- `build_arm11_core.sh`: PASS; ARM EABI5 relocatable core.
- `build_arm11_linkcheck.sh`: PASS; static ARM ELF with no undefined symbols (still a diagnostic stub executable, not an E32Image).
- `step12_forensics/build_and_test.sh`: NOT PASS in this archive: its script references missing `shadowkey_appui_construct_test.c`. This pre-existing packaging gap is recorded rather than hidden.

## Sources

- Symbian `TFontSpec` reference: constructor takes `const TDesC&` and `TInt`; stores `iTypeface`, `iHeight`, and `iFontStyle`.
- Symbian `CGraphicsDevice` / `MGraphicsDeviceMap` reference: `GetNearestFontInTwips(CFont*&, const TFontSpec&)` is virtual and returns an error code.
- Symbian off-screen graphics example: create `CFbsBitmap`, create `CFbsBitmapDevice` from it, then call `CreateContext`.
