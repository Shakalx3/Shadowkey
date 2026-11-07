> **Superseded by step32:** the GDI108 receiver is not established as a separate 24-byte object. It is at `TFontSpec+0x3C`; the pre-call vtable-looking word was scratch/overlap data. See `V8_4_STEP32_GDI108_TFONTSPEC72.md` for the corrected analysis and write-watch evidence.

# Shadowkey v8.4 step31 — EUSER 1407 descriptor reconstruction

## Scope
This checkpoint resumes the exact v8.4 step30 archive (SHA-256:
`7f471b4ec24b229e04e4553ba4e9da1c585f43bc7ae607a8f52db59502a1fca9`).
It tests the `Swiss` typeface-name producer and records the next unresolved GDI boundary.
No target-phone execution is claimed.

## Findings

### 1. The three repeated font-name callsites agree
The EUSER 1407 callsites at:
- `0x10022B7C` (`sub_10022b20`)
- `0x10022DA8` (`sub_10022d48`)
- `0x10022FE4` (`sub_10022f88`)

have the same caller-side sequence:
- `r1 = 0x100AC718` (UTF-16 literal `Swiss`)
- `r0 = SP+0x1c` (temporary descriptor object)
- EUSER 1407
- EUSER 1282 copies exactly 20 bytes from that temporary object
- GDI 151 receives the 20-byte destination descriptor and height 213 twips.

The adjacent callsites in `sub_100231b4` and `sub_10023608` use the same construction/copy pattern at different stack offsets.

### 2. EUSER 1407's font-path ABI is a formatter, not a raw pointer descriptor constructor
Across the full import callsite inventory, EUSER 1407 is called with format-like strings and variadic values at unrelated sites (including a `%x` format and a Bluetooth error format with `%d` fields). The font path supplies the literal `Swiss`, which has no format substitutions. This is consistent with `TDes16::Format(...)` into a stack `TBuf`, not a TPtrC constructor.

The exact ROM export identity is still not proven against the target N95 FP1 EUSER export table. The behavior is inferred from the callsite family and argument flow.

### 3. Experimental descriptor reconstruction passes the live boundary
An environment-gated experiment writes the candidate `TBuf16<6>` layout at the first live font site:
- word 0: `0x30000005` (modifiable inline descriptor, length 5)
- word 1: `6` (maximum length)
- bytes at +8: UTF-16 `Swiss` followed by NUL.

The 20-byte object is then copied by the already-implemented EUSER 1282 path. The live trace's GDI 151 forensic decoder independently reads:
- descriptor type = 3
- length = 5
- maximum length = 6
- inline data = `Swiss`.

This is a successful structural test of the descriptor candidate. It is not yet a complete proof of EUSER 1407's full formatting semantics for all format specifiers.

### 4. GDI 108 receives a structurally meaningful receiver
At the same live site, GDI 108 receives:
- `r0 = 0x102FED2C`
- `r1 = 0`
- `r2 = 213`
- `r3 = 0xA0`.

The 24-byte receiver prefix is:
`70 fe 0f 10 05 00 00 30 06 00 00 00 53 00 77 00 69 00 73 00 73 00 00 00`.

The first word is `0x100FFE70`; mapping that address into the loaded APP image yields a table of 12 non-null code pointers, all within the image's executable address range. At receiver+4 is the validated `TBuf16<6>` descriptor containing `Swiss`. Thus GDI 108 no longer receives merely stale path bytes in this experimental pass; it receives a valid vtable-like pointer followed by the expected descriptor. The exact GDI 108 API identity and receiver class are not established.

### 5. Experimental GDI 151 constructor now produces a valid 60-byte TFontSpec
A second environment-gated experiment handles GDI ordinal 151 as the observed `TFontSpec(const TDesC&, TInt)` constructor. It reads the validated type-3 input descriptor and writes:
- `iTypeface`: a 44-byte inline constant descriptor (`TBufC<20>` shape), header `length=5`, text `Swiss` at +4;
- `iHeight`: 213 twips at +44;
- `iFontStyle`: three zero-valued default fields at +48..+59 (normal style is still a provisional interpretation).

The subsequent `GetNearestFontInTwips` HLE consumer accepts this exact object and logs `TFontSpec name='Swiss' height=213 twips`; it returns the synthetic host `CFont` model at 14 px in the 96-dpi diagnostic conversion. This closes the previously failing descriptor -> TFontSpec -> font lookup data path in the host trace.

The constructor layout is now strongly supported by the 60-byte caller allocation, the HLE consumer's field offsets, the successful font lookup, and the next caller behavior. It is still an experimental HLE reconstruction, not a ROM-verified implementation of GDI ordinal 151 on S60 3rd FP1.

### 6. GDI 108 remains a separate unresolved import
GDI 108 still has no implementation or confirmed export identity. In the same pass it receives `r0=0x102FED2C`, whose first word is `0x100FFE70` (a table of 12 non-null code pointers inside the APP image) and whose inline descriptor at +4 is the valid `Swiss` TBuf16<6>. This is now a structurally meaningful receiver, but its class/API semantics remain unknown. Do not conflate this with the TFontSpec passed separately to the device's vtable `+0x44` lookup.

## Validation
- `build_and_test.sh`: PASS.
- `trace_asset_loader_live_vfs.sh` with both `SHADOWKEY_EXPERIMENTAL_EUSER1407_FONT_TBUF=1` and `SHADOWKEY_EXPERIMENTAL_GDI151_TFONTSPEC=1`: PASS.
- `GetNearestFontInTwips` accepts `Swiss`, height 213 twips; synthetic CFont model returned at 14 px.
- Live path reaches DrawText with `has paused the game` (19 UTF-16 chars), point `(0,160)`, baseline 83; then reaches the second DrawText candidate with an empty descriptor and point `(0,13)`.
- DiscardFont and the diagnostic bitmap/font callback are reached.
- Glyph rasterization is still absent; no text pixel changes are claimed.
- This is host diagnostic execution only; no physical N95 launch or E32Image/SIS is claimed.

## Next target
Resolve GDI ordinal 108 independently, then replace the environment-gated GDI 151 experiment with a tested normal HLE handler only after confirming its default `TFontStyle` representation. Continue from the now-valid TFontSpec/font-lookup path toward real CFont/glyph rasterization and the remaining startup blockers.
