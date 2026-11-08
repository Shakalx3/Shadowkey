# Shadowkey — Nokia N95 compatibility research

Technical project to run **The Elder Scrolls Travels: Shadowkey** on Nokia N95 8GB RM-320 (Symbian OS 9.2 / S60 3rd Edition FP1).

## Target and deliverable

- Target handset: Nokia N95 8GB RM-320, firmware reported as V 35.0.001.
- Desired output: a modified executable and/or compatible EKA2 support DLLs that can be copied to the phone.
- A SIS installer is not required.
- No successful launch on a physical N95 has been demonstrated.

## Current verified state — step 47

The step35 archive is preserved at the repository root and its extracted 2,191-file working tree is committed under `source_bundle/shadowkey_step35_work/`. The import workflow verified the archive SHA-256, ZIP entry count, and total uncompressed byte count before extraction.

### Step 47 — import ordinal semantics correction

The original N-Gage / Symbian 6.1 SDK WINS UDEB import-library records map several important game imports to different functions than earlier synthetic HLE assumptions:

- EUSER 1407: `TDblQueBase::SetOffset(TInt)`.
- EUSER 1575: `TLex8::Val(TInt64&, const TInt64&)`.
- CONE 160: `CCoeControl::Position() const -> TPoint`.
- GDI 101: `CGraphicsContext::JustificationInPixels(TInt&, TInt&)`.
- GDI 108: `CPalette::NewL(TInt)`.
- GDI 151: `CPicture::StoreL(CStreamStore&) const -> TStreamId`.

This invalidates the earlier interpretation of GDI 101/108/151 as a text/font construction chain and means the 60-byte GDI151 and 72-byte TFontSpec hypotheses must be re-examined rather than treated as established ABI. CONE 160's mapped TPoint return is consistent with the previously observed hidden-result ABI.

See [Step 47 import ordinal semantics correction](docs/STEP47_IMPORT_ORDINAL_SEMANTICS_CORRECTION.md).

### Step 48 — HLE and historical font-trace audit

The committed HLE source already routes EUSER 1407 to `TDblQueBase::SetOffset(TInt)` (receiver in r0, integer in r1, write at object +8). CONE 160 is implemented as a hidden-result `TPoint` return. The bundled Step32/33 README's old EUSER1407-to-font trace is now explicitly marked historical and semantically superseded; it must not be used as proof of a descriptor/font API. See [Step 48 HLE/font trace audit](docs/STEP48_EUSER1407_HLE_AND_FONT_TRACE_AUDIT.md).

A static consistency test was added at `tools/step48_import_hle_consistency_test.py`. It checks game thunk/IAT/ordinal associations, the six WINS SDK symbol names, and current HLE routing. The test is committed but has not yet been executed in a project runner. The Step46 ARM UREL report is still absent; no workflow run was returned for the trigger-file commit.


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
