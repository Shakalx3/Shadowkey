# Crypt3.zon notes (2026-11-27)

The companion file `Crypt3.zon` is 578 bytes and is not part of the six zlib-wrapped payloads. Its byte stream contains eight readable ASCII labels:

- `WatersOfRS`
- `Spotted`
- `Entrance`
- `crypt2`
- `Awaits`
- `Forge`
- `crypt2` (second occurrence)
- `UmbraHere`

The labels are embedded in a highly padded binary structure. Before several labels there are groups of four little-endian 16-bit values (for example, the record immediately preceding `Entrance` contains 6, 15, 10, 17; the record before the first `crypt2` contains 10, 12, 15, 14; the record before the second `crypt2` contains 13, 8, 15, 12; and the record before `UmbraHere` contains 7, 15, 9, 17). These values may encode grid coordinates, bounds, or other zone parameters. Their exact meaning and record boundaries have not yet been established.

This file is a promising bridge between the zone's named sub-areas and the binary map/collision data, but it is not sufficient on its own to reconstruct the 3D geometry.
