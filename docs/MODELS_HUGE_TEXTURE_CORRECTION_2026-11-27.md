# Corrected models.huge texture interpretation — 2026-11-27

## Correction to the first probe

The first probe incorrectly treated the embedded 16-bit words as RGB565 and used the wrong start offset for the second image. The visual output from that probe should not be used.

A closer byte-level inspection establishes:

- Record 0's 32×32 image starts at `0x2C0` and occupies exactly 2,048 bytes. Its end is `0xAC0`, exactly the start of the next sample record.
- Record 1's 64×64 image does **not** start at `0xD82`. That area contains a 20-byte metadata/name sequence. The image starts at `0xD96` and occupies 8,192 bytes.
- Every 16-bit word in both sample images is within `0x000..0xFFF`. Interpreting each as 12-bit RGB444 (4 bits per channel) produces coherent, recognizable foliage-like images.

## Visual interpretation (tentative)

- Record 0 resembles a small leafy tree or plant sprite on a saturated magenta background. The dominant background word is `0xF0F`; this may be a transparency key, but that has not been verified.
- Record 1 resembles dense green foliage with pale pink/white blossoms. It contains many zero-valued pixels, which may represent transparency or black; not proven.

The images appear to be textures/sprites, not complete 3D models. The previous RGB565 preview of record 1 was invalid because it began 20 bytes too early.

## Updated exporter

`tools/probe_models_huge.py` now:
- decodes the two sample images as RGB444 candidate data;
- uses the corrected second-image offset `0xD96`;
- exports the exact dimensions and metadata area;
- records value statistics and remaining uncertainties.

## Next steps

1. Determine whether `0xF0F` and zero are transparency keys by checking other textures and model rendering conventions.
2. Decode the arrays between the coordinate triplets and image payload; determine whether they encode UVs, faces, normals, or material references.
3. Locate the actual model records used by the Crypt3 model table and identify the matching named object.
4. Avoid calling the first image a complete tree model: it is only a texture image until its mesh association is demonstrated.
