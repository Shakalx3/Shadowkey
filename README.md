# Shadowkey — Nokia N95 compatibility research

Technical project to run **The Elder Scrolls Travels: Shadowkey** on Nokia N95 8GB RM-320 (Symbian OS 9.2 / S60 3rd Edition FP1).

## Target and deliverable

- Target handset: Nokia N95 8GB RM-320, firmware reported as V 35.0.001.
- Desired output: a modified executable and/or compatible EKA2 support DLLs that can be copied to the phone.
- A SIS installer is not required.
- No successful launch on a physical N95 has been demonstrated.

## Current verified state — step 49 (ARM ordinal conflict unresolved)

The step35 archive is preserved at the repository root and its extracted 2,191-file working tree is committed under `source_bundle/shadowkey_step35_work/`. The import workflow verified the archive SHA-256, ZIP entry count, and total uncompressed byte count before extraction.

### Step 47 — import ordinal semantics correction

The original N-Gage / Symbian 6.1 SDK WINS UDEB import-library records provide names for the WINS configuration only. They do not yet establish the names of the corresponding imports in the game's ARM binary:

- EUSER 1407: `TDblQueBase::SetOffset(TInt)`.
- EUSER 1575: `TLex8::Val(TInt64&, const TInt64&)`.
- CONE 160: `CCoeControl::Position() const -> TPoint`.
- GDI 101: `CGraphicsContext::JustificationInPixels(TInt&, TInt&)`.
- GDI 108: `CPalette::NewL(TInt)`.
- GDI 151: `CPicture::StoreL(CStreamStore&) const -> TStreamId`.

These names must not be assigned to the game's ARM import table until the ARM UREL member-level check is complete. The WINS identities conflict with at least one strong ARM callsite observation for EUSER 1407; consequently, neither the WINS-derived GDI meanings nor the old font-chain interpretation is accepted as the game's ARM ABI at this stage.

See [Step 47 import ordinal semantics correction](docs/STEP47_IMPORT_ORDINAL_SEMANTICS_CORRECTION.md).

### Step 48 — HLE and historical font-trace audit

The EUSER 1407 SetOffset helper is now retained only as a WINS-UDEB reference and is no longer dispatched, because the ARM game callsites pass a format-string literal through the same thunk. CONE 160's TPoint helper is also not active dispatch. The old font trace is diagnostic evidence, not a native API identity. See [Step 49 WINS/ARM ordinal conflict](docs/STEP49_WINS_ARM_ORDINAL_CONFLICT.md).

The static audit at `tools/step48_import_hle_consistency_test.py` now checks the WINS/ARM conflict and fail-closed dispatch. An executable GitHub Actions workflow has been added. The Step46 ARM UREL workflow previously parsed all required libraries successfully but failed only when committing its generated report because the runner had no Git author identity; that commit step has now been corrected and rerun.


### Remaining compatibility gates

- The WINS UDEB import-library mappings are evidence for the original N-Gage SDK, not proof of same-numbered N95 OS 9.2 exports.
- ARM UREL import-member cross-check is still pending; the Step 46 parser exists, but its generated report was not present at the time of Step 47.
- Exact RM-320 / S60 3rd FP1 exports and ABI must be verified before implementing N95-side replacements.
- No N95-compatible EKA2 executable or successful physical-device launch has been demonstrated.


## Private repository and archive status

This repository is private. The supplied step35 ZIP is present at the repository root and its verified extraction is committed under `source_bundle/shadowkey_step35_work/`. The archive intake report records the SHA-256, ZIP inventory, extraction workflow, and commit. See [archive import status](docs/ARCHIVE_IMPORT_STATUS.md).

## Working rules

1. Distinguish diagnostic shims from real Symbian implementations.
2. Treat static analysis and synthetic traces as evidence, not proof of device compatibility.
3. Verify imports against the exact N95/S60 3rd FP1 export tables.
4. Record milestones and reproducible tests in separate commits.
5. Never claim a real-device launch until it has been observed on the handset.


### Step 49 — WINS/ARM ordinal conflict

The earlier Step47/48 assignment of EUSER 1407 to SetOffset was too strong for the ARM game. Step39 static callsites load the UTF-16 literal `Swiss` into r1 before calling thunk `0x1009F0F0`; Step42 preserves the old format-specific diagnostic trace. The WINS UDEB mapping expects an integer argument. The active SetOffset route has therefore been disabled pending inspection of ARM UREL member `ds01407.o`. See [Step 49 report](docs/STEP49_WINS_ARM_ORDINAL_CONFLICT.md).
