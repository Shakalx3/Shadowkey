# Step 61 — target CAknAppUi layout and AVKON ordinal remap

Date: 2026-11-08

## 1. AVKON methods used by the game's CAknAppUi vtables

The Step60 vtable thunk disassembly showed that the game's +0x48 and +0x4c secondary vptrs forward to AVKON ordinals 802 and 805.

The pinned S60 3.1 FP1 ARMv5 EABI4 `avkon.dso` was parsed and the exact target symbols were found:

| Original N-Gage import | Target direct method export | Target ordinal | Non-virtual thunk export | Target thunk ordinal | Symbol at unchanged old ordinal |
|---|---|---:|---|---:|---|
| AVKON 802 `CAknAppUi::HandleStatusPaneSizeChange()` | `CAknAppUi::HandleStatusPaneSizeChange()` | **2935** | non-virtual thunk to same method | 4021 | `CAknQueryDialog::NewL(TTimeIntervalSeconds&, const TTone&)` |
| AVKON 805 `CAknAppUi::HandleViewDeactivation(const TVwsViewId&,const TVwsViewId&)` | `CAknAppUi::HandleViewDeactivation(...)` | **2932** | non-virtual thunk to same method | 4030 | `CAknQueryDialog::NewL(TInetAddr&, const TTone&)` |
| AVKON 803 `CAknAppUi::PrepareToExit()` | `CAknAppUi::PrepareToExit()` | **2922** | — | — | `CAknQueryDialog::NewL(TTime&, const TTone&)` |
| AVKON 808 `CAknAppUi::ProcessCommandL(TInt)` | `CAknAppUi::ProcessCommandL(TInt)` | **2926** | non-virtual thunk to same method | 3862 | `CAknQueryDialog::NewL(TInt&, const TTone&)` |

The game's vtable thunks already adjust `this` from the old secondary interface subobject to the old complete object:
- +0x48: `SUB r0,r0,#0x48`, then branch to the old AVKON 802 import;
- +0x4c: `SUB r0,r0,#0x4c`, then branch to the old AVKON 805 import.

Therefore, if a compatibility wrapper forwards these calls to a target shadow CAknAppUi object, the target **direct** method exports 2935 and 2932 are the appropriate candidates. Calling the target non-virtual thunks 4021/4030 as well would apply an additional this-adjustment and is not appropriate for the already-adjusted game call path.

All four old ordinal slots are occupied by unrelated CAknQueryDialog overloads in the target DSO. Passing the old ordinal unchanged is unsafe.

## 2. The target S60 CAknAppUi hierarchy changed

The original N-Gage SDK `aknappui.h` declares:

`CAknAppUi : public CEikAppUi, MEikStatusPaneObserver, public MCoeViewDeactivationObserver`

The target S60 3.1 FP1 `aknappui.h` instead declares:

`CAknAppUi : public CAknAppUiBase, MEikStatusPaneObserver, public MCoeViewDeactivationObserver, public MAknTouchPaneObserver`

The target also introduces an intermediate `CAknAppUiBase : public CEikAppUi` with additional data members. This is a structural ABI change, not just an ordinal change.

## 3. N-Gage versus target CAknAppUi layout

The offsets below are calculated for 32-bit ARM from the respective header declaration order and pointer/integer sizes.

### Original N-Gage layout expected by the game

| Offset | Member/base |
|---:|---|
| +0x00..+0x47 | N-Gage CEikAppUi base (0x48 bytes) |
| +0x48 | MEikStatusPaneObserver vptr |
| +0x4c | MCoeViewDeactivationObserver vptr |
| +0x50 | `iDumpNextControl` |
| +0x54 | `iAppShutter` |
| +0x58 | `iBlockMode` |
| +0x5c | `iSpare` |

N-Gage CAknAppUi base size: **0x60 (96 bytes)**. The game allocates a 0x6c-byte derived object, leaving 12 bytes after this base.

### S60 3.1 FP1 target layout

