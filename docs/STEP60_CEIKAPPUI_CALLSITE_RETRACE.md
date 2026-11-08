# Step 60 — complete CEikAppUi constructor callsite retrace

Date: 2026-11-08

## Exact callsite and import identity

The lifted function `sub_10021138` is the constructor caller described in Step53. It calls:

- thunk: `0x1009f700`;
- return address: `0x10021144`;
- import table row: `{ 0x1009f700u, 0x10100580u, "EIKCORE[10004892].DLL", 224u }`.

The full function body was extracted from `source_bundle/shadowkey_step35_work/shadowkey_lifted_v6.c`. It is 2,699 bytes and contains the complete post-constructor stores.

## Exact store sequence

After the EIKCORE 224 constructor returns, the game performs these stores:

| Instruction address | Object offset | Value | Interpretation |
|---:|---:|---:|---|
| 0x10021148 | +0x48 | 0x100fdc90 | temporary pointer; overwritten later |
| 0x10021150 | +0x4c | 0x100fe050 | temporary pointer; overwritten later |
| 0x10021158 | +0x1c | 0x100fff54 | final MObjectProvider vptr |
| 0x10021160 | +0x00 | 0x100ffe88 | temporary primary vptr; overwritten later |
| 0x10021168 | +0x14 | 0x100fff00 | final MEikMenuObserver vptr |
| 0x10021170 | +0x18 | 0x100fff64 | final MCoeMessageObserver vptr |
| 0x10021178 | +0x4c | 0x100fff40 | final pointer/table value; exact interface identity pending |
| 0x10021180 | +0x48 | 0x100fff34 | final pointer/table value; exact interface identity pending |
| 0x1002118c | +0x00 | 0x100fc4d8 | final primary vptr |

This corrects Step53: **the game does write +0x18 itself**. The earlier claim that +0x18 was left untouched was based on an incomplete trace. All three secondary interface vptrs are installed by the game after the constructor.

The final values at +0x48 and +0x4c are in the same pointer-like address region as the other vtable data, but their precise base/interface identity has not yet been proven. The initial values 0x100fdc90 and 0x100fe050 are not final object state; the same function overwrites them.

## Implication for the target S60 constructor

Step59 established that S60 3.1 FP1 CEikAppUi C2/178 has a four-byte-shifted layout compared with the N-Gage object.

Step60 refines the risk:
- the game overwrites its primary and all three secondary vptrs after EIKCORE 224 returns;
- therefore the target constructor's vptr values are not the missing game state;
- however, target C2/178 writes MObjectProvider at +0x20 and iDocument at +0x24, while the N-Gage game layout expects iDocument at +0x20;
- the target constructor's base data and side effects still require a compatibility translation.

The immediate task is no longer “find the missing +0x18 vptr.” It is to determine which old CEikAppUi base data fields the game actually reads after construction, and whether the target constructor can be called behind a wrapper that translates the data layout without breaking framework object ownership or virtual dispatch.

## Binary locator results

The Step60 workflow found the 6R51.APP copies in the source bundle and located raw little-endian occurrences of the pointer constants. The first hits are in the binary's code/literal area and are locators only; they are not yet a validated E32 virtual-address-to-file-offset mapping and do not identify the actual vtable contents.

## Reproducibility

- Workflow: `.github/workflows/step60-appui-object-field-audit.yml`.
- Run: `42500106008`, completed successfully.
- Artifact: `step60-appui-object-field-audit`, ID `13624807375`.
- SHA-256: `913a02a46e4deba12b6d935a983d485125c8783c8670b28b3b3541e9b2b7b5b4`.
- Reusable extractor: `tools/step60_appui_object_field_audit.py`.

## Next work

1. Decode the final pointer tables at 0x100fff34 and 0x100fff40 and identify the corresponding derived interfaces.
2. Inspect all game reads/writes of the CEikAppUi object at +0x20..+0x4c after construction.
3. Determine whether old fields `iKeySounds`, `iEventMonitor`, `iFactory` and spare slots are accessed by the game.
4. Only then design a compatibility constructor wrapper for EIKCORE 224.
5. Keep EIKCORE 224 fail-closed; no target C2 direct remap or synthetic field initialization is justified yet.

No binary patch or physical-device launch is claimed.


## Step60 vtable-group decoding

The E32 header and code payload were used to map each vtable VA to its actual file offset. For the original `6R51.APP` image:
- image base: `0x10000000`;
- code size: `0x1009c4`;
- text size: `0x100340`;
- code file offset: `0x7c`;
- code VA to file offset: `0x7c + (VA - 0x10000000)`.

