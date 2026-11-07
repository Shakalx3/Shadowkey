# Shadowkey v8.4 — step 5: separate FBSCLI result path from source+0x14A3C

Date: 2026-11-02

## Fresh reproduction from step-4 archive

Commands executed in a clean extracted working copy:

- `./build_and_test.sh` — exit 0; AppUi/engine regression assertions PASS.
- `./trace_asset_loader_vfs.sh` — wrapper exit 0; diagnostic guest execution itself stops at `OOB 00000080/4`, exit 90, as expected. This is not a successful game launch.
- `python3 shadowkey_gc_trace_regression.py .build/asset_vfs_trace.log` — PASS against the newly generated `.build/asset_vfs_trace.log`.
- `./build_arm11_core.sh` — PASS; ARM EABI5 relocatable core object produced/up to date.
- `./build_arm11_linkcheck.sh` — PASS; statically linked ARM EABI5 linkcheck ELF, no undefined symbols. Its E32Main is deliberately a no-op.

The VFS wrapper prints a missing empty-path open between successful asset opens. This is present in the fresh trace and must not be silently described as all opens succeeding. The four expected named assets are opened; the empty path is separately logged as missing.

## Static code facts rechecked

### FBSCLI ordinal 17 path

- `shadowkey_import_thunks_v2.csv`: thunk `0x1009FD40` maps to `FBSCLI[10003a15].DLL`, ordinal 17, IAT slot `0x10100808`.
- `sub_10023ad0`, `0x10023B24–0x10023B2C`: loads `*(r7 + 0x2E4)`, calls thunk `0x1009FD40`, stores returned `r0` to `*(r7 + 0x300)`.
- `0x10023F38–0x10023F48`: loads that `+0x300` value, duplicates it into `r1/r2`, and calls `sub_1000EA00`.
- `sub_1000EA00` stores its incoming `r1/r2` at the newly created child object's `+0x47C/+0x480`.
- The current HLE has no ordinal-17 implementation; the dispatcher returns zero for this import. The existing diagnostic override at `0x10023F44` replaces both arguments with `0x101D0000`. It is explicitly non-faithful and remains diagnostic only.

### `source+0x14A3C` path

- `sub_100298A4` receives a parent/control object in `r7`, obtains the source pointer from `*(r7 + 0x14)`, allocates a `0x9C`-byte child, and calls `sub_1001F9AC(child, source)`.
- `sub_1001F9AC` computes offset `0x14A3C` as `0x14800 + 0x23C`, loads `LR = *(source + 0x14A3C)`, then immediately reads `[LR + 0x80]`, `[LR + 0x84]`, `[LR + 0x88]` and further fields. In the fresh trace, the loaded pointer is zero, so the first dereference is `0x00000080`.
- The field is therefore a pointer to a structure/object with at least the observed fields at offsets `0x80`, `0x84`, `0x88`; calling it a vtable or a particular manager type is not justified yet.

## Important correction

The two paths above are proven separately, but no direct dataflow currently links the return from FBSCLI ordinal 17 to `source+0x14A3C`. The prior report's causal implication must not be carried forward. Ordinal 17 may still be relevant indirectly through broader engine initialization, but that remains unproven.

## External SDK / ROM evidence status

The target user's N95 reports Symbian OS 9.2 / S60 3rd Edition FP1. Public SDK archive indexes identify the relevant SDK generation and public documentation places it at `C:\Symbian\9.2\S60_3rd_FP1\epoc32\release\armv5\lib`; however, no exact FP1 `fbscli.lib` export table or N95 RM-320 ROM EAT has been acquired in this work session. A separate public reverse-engineering reference for a Nokia 5320 / Symbian 9.3 ROM contains FbsCli.dll evidence, but it is a different firmware generation and is not accepted as proof of the N95 FP1 ordinal mapping.

## Changes

No game runtime, import dispatch, or guest-memory behaviour was changed. This step adds only this forensic note. No synthetic pointer was added; the diagnostic override remains explicitly labelled.

## Next step

1. Resolve the actual owner/type of the `source` pointer passed by `sub_100298A4` and trace its constructor/allocation path.
2. Search all writers to the `source + 0x14A3C` member, including indirect stores through computed offsets and constructor callbacks; compare them with the runtime trace's allocation/zeroing timeline.
3. In parallel, acquire the exact S60 3rd FP1 `fbscli.lib` or N95 RM-320 ROM image and extract its export address table to resolve ordinals 135, 16 and 17. Until then, keep the ordinal names unknown.

## Device status

No native E32Image has been produced and no execution on a physical Nokia N95 has been performed.
