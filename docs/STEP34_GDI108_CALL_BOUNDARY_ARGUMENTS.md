# Step 34 — GDI108 call-boundary argument proof

Date: 2026-11-06

## Scope

This pass follows both direct callers of `sub_10023608` and its stack frame to resolve the fifth GDI108 callsite's second argument. It does not identify GDI ordinal 108 or assign a meaning to that parameter.

## Caller evidence

The two direct callers are:

- `0x1006B730`, return address `0x1006B734`;
- `0x1006B7D4`, return address `0x1006B7D8`.

Both prepare the same outgoing stack words:

| Caller stack offset | Value | Callee use |
|---:|---:|---|
| `sp+0x14` | `r5 = 0` | loaded into `r6` |
| `sp+0x18` | `r8 = 1` | loaded into `r5` |

The callee pushes eight registers (0x20 bytes) and allocates 0x6ac bytes. Its loads from current `sp+0x6e0` and `sp+0x6e4` resolve to entry `sp+0x14` and `sp+0x18`. Therefore both paths enter with `r6=0`, `r5=1`.

## GDI call consequences

1. `r5==1` takes the conditional GDI ordinal-101 call at `0x100236A8`, with `r1=1`.
2. `r6==0` selects the `r1=r10` path for GDI ordinal 108.
3. `r10` is initialized to zero at `0x10023628`.
4. The `r10 += 13` increments occur at `0x100237D8`, after the GDI108 call at `0x100236D4`.

Thus GDI108 receives `r1=0` on both direct caller paths. The later increments are downstream parser/decoder work, not GDI108 arguments.

## Verification and remaining unknowns

- `shadowkey_step34_gdi108_arg_audit.py` — PASS in the original archive.
- Complete direct-caller set, outgoing stack writes, callee frame arithmetic, byte-load aliases, branch choice, and ordering were checked.
- GDI ordinals 101/108 still lack exact S60 3rd FP1 export-name/signature proof.
- The 72-byte `TFontSpec` and 56-byte typeface candidate still need N95 OS 9.2 confirmation.
- Real FBS font provider and glyph rasterizer remain outstanding.

Next: obtain the exact FP1 GDI export table or `Z:\sys\bin\GDI.DLL` from the handset.
