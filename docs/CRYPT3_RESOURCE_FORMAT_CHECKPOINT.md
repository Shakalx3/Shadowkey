# Shadowkey resource format checkpoint — Crypt3

Initial binary inspection of the supplied Crypt3 zone files found a consistent
container pattern in several resources:

- bytes 0..3: little-endian uncompressed payload length
- bytes 4..: zlib stream (observed signature `78 9c`)

Verified header samples:

| File | Declared decoded size | Compressed file size |
|---|---:|---:|
| Crypt3.zmp | 98,436 | 9,776 |
| Crypt3.ztx | 294,913 | 164,843 |
| Crypt3.zlu | 131,072 | 47,303 |
| Crypt3.zfg | 131,072 | 17,188 |
| Crypt3.zsk | 134,570 | 2,245 |
| Crypt3.zcp | 9,724 | 1,405 |

The declared lengths and zlib signatures are directly read from the files. The
full decompressed payloads still need structural parsing; these names and sizes
alone do not establish vertex, face, texture, or collision layouts.

A first desktop-side decoder is provided at `tools/shadowkey_decode_resources.py`.
It validates the zlib stream and declared output length before writing a
`.raw` sibling. It never modifies the original game files.

## Phone-side direction

The HTML page is only a desktop resource catalogue. The N95 build will be a
separate native Symbian C++ application. The desktop converter is an asset
preparation tool; the phone renderer will consume compact, documented data
files generated from the decoded resources. No browser engine is required on
the N95.
