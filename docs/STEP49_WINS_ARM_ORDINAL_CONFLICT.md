# Step 49 — WINS UDEB versus ARM game ordinal conflict

Date: 2026-11-08

## Executive finding

The Step 47/48 conclusion that EUSER ordinal 1407 in the ARM game is
`TDblQueBase::SetOffset(TInt)` was too strong. The symbol name is present in
the original N-Gage SDK's **WINS UDEB** short-import records, but the game's
ARM callsites contain evidence incompatible with blindly applying that
signature.

The game import registry maps thunk `0x1009F0F0`, IAT `0x101007A4`, to
EUSER UID `100039E5`, ordinal 1407. In the lifted ARM callsite report,
callers load the address of the UTF-16 literal `0x100AC718` (the text
`Swiss`) into r1, place a stack temporary in r0, and call that thunk. The
same pattern occurs at multiple callsites, including return addresses
`0x10022B80`, `0x10022DAC`, `0x10023230`, and `0x1002366C`.

The earlier Step 42 diagnostic log also records a format-specific
EUSER1407 experiment, including the line
`HLE EUSER1407 Format literal-only: TBuf16<6> length=5 text=Swiss`.
That log is evidence of the old diagnostic harness's interpretation and
output, not proof of the native Symbian export name. It must be kept distinct
from a real OS implementation.

A normal `TDblQueBase::SetOffset(TInt)` call expects an integer in r1.
Passing a pointer to a UTF-16 format literal is inconsistent with that
signature. Therefore the WINS UDEB mapping cannot currently be used as the
ARM game's API identity without resolving the ARM UREL import member.

## Most likely explanation, not yet proven

The game is an ARM binary. The WINS UDEB import library and ARM UREL import
library are separate platform/configuration artifacts. Their ordinal/name
associations may differ. This is exactly why the ARM UREL member-level
cross-check is required.

The Step 44 report confirms that ARM UREL libraries existed in the earlier
SDK working environment and were scanned with `strings`, but the report did
not correlate each symbol string to its `dsNNNNN.o` archive member. The
host `nm` could not decode those proprietary ARM import objects. A global
strings list is not enough to assign a symbol to a particular ordinal.

## Corrective source change

The active bootstrap route:

`EUSER 1407 -> shadowkey_hle_euser1407_setoffset()`

has been disabled. The SetOffset helper remains in the header only as a
WINS-UDEB reference implementation and is explicitly marked unverified for
the ARM game. This avoids writing an arbitrary r1 value to receiver+8 when
the actual ARM import identity is unresolved.

The CONE 160 helper also remains an isolated reference helper. Its presence
does not mean the import dispatcher currently routes that ordinal to it.

## What remains valid

- The game import registry's DLL UID, ordinal, thunk, and IAT slot are
  verified from the committed generated registry.
- WINS UDEB short-import records contain the six names listed in Step 47.
- The static ARM callsite evidence for EUSER 1407 is preserved in Step 39.
- The historical diagnostic output is preserved in Step 42.
- None of these facts alone resolves the ARM UREL ordinal identity.

## Required next operation: member-level ARM UREL mapping

For each relevant ARM library:
- `euser.lib`
- `cone.lib`
- `gdi.lib`

inspect archive members named `dsNNNNN.o` individually. At minimum inspect
`ds01407.o`, `ds01575.o`, `ds00160.o`, and the GDI members corresponding
to ordinals 101, 108, and 151. Extract each member with `ar p`; run
`strings -a` and an ARM-aware object/symbol inspection tool if available.
Do not use `nm` failure as evidence that a member contains no symbols.

The existing `tools/step46_arm_importlib_ordinal_map.py` is intended to do
this member-level extraction. It must be run against the actual SDK tree
`6.1/Series60/Epoc32/Release/armi/urel`. The expected SDK root is
configurable through `SHADOWKEY_ARM_SDK_ROOT`.

## Status

- WINS UDEB name mapping: verified for that library/configuration only.
- ARM game's EUSER 1407 identity: unresolved; WINS mapping conflicts with
  callsite register use.
- Active EUSER 1407 SetOffset HLE: disabled to prevent unverified writes.
- ARM UREL member-level cross-check: pending.
- N95 OS 9.2 / S60 FP1 ordinal mapping: pending separately.
- Real-device launch: not demonstrated.
