# Shadowkey v8.4 — Step 23: HAL memory gate and unforced DrawText reachability

## Executive result

The previous discrepancy between the forced-zero VFS probe and the live constructor path is now explained. The constructor calls `HAL::Get` for attribute `16` (`HALData::EMemoryRAMFree`) and compares the returned free-RAM value against `0x0068AFFF` (6,860,799 bytes, about 6.54 MiB).

- If free RAM is greater than `0x0068AFFF`, the constructor writes `0` to `engine+0x34`.
- Otherwise, it follows the low-memory branch and writes `1` to `engine+0x34`.

The host HLE previously left the output argument untouched (zero-filled guest memory). That made the constructor falsely take the low-memory branch, which is why the unmodified live harness did not enter the text initialization path. The old forced test manually set `engine+0x34` to zero and therefore hid the missing HAL behavior.

A call-site-based `HAL::Get(TAttribute, TInt&)` HLE was added for HAL DLL ordinal 1. Attribute 16 is handled as `EMemoryRAMFree`; the diagnostic free-RAM value is configurable via `SHADOWKEY_HLE_FREE_RAM_BYTES`, defaulting to 32 MiB. This is a host test model, not a measurement of the user's N95.

With the 32 MiB model, the unmodified constructor initializes `engine+0x34` to zero and a single direct `RunL` call reaches the actual guest `DrawText` and `DiscardFont` call sites. No write to `engine+0x34` is injected by the live harness.

## Reproduction

Run the high-memory diagnostic path:

```sh
SHADOWKEY_HLE_FREE_RAM_BYTES=33554432 ./trace_asset_loader_live_vfs.sh
```

Expected: `HAL::Get EMemoryRAMFree=33554432`, constructor state `engine+0x34=0`, and `DrawText`/`DiscardFont` in the trace.

Run the low-memory branch:

```sh
SHADOWKEY_HLE_FREE_RAM_BYTES=4194304 ./trace_asset_loader_live_vfs.sh
```

Expected: `HAL::Get EMemoryRAMFree=4194304`, constructor state `engine+0x34=1`, and no `DrawText` call in this single-RunL probe.

The old `trace_asset_loader_vfs.sh` remains a forced-zero diagnostic probe and is explicitly labelled as such in its regression output. It must not be treated as the natural constructor path.

## DrawText argument and memory findings

The DrawText HLE now has a separately testable ABI decoder. It reads:

- `r0`: graphics context
- `r1`: descriptor pointer
- `r2`: rectangle pointer (16 bytes)
- `r3`: baseline
- `[sp]`: alignment
- `[sp+4]`: margin

A standalone unit test constructs a known 16-bit `TBuf` and `TRect`, verifies all register/stack fields, calls the diagnostic virtual handler, and verifies that the pixel sentinel is unchanged. It passes.

The live game call-site dump reveals two unresolved import effects:

1. The descriptor begins with header `0x30000000`, followed by maximum length `0x100`. In Symbian descriptor layout, the top nibble `3` identifies a stack-based modifiable buffer (`TBuf`); the low 28-bit length is zero. The buffer has capacity 256 UTF-16 characters but currently contains no valid text according to its length field. Bytes that look like text after the header are not evidence of valid descriptor content while the length is zero. EUSER ordinal 248 is unimplemented at this call site and is a prime next target for understanding how the text buffer is populated.
2. The rectangle passed to DrawText is not valid yet. EUSER ordinal 711 is called with the output address immediately before DrawText, but the current HLE leaves that output area unchanged. The resulting words (`0`, `0x100FFE70`, `0`, `0x102FED48`) are stale guest-stack values, not screen coordinates. Ordinal 711 must be identified/implemented before rasterization.

Therefore reaching DrawText is now confirmed, but actual text drawing is not. The current handler remains diagnostic-only and does not rasterize glyphs or modify pixels.

## EUSER 1575

The live path also reaches EUSER ordinal 1575. It is still unimplemented. Its observed call has:

- `r0 = SP + 0x34` (8-byte output area)
- `r1 = object + 0x310`
- `r2 = [engine+0x30] = 0x10111288` (the pointer stored in the engine field at +0x30)
- `r3 = object + 0x320`

The caller's status check and pair copy remain as previously audited. No semantics are fabricated in this step.

## Tests

- `build_and_test.sh`: PASS
- step17/18/19/20/21 static audits: PASS
- `shadowkey_step23_drawtext_abi_test.sh`: PASS
- high-RAM live-path audit (32 MiB): PASS; reaches DrawText and DiscardFont without forced `engine+0x34` write
- low-RAM branch audit (4 MiB): PASS; takes the alternate constructor branch and does not reach DrawText in the one-call probe
- `build_arm11_core.sh`: PASS; ARM EABI5 relocatable core
- `build_arm11_linkcheck.sh`: PASS; static ARM EABI5 linkcheck has no undefined symbols

## Limitations

- The live test still calls the recovered `RunL` directly from the host harness; it does not instantiate a real Symbian `CActiveScheduler` or model every asynchronous completion.
- The 32 MiB free-RAM value is a configurable diagnostic model, not an N95 measurement.
- EUSER 248, EUSER 711, EUSER 1575, GDI 151 and GDI 108 remain incompletely mapped.
- DrawText has not rasterized a glyph; no screen output has been verified.
- `elf2e32`, `petran`, `makesis`, `abld`, `bldmake`, and `sbs` are absent from this environment. The ARM ELF linkcheck is not an E32Image and is not installable on the N95.
- No physical N95 launch has been attempted or verified.
