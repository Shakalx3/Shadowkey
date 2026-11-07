# Step 35 — structural old-E32 patch test

Date: 2026-11-07

## Reproduction result

Ran `bash ./shadowkey_step35_e32_patch_test.sh` from the supplied step35 archive.

<badge>PASS</badge> The test validated:

- E32 header and table offsets after insertion;
- eight bytes of ARM stub insertion at the end of the old text section;
- direct ARM branch redirection from the selected import veneer;
- relocation-backed IAT pointer adjustment;
- import block parsing after the rewrite;
- recalculated additive code checksum for the patched output.

Key measured values:

| Field | Value |
|---|---:|
| Input image | `6R51.APP` |
| Input SHA-256 | `3c3376945f6798a17bd4972f17a3f5c8ba1b9515386acc1c86f9ab1f9e07e98e` |
| Temporary output SHA-256 | `4457b9e47ba54eece2e167581dda874545ca57c6df233cb79cb1f2035d7a84ba` |
| Image base | `0x10000000` |
| Original text size | `0x100340` |
| Injected stub VA | `0x10100340` |
| Original code size | `0x1009C4` |
| Patched code size | `0x1009CC` |
| Relocation blocks / entries | 168 / 10,104 |
| IAT-target relocations shifted | 415 |
| Import DLL blocks / ordinals | 20 / 415 |
| Patched thunk VA | `0x100A00B0` |
| Branch target VA | `0x10100340` |
| ARM branch opcode | `0xEA0180A2` |

The test reports that 413 import veneers remain pattern-recognized because the selected GDI veneer becomes a direct branch while its ordinal remains in the import table.

## Checksum caveat

The original image stores `0x67F7151E` at header offset `0x18`, while the additive sum over its declared code segment is `0x6387532B`. The test recalculates the patched image checksum, but the unexplained baseline mismatch remains open. Compare against a fresh original extraction before producing any user-facing patch.

## Strict limitation

This test proves only that the supplied **legacy E32 image can be structurally rewritten**. The injected stub is a no-op probe, not a GDI implementation. The test does not prove that the old App-DLL image can load on Symbian OS 9.2/EKA2, and it does not create an N95-ready executable.

The correct N95 target remains a newly linked EKA2 ARM E32 EXE and, if required, EKA2-compatible support DLLs. No physical-device launch has been performed.
