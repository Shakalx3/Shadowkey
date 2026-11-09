# Step 67 — target S60 3.1 CCoeControl export remap

Date: 2026-11-09

## 1. Target CONE exports for the original control bridge

The target S60 3.1 FP1 ARMv5 EABI4 CONE DSO was parsed from its defined global dynamic symbols. The target ordinals below are independent of the N-Gage ARM UREL ordinals.

| Old N-Gage CONE ordinal | Method | Target S60 3.1 ordinal(s) |
|---:|---|---:|
| 236 | CCoeControl constructor | 64 (C1), 65 (C2) |
| 232 | CCoeControl destructor | 66 (D0), 67 (D1), 68 (D2) |
| 226 | CCoeControl::SystemGc() const | **287** |
| 160 | CCoeControl::Rect() const | **276** |
| 40 | CCoeControl::CreateWindowL() | **25** |
| 214 | CCoeControl::SetRect(const TRect&) | **57** |
| 138 | MakeVisible | 11 |
| 200 | SetDimmed | 62 |
| 197 | SetContainerWindowL | 37, 38, 39 (overloads) |
| 29 | ConstructFromResourceL | 48 |
| 3 | ActivateL | 61 |
| 153 | PrepareForFocusLossL | 42 |
| 185 | SetAdjacent | 13 |
| 208 | SetNeighbor | 15 |
| 95 | HasBorder | 288 |
| 139 | MinimumSize | 12 |
| 87 | HandleResourceChange | 40 |
| 72 | GetColorUseListL | 266 |
| 74 | GetHelpContext | 263 |
| 84 | HandlePointerBufferReadyL | 51 |
| 221 | SizeChanged | 18 |
| 147 | PositionChanged | 30 |
| 33 | CountComponentControls | 272 |
| 28 | ComponentControl | 265 |
| 173 | WriteInternalStateL | 271 |
| 177 | Reserved_2 | 9 |

All listed old ordinal positions are occupied by unrelated target exports or absent exports. Direct ordinal forwarding is invalid.

## 2. Constructor/destructor variants

The target DSO exposes:
- constructor C1 at 64 and C2 at 65;
- destructor D0 at 66, D1 at 67 and D2 at 68.

The original game control is a derived object. Its old constructor calls N-Gage CONE 236 from `sub_10021648`, and its old destructor calls N-Gage CONE 232 from `sub_100216f8`.

Do not run target CCoeControl C1/C2 on the original game object: the target base layout has already been shown incompatible with the N-Gage object layout. A target-native proxy derived from CCoeControl should let the target compiler select the correct base constructor/destructor variants. The exact wrapper path for any manual destructor call remains subject to the target object-lifetime rules.

## 3. Useful target ordinals for the proxy implementation

The minimum confirmed target calls needed for the currently traced control construction/drawing path are:

- CCoeControl::CreateWindowL() — 25
- CCoeControl::SetRect(const TRect&) — 57
- CCoeControl::Rect() const — 276
- CCoeControl::SystemGc() const — 287

These are target SDK export ordinals, not yet confirmed against a physical N95 ROM dump. The target CONE DSO SHA-256 is:

`e52ba0f53aaeb97c8ab7fc9d32eaa3a157b73b01bbb0e80796926420ccca80ac`

## 4. Reproducibility

- Tool: `tools/step67_target_coecontrol_export_map.py`.
- Workflow: `.github/workflows/s60-runtime-import-probe.yml`.
- GitHub Actions run: `42571112130`, completed successfully.
- Artifact: `s60-3.1-fp1-runtime-import-probe`, ID `13653620496`.
- Artifact SHA-256: `3c3ca182e4e942809d85638d2b89c0c65403a34977446704365ea346a5eaf778`.

No game HLE or executable was modified. No device launch is claimed.

## Next actions

1. Build the target-native CCoeControl proxy using these target ordinals through the real S60 SDK.
2. Keep the original game object on the old N-Gage layout and route old CONE calls through wrappers.
3. Determine the exact destructor variant from the old callsite and target object ownership.
4. Resolve the CWindowGc virtual-order mismatch found in Step66 before returning any target graphics context to the original game code.
