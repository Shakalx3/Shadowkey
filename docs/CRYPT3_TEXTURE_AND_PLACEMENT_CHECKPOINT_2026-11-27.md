# Crypt3 texture and placement checkpoint — 2026-11-27

## Confirmed: indexed texture atlas

The decoded `Crypt3.ztx.raw` is 294,913 bytes. Its first byte is `0x12`; the remaining 294,912 bytes are exactly `768 × 384` bytes. `Crypt3.pal` is exactly 768 bytes, i.e. 256 RGB triplets.

Interpreting the pixel plane as 8-bit palette indices and applying the 256-entry RGB palette produces a coherent texture atlas: repeating stone wall courses, carved stone bands, and several horizontal decorative/trim bands are visibly recognizable. The current atlas preview does not establish a water texture. This is substantially stronger evidence than the earlier raw RGB interpretations.

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
- `Crypt3.pth`: 254 bytes. It contains the label `UmbraKeth`, a 16-bit waypoint count of 23 at offset `0x42`, then exactly 46 32-bit coordinate words beginning at `0x46`. Each word has a 16-bit coordinate payload and a zero upper half. Interpreting each payload as signed 8.8 coordinates yields 23 plausible XY points. The first point is `(108.40, 69.70)`, near the `Umbra_Keth` entity at `(117.50, 69.50)`. This strongly supports the shared `/256` coordinate scale and association with UmbraKeth, although the exact path behavior (patrol, movement route, or another path use) is not yet proven.
- `Crypt3.sur`: 137 bytes = 1 count byte plus 17 records of 8 bytes. Several records contain compact nonzero flags/values. Semantics remain unresolved.

## Next validation steps

1. Compare the entity XY scatter with the named region values in `.zon` before assigning region membership.
2. Correlate `.sur` record fields with models/materials and inspect whether the 23-point UmbraKeth path is traversed at runtime.
3. Inspect model/material references to map atlas rectangles to wall, floor, and prop textures.
4. Keep coordinate scale, yaw units, and region bounds marked as hypotheses until cross-validated.

## New exports

- `tools/export_crypt3_map.py` decodes the named UmbraKeth path and exports `Crypt3_path.csv` / `.json`.
- The same exporter generates `Crypt3_entity_path_map.svg` and a self-contained offline `Crypt3_entity_path_map.html` with hoverable entity markers, category legend, and the 23 path points.
- The placement plot is explicitly not room geometry; no walls or collision boundaries have been reconstructed yet.
