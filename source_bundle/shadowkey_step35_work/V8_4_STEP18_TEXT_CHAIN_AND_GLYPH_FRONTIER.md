# Shadowkey v8.4 — step18: text-chain data-flow refinement

## Scope and status

This is a static reverse-engineering checkpoint based on the lifted ARM source. It does not claim a native Symbian build or a physical N95 launch. No speculative import handlers were added.

## 1. GDI text preparation: corrected pipeline

Five call sites were compared: `sub_10022b20`, `sub_10022d48`, `sub_10022f88`, `sub_100231b4`, and `sub_10023608`.

At each site the broad sequence contains GDI ordinal 151 followed by GDI ordinal 108. The first site (`0x10022b20`) exposes an additional conditional GDI ordinal 101 call between them.

At the first site:

- A local record at `SP+0x1c` is initialized through a constructor-like internal call.
- A 20-byte copy is made from that record into `SP+0x26c`.
- GDI 151 receives `r0=SP+0x22c`, `r1=SP+0x26c`, `r2=0xD5`.
- The destination span `[SP+0x22c, SP+0x268)` is exactly 60 bytes and is subsequently passed to a virtual method on the object stored at engine offset `+0x2e8`.
- If the branch condition based on the byte at `SP+0x2cc` is nonzero, GDI 101 receives `r0=SP+0x268`, `r1=r5`.
- GDI 108 then receives `r0=SP+0x268`, and `r1` is selected from `r5` or zero depending on the other byte condition.

Thus the earlier shorthand “GDI 151 -> GDI 108” omitted a real optional stage. GDI 101 is conditional, not universally executed. GDI 108's work/result slot at `SP+0x268` is distinct from the 60-byte output span of GDI 151.

The explicit character argument `0xD5` is observed at all five sites in the lifted source. It is one code value, not evidence that this call renders a complete string.

## 2. What is now established versus unknown

Established from caller code:

- 20-byte input record is copied before GDI 151.
- GDI 151 writes/prepares data into a 60-byte caller-owned span.
- GDI 101 is an optional middle stage at the first inspected call site.
- GDI 108 uses a separate four-byte-addressed work slot at `SP+0x268`.
- The 60-byte span is consumed by a subsequent virtual call on the object at `engine+0x2e8`.

Not established:

- Exact exported C++ names for GDI ordinals 151, 101, and 108.
- Field meanings in the 20-byte and 60-byte records.
- Whether the 60-byte object is a glyph image, glyph metrics, cache node, or a compound descriptor.
- Whether the same conditional GDI 101 branch is semantically identical at all five sites.

## 3. EUSER 1575 / 1557 relation

The only EUSER 1575 call remains in `sub_10022898`. It takes an 8-byte caller-owned work pair seeded from `object+0x320` and a pointer to `object+0x310`. The caller checks the integer return immediately; only the nonzero branch commits the output pair back to `object+0x310`.

On the success path, EUSER 1557 is called with three pointers: `SP+0x2c`, `SP+0x34`, and `object+0x310`. The surrounding code maintains a nine-entry pointer table at `object+0x330`, a count byte at `object+0x358`, and adjacent state fields. This supports a stateful descriptor/cache/list interpretation, but does not prove the API identity. No HLE was added.

## 4. CONE 160 / graphics context

CONE 160's hidden-result ABI remains confirmed at four call sites. At two sites the returned pair is passed by pointer to a virtual slot at byte offset `+0xB8` on the `SystemGc()` object. The SDK examples confirm that Symbian graphics contexts use `TPoint` for coordinate operations and `TSize` for extents, but public examples do not establish the ordinal vtable slot. Therefore the `Position()` hypothesis remains unconfirmed; do not implement it as fact.

## 5. Regression

`shadowkey_step18_text_chain_audit.py` checks all five GDI sites, the 20-byte preparation, the explicit `0xD5` argument, the 60-byte output span, the conditional GDI 101 call, and the EUSER 1575 -> 1557 success path.

## Next frontier

1. Recover the concrete object type at `engine+0x2e8` and map its virtual slot `+0x44`.
2. Determine whether the 60-byte GDI 151 output is a glyph record or an intermediate font/cache structure by tracking its first writes and every read.
3. Trace the optional GDI 101 branch conditions to the originating object flags.
4. Resolve EUSER 1575 and 1557 as a connected API using exact S60 3rd FP1 import/export metadata.
5. Map the `SystemGc` vtable slot `+0xB8` before assigning CONE 160 a method name.
