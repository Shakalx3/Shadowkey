# Shadowkey — Nokia N95 compatibility research

Technical project to run **The Elder Scrolls Travels: Shadowkey** on Nokia N95 8GB RM-320 (Symbian OS 9.2 / S60 3rd Edition FP1).

## Target and deliverable

- Target handset: Nokia N95 8GB RM-320, firmware reported as V 35.0.001.
- Desired output: a modified executable and/or compatible EKA2 support DLLs that can be copied to the phone.
- A SIS installer is not required.
- No successful launch on a physical N95 has been demonstrated.

## SDKs and reproducible build environment

Both platform generations are now pinned and available to the project:

- **Original N-Gage / Symbian 6.1 SDK** — linked at `third_party/ngage-sdk` as a submodule pinned to upstream commit `0a94b7655117f325a1729f5600093e4ad12c8d60`. Initialize with `git submodule update --init --recursive`.
- **Nokia S60 3.1 FP1 / Symbian OS 9.2 SDK** — curated and full extracted packages are preserved as permanent assets in the [private SDK release](https://github.com/Shakalx3/Shadowkey/releases/tag/s60-sdk-3.1-fp1-20261108).
- **EKA2 ARMv6 toolchain** — native E32 generation validated in [Step52](docs/STEP52_EKA2_ARMV6_E32_TOOLCHAIN_VALIDATED.md).

See [Step54: both SDKs pinned and expected development impact](docs/STEP54_BOTH_SDKS_PINNED_AND_IMPACT.md). The N-Gage SDK components are not covered by the upstream toolchain's MIT license, so we reference the original repository rather than duplicating its proprietary SDK payload. SDK availability does not itself prove a successful N95 launch.

## Current verified state — SDK/toolchain milestones through step 54; native app port remains incomplete

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
- The Step45 host regression and live VFS trace pass through the corrected ARM UREL HLE handlers, CEikApplication/CEikDocument constructors and CleanupStack PushL/Pop; the current deliberate stop is EIKCORE 224 (`CEikAppUi()`), documented in [Step53](docs/STEP53_CEIKAPPUI_MULTIPLE_INHERITANCE_LAYOUT.md).
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


### Step 53 — CEikAppUi secondary vtable blocker

The live trace passes the ARM-identified CEikApplication and CEikDocument constructors and CleanupStack PushL/Pop, then stops at EIKCORE 224 (CEikAppUi). The lifted caller writes derived vtables at +0x00, +0x14 and +0x1c but leaves +0x18, the MCoeMessageObserver base vptr, to the EIKCORE constructor. The WINS UDEB DLL is stripped and cannot supply this ARM address. See [Step53](docs/STEP53_CEIKAPPUI_MULTIPLE_INHERITANCE_LAYOUT.md).

The next required artifact is the matching N-Gage QD ARM library `Z:\system\libs\EIKCORE.DLL`. The N95 `Z:\sys\bin\EIKCORE.DLL` is separately needed to cross-check the target firmware exports. Do not substitute one for the other.


### Step 55 — current-state and Step48 audit

The repository was re-audited against the ARM UREL identity correction. The independent read-only assertion pass reproduced 14/14 grouped checks. The original Step48 Python checker was inspected but was not run during that audit; see [Step55](docs/STEP55_CURRENT_STATE_AND_STEP48_AUDIT.md).

### Step 56 — executable Step48 CI gate

Added [the Step48 consistency workflow](.github/workflows/step48-consistency.yml), which runs the original Python checker when its evidence/source inputs change or when manually dispatched. The workflow definition is committed; its first Actions result was not available at the time of the Step56 report. See [Step56](docs/STEP56_STEP48_CI_GATE.md).

### Step 57 — ARMv6 object closure

Downloaded and independently inspected the 14-object ARMv6 artifact from run 42485190637. All objects are ELF32 ARM EABI5 with ARMv6 attributes. A relocatable LLD link resolved all recovered game functions and all 414 import-thunk wrappers across 19 DLL identities. Ten runtime symbols remain undefined (seven C/OpenC runtime symbols and three project instrumentation hooks). This is not a final E32 image and does not validate target DLL exports or device launch. See [Step57](docs/STEP57_ARMV6_OBJECT_CLOSURE_AUDIT.md) and the reusable [object audit tool](tools/step57_arm_object_link_audit.py).


### Step 58 — S60 3.1 FP1 target export remapping

The pinned S60 3.1 FP1 ARMv5 EABI4 DSOs were parsed directly. The original game's disputed N-Gage ordinals do not retain their meanings on the target: EUSER 1407 maps to E32Loader::ProcessLoaded at the unchanged target ordinal, while TPtrC16's target constructor is EUSER 1169; CONE 160 must map to CCoeControl::Rect at 276; GDI 101/108/151 map to TFontStyle/TFontSpec at 12/14/169; EIKCORE 224 is CEikonEnv::DestroyEnvironment, while CEikAppUi C2 is at 178. EUSER 1575 has no matching named TInt64 operator export and needs a local implementation/callsite treatment. See [Step58](docs/STEP58_N95_TARGET_EXPORT_REMAP.md) and [the parser](tools/step58_s60_target_export_map.py).

The seven strong C/OpenC runtime imports left by Step57 are present in the target EUSER/ESTLIB import libraries and DSOs: EUSER memmove/memset (1954/1955), ESTLIB __stderr/exit/fprintf/strcmp/strncmp (18/130/141/247/257). The Step58 remap script has a successful GitHub Actions execution; the target SDK DSO ABI is EABI4, while the recovered ARMv6 objects are EABI5, so final link/loader compatibility remains an explicit open gate. No N95 ROM dump or physical-device launch is claimed.

### Step 59 — CEikAppUi layout incompatibility

The S60 3.1 FP1 headers confirm the same CEikAppUi multiple-inheritance base order as N-Gage, but target CCoeAppUi adds a reserved 32-bit field at +0x14. This shifts target secondary vptrs to +0x18/+0x1c/+0x20 and data members to +0x24 onward, while the N-Gage game object expects vptrs at +0x14/+0x18/+0x1c and fields beginning +0x20. Consequently, target EIKCORE CEikAppUi C2 ordinal 178 is **not** a safe direct replacement for old EIKCORE 224; an old-layout compatibility wrapper and this/field translation are required. The same header audit confirms that target TInt64 is a built-in type and old class operators are no longer exported, validating a local 64-bit inequality implementation. See [Step59](docs/STEP59_CEIKAPPUI_TARGET_LAYOUT_BREAK.md).

### Step 60 — complete CEikAppUi callsite extraction

Extracted the full `sub_10021138` body (2,699 bytes) from the lifted source and confirmed it calls EIKCORE ordinal 224 via thunk `0x1009f700`. The caller writes all three secondary vptrs itself after the constructor, including MCoeMessageObserver at +0x18 (`0x100fff64`); the earlier Step53 claim that +0x18 was untouched is corrected. Final game vptrs are +0x14=`0x100fff00`, +0x18=`0x100fff64`, +0x1c=`0x100fff54`, with primary +0x00=`0x100fc4d8`. Earlier writes at +0x00/+0x48/+0x4c are overwritten later in the same function. See the [Step53 correction](docs/STEP53_CEIKAPPUI_MULTIPLE_INHERITANCE_LAYOUT.md) and [Step59 layout analysis](docs/STEP59_CEIKAPPUI_TARGET_LAYOUT_BREAK.md). The target C2 layout mismatch remains a base-data translation issue, not a missing game vptr.

### Step 61 — target CAknAppUi and AVKON remapping

Mapped the game's AVKON vtable calls to the S60 3.1 FP1 target exports: HandleStatusPaneSizeChange 802→2935, HandleViewDeactivation 805→2932, PrepareToExit 803→2922, ProcessCommandL 808→2926. The unchanged old ordinals instead resolve to unrelated CAknQueryDialog constructors. The target CAknAppUi hierarchy also changed: S60 3.1 inserts CAknAppUiBase with iAknFlags/iEventMonitor/iKeySounds/iAppUiBaseExtension and adds MAknTouchPaneObserver. The target CAknAppUi layout is 0x68 bytes versus 0x60 for the old N-Gage base, with secondary vptrs and fields at different offsets. Direct AVKON ordinal remapping on the old game object is unsafe; a shadow target CAknAppUi object and pointer-translation wrappers are the next architecture to evaluate. See [Step61](docs/STEP61_TARGET_CAKNAPPUI_LAYOUT_AND_AVKON_REMAP.md).

### Step 62 — game-side CAknAppUi derived fields

Recovered the game construction/cleanup sequence. The old game object stores a CCoeControl pointer at +0x60, a CAknKeySoundSystem pointer at +0x64, and a byte flag at +0x68. The target S60 3.1 CAknAppUi instead uses +0x60 for iBlockMode and +0x64 for iExtension. The conflict is now confirmed by actual lifted instructions and call signatures. The leading compatibility architecture is to preserve the old game object and map it to a separate valid target CAknAppUi object, with wrappers for object-sensitive AVKON/EIKCORE/CONE calls. See [Step62](docs/STEP62_CAKNAPPUI_GAME_DERIVED_FIELDS_AND_SHADOW_OBJECT.md).
