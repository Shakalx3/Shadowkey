# Shadowkey v8.4 step34 — GDI108 call-boundary argument proof for `sub_10023608`

Date: 2026-11-06

## Scope

Step33 correctly left the fifth GDI108 callsite's `r1` source unresolved in semantic terms. This pass follows the two direct callers of `sub_10023608` and the callee's stack frame to determine the actual value reaching the call. It does **not** identify GDI ordinal 108 or assign a meaning to its second parameter.

## Direct callers and outgoing stack arguments

The recovered lifted image has exactly two direct calls to `sub_10023608`:

- `0x1006B730`, return address `0x1006B734`;
- `0x1006B7D4`, return address `0x1006B7D8`.

Both caller paths prepare the same outgoing stack words immediately before the call:

| Caller stack offset | Value prepared | Callee use |
|---:|---:|---|
| `sp+0x14` | `r5`, explicitly set to `0` | callee `LDRB` into `r6` |
| `sp+0x18` | `r8`, explicitly set to `1` | callee `LDRB` into `r5` |

The callee prologue pushes eight registers (`0x20` bytes) and allocates `0x6ac` bytes (`0x6a0 + 0x0c`). Its current stack pointer is therefore `entrySP - 0x6cc`. The loads from current `sp+0x6e0` and `sp+0x6e4` resolve exactly to `entrySP+0x14` and `entrySP+0x18`. As a result, both direct call paths deterministically enter the callee with:

- `r6 = 0`;
- `r5 = 1`.

## Consequence for the GDI calls

The path through `sub_10023608` now has a concrete branch resolution:

1. `r5 == 1` makes the conditional call at `0x100236A8` execute. This is GDI ordinal 101, with `r0` pointing at the style-subobject candidate and `r1=1`.
2. `r6 == 0` selects the `r1 = r10` branch at `0x100236D0` for GDI ordinal 108.
3. `r10` was initialized to zero at `0x10023628` and is not incremented until `0x100237D8`, after the GDI108 call at `0x100236D4`.
4. Therefore GDI108 receives `r1=0` on both direct caller paths. The later `r10 += 13` operations belong to the subsequent parser/decoder loop and are not inputs to GDI108.

This corrects the potentially misleading step33 shorthand that described `r10` as a value which “starts at 0, then accumulates +13”. The accumulation is real, but temporally downstream of this GDI call.

## Verification

- `python3 shadowkey_step34_gdi108_arg_audit.py` — PASS.
- The audit verifies the complete set of direct callers, outgoing stack writes, callee frame arithmetic, byte-load aliases, branch selection, and ordering of the `+13` increments relative to GDI108.

## What remains unknown

- GDI ordinal 108's actual FP1 export name, signature, and meaning of `r1=0` remain unverified.
- GDI ordinal 101's export name and the semantics of its `r0`/`r1` pair remain unverified. The current host diagnostic's generic handling must not be mistaken for target behavior.
- The 72-byte `TFontSpec` layout and 56-byte inline typeface candidate still need confirmation against N95 RM-320 / Symbian OS 9.2, not merely the OS 9.3 cross-reference.
- The actual FBS font provider, CFont implementation, and glyph rasterizer remain outstanding.

## Next investigation

Prioritize the two related imports at this same style-subobject address: GDI ordinals 101 and 108. Search the exact S60 3rd Edition FP1 SDK import library / DEF data or the N95 `Z:\\sys\\bin\\GDI.DLL` export table. Keep the current HLE path explicitly experimental until those identities and argument contracts are established.