The first two words at each vtable pointer are the offset-to-top and null typeinfo pointer; function entries follow them. The signed offset-to-top values independently confirm the subobject offsets:

| Stored vptr offset in game object | Vtable VA | Offset-to-top in vtable | Result |
|---:|---:|---:|---|
| +0x00 | 0x100fc4d8 | 0 | primary vtable |
| +0x14 | 0x100fff00 | -0x14 | MEikMenuObserver |
| +0x18 | 0x100fff64 | -0x18 | MCoeMessageObserver |
| +0x1c | 0x100fff54 | -0x1c | MObjectProvider |
| +0x48 | 0x100fff34 | -0x48 | additional secondary interface A |
| +0x4c | 0x100fff40 | -0x4c | additional secondary interface B |

This proves that the final +0x48 and +0x4c values are secondary vtable pointers, not ordinary function pointers. The vtable group also confirms the game-derived class has two further interface bases after the old 0x48-byte CEikAppUi base.

### Vtable method imports

| Vtable | Game/OS method entries observed |
|---|---|
| Primary | game: `sub_10021080`, `sub_10020b04`, `sub_100211c0`, `sub_100209c8`; AVKON 808, 1254, 803; EIKCORE 144, 147, 74, 81, 133, 198, 134, 124, 51, 82, 206; CONE 101, 82, 90 |
| MEikMenuObserver (+0x14) | EIKCORE 48, 75, 31, 157, 65, 64, 121, 226; game thunks at 0x100a417c, 0x100a4174, 0x100a4184 |
| MCoeMessageObserver (+0x18) | CONE 255, 256; game thunk at 0x100a418c |
| MObjectProvider (+0x1c) | game thunks at 0x100a419c, 0x100a4194 |
| Additional A (+0x48) | game thunk at 0x100a4368 |
| Additional B (+0x4c) | game thunk at 0x100a4370; CONE 292, 293 |

CONE 292/293 are the N-Gage ARM imports `MCoeViewDeactivationObserver_Reserved_1/2`, so additional interface B is identified as `MCoeViewDeactivationObserver`. Additional interface A has one game override and is likely `MCoeViewActivationObserver`; that identity remains an inference pending direct header/vtable-thunk confirmation.

The six non-registry game thunk addresses (0x100a417c, 0x100a4174, 0x100a4184, 0x100a418c, 0x100a419c, 0x100a4194, 0x100a4368, 0x100a4370) need a short ARM disassembly pass to identify their this-adjustments and target methods. The vtable import map was produced by joining the actual E32 vtable entries to the game's import-thunk table and Step46 ARM UREL ordinal map.


## Step61 follow-up — the two additional interfaces are identified

The vtable thunks were disassembled from the original E32 code payload with ARM binutils. The two final secondary bases are now identified by the imports they forward to:

- +0x48 thunk `0x100a4368`: `SUB r0,r0,#0x48`; branch to AVKON ordinal 802, `CAknAppUi::HandleStatusPaneSizeChange()`. This is `MEikStatusPaneObserver`.
- +0x4c thunk `0x100a4370`: `SUB r0,r0,#0x4c`; branch to AVKON ordinal 805, `CAknAppUi::HandleViewDeactivation(const TVwsViewId&,const TVwsViewId&)`. This is `MCoeViewDeactivationObserver`; the following vtable entries are CONE 292/293, the interface's reserved methods.

The original N-Gage SDK `aknappui.h` independently declares:

`CAknAppUi : public CEikAppUi, MEikStatusPaneObserver, public MCoeViewDeactivationObserver`

The game object is therefore a `CAknAppUi`-layout object (or a class derived from it), not merely a CEikAppUi object. This explains the additional secondary vptrs at +0x48 and +0x4c. The earlier “Additional A/B” labels are now resolved as MEikStatusPaneObserver and MCoeViewDeactivationObserver.

The other secondary thunks also prove their this-adjustments:
- +0x14 MEikMenuObserver: subtract 0x14 before forwarding to EIKCORE methods;
- +0x18 MCoeMessageObserver: subtract 0x18 before forwarding to EIKCORE 80;
- +0x1c MObjectProvider: subtract 0x1c before forwarding to EIKCORE 290/264;
- +0x48 MEikStatusPaneObserver: subtract 0x48 before AVKON 802;
- +0x4c MCoeViewDeactivationObserver: subtract 0x4c before AVKON 805.

This provides direct binary evidence of the multiple-inheritance adjustment model. The N95 S60 3.1 `CAknAppUi` declaration and AVKON target ordinals are the next comparison point; do not assume that the old AVKON ordinals or the old +0x48/+0x4c offsets remain valid on the target.
