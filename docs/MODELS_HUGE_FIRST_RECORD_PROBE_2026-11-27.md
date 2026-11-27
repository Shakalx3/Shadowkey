# models.huge first-record probe — 2026-11-27

## Confirmed byte-level observations

The 4,907,880-byte `models.huge` file is not a single opaque compressed blob. Its beginning contains structured records with signed 16-bit numeric arrays and embedded image payloads.

The new probe exporter handles two sample records:

| Sample | Start | Header words | Coordinate payload | Embedded image |
|---|---:|---|---|---|
| Record 0 | `0x0000` | 7 × u16: `7, 1, 18, 72, 24, 54, 1` | offset `0x000E`, 54 × i16 (=18 triples) | `32×32×16-bit`, pixels at `0x02C0` |
| Record 1 | `0x0AC0` | u32 prefix `1`, then 9 × u16: `1, 10, 7, 1, 17, 72, 24, 51, 1` | offset `0x0AD4`, 51 × i16 (=17 triples) | `64×64×16-bit`, pixels at `0x0D82` |

The embedded image data decodes into coherent-looking colored imagery under an RGB565 interpretation. This is a useful candidate interpretation, not yet a proven pixel format. The first sample's 32×32 image looks foliage-like; the second 64×64 image contains a blue/green organic-looking pattern. Their exact asset identities are not established.

The coordinate arrays divide evenly into signed 16-bit triples. They may be XYZ positions, but axis order, scale, and even the interpretation as positions remain unverified.

## Exporter

`tools/probe_models_huge.py` exports:
- coordinate triples as CSV for the first two samples;
- embedded images as BMP under the RGB565 candidate interpretation;
- a JSON report with offsets and confidence notes.

The workflow `Crypt3 resource format inspection` runs this probe and uploads its output. Successful run:
https://github.com/Shakalx3/Shadowkey/actions/runs/45954164848

Artifact: `crypt3-decoded-resource-payloads` (expires 2026-12-11).

## Still unresolved

- Complete record grammar and how later records are delimited.
- Meaning of the header fields.
- Which of the adjacent 72-entry tables are vertex indices, UV indices, normals, or other mesh data.
- Whether the coordinate triples are actual model vertices.
- Embedded image pixel format, transparency, and model-to-texture association.
- Mapping records in `models.huge` to names in the per-zone `*_models.txt` tables.

No 3D mesh has been claimed as reconstructed yet. Next work should correlate the numeric tables and record boundaries across several consecutive records, then validate candidate faces against the coordinate and texture data.
