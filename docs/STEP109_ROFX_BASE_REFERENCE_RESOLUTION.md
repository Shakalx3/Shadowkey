# Step109 — resolve ROFx external references against base ROFS

Date: 2026-11-12

## Baseline

The latest default-branch firmware run is 43206146199 at commit f91eb5fa4029a3f74b93a07f6491429c9ea90c3b. Step108 passed its five synthetic checks and extracted:

| Image | Directories | Entries | Local files | External refs | Local bytes |
|---|---:|---:|---:|---:|---:|
| C0R SOS+ROFS | 275 | 1,441 | 1,441 | 0 | 21,545,554 |
| PPM SOS+ROFx | 315 | 5,909 | 4,468 | 1,441 | 18,490,107 |

The PPM extension contains 1,441 external references, the same count as the base ROFS file entries. Step108 deliberately skipped these until a base-image match could be proven.

## Source-level format evidence

The published Symbian headers define TRofsEntry::iFileAddress as the address of the file in the image. The Symbian ROFS builder's CreateExtension lays out the extension using the base image's size, while PlaceFiles preserves an existing base TRomBuilderEntry::iFileOffset for aliased files instead of assigning a new extension-local address. The ROFx reader computes its extension adjustment from iDirTreeOffset and the file position immediately after the extension header.

This supports testing the ROFx external address as a reference to the original base-image file address. It does not justify resolving by path alone.

## Step109 implementation

Added tools/step109_resolve_rofx_base_references.py. It:

1. Re-runs the Step106 metadata audit against both exact source images and checks their SHA-256 values.
2. Builds a base-file index by original iFileAddress.
3. Resolves an external ROFx entry only if address, case-insensitive full path, file size, and UID bytes identify exactly one local base ROFS entry.
4. Uses local ROFx extents for extension files and overrides; preserves base files not listed by the extension.
5. Leaves unresolved references unguessed and reports them as PARTIAL.
6. Writes a complete or partial merged tree only to a fresh ephemeral output directory, plus text/JSON manifests and an E32 candidate TSV.
7. Never changes source images and never commits extracted firmware files or system DLLs.

Synthetic tests cover one valid inherited reference plus one extension-local file, and one deliberately corrupted external address.

## Target-device boundary

This step is filesystem reconstruction only. It does not alter the ROM, change E32 exports, or prove that the original EKA1 game image can be loaded by the N95 EKA2 loader. The separate Step102 package is only a small EKA2 DLL loader probe; it is not a Shadowkey build. No physical-device execution or game launch is claimed.
