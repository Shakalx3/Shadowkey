# Crypt3 texture and placement checkpoint — 2026-11-27

## Confirmed: indexed texture atlas

The decoded `Crypt3.ztx.raw` is 294,913 bytes. Its first byte is `0x12`; the remaining 294,912 bytes are exactly `768 × 384` bytes. `Crypt3.pal` is exactly 768 bytes, i.e. 256 RGB triplets.

Interpreting the pixel plane as 8-bit palette indices and applying the 256-entry RGB palette produces a coherent texture atlas: stone wall courses, carved stone bands, floor/trim details, and a blue water texture region are visibly recognizable. This is substantially stronger evidence than the earlier raw RGB interpretations.

What is confirmed:
- pixel plane size: 768 × 384;
- 8-bit indexed interpretation;
- companion palette size: 256 × RGB;
- palette application yields coherent game textures.

Still unknown:
- meaning of the leading `0x12` byte;
- whether the atlas has additional tile/page metadata elsewhere;
- exact UV rectangles and which model/material references each region.

A standard-library exporter, `tools/export_crypt3_texture.py`, writes `Crypt3_texture_atlas.bmp` as an indexed BMP without requiring Pillow. The Crypt3 inspection workflow now runs this exporter and uploads the BMP with the raw resources.

## Entity placements

`Crypt3.ent` remains an exact table of 129 records × 72 bytes after a 4-byte count header. The first three signed 32-bit fields form plausible position coordinates when divided by 256; across all 129 records the resulting X/Y range is approximately 2.03–124.97 and 2.03–125.97. The Z range is approximately -5.74–9.30.

The signed 32-bit field at record offset 20 divided by 256 yields plausible degree-like values (for example -76, 60, -60, -70). It is a yaw/rotation candidate, not yet proven.

## Companion structures requiring further decoding

- `Crypt3.zon`: 8 name records embedded in 72-byte padded blocks; names include WatersOfRS, Spotted, Entrance, crypt2, Awaits, Forge, and UmbraHere. The preceding groups of four 16-bit values may be bounds or region coordinates, but field semantics are unverified.
- `Crypt3.pth`: 254 bytes; begins with a count of 1 and the label UmbraKeth, then a value 23 and packed coordinate-like data. Its record layout remains unresolved.
- `Crypt3.sur`: 137 bytes = 1 count byte plus 17 records of 8 bytes. Several records contain compact nonzero flags/values. Semantics remain unresolved.

## Next validation steps

1. Compare the entity XY scatter with the named region values in `.zon` before assigning region membership.
2. Decode `.pth` and `.sur` record fields using correlations with entity positions and known object types.
3. Inspect model/material references to map atlas rectangles to wall, floor, water, and prop textures.
4. Keep coordinate scale, yaw units, and region bounds marked as hypotheses until cross-validated.
