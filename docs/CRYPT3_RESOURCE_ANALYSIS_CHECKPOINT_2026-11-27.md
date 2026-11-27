# Crypt3 resource analysis checkpoint (2026-11-27)

## Execution status

The `Crypt3 resource format inspection` workflow was successfully rerun after the repository runner issue was fixed.

- Workflow run: https://github.com/Shakalx3/Shadowkey/actions/runs/45940634141
- Job: `inspect`
- Checkout: success
- Decoder/inspector: success
- Artifact upload: success
- Artifact: `crypt3-decoded-resource-payloads` (six decoded files, 799,787 bytes)

The six files were extracted from the artifact and independently inspected locally.

## Confirmed outer container

All six files use the same outer wrapper: a 4-byte little-endian uncompressed length followed by a zlib stream (signature `78 9c`). The decoder's output lengths match the header values.

| File | Decoded bytes |
|---|---:|
| Crypt3.zmp | 98,436 |
| Crypt3.ztx | 294,913 |
| Crypt3.zlu | 131,072 |
| Crypt3.zfg | 131,072 |
| Crypt3.zsk | 134,570 |
| Crypt3.zcp | 9,724 |

## First structural observations

- `Crypt3.zmp` begins with the ASCII strings `Crypt3`, `No Auth`, and `Nondescript` at offsets 0, 32, and 64. This looks like a fixed-width metadata/header region, not self-evident vertex data.
- `Crypt3.zfg` is exactly 65,536 little-endian 16-bit values. The beginning is the sequence 0, 1, 2, 3 ...; this is likely an index/lookup table, but its semantics are not yet proven.
- `Crypt3.zlu` is also 65,536 bytes of 16-bit data, mostly small values and zeroes. Its role is still unknown.
- `Crypt3.zsk` is highly sparse: 134,570 bytes, dominated by zero bytes, with a small number of signed-looking 16-bit values. Its role is still unknown.
- `Crypt3.zcp` is 9,724 bytes and has a strongly structured/repeating 16-bit pattern. It may be a compact table or collision/portal-related structure; this is not yet confirmed.
- `Crypt3.ztx` is 294,913 bytes. Treating bytes after the first byte as raw RGB at candidate dimensions (384x256, 256x384, 512x192, 192x512) produces noisy/banded images, not a recognizable texture. Therefore the payload is not yet understood as a direct RGB bitmap; possible additional packing, palette/indexing, swizzling, or obfuscation remains to be tested.

## Next reverse-engineering steps

1. Parse the `.zon` companion file and compare its names/records with `Crypt3.zmp` metadata.
2. Inspect the `.ent`, `.pal`, and `Crypt3_models.txt` data together to identify model/texture references and palette format.
3. Determine whether `.ztx` is indexed, tiled/swizzled, encrypted, or uses a platform-specific pixel format before attempting image conversion.
4. Correlate `.zcp`, `.zsk`, `.zlu`, and `.zfg` against known dimensions and record boundaries; do not label any of them as geometry until proven.

## Important limitation

The current result is successful decompression and initial classification only. No 3D mesh, walkable map, or complete location has been reconstructed yet.
