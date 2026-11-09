# Step 65 — actual game CCoeControl object and target ABI incompatibility

Date: 2026-11-09

## 1. The factory creates a 0x444-byte game-derived control

The real factory chain is now traced in lifted ARM instructions:

- `sub_10028340` calls `sub_100282f8`, then calls EUSER ordinal 828 (CleanupStack::Pop) on the returned object.
- `sub_100282f8` requests an allocation of `0x444` bytes through EUSER ordinal 3, calls `sub_10021648` as the constructor, pushes the object to CleanupStack through EUSER ordinal 858, then calls `sub_10021244(control, appUi)` as the leaving/second-stage construction path.
- `sub_10021648` calls CONE ordinal 236 (the N-Gage import-library member is `CCoeControl::CCoeControl()`), then installs the derived object's vptrs.
- `sub_10021244` calls the old CCoeControl APIs through the following game imports: CONE 40 (`CreateWindowL()`), CONE 214 (`SetRect(const TRect&)`), and CONE 160 (`Position() const -> TPoint`).

The 0x444 allocation is the requested size passed by the game, not an inferred sizeof from headers.

## 2. Actual vptrs written by the game constructor

The constructor `sub_10021648` writes:

| Object offset | Vptr value | Meaning |
|---:|---:|---|
| +0x00 | `0x100fcf68` | primary game-derived CCoeControl vtable |
| +0x04 | `0x100fbb74` | secondary MObjectProvider vtable |

The secondary table has offset-to-top `-4` and two thunk entries, consistent with the secondary `MObjectProvider` base subobject at +4. The primary table has offset-to-top 0.

These addresses were decoded from the E32 code payload using the image base and code file offset, not found only by raw-byte scanning.

## 3. Primary virtual table recovered from the actual object

Primary vtable `0x100fcf68`, decoded from the original `6R51.APP`:

| Slot | Entry | Old N-Gage meaning |
|---:|---|---|
| 0 | `sub_100216f8` | game-derived destructor |
| 1 | `sub_10021fc0` | game override of OfferKeyEventL |
| 2 | CONE 138 | MakeVisible |
| 3 | CONE 200 | SetDimmed |
| 4 | CONE 197 | SetContainerWindowL(const CCoeControl&) |
| 5 | CONE 29 | ConstructFromResourceL |
| 6 | CONE 3 | ActivateL |
| 7 | CONE 153 | PrepareForFocusLossL |
| 8 | `sub_100282f4` | game no-op override (PrepareForFocusGainL position) |
| 9 | CONE 185 | SetAdjacent |
| 10 | CONE 208 | SetNeighbor |
| 11 | CONE 95 | HasBorder |
| 12 | CONE 139 | MinimumSize |
| 13 | CONE 87 | HandleResourceChange |
| 14 | CONE 72 | GetColorUseListL |
| 15 | CONE 74 | GetHelpContext |
| 16 | `sub_10028158` | InputCapabilities wrapper; calls CONE 83 |
| 17 | `sub_100281fc` | game no-op override at HandlePointerEventL position |
| 18 | CONE 84 | HandlePointerBufferReadyL |
| 19 | `sub_100282f0` | game no-op override at FocusChanged position |
| 20 | CONE 221 | SizeChanged |
| 21 | CONE 147 | PositionChanged |
| 22 | CONE 33 | CountComponentControls |
| 23 | CONE 28 | ComponentControl |
| 24 | `sub_10028260` | game Draw override |
| 25 | CONE 173 | WriteInternalStateL |
| 26 | CONE 177 | Reserved_2 |
| 27 | null | end marker |

The vtable also contains a separate secondary `MObjectProvider` table at +4. The exact primary entries and imported ordinals are preserved in the Step60 artifact; the extraction is reproducible through `tools/step60_appui_object_field_audit.py`.

## 4. Target S60 3.1 CCoeControl is not layout-compatible

Step64 compared the actual N-Gage and target S60 3.1 `coecntrl.h` declarations.

Both declare the same direct bases:
`CCoeControl : public CBase, public MObjectProvider`.

However, their private data members differ:

### N-Gage
`iCoeEnv; iContext; iPosition; iSize; iWin; iObserver; iExt; iMopParent;`

### S60 3.1 target
`iCoeEnv; iContext; iPosition; iSize; iFlags; iWin; iData; iMopParent;`

