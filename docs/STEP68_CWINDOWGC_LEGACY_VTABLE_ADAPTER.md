# Step 68 — original Draw path requires an old-order CWindowGc adapter

Date: 2026-11-09

## 1. Four direct SystemGc call sites

A scan of the full lifted ARM source found four calls through the old N-Gage CONE 226 import (`CCoeControl::SystemGc()`):

| Game function | Subsequent CWindowGc vtable byte offsets |
|---|---|
| `sub_10021b98` | `+0x48`, `+0xB8` |
| `sub_1002256c` | `+0xD8` |
| `sub_10022898` | `+0xC0`, `+0xDC` |
| `sub_10028260` | `+0x48`, `+0xB8` |

The old N-Gage declaration returns `CWindowGc&` from `CCoeControl::SystemGc() const`. The target S60 3.1 export is CONE ordinal **287**, not old N-Gage ordinal 226 (Step67).

## 2. Important ABI correction: the vtable has an 8-byte prefix

The first Step68 draft treated the byte offsets as direct function-slot indices. That was incorrect.

The actual game object's vptr points to a two-word vtable prefix:
- word 0: offset-to-top;
- word 1: RTTI/typeinfo pointer;
- function declarations begin at byte offset +8 from the stored vptr.

This prefix is directly visible in the original game's decoded vtable tables in Step60. Therefore a virtual call using byte offset `N` addresses declaration slot:

`slot = (N - 8) / 4`

The corrected slot mapping below accounts for that prefix.

## 3. Corrected old-to-target CWindowGc method mapping

Step66 parsed the N-Gage and target S60 3.1 FP1 declarations. The target inserts two `DrawBitmapMasked` overloads before DrawText, shifting the later declarations by two slots.

| Game byte offset | Old declaration slot | N-Gage method | Target declaration slot | Target method at unchanged old slot |
|---:|---:|---|---:|---|
| `+0x48` | 16 | SetPenColor(const TRgb&) | 16 | SetPenColor(const TRgb&) |
| `+0xB8` | 44 | Clear() | 46 | DrawText(const TDesC&, const TPoint&) |
| `+0xC0` | 46 | CopyRect(const TPoint&, const TRect&) | 48 | Clear() |
| `+0xD8` | 52 | BitBltMasked(TPoint, CWsBitmap, TRect, CWsBitmap, TBool) | 54 | BitBlt(TPoint, CWsBitmap) |
| `+0xDC` | 53 | MapColors(TRect, TRgb*, ...) | 55 | BitBlt(TPoint, CWsBitmap, TRect) |

The +0x48 call remains compatible. The other four calls would dispatch to unrelated target methods if the old game received the raw target CWindowGc pointer.

## 4. Direct evidence from call sites

- `sub_10021b98` and `sub_10028260` call offsets +0x48 and +0xB8.
- `sub_1002256c` calls offset +0xD8.
- `sub_10022898` calls offsets +0xC0 and +0xDC.

The callsite argument-register setup is not fully resolved yet. The method identities above come from the corrected vtable prefix calculation plus the old/target CWindowGc declaration order. Exact r1-r3/stack argument provenance remains a separate tracing task before writing forwarding thunks.

## 5. Required graphics-context bridge

The CCoeControl proxy from Step65 is not sufficient by itself. The old game's SystemGc import must return an adapter object with an N-Gage-order vtable, not the raw target S60 CWindowGc pointer.

Leading implementation:

1. The target-native CCoeControl proxy owns/obtains the real target S60 CWindowGc pointer.
2. The old CONE 226 wrapper resolves the original game control to its target proxy.
3. It returns a per-control legacy-GC shim whose primary vtable reproduces the old N-Gage CWindowGc order, including the two-word prefix expected by the old game.
4. Shim slots forward by semantic method name to the real target CWindowGc object. The currently proven map is 16→16, 44→46, 46→48, 52→54 and 53→55.
5. Continue scanning all game code paths that can receive a CWindowGc pointer before declaring the shim's required slot set complete.

The shim should be an ABI adapter, not a fake graphics implementation. It must preserve real target clipping, font selection, drawing and window-server behavior by forwarding to the actual S60 CWindowGc.

## 6. Reproducibility and limits

- GDI comparison tool: `tools/step66_gdi_virtual_abi_compare.py`.
- Target CCoeControl export tool: `tools/step67_target_coecontrol_export_map.py`.
- Step66 runtime SDK workflow: `42572524845`, completed successfully; its assertions validate the corrected byte-offset-to-slot mapping.
- Step66/67 artifact: `s60-3.1-fp1-runtime-import-probe`, ID `13654020873`.
- Artifact SHA-256: `63ae14ae299efd236bf21967f50e36c055ca506017d092b36f5ec99b7d9056b9`.
- Step60 caller extraction run: `42571320167`, completed successfully.
- Step60 artifact: `step60-appui-object-field-audit`, ID `13653695469`.
- Step60 artifact SHA-256: `8a8df5fdcbd804cf3b6c862292d66d23de69e59b34538f28e3e9b4e50f838065`.
- Target evidence is from the pinned S60 3.1 FP1 SDK, not a physical N95 ROM dump.

No shim implementation has been committed. No HLE behavior was changed and no N95 launch is claimed.

## Next actions

1. Trace exact r1-r3 and stack argument setup for the five old CWindowGc slots.
2. Search for indirect uses of the GC pointer beyond the four direct SystemGc callers.
3. Implement a host-side table-driven slot mapping test, then the native Symbian shim.
4. Integrate the shim with the target-native CCoeControl proxy and verify lifecycle/ownership.
5. Keep target SDK-vs-ROM export validation and EKA2 E32Image generation as separate release gates.
