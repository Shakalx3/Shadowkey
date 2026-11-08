# Step 55 — current repository state and Step48 audit

Date: 2026-11-08

## Repository state checked

- Repository: `Shakalx3/Shadowkey`, private, default branch `main`.
- The repository is available through the connected GitHub integration.
- The current README describes milestones through Step54; the task brief's Step48 snapshot is therefore stale.
- The original archive and extracted source tree are present as documented in `docs/ARCHIVE_IMPORT_STATUS.md`.
- The N-Gage SDK is pinned as the `third_party/ngage-sdk` submodule at commit `0a94b7655117f325a1729f5600093e4ad12c8d60`.
- The S60 3.1 FP1 SDK assets are documented in the private release `s60-sdk-3.1-fp1-20261108`.

## Step48 consistency audit

The following files were read from the current `main` tree:

- `tools/step48_import_hle_consistency_test.py`
- `docs/STEP44_SYMBIAN61_EXPORT_ORDINAL_AUDIT.md`
- `docs/STEP39_EUSER1407_STATIC_CALLSITE_AUDIT.md`
- `docs/STEP42_EUSER1575_CONE160_RUNTIME_FORENSICS.md`
- `docs/STEP46_ARM_IMPORTLIB_ORDINAL_MAP.md`
- `source_bundle/shadowkey_step35_work/shadowkey_import_dispatch.c`
- `source_bundle/shadowkey_step35_work/shadowkey_symbian61_hle.h`
- `source_bundle/shadowkey_step35_work/shadowkey_hle_bootstrap_v2.c`
- `source_bundle/shadowkey_step35_work/shadowkey_hle_vfs_trace.c`

A read-only independent assertion audit was executed against the fetched file contents. All 14 grouped checks passed:

1. EUSER 1407/1575 and CONE 160 thunk, IAT and ordinal rows.
2. Six WINS UDEB names retained strictly as WINS-only evidence.
3. Fifteen ARM UREL archive-index identities in the Step46 report.
4. The Swiss literal ARM callsite register setup.
5. Historical diagnostic trace labels remain documented.
6. WINS-only SetOffset/Position HLE handlers are absent.
7. EUSER 1407 TPtrC16 routing is present in bootstrap and VFS paths.
8. EUSER 3 and CleanupStack PushL/Pop routes are present.
9. CONE 160 Rect routing is present.
10. EUSER 1575 TInt64 inequality routing is present.
11. GDI 151 TFontSpec construction and GDI 108/101 TFontStyle setter routes are present.
12. EUSER TRect constructor/Height/Move routes are present.
13. EIKCORE 219/222 constructor routes are present.
14. The CEikApplication caption descriptor layout markers are present.

**Execution boundary:** the original Python file `tools/step48_import_hle_consistency_test.py` was inspected, but was not executed by a Python interpreter in this pass. The 14/14 result above is an independently reproduced read-only assertion audit over the fetched repository contents, not a claim that the Python script itself ran. No source files or HLE behavior were changed during this audit.

## ARM UREL import-library status

Step46 and Step50 already resolve the original game's ARM identities. The three libraries requested in the older Step48 task are available in the pinned N-Gage SDK submodule:

- `euser.lib`
- `cone.lib`
- `gdi.lib`

The Step46 generated map records the archive-index symbols for the game's imports. The central corrected identities are:

| DLL / ordinal | ARM UREL identity |
|---|---|
| EUSER 1407 | `TPtrC16::TPtrC16(const TUint16*)` |
| EUSER 1575 | `TInt64::operator!=(const TInt64&) const` |
| CONE 160 | `CCoeControl::Rect() const` |
| GDI 151 | `TFontSpec::TFontSpec(const TDesC16&,TInt)` |
| GDI 108 | `TFontStyle::SetStrokeWeight(TFontStrokeWeight)` |
| GDI 101 | `TFontStyle::SetPosture(TFontPosture)` |

The Step47/48 WINS names are not the ARM game's import identities. Step50 supersedes the earlier WINS-derived interpretations for the ARM binary. Do not revive the old SetOffset, Position, palette, picture-store or TLex8 handlers for these ARM imports.

## Verified CI state

GitHub Actions job details were queried for the two run IDs documented by the repository:

- Run `42484330178`: native ARMv6 EKA2 control GUI build — completed, conclusion `success`; the SDK download/verification, GUI build, E32 inspection and artifact publication steps completed.
- Run `42485190637`: recovered C translation units ARMv6 EKA2 object build — completed, conclusion `success`; the SDK download/verification, compilation and artifact publication steps completed.

These results verify a native E32 toolchain and compilation of the recovered C translation units. They do **not** verify a complete linked Shadowkey E32 application, full native Symbian framework compatibility, emulator launch or physical N95 launch.

## Current technical blocker

Step53 is the current trace stop:

- EIKCORE ordinal 224: `CEikAppUi::CEikAppUi()`.
- The game allocates a 108-byte derived object.
- The caller writes derived/base vptrs at +0x00, +0x14 and +0x1c but leaves +0x18 untouched.
- The N-Gage SDK multiple-inheritance layout identifies +0x18 as the `MCoeMessageObserver` secondary-base vptr.
- The correct constructor-installed value and any associated field initialization are not present in the import-library stub.

The next required binary inputs are distinct and must not be conflated:

1. Original Nokia N-Gage QD ARM ROM library: `Z:\\system\\libs\\EIKCORE.DLL` — to recover the legacy CEikAppUi constructor and its +0x18 vptr.
2. Nokia N95 RM-320 firmware library: `Z:\\sys\\bin\\EIKCORE.DLL` — to establish the target Symbian OS 9.2 export table and compare target-side API availability.

Until those files (or equivalent verified binary dumps) are available, EIKCORE 224 must remain fail-closed/diagnostic-only. Do not synthesize the missing vptr or claim the constructor is implemented.

## Next actions

1. Obtain and inspect the two EIKCORE binaries separately.
2. Recover the N-Gage ARM constructor's +0x18 vtable and constructor side effects.
3. Compare the N95 EIKCORE exports against the game's required EIKCORE imports and the S60 3.1 FP1 SDK import metadata.
4. Implement EIKCORE 224 only from verified constructor evidence, then advance the live VFS trace.
5. Continue resolving CleanupStack PopAndDestroy and remaining FBS/GDI/UI imports.
6. Build and inspect a complete EKA2 Shadowkey executable only after the framework compatibility layer has real implementations.

## Scope boundary

No physical Nokia N95 is available to this analysis session. No N95 launch is claimed. The host HLE, SDK symbol maps and EKA2 control build remain diagnostic/research evidence, not the final deliverable.
