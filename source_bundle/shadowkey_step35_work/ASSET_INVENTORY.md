# Shadowkey asset archive inventory

Source: user-provided `The_Elder_Scrolls_Travels_Shadowkey.zip`.

- ZIP integrity test: passed (`zipfile.testzip()` returned no corrupt member).
- Entries: 1,969 total, 1,937 files.
- Uncompressed payload: 19,817,344 bytes (~18.9 MiB).
- App assets: 1,918 files under `system/apps/6R51/`.
- Included game resources: `StringTable.eng` (338,078 bytes), `global.spr` (1,646,707 bytes), `models.huge` (4,907,880 bytes), zone/model/texture files, sound effects and music.
- Included bundled libraries: `system/libs/GAMECOMMS.DLL`, `egl.dll`, `ogles.dll`, plus 16 additional DLL/EXE files. `SIMKIN.DLL` is in the app directory.

## First real-resource VFS trace

The diagnostic HLE can resolve the two paths observed during engine startup:

- `z:\system\apps\6R51\StringTable.eng` — found and opened; a zero-length metadata-style call follows.
- `e:\system\apps\6R51\global.spr` — found and opened; reads 1,536-byte chunks into a guest descriptor buffer.

The first resource table is populated, and the next lookup reads index `0xF8` → offset `0x9444`. The second loader call opens `global.spr` and reads 1,536 bytes at offset `1,456,927`, but returns a null resource pointer; the subsequent byte access stops at `0x10024c18`. The HLE file-system/runtime semantics are still provisional. The harness also invokes `RunL` directly, bypassing the real active-scheduler sequence. This does **not** demonstrate a successful game launch.
