# models.huge first-record probe — 2026-11-27 (updated)

## Confirmed byte-level observations

The 4,907,880-byte `models.huge` file begins with structured records, not one opaque compressed blob. Record 0 occupies offsets `0x0000–0x0ABF`; the next sampled record begins at `0x0AC0`.

Record 0:

| Region | Offset | Observed structure | Interpretation status |
|---|---:|---|---|
| Header | `0x0000` | 7 little-endian u16 values: `7, 1, 18, 72, 24, 54, 1` | Field meanings unknown |
| Numeric triples | `0x000E` | 54 signed little-endian i16 values = 18 triples | Candidate XYZ or other 3-component data |
| Two-component table | `0x007A` | 144 big-endian u16 values = 72 pairs; values range 0–64, 10 unique pairs | Candidate UV coordinates; semantics unproven |
| Index table | `0x019A` | 147 little-endian u16 values = 49 triangles; indices range 0–71 | Strong candidate triangle index list; addresses 72-pair table if paired |
| Image dimensions | `0x02BC` | `32 × 32` | Confirmed dimensions |
| Image payload | `0x02C0` | 1,024 16-bit words, ends exactly at `0x0AC0` | Candidate 12-bit RGB data |

The three numeric regions are distinct and contiguous: 18 triples, 72 pairs, and 49 indexed triangles. This is the first substantial evidence for a mesh-like record layout. However, the relationship between the 18 triples and the 72 indexed pairs is not yet understood. It is not yet safe to render these arrays as a complete mesh.

Record 1 begins at `0x0AC0`, has a 64×64 image, and its pixel payload begins at `0x0D96`, after a 20-byte metadata/name area. Its header and array relationships have not yet been fully parsed.

## Correction to the earlier image interpretation

The earlier RGB565 interpretation was wrong. The words in the sample image payloads fit within 12 bits (`0x000–0xFFF`), so the current exporter tests RGB444. This is still only a candidate: channel order, byte/word ordering, transparency, and palette semantics have not been validated against the game renderer.

The two sample images are not identified assets. Their foliage-like appearance alone does not establish what model or object they represent.

## Model-name table

`Crypt3_models.txt` contains 236 model slots. Some named slots include 5 `sbarrel.bin`, 15 `chest_closed.bin`, 18 `rat.bin`, 43 `torch.bin`, 44 `weaponrack.bin`, 67 `umbra.bin`, 68 `wolf.bin`, 82 `urn.bin`, and 135 `darkchest.bin`.

The table is useful for eventual correlation, but the mapping from a slot to a byte range in `models.huge` has not been established. Do not assume record 0 is slot 0 or that consecutive model slots map one-to-one to consecutive records.

## Exporter and workflow

`tools/probe_models_huge.py` currently exports coordinate triples and candidate RGB444 images for the first two records, plus a JSON report. The workflow uploads the full `models.huge` file and the probe outputs.

Successful workflow run:
https://github.com/Shakalx3/Shadowkey/actions/runs/45954164848

Artifact: `crypt3-decoded-resource-payloads`.

## Next investigations

1. Find record boundaries across the whole `models.huge` file, rather than assuming the first two sample offsets generalize.
2. Determine whether the 18 triples are positions, normals, or another attribute.
3. Validate the 72-pair table as UVs by checking value scaling and matching it to the embedded image.
4. Determine whether the 49 triangles index the 72 pairs, and find the missing mapping to the 18 triples if so.
5. Correlate record offsets with model slots from `Crypt3_models.txt` and other zone model tables.
6. Only then build a mesh renderer and compare the result against the original game.

No complete 3D mesh has been claimed as reconstructed.
