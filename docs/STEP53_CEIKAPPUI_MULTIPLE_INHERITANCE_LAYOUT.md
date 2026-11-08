# Step 53 — CEikAppUi multiple-inheritance layout and missing vtable

Date: 2026-11-08

## Current stop

The live VFS trace reaches ARM UREL EIKCORE ordinal 224:

- symbol: `__9CEikAppUi` — `CEikAppUi::CEikAppUi()`;
- return address: `0x10021144`;
- `this = 0x10110258`;
- allocation size: 108 bytes (`0x6c`);
- lifted callsite: `sub_10021138`.

The caller invokes the imported constructor and then writes these values:

| Object offset | Value written by game | Likely role |
|---:|---:|---|
| +0x00 | `0x100ffe88` | game-derived primary vtable |
| +0x14 | `0x100fff00` | `MEikMenuObserver` secondary vtable |
| +0x1c | `0x100fff54` | `MObjectProvider` secondary vtable |
| +0x48 | `0x100fdc90` | game-derived member/function pointer |
| +0x4c | `0x100fe050` | game-derived member/function pointer |

The caller does **not** write object offset +0x18.

## SDK layout reconstruction

The N-Gage SDK declares:

`CEikAppUi : public CCoeAppUi, public MEikMenuObserver, public MCoeMessageObserver, public MObjectProvider`

The `CCoeAppUi` base contributes a 20-byte subobject:
- CBase vptr at +0x00;
- `iCoeEnv` at +0x04;
- `iViewManager` at +0x08;
- `iStack` at +0x0c;
- `iExtra` at +0x10.

The three subsequent interface bases each contribute a 4-byte vptr in declaration order:

| Offset | Base subobject |
|---:|---|
| +0x14 | `MEikMenuObserver` |
| +0x18 | `MCoeMessageObserver` |
| +0x1c | `MObjectProvider` |

The `CEikAppUi` data members then begin at +0x20:

| Offset | Member |
|---:|---|
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

This yields a 72-byte `CEikAppUi` base subobject. The 108-byte allocation is therefore consistent with a game-derived class adding 36 bytes.

## Exact unresolved state

The caller overwrites the primary vptr at +0x00 and secondary vptrs at +0x14 and +0x1c. It leaves +0x18 untouched. Given the declared base order, +0x18 is the `MCoeMessageObserver` subobject vptr.

That value must be installed by the imported EIKCORE 224 constructor. It is not present in the ARM UREL import-library stub, and it cannot be inferred from the other three game-owned vtable addresses.

The constructor HLE must therefore remain fail-closed until the correct +0x18 vtable value and any constructor side effects are recovered. Writing zero or borrowing a WINS/OS9.2 address would be an unsupported substitution.

## Why the WINS DLL did not resolve it

Step52 inspected the SDK's WINS UDEB `eikcore.dll`:
- PE32 Intel i386, 110,648 bytes;
- 290 export ordinals, no named exports;
- stripped COFF symbol table;
- no CEikAppUi/CEikApplication/CEikDocument constructor strings in the WINS import library.

It cannot provide the ARM vtable address. WINS ordinal assignments also differ from ARM UREL.

## Required artifact

The next useful artifact is the matching original N-Gage QD ROM library:

`Z:\system\libs\EIKCORE.DLL`

A dump from the target Nokia N95 is also useful for a separate EKA2 compatibility audit:

`Z:\sys\bin\EIKCORE.DLL`

The N-Gage ARM library is needed to resolve the old constructor and its +0x18 vtable. The N95 library is needed to establish the target firmware's own export table. Do not substitute one for the other.

## Validation boundary

The host regression suite passes the implemented ARM-identity HLEs through EIKCORE 219. The live trace currently stops at EIKCORE 224. No full UI initialization, N95 launch, or real-device test is claimed.


## Step59 follow-up — target S60 layout is not binary-identical

The Step53 N-Gage SDK layout above remains the correct layout expected by the game. The later S60 3.1 FP1 header audit (see [Step59](STEP59_CEIKAPPUI_TARGET_LAYOUT_BREAK.md)) found that target `CCoeAppUi` adds `iCCoeAppUi_Reserved1` at +0x14. This expands the target base from 0x14 to 0x18 bytes and shifts the target CEikAppUi secondary vptrs to +0x18/+0x1c/+0x20 and data members to +0x24 onward. The game still expects +0x14/+0x18/+0x1c and data from +0x20.

Therefore the S60 EIKCORE CEikAppUi C2 constructor at target ordinal 178 is **not** a safe direct replacement for the missing N-Gage EIKCORE 224 constructor. The original Step53 requirement for the old-layout +0x18 MCoeMessageObserver vptr remains unresolved until an old-layout compatibility shim or equivalent vtable/this-adjustment layer is designed and validated. Keep EIKCORE 224 fail-closed.
