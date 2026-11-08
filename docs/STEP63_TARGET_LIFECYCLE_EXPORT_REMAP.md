# Step 63 — target S60 lifecycle export remap

Date: 2026-11-08

## 1. Target ordinals for the game CAknAppUi construction path

The S60 3.1 FP1 ARMv5 EABI4 target DSOs were parsed by `tools/step63_target_lifecycle_export_map.py`.

| Old N-Gage import | Target method | Target ordinal | Target symbol at unchanged old ordinal |
|---|---|---:|---|
| AVKON 63 | `CAknAppUi::BaseConstructL(TInt)` | **2924** | AknLAFUtils::ReplaceColumn |
| EIKCORE 233 | `CEikAppUi::ApplicationRect() const` | **318** | CEikonEnv::RemovePictureFactory |
| CONE 12 | `CCoeAppUi::AddToStackL(CCoeControl*,TInt,TInt)` | **202** | CCoeControl::MinimumSize |
| AVKON 1529 | `CAknAppUi::SetKeyBlockMode(TAknKeyBlockMode)` | **2927** | RAknEikAppUiSession::SetSystemFaded |
| AVKON 874 | `CAknAppUiBase::KeySounds() const` | **3002** | CAknSettingPage::AcceptSettingL |
| AVKON 1272 | `CAknKeySoundSystem::PushContextL(TInt)` | **1141** | AknListBoxShortCuts::ChangeStateL |
| AVKON 1213 | `CAknKeySoundSystem::PopContext()` | **1139** | CAknProgressDialog constructor |
| CONE 167 | `CCoeAppUi::RemoveFromStack(CCoeControl*)` | **211** | CCoeEnv::AddObserverOfLoadedFepL |
| AVKON 2048 | `CAknAppUi::~CAknAppUi()` | **2937 / 2938 / 2939** | CAknDoubleStyle2ListBox::HandlePointerEventL |

Additional target AVKON symbol:
- `CAknAppUiBase::BaseConstructL(TInt)` is also exported at ordinal 205.
- The old game import is explicitly `CAknAppUi::BaseConstructL(TInt)`; the direct class match is target ordinal 2924. Do not silently substitute the base-class overload at 205.

The unchanged old ordinals are occupied by unrelated methods in all nine cases. Raw ordinal forwarding is unsafe.

## 2. Destructor ABI remains unresolved

The target AVKON DSO exports three destructor variants at ordinals 2937, 2938 and 2939 (Itanium ABI D0/D1/D2 forms). The old N-Gage import library exposes one ordinal named `CAknAppUi::~CAknAppUi()`, and the game destructor call site passes a second register argument through the import thunk.

The exact correspondence between the old destructor ABI and target D0/D1/D2 must be proven before selecting one. The wrapper must also preserve the target shadow object's lifetime and avoid deleting the game-side object.

## 3. Wrapper boundary suggested by the lifecycle

The Step62 game-side trace shows which calls operate on the old app-UI object and which operate on a target-created key-sound object:

### Calls requiring game-object → target-app-UI translation

- AVKON 63 → target CAknAppUi::BaseConstructL ordinal 2924.
- EIKCORE 233 → target CEikAppUi::ApplicationRect ordinal 318.
- AVKON 1529 → target CAknAppUi::SetKeyBlockMode ordinal 2927.
- AVKON 874 → target CAknAppUiBase::KeySounds ordinal 3002.
- CONE 12 → target CCoeAppUi::AddToStackL ordinal 202.
- CONE 167 → target CCoeAppUi::RemoveFromStack ordinal 211.
- AVKON 2048 → target CAknAppUi destructor variant, after ABI resolution.

These calls receive the old game app-UI pointer or a game CCoeControl pointer and must not be forwarded blindly.

### Calls receiving the target key-sound-system pointer

- AVKON 1272 → target CAknKeySoundSystem::PushContextL ordinal 1141.
- AVKON 1213 → target CAknKeySoundSystem::PopContext ordinal 1139.

The game obtains this pointer from target `KeySounds()` and stores it at its own +0x64. Once returned, the key-sound object is a target object; these two calls may be forwarded directly after their object ABI and lifetime are confirmed.

## 4. Remaining control-object compatibility question

The game control returned by `sub_10028340` is stored at game app-UI +0x60 and passed to target AddToStackL/RemoveFromStack. It is an original game CCoeControl-derived object with a backpointer at control+0x25c.

Before forwarding AddToStackL/RemoveFromStack to target CONE, compare the N-Gage and S60 3.1 CCoeControl layouts and inspect the game's control vtable. The target app UI stack may invoke virtual methods on that control; a target stack cannot safely accept an old-layout control unless its virtual calls and fields are compatible or wrapped.

## 5. Reproducibility

- Script: `tools/step63_target_lifecycle_export_map.py`.
- Workflow: `.github/workflows/s60-runtime-import-probe.yml`.
- GitHub Actions run: `42501249442`, completed successfully.
- Artifact: `s60-3.1-fp1-runtime-import-probe`, ID `13625044543`.
- Artifact SHA-256: `87485ec8871b0d0d09ca03be90cf3d0bf44390c53c497304c3d5b21ff0b82ba7`.
- Target DSO SHA-256:
  - AVKON: `64590eb8ee673c14e98f392811f30175e0c3f3279237a8f72f2a12ddb3f68861`
  - EIKCORE: `617665936538cda7b49f957cb354c87e7ee38af048ec8886098aa83c92165b53`
  - CONE: `e52ba0f53aaeb97c8ab7fc9d32eaa3a157b73b01bbb0e80796926420ccca80ac`

This is SDK export evidence, not a physical N95 ROM export dump. No real-device launch is claimed.

## Next actions

1. Resolve the old destructor ABI against target D0/D1/D2.
2. Compare N-Gage and S60 3.1 CCoeControl layouts and virtual method slots.
3. Inspect `sub_10028340` and the full game control object lifecycle.
4. Design wrappers for AddToStackL/RemoveFromStack and any old-layout control virtual methods.
5. Continue mapping the remaining primary-vtable imports.