| Offset | Member/base |
|---:|---|
| +0x00..+0x3b | Target CEikAppUi base (0x3c bytes) |
| +0x3c | `CAknAppUiBase::iAknFlags` |
| +0x40 | `CAknAppUiBase::iEventMonitor` |
| +0x44 | `CAknAppUiBase::iKeySounds` |
| +0x48 | `CAknAppUiBase::iAppUiBaseExtension` |
| +0x4c | MEikStatusPaneObserver vptr |
| +0x50 | MCoeViewDeactivationObserver vptr |
| +0x54 | MAknTouchPaneObserver vptr |
| +0x58 | `iDumpNextControl` |
| +0x5c | `iAppShutter` |
| +0x60 | `iBlockMode` |
| +0x64 | `iExtension` |

Target CAknAppUi size: **0x68 (104 bytes)**.

The target CAknAppUi object is eight bytes larger than the old N-Gage CAknAppUi base, but its members are not simply shifted by a constant amount:
- target CEikAppUi is 12 bytes smaller than the old N-Gage CEikAppUi base;
- target CAknAppUiBase adds four words: flags, event monitor, key-sound system and extension;
- target CAknAppUi adds MAknTouchPaneObserver, an extra secondary vptr absent from the N-Gage layout;
- target CAknAppUi replaces the old `iSpare` with `iExtension`.

The old game's secondary vptrs at +0x48/+0x4c therefore do not line up with the target CAknAppUi vptrs at +0x4c/+0x50. The target has a further interface vptr at +0x54, where the old class has data.

## 4. Compatibility consequence

Directly remapping AVKON 802/805 to target 2935/2932 is not safe when the target methods receive the old game object pointer. The target methods are compiled for the S60 3.1 CAknAppUi/CAknAppUiBase layout and may access fields at offsets that differ from the N-Gage object.

A viable architecture to investigate is a **shadow target CAknAppUi object**:
1. Keep the original N-Gage-layout game object at its existing address, preserving its game vtables and fields.
2. Create a separate valid S60 3.1 CAknAppUi object using the target framework constructor and BaseConstructL path.
3. Maintain a mapping from game CAknAppUi pointer to target CAknAppUi pointer.
4. Route imported AVKON/EIKCORE/CONE calls that operate on the app UI through wrappers that translate the old `this` pointer to the target object.
5. Preserve ownership, cleanup-stack behavior, leave propagation, app-UI registration and destructor order.

This is a design candidate, not an implemented solution. A separate target object may interact with the S60 framework as an additional app UI, which must be checked. The host application may need to make the shadow object the registered app UI rather than constructing an independent second one.

## 5. Evidence

- Target S60 3.1 FP1 SDK devkit asset SHA-256: `7ed8b62b15f191ca47d2f6ca97ee5ce74cd02ce3e42b74bc7b1f9513d7df87b5`.
- Target AVKON DSO: `Epoc32/release/armv5/lib/avkon.dso`, ELF32 ARM EABI4.
- Target AVKON DSO SHA-256 is recorded in `step61-avkon-layout.json` from the workflow artifact.
- Target header and DSO probe: GitHub Actions run `42500922701`, artifact `s60-3.1-fp1-runtime-import-probe`, artifact ID `13625338015`, SHA-256 `b3c521dd739fac85d7f8803acf69008be2313f1098585e4d304fbc4af3970018`.
- Reproducible script: `tools/step61_avkon_target_export_map.py`.
- Workflow: `.github/workflows/s60-runtime-import-probe.yml`.
- This is SDK evidence, not a physical N95 ROM dump. No device launch is claimed.

## Next actions

1. Audit the game-side reads/writes of CAknAppUi fields at +0x34..+0x6c.
2. Identify the exact constructor/BaseConstructL calls and app-UI registration sequence.
3. Verify whether a shadow CAknAppUi can coexist with the host app UI or must itself be the registered UI.
4. Map the remaining primary-vtable AVKON/EIKCORE/CONE imports to target exports and decide which require wrappers.
5. Keep direct import remapping disabled for object-sensitive CAknAppUi methods until the shadow-object path is validated.