The target inserts `TInt iFlags` before `iWin`. Under the 32-bit ARM layout, the shared prefix is the two base subobjects followed by the same `iCoeEnv`, `iContext`, `TPoint`, and `TSize` members. Therefore the target's `iWin` is displaced by one 32-bit word relative to the N-Gage declaration. All later private state also requires separate validation; matching field names do not establish matching offsets.

Header SHA-256:
- N-Gage `coecntrl.h`: `05663393eaa0788de7edc11aa64ec317547e049b45190e89fd08abb8d4888178`
- Target S60 3.1 `coecntrl.h`: `9f86184d56ea80929bba85491802c8ce30256f9608a9a20714605319f5aa0739`

## 5. Target vtable inserts virtual methods before old event-handling slots

The old N-Gage virtual order after `InputCapabilities()` proceeds to:
`HandlePointerEventL`, `HandlePointerBufferReadyL`, `FocusChanged`, `SizeChanged`, `PositionChanged`, `CountComponentControls`, `ComponentControl`, then drawing/stream virtuals.

The target S60 3.1 header inserts five virtual methods after `InputCapabilities()` and before `HandlePointerEventL`:

1. `SetParent(CCoeControl*)`
2. `SetLayoutManagerL(MCoeLayoutManager*)`
3. `RequestRelayout(const CCoeControl*)`
4. `TextBaselineOffset(const TSize&) const`
5. `SetTextBaselineSpacing(TInt)`

It also inserts `HandleControlArrayEventL` and `GetTextDrawer` before the MObjectProvider virtuals.

Consequently, the old game vtable's slot 17 is its `HandlePointerEventL)-position no-op, while target slot 17 is `SetParent`. Old slot 18 is `HandlePointerBufferReadyL`, while target slot 18 is `SetLayoutManagerL`. These are different contracts and signatures. The shift continues through later virtuals.

This is direct header-order evidence of an ABI mismatch; it does not depend on a speculative object-size estimate.

## 6. Consequence: do not register the original game control with target CCoeAppUi

The game control cannot safely be passed directly to target S60 3.1 `CCoeAppUi::AddToStackL` / `RemoveFromStack`:

- target CCoeControl private fields are laid out differently;
- target virtual calls after InputCapabilities use different slots;
- target base constructors/destructors would write/read target layout on old game memory.

A wrapper that merely remaps the AddToStackL ordinal is insufficient.

The leading safe architecture is now more specific:

1. Keep the original 0x444-byte game control object and its old vptrs intact.
2. Allocate a separate S60 3.1-native proxy object derived from target `CCoeControl`.
3. Register only the proxy with the target app UI stack.
4. Implement proxy virtual methods to delegate to the original game control where the semantics are compatible, and bridge the old game's input/draw/update methods explicitly.
5. Maintain bidirectional mapping between game control and target proxy.
6. Ensure the proxy owns/uses a target-valid window/control environment, while the old game object continues to receive its original game-side state and callbacks.

A native proxy still requires a real EKA2 host executable and a target SDK toolchain. It is an architecture direction, not yet an implementation or proof of launchability.

## 7. Reproducibility

- Step60 extractor: `tools/step60_appui_object_field_audit.py`.
- GitHub Actions run: `42570201301`, completed successfully.
- Commit: `8243ea948424d269a50ac349551916b8940fe51c`.
- Artifact: `step60-appui-object-field-audit`, ID `13652687565`.
- Artifact SHA-256: `12c0b2cbd3039a4242251d9934157a375a02ad92967f877ccb5034c79bd37646`.
- The Step64 header comparison is from the S60 3.1 FP1 devkit artifact, not a physical N95 ROM dump.

No HLE behavior was changed. No N95 device launch is claimed.

## Next technical tasks

1. Trace the full old control destructor `sub_100216f8` and the game-specific virtuals `sub_10021fc0`, `sub_10028158`, and `sub_10028260`.
2. Map the target S60 ordinals for the complete proxy lifecycle: CCoeControl construction/destruction, window creation, rect/position, visibility, dimming, focus, event dispatch, drawing, and stack registration.
3. Establish which old control methods can be delegated directly and which need semantic conversion.
4. Define the proxy's ownership and cleanup rules against the target app UI lifecycle.
5. Keep the EKA2 executable/ELF-to-E32Image pipeline as a parallel blocker; the proxy alone does not produce a bootable application.
