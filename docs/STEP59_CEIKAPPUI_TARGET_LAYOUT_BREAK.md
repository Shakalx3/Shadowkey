# Step 59 — CEikAppUi layout mismatch and TInt64 compatibility break

Date: 2026-11-08

## 1. Target CEikAppUi inheritance is confirmed

The S60 3.1 FP1 target header `Epoc32/include/eikappui.h` declares the same ordered base list as the original N-Gage SDK:

`CEikAppUi : public CCoeAppUi, public MEikMenuObserver, public MCoeMessageObserver, public MObjectProvider`

This confirms that the interface-base order itself did not change. The target constructor exports are:
- C1 complete-object constructor: EIKCORE ordinal 177.
- C2 base-object constructor: EIKCORE ordinal 178.

Because the game constructs CEikAppUi as a base subobject of its 108-byte derived UI object, C2/178 is the semantically closest target export. It is **not**, however, safe to remap directly.

## 2. CCoeAppUi grew by one word on the target

The target S60 3.1 FP1 `coeaui.h` declares the following CCoeAppUi data members, in order:

| Offset in target CCoeAppUi | Member |
|---:|---|
| +0x00 | CBase primary vptr |
| +0x04 | `iCoeEnv` |
| +0x08 | `iViewManager` |
| +0x0c | `iStack` |
| +0x10 | `iExtra` |
| +0x14 | `iCCoeAppUi_Reserved1` |

On 32-bit ARM this makes the target CCoeAppUi subobject 0x18 bytes. The N-Gage SDK layout recovered in Step53 has only the first four data members after the vptr and a 0x14-byte CCoeAppUi subobject.

That one added reserved word shifts every later CEikAppUi base and member offset by four bytes.

## 3. Target and N-Gage CEikAppUi layouts diverge

### N-Gage layout used by the game (Step53)

| Offset | Member/base |
|---:|---|
| +0x00 | CCoeAppUi primary vptr |
| +0x14 | MEikMenuObserver vptr |
| +0x18 | MCoeMessageObserver vptr |
| +0x1c | MObjectProvider vptr |
| +0x20 | `iDocument` |
| +0x24 | `iContainerAppUi` |
| +0x28 | `iDoorObserver` |
| +0x2c | `iEmbeddedAndReadOnly` |
| +0x30 | `iFlags` |
| +0x34 | `iKeySounds` |
| +0x38 | `iEventMonitor` |
| +0x3c | `iFactory` |
| +0x40 | `iSpare2` |
| +0x44 | `iSpare` |

The N-Gage CEikAppUi base occupies 0x48 bytes.

### S60 3.1 FP1 target layout inferred from headers

| Offset | Member/base |
|---:|---|
| +0x00 | CCoeAppUi primary vptr |
| +0x14 | `iCCoeAppUi_Reserved1` |
| +0x18 | MEikMenuObserver vptr |
| +0x1c | MCoeMessageObserver vptr |
| +0x20 | MObjectProvider vptr |
| +0x24 | `iDocument` |
| +0x28 | `iContainerAppUi` |
| +0x2c | `iDoorObserver` |
| +0x30 | `iEmbeddedAndReadOnly` |
| +0x34 | `iFlags` |
| +0x38 | `iAppUiExtra` |

The target CEikAppUi base occupies 0x3c bytes.

## 4. Why direct EIKCORE 224 → EIKCORE 178 remapping is unsafe

The game constructor caller writes its N-Gage layout:
- game MEikMenuObserver vptr at +0x14;
- game MObjectProvider vptr at +0x1c;
- it leaves +0x18 for the missing MCoeMessageObserver vptr.

The target S60 C2 constructor expects:
- +0x14 to be the reserved CCoeAppUi word;
- MEikMenuObserver vptr at +0x18;
- MCoeMessageObserver vptr at +0x1c;
- MObjectProvider vptr at +0x20.

Therefore a direct call to target C2/178 would:
- have its MEikMenuObserver vptr at the wrong offset for the game;
- have its MCoeMessageObserver vptr overwritten by the game's MObjectProvider vptr write at +0x1c;
- leave the game's expected MCoeMessageObserver slot at +0x18 holding the wrong interface vptr;
- place the target MObjectProvider vptr at +0x20, where the game expects `iDocument`;
- shift all target data members by four bytes relative to the game layout;
- provide `iAppUiExtra` where the old game layout expects `iEventMonitor`, while the old `iKeySounds`, `iEventMonitor`, `iFactory` and spare slots do not exist with the same meanings in the target header.

This is a confirmed class-layout ABI break, not merely an unresolved ordinal. Do not patch EIKCORE 224 directly to 178.

## 5. Consequence for the compatibility layer

A safe compatibility implementation must preserve the N-Gage object layout seen by the game while adapting framework operations to S60 3.1. Possible approaches include:
- a dedicated old-layout CEikAppUi compatibility object with translated calls into S60;
- explicit secondary-vtable thunks that adjust `this` and translate old offsets to target offsets;
- a separate target-layout backing object, with a wrapper maintaining the old-layout game object and lifetime/ownership mapping.

These are design directions only. A temporary object with copied target vptrs is not sufficient by itself: virtual calls through those vptrs would still pass an old-layout `this` pointer to methods compiled for the target layout.

The next static audit must enumerate all reads/writes of the game's CEikAppUi object at offsets +0x14 through +0x4c and determine which old fields are actually used before choosing a shim strategy.

## 6. EUSER 1575 is explained by the Symbian TInt64 transition

The target S60 3.1 FP1 header `e32def.h` explicitly documents that from Symbian OS 8.1b onward `TInt64` is a built-in type rather than the old class type, and that the old class member functions are no longer exported from EUSER. The header defines:

`typedef Int64 TInt64;`

This explains why the N-Gage ARM import `TInt64::operator!=(const TInt64&) const` has no named export in the S60 target EUSER DSO. On the target, the comparison is an ordinary built-in 64-bit inequality and should be compiled inline or implemented by the compatibility thunk.

The existing HLE `shadowkey_hle_euser1575_int64_ne` reads both 32-bit halves of the two 64-bit operands and returns true if either half differs. That is equivalent to 64-bit inequality for the two in-memory operands. Its current guest-pointer bounds checks remain diagnostic-HLE policy, not part of the C++ operator semantics.

## 7. Evidence and boundaries

- Target headers were extracted from the pinned S60 3.1 FP1 SDK devkit by workflow run `42499878299`.
- Header probe artifact: `s60-3.1-fp1-runtime-import-probe`, artifact ID `13624688892`, SHA-256 `f7025598afd57afbab9fbbd6c7c3beb52984bef3f10b00fc812a05c9af58e3fb`.
- The target SDK headers establish the public class declaration and member declaration order. The offsets above are 32-bit ARM layout calculations from those declarations; they are not runtime memory measurements from an N95.
- The target SDK DSO export map is verified by Step58. The physical N95 ROM's actual EIKCORE exports and implementation still need later confirmation.
- No EIKCORE binary patch or constructor HLE replacement was made in this step.
- No physical-device launch is claimed.

## Next action

Inspect the game-side CEikAppUi object accesses from the lifted callsites and establish which old fields at +0x34..+0x44 are read, written, or passed to framework virtual methods. Keep EIKCORE 224 fail-closed until the compatibility object/thunk design is evidence-based.
