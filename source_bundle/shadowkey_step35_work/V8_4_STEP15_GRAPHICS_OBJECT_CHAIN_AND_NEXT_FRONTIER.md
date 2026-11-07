# Shadowkey v8.4 — step15: graphics object chain and next frontier

## Input and scope

Started from `shadowkey_recomp_bundle_v8_4_step14_euser1431_live_runl.zip`.
This step continues the host-side lifted-code/HLE diagnostic path. It is not a full Symbian runtime and not a physical N95 launch.

## 1. Corrected the previous diagnosis of `engine+0x2EC`

Instrumentation at entry to `sub_100231b4` records:

```text
TRACE sub_100231b4 entry obj=101102c8
  +2e4=10110718 +2e8=10110730 +2ec=10110770
TRACE sub_100231b4 text-gc obj=101102c8
  +2ec=10110770 +2ec.vt=10226100
```

Therefore `+0x2EC` is not null or uninitialized in this trace. It is the graphics-context object created by the BITGDI ordinal-23 `CreateContext` HLE path. The three object fields are:

- `+0x2E4`: bitmap handle `0x10110718`;
- `+0x2E8`: bitmap device `0x10110730`;
- `+0x2EC`: graphics context `0x10110770`.

The `+0x2EC` chain was previously misidentified as the next blocker. This step explicitly corrects that claim.

## 2. Recovered the immediate graphics virtual-call chain

`sub_100231b4` calls the context vtable at:

- `+0xA8` at guest callsites `0x100234F0` and `0x1002358C`, with descriptor/point-like arguments;
- `+0x28` at guest callsite `0x100235D4`, with only the receiver.

The diagnostic context vtable now contains explicit trampolines for those observed slots. Their exact SDK method names are intentionally unresolved; the HLE records arguments and does not claim to render text.

The previous null virtual call at `0x100235D4` is now handled by the slot `+0x28` diagnostic trampoline.

## 3. Separated a bitmap/font callback from the pixel-buffer pointer

The next call at `0x100235F4` loads a target from `[bitmap+0x20]` and invokes it with:

```text
r0=10110734  ; address of device->bitmap field
r1=1027c6f0  ; diagnostic CFont object
r2=0000000d  ; character/code argument
r3=10110718  ; bitmap handle
```

The earlier HLE device model had placed the pixel pointer at `device+8`. Because `bitmap` and `device` happened to be adjacent in the host allocator, `[bitmap+0x20]` aliased that pixel pointer (`0x10311000`) and the emulator tried to execute pixel data as code.

The HLE layout is now corrected for the observed call contract:

- `device+8` contains a dedicated diagnostic callback trampoline;
- `device+12` contains the pixel-buffer address in the diagnostic object layout;
- the callback logs its arguments and returns without pretending to rasterize glyphs.

New trace:

```text
GFX HLE: bitmap/font callback diagnostic
  receiver=10110734 font=1027c6f0 char=13 bitmap=10110718
```

The erroneous `unimplemented 10311000` is gone. This does not yet prove the native callback's exact semantic name or reproduce glyph rasterization.

## 4. Remaining imports and next investigation target

The current forced graphics/resource path now reaches the later CONE/EUSER sequence without the former bitmap-as-code failure. Unresolved imports still include:

- EUSER ordinal 1575 at `0x1002290C` (single static callsite in `sub_10022898`);
- CONE ordinal 160 at `0x10022AD4` in this path;
- EUSER ordinal 21 after graphics-context deactivation;
- EUSER 248 and 711 in text/descriptor processing;
- GDI ordinals 151 and 108 in the preceding text-layout path.

For EUSER 1575, the observed call contract at its sole static callsite is `r0=SP+0x34` (an 8-byte output/work structure) and `r1=object+0x310`. The caller tests the returned `r0` as a success/failure value. This is not enough to assign an exact export name; no guessed implementation was added.

CONE ordinal 160 remains unresolved by exact export name. The earlier static audit of its four callsites and the stack-return investigation remain in the earlier reports.

## 5. Tests

- `build_and_test.sh` — PASS.
- `trace_asset_loader_vfs.sh` — PASS, including the expanded frontier regression.
- `build_arm11_core.sh` — PASS; ARM EABI5 relocatable core produced.
- `build_arm11_linkcheck.sh` — PASS; static ARM ELF has no undefined symbols. `E32Main` remains a deliberate no-op linkcheck stub.

The trace still uses the diagnostic forced-zero resource branch. It is not a natural full application launch. The separate live-RunL probe remains a scheduler approximation.

## 6. Exact frontier

The immediate null target from the graphics context is gone. The trace now records the bitmap/font callback and proceeds to the later imports. The next useful work is to identify EUSER ordinal 1575 from the callsite and the correct CONE 160 semantics, then return to the still-unimplemented native text rasterization rather than adding more generic no-op stubs.
