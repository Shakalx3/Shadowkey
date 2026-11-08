# Step 51 — Next live-trace blocker: EIKCORE ordinal 222

Date: 2026-11-08

## Observed stop

The Step45 live VFS trace now advances beyond the earlier EUSER 1582
allocation request. Its current deliberate fail-closed stop is:

`EIKCORE[10004892].DLL ordinal=222`
- guest receiver: `r0 = 0x10110000`
- return address: `lr = 0x10028438`
- IAT slot: `0x1010057C`
- import thunk: `0x1009FA00`

The game import registry maps that thunk and slot to EIKCORE UID 10004892,
ordinal 222. Step46's ARM UREL archive-index report maps this ordinal to
`__15CEikApplication`, i.e. the `CEikApplication` constructor.

## SDK declaration evidence

The original N-Gage SDK header
`6.1/Series60/Epoc32/Include/eikapp.h` declares
`CEikApplication : public CApaApplication` and exposes a protected imported
default constructor `CEikApplication()`.

The base declaration in
`6.1/Series60/Epoc32/Include/apparc.h` is
`CApaApplication : public CBase`. It owns additional state including
`CApaDll* iApaDll` and `TInt iSpare`. The derived class declares members
`iCoeEnv`, `iResourceFileOffset`, `iProcess`, `iCaption`,
`iCapabilityBuf`, `iAppFlags`, and `iSpare`.

This confirms the semantic identity and inheritance chain, but header
declarations do not provide the constructor's executable initialization
sequence or the exact vtable address to install in the guest object.

## Why no HLE constructor is added yet

The receiver is a 556-byte allocation in the current trace. It is likely a
concrete game application object whose constructor is invoking the imported
`CEikApplication` base constructor. A correct base-constructor model must
respect the ARM EABI object/vtable setup and all state initialized by the
N-Gage EIKCORE implementation. Zero-filling the object or writing a guessed
vtable would be a diagnostic bypass, not a faithful constructor.

The public SDK repository includes the ARM UREL import library
`6.1/Series60/Epoc32/Release/armi/urel/eikcore.lib`, but the corresponding
ARM UREL `eikcore.dll` body is not present in that SDK tree. The SDK does
contain WINS DLLs, which are not interchangeable with the ARM target binary.

## Next verification route

1. Inspect the lifted callsite around the BL whose return address is
   `0x10028438`, including the constructor's caller and object allocation.
2. Determine whether the game's own derived constructor immediately writes
   its vtable after the imported base constructor returns.
3. If the body remains necessary, obtain the matching N-Gage ROM's ARM
   `eikcore.dll` (or a ROM dump from the user's N-Gage QD) and disassemble
   ordinal 222's implementation. Do not substitute the WINS DLL.
4. Compare the resulting object writes against the declared
   `CEikApplication`/ `CApaApplication` member layout before implementing
   the HLE.

## Validation status

- ARM UREL ordinal 222 identity: mapped to `CEikApplication()`.
- Header declaration and base-class chain: verified from original N-Gage SDK.
- Exact constructor body / vtable initialization: unresolved.
- Live trace: advances to this import and stops with exit code 95 by design.
- Real N-Gage or N95 hardware launch: not demonstrated.
