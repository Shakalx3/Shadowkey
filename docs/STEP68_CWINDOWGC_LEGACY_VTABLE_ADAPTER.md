# Step 68 — original Draw path requires an old-order CWindowGc adapter

Date: 2026-11-09

## 1. The game has four direct SystemGc call sites

A scan of the full lifted ARM source found four calls through the old N-Gage CONE 226 import (`CCoeControl::SystemGc()`):

| Game function | SystemGc caller | Subsequent CWindowGc vtable byte offsets |
|---|---|---|
| `sub_10021b98` | game control Draw helper | `+0x48`, `+0xB8` |
| `sub_1002256c` | game UI/render helper | `+0xD8` |
| `sub_10022898` | game UI/render helper | `+0xC0`, `+0xDC` |
| `sub_10028260` | game control Draw override | `+0x48`, `+0xB8` |

The four direct call sites are listed in the Step60 artifact JSON as `systemgc_callsites`. The four functions are extracted by `tools/step60_appui_object_field_audit.py`.

The target S60 3.1 export for `CCoeControl::SystemGc() const` is CONE ordinal **287**, not old N-Gage ordinal 226 (Step67).

## 2. CWindowGc vtable order differs between the SDKs

Step66 parsed the old N-Gage and target S60 3.1 FP1 class declarations:

| Class | N-Gage virtual declarations | Target virtual declarations |
|---|---:|---:|
| CGraphicsContext | 42 | 51 |
| CBitmapContext | 8 | 13 |
| CWindowGc | 59 | 71 |

The target CWindowGc inserts two virtual `DrawBitmapMasked` overloads before the old DrawText methods. This shifts the subsequent methods by two slots. It also adds later virtual methods including SetOpaque, fading, alpha blending and WS graphics operations.

Important slot positions (zero-based from the first declared CWindowGc virtual, including its virtual destructor):

| Old slot | N-Gage method | Target slot for same method | Target method at unchanged old slot |
|---:|---|---:|---|
| 18 | SetPenSize | 18 | SetPenSize |
| 46 | CopyRect | 48 | Clear |
| 48 | BitBlt(TPoint, CFbsBitmap*, TRect) | 50 | CopyRect |
| 54 | DrawTextVertical(TDesC, TPoint, TBool) | 56 | BitBltMasked(TPoint, CWsBitmap*, ...) |
| 55 | DrawTextVertical(TDesC, TRect, ...) | 57 | MapColors |

The slot 18 check is a useful control: it remains identical. The other four old slots used by the game are incompatible.

## 3. Direct evidence from game call sites

The lifted functions show these exact offsets:

- `sub_10021b98`: loads a function pointer from the SystemGc vtable at +72 bytes (slot 18) and +184 bytes (slot 46), then calls both.
- `sub_1002256c`: loads and calls the SystemGc vtable entry at +216 bytes (slot 54).
- `sub_10022898`: loads and calls entries at +192 bytes (slot 48) and +220 bytes (slot 55).
- `sub_10028260`: loads and calls entries at +72 bytes (slot 18) and +184 bytes (slot 46).

Therefore, if the old CONE 226 wrapper simply returns the target S60 CWindowGc pointer, the game will dispatch:
- old CopyRect call → target Clear;
- old BitBlt-with-source-rect call → target CopyRect;
- old DrawTextVertical(point) call → target BitBltMasked(CWsBitmap);
- old DrawTextVertical(rect) call → target MapColors.

These are not equivalent signatures. This is a concrete virtual-dispatch incompatibility, not just a difference in exported ordinals.

## 4. Required graphics-context bridge

The CCoeControl proxy from Step65 is not sufficient by itself. The old game's SystemGc import must return an adapter object with an N-Gage-order vtable, not the raw target CWindowGc pointer.

Leading implementation:

1. The target-native CCoeControl proxy owns/obtains the real target S60 CWindowGc pointer.
2. The old CONE 226 wrapper resolves the original game control to its target proxy.
3. It returns a per-control legacy-GC shim whose primary vtable reproduces the old N-Gage CWindowGc order.
4. Shim slots forward by semantic method name to the real target CWindowGc object. For the currently proven slots: 18→18, 46→48, 48→50, 54→56, 55→57.
5. Continue scanning all game code paths that can receive a CWindowGc pointer before declaring the shim's required slot set complete.

The shim should be a small ABI adapter, not a fake graphics implementation. It must preserve real target clipping, font selection, drawing and window-server behavior by forwarding to the actual S60 CWindowGc.

## 5. Reproducibility and limits

- GDI comparison tool: `tools/step66_gdi_virtual_abi_compare.py`.
- Target CCoeControl export tool: `tools/step67_target_coecontrol_export_map.py`.
- Runtime SDK workflow run: `42571112130`, completed successfully.
- Artifact: `s60-3.1-fp1-runtime-import-probe`, ID `13653620496`.
- Artifact SHA-256: `3c3ca182e4e942809d85638d2b89c0c65403a34977446704365ea346a5eaf778`.
- Step60 caller extraction run: `42571320167`, completed successfully.
- Step60 artifact: `step60-appui-object-field-audit`, ID `13653695469`.
- Step60 artifact SHA-256: `8a8df5fdcbd804cf3b6c862292d66d23de69e59b34538f28e3e9b4e50f838065`.
- Header hashes are recorded in `step66-gdi-virtual-abi.json` inside the runtime artifact.
- All target evidence is from the pinned S60 3.1 FP1 SDK, not a physical N95 ROM dump.

No shim implementation has been committed yet. No HLE behavior was changed and no N95 launch is claimed.

## Next actions

1. Trace the full argument setup for each of the five old CWindowGc slots and record exact parameter/return ABI.
2. Search for indirect uses of the GC pointer beyond the four direct SystemGc callers.
3. Implement a host-side table-driven slot mapping test first, then the native Symbian shim.
4. Integrate the shim with the target-native CCoeControl proxy and verify lifecycle/ownership.
5. Keep target SDK-vs-ROM export validation and EKA2 E32Image generation as separate release gates.
