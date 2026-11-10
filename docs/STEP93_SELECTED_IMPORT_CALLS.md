# Step93 — selected 6R51.APP import callers and thunk ABI

Date: 2026-11-10

Source: `STEP93_SELECTED_IMPORT_CALLS.txt` from firmware audit run 42806506334. The report scans the complete 6R51.APP code segment in ARM and forced-Thumb modes, then disassembles each selected import thunk and every direct branch found to it.

## Verified direct ARM call counts

| Import | ARM direct calls to thunk |
|---|---:|
| EUSER 1407 — TPtrC16 constructor | 10 |
| EUSER 1575 — TInt64::operator!= | 1 |
| CONE 160 — CCoeControl::Rect() const | 4 |
| EIKCORE 224 — CEikAppUi constructor | 1 |
| GDI 101 — TFontStyle::SetPosture | 5 |
| GDI 108 — TFontStyle::SetStrokeWeight | 5 |
| GDI 151 — TFontSpec constructor | 5 |

No direct branches to these thunks were found in the forced-Thumb scan. The import thunks themselves are ARM three-instruction stubs:

```asm
ldr ip, [pc, #4]   ; address of IAT slot literal
ldr ip, [ip]       ; resolve imported function pointer
bx  ip
.word IAT_slot
```

This confirms the relevant calls are ordinary direct ARM BL calls through the E32 import stubs, rather than guessed call sites inferred only from ordinal tables.

## EUSER 1575 caller

- Import thunk: `0x1009F240`
- IAT slot: `0x101007E8`
- IAT literal: file offset `0x9F2C8`, runtime VA `0x1009F24C`
- Direct caller: `0x1002290C`

The caller sequence is:

```asm
0x10022900  mov r0, sl
0x10022904  add r5, r8, #0x310
0x10022908  mov r1, r5
0x1002290C  bl  0x1009F240
0x10022910  cmp r0, #0
0x10022914  beq ...
```

The call uses `r0` as the left-hand object pointer and `r1` as the right-hand object pointer; the returned `r0` is tested as a boolean. This is consistent with the ARM UREL import symbol `TInt64::operator!=(TInt64 const&) const`. It establishes the caller-side register contract, but does not yet prove the exact `TInt64` field layout or justify a binary shim without checking the SDK class definition and related `TInt64` operators.

## EUSER 1407 caller

The first inspected caller at `0x1000D418` sets `r0` to a stack-allocated destination object and `r1` to a pointer loaded from a UTF-16 literal, then calls thunk `0x1009F0F0`. This matches the ARM UREL symbol `TPtrC16(const TUint16*)` and supports the already verified remap to N95 EUSER ordinal 1169.

## Remaining boundary

The call-site scan is not a runtime test. It does not prove that the remapped function's side effects, object layout, or exception/leave behavior match on the N95. The next ABI work should inspect the SDK `TInt64` declaration and the callers of its constructor, comparison, arithmetic and conversion imports as one group. The separate unresolved `TTrap::Trap/UnTrap` imports also need their own leave/trap compatibility analysis.
