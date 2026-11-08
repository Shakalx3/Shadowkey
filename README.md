# Shadowkey — Nokia N95 compatibility research

Technical project to run **The Elder Scrolls Travels: Shadowkey** on Nokia N95 8GB RM-320 (Symbian OS 9.2 / S60 3rd Edition FP1).

## Target and deliverable

- Target handset: Nokia N95 8GB RM-320, firmware reported as V 35.0.001.
- Desired output: a modified executable and/or compatible EKA2 support DLLs that can be copied to the phone.
- A SIS installer is not required.
- No successful launch on a physical N95 has been demonstrated.

## Current verified state — step 50 (ARM UREL import identities recovered)

The step35 archive is preserved at the repository root and its extracted 2,191-file working tree is committed under `source_bundle/shadowkey_step35_work/`. The import workflow verified the archive SHA-256, ZIP entry count, and total uncompressed byte count before extraction.

### Step 47 — import ordinal semantics correction

The Step44 WINS UDEB names below are retained as historical reference data for the WINS configuration only. They are not the game's ARM import identities:

- EUSER 1407: `TDblQueBase::SetOffset(TInt)`.
- EUSER 1575: `TLex8::Val(TInt64&, const TInt64&)`.
- CONE 160: `CCoeControl::Position() const -> TPoint`.
- GDI 101: `CGraphicsContext::JustificationInPixels(TInt&, TInt&)`.
- GDI 108: `CPalette::NewL(TInt)`.
- GDI 151: `CPicture::StoreL(CStreamStore&) const -> TStreamId`.

The ARM UREL archive-index map recovered in Step50 provides the actual original-game ARM identities. It confirms that several WINS ordinal names differ from ARM, including EUSER 1407, CONE 160 and GDI 101/108/151. See the ARM table below and the full [Step50 report](docs/STEP50_ARM_UREL_IMPORT_IDENTITY_BREAKTHROUGH.md).

See [Step 47 import ordinal semantics correction](docs/STEP47_IMPORT_ORDINAL_SEMANTICS_CORRECTION.md).

### Step 48 — HLE and historical font-trace audit

The WINS-derived EUSER 1407 SetOffset and CONE 160 Position helpers remain disabled. ARM UREL now identifies EUSER 1407 as a TPtrC16 constructor and CONE 160 as CCoeControl::Rect. The font path is again supported at the import level: GDI151 constructs TFontSpec, GDI108 sets stroke weight, and GDI101 sets posture. The old HLE implementations still need correction before being re-enabled.

The static audit at `tools/step48_import_hle_consistency_test.py` checks the WINS/ARM mapping distinction and fail-closed dispatch. The Step46 workflow now extracts ARM archive-index symbols for the game imports and self-checks the key identities. The generated report is committed in the repository.


### Remaining compatibility gates

- The WINS UDEB import-library mappings are evidence for the original N-Gage SDK, not proof of same-numbered N95 OS 9.2 exports.
- Original N-Gage SDK ARM UREL import identities are now mapped in Step46/50. The N95 RM-320 / S60 3rd FP1 ROM export table remains a separate, unresolved compatibility gate.
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


### Step 50 — ARM UREL import identity breakthrough

The ARM UREL archive index maps the game's EUSER 1407 to `TPtrC16(const TUint16*)`, EUSER 1575 to `TInt64::operator!=`, EUSER 1582 to `CBase::operator new`, EUSER 1373/530/711 to TRect constructor/Height/Move, CONE 160 to `CCoeControl::Rect`, and GDI 101/108/151 to TFontStyle/TFontSpec functions. This restores the font path as a valid ARM import-level chain while invalidating the earlier WINS-derived HLE identities. See [Step50](docs/STEP50_ARM_UREL_IMPORT_IDENTITY_BREAKTHROUGH.md).
