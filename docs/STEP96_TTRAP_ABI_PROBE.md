# Step96 — target TInt64 / TTrap ABI probe

Date: 2026-11-10

## Evidence from Step95

The successful workflow run 42807746277 scanned 1,720 S60 3.1 FP1 SDK header files. The report found:

- no direct `class TInt64` or `struct TInt64` declaration;
- 204 `TInt64` references;
- the internal `TTrap` declaration in `e32cmn.h`;
- 6 TRAP-family macro definitions.

The target header declares:

- `TInt TTrap::Trap(TInt& aResult)` as an instance method;
- `static void TTrap::UnTrap()`;
- `TInt iState[16]`;
- `TTrap* iNext`;
- `TInt* iResult`;
- `TTrapHandler* iHandler`.

The public `TRAP` macro constructs a stack-local `TTrap`, calls `Trap`, executes the protected statements only when `Trap` returns zero, then calls `UnTrap`. This is evidence about the expected call sequence, not enough to emulate Symbian leave semantics.

## Step96 compile-time probe

`tools/step96_ttrap_abi_probe.cpp` is compiled with the pinned target GCCE toolchain and SDK headers. It asserts:

- `sizeof(TInt64) == 8`;
- `sizeof(TTrap) == 76`;
- `TTrap` member offsets: `iState=0`, `iNext=64`, `iResult=68`, `iHandler=72`;
- `Trap(TInt&)` is an instance method and `UnTrap()` is static.

The workflow also records the target object symbol table. These checks intentionally do not provide a shim and do not claim runtime compatibility.

## Important unresolved issue

The ARM UREL import `EUSER!1575` demangles to `TInt64::operator!=(TInt64 const&) const`. Its caller at `0x1002290C` passes two object pointers in `r0/r1` and tests the boolean result in `r0`. The current N95 mapping reports `NO_TARGET_SIGNATURE`; do not redirect it to a guessed ordinal.

The header scan alone does not settle why the legacy import is represented as a member operator when the target SDK does not expose a matching named export. Next inspect the target compiler's exact `TInt64` definition and GCCE-generated object code, then decide whether a local shim and an E32 import-table patch are viable.

## Hardware-test boundary

The user now reports that a phone is available. The project target remains Nokia N95 8GB RM-320 / Symbian OS 9.2 / S60 3rd FP1. No device test has yet been performed. Before a first installation attempt, confirm the handset's `*#0000#` firmware string and prepare a reversible test package; do not flash firmware or replace ROM DLLs. The Step90 host EXE is only a build-format proof and is not a runnable Shadowkey port.
