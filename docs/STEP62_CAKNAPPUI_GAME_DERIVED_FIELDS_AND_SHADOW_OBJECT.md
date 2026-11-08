# Step 62 — CAknAppUi game-derived fields and shadow-object requirement

Date: 2026-11-08

## 1. Game-side construction and cleanup paths

The Step60 extractor was extended to retrieve the game-side functions from the lifted ARM source:

- `sub_10021138`: initializes the old N-Gage CEikAppUi/CAknAppUi vptr group after EIKCORE 224.
- `sub_100211c0`: post-base app-UI construction path.
- `sub_10021080`: matching cleanup/destruction path.
- `sub_100209c8`: app-UI virtual method that reads the game-derived control pointer at +0x60.

The import identities below come from the actual thunk/IAT table and Step46 ARM UREL map.

## 2. Derived fields at +0x60, +0x64 and +0x68

The construction path `sub_100211c0` performs:

1. AVKON 63 — `CAknAppUi::BaseConstructL(TInt)`, with `this` and mode 0.
2. EIKCORE 233 — `CEikAppUi::ApplicationRect()`, using a stack result buffer.
3. Calls local `sub_10028340` to create a control object.
4. Stores that control pointer at `this + 0x60`.
5. Stores the app-UI backpointer at `control + 0x25c`.
6. AVKON 1529 — `CAknAppUi::SetKeyBlockMode(TAknKeyBlockMode)`, with mode 1.
7. CONE 12 — `CCoeAppUi::AddToStackL(CCoeControl*, TInt, TInt)`, passing the control pointer from `this + 0x60`.
8. AVKON 874 — `CAknAppUi::KeySounds()`; stores the returned key-sound-system pointer at `this + 0x64`.
9. AVKON 1272 — `CAknKeySoundSystem::PushContextL(TInt)`, on the object stored at +0x64.
10. Writes byte 0 to `this + 0x68`.

This proves the game-derived fields are:

| Game object offset | Meaning | Evidence |
|---:|---|---|
| +0x60 | `CCoeControl*` owned/registered by this app UI | returned by `sub_10028340`, passed to AddToStackL, backpointer stored at control+0x25c; read by `sub_100209c8` |
| +0x64 | `CAknKeySoundSystem*` | returned by CAknAppUi::KeySounds and passed to PushContextL |
| +0x68 | byte flag | explicitly initialized to zero; further use not yet traced |

The cleanup path `sub_10021080` reverses these operations:
- PopContext on the object at +0x64 (AVKON 1213);
- RemoveFromStack for the control at +0x60 (CONE 167);
- clears +0x60;
- calls SetKeyBlockMode with mode 0 (AVKON 1529);
- calls the CAknAppUi destructor (AVKON 2048).

The cleanup function also reinstalls the complete old game vptr group before running base cleanup.

## 3. Direct conflict with target S60 3.1 CAknAppUi

Step61 established the target CAknAppUi layout:

- +0x60 is target `iBlockMode`;
- +0x64 is target `iExtension`.

The game instead uses:
- +0x60 as a `CCoeControl*`;
- +0x64 as a `CAknKeySoundSystem*`.

The target CAknAppUi base also has its own `iEventMonitor` and `iKeySounds` fields at +0x40 and +0x44, while the old N-Gage layout places the corresponding CEikAppUi fields at +0x38 and +0x34.

This is now a concrete object-layout conflict demonstrated by executable instructions, not only a header-derived offset concern. A target CAknAppUi constructor or object-sensitive AVKON method cannot safely operate directly on the old game object.

## 4. Shadow target CAknAppUi is the leading architecture

The game object must retain its old N-Gage layout because:
- its vptr group is installed at the old offsets;
- its game control pointer at +0x60 is directly used;
- its key-sound-system pointer at +0x64 is directly used;
- its own byte state at +0x68 is separate from target CAknAppUi fields.

The leading design is therefore:
1. Preserve the original game object and its old-layout fields.
2. Construct a separate valid S60 3.1 CAknAppUi/CAknAppUiBase object (or use the host application's registered app UI object).
3. Maintain a game-object → target-app-UI mapping.
4. Wrap object-sensitive imports such as BaseConstructL, ApplicationRect, SetKeyBlockMode, AddToStackL, KeySounds, RemoveFromStack and CAknAppUi destruction so they operate on the target object while preserving game-side fields.
5. Return real target CAknKeySoundSystem pointers to the game; PushContextL/PopContext can then operate on those target objects directly if their own ABI and lifetime are confirmed.
6. Preserve the game CCoeControl object and ensure target AddToStackL/RemoveFromStack can safely accept it. If its own layout differs, it will need a similar proxy or a control adapter.

A separate shadow CAknAppUi may not be allowed to register as a second active app UI. The host E32 application may need to use the shadow object as its actual registered app UI, while the old game object acts only as a proxy/state object. This must be tested against the S60 application lifecycle.

## 5. Imports confirmed from the game

| Old import | ARM UREL identity |
|---|---|
| AVKON 63 | `CAknAppUi::BaseConstructL(TInt)` |
| EIKCORE 233 | `CEikAppUi::ApplicationRect()` |
| CONE 12 | `CCoeAppUi::AddToStackL(CCoeControl*,TInt,TInt)` |
| AVKON 1529 | `CAknAppUi::SetKeyBlockMode(TAknKeyBlockMode)` |
| AVKON 874 | `CAknAppUi::KeySounds()` |
| AVKON 1272 | `CAknKeySoundSystem::PushContextL(TInt)` |
| AVKON 1213 | `CAknKeySoundSystem::PopContext()` |
| CONE 167 | `CCoeAppUi::RemoveFromStack(CCoeControl*)` |
| AVKON 2048 | `CAknAppUi::~CAknAppUi()` |

Target S60 3.1 ordinals for this lifecycle subset have not yet been mapped in this step. Do not use the old ordinals on the target.

## 6. Evidence and limits

- Function bodies extracted from `shadowkey_lifted_v6.c` by the Step60 workflow.
- Import thunk identities checked against `shadowkey_import_dispatch.c`.
- ARM UREL symbol names checked against Step46.
- The control and key-sound pointer meanings are inferred directly from the imported function signatures and register setup.
- No HLE behavior or executable was changed.
- No N95 ROM dump or physical-device launch is claimed.

## Next work

1. Map the target S60 3.1 exports for the nine lifecycle imports listed above.
2. Trace the constructor/factory call that allocates the 108-byte game object and determine how its lifetime is tied to the E32 application's registered app UI.
3. Inspect the game CCoeControl object created by `sub_10028340` and its +0x25c backpointer; establish whether it can be passed to target AddToStackL directly.
4. Trace all reads/writes of game fields +0x60..+0x68 and identify any other derived fields.
5. Prototype a host-side pointer-map and wrapper contract without pretending it is a native Symbian implementation.
