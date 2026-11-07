# Shadowkey v8.4 — step 4: FBSCLI ordinal 17 call-chain analysis

Date: 2026-11-02

## Fresh reproduction

From a clean extraction of `shadowkey_recomp_bundle_v8_4_step3_source_forensics.zip`:

- `./build_and_test.sh` — PASS.
- `./trace_asset_loader_vfs.sh` — diagnostic run reached the expected bounds-checked stop (`OOB 00000080/4`, exit 90); wrapper returned 0.
- `python3 shadowkey_gc_trace_regression.py .build/asset_vfs_trace.log` — PASS.
- `./build_arm11_core.sh` — PASS.
- `./build_arm11_linkcheck.sh` — PASS; statically linked ARM EABI5 linkcheck ELF, no unresolved symbols.

Fresh trace is `.build/asset_vfs_trace.log`, generated in this run. It is distinct from the archived historical trace.

## Confirmed call-chain facts

1. In `sub_10023ad0`, the engine object at `r7` obtains `r0 = *(r7 + 0x2E4)` and calls import thunk `0x1009FD40` at `0x10023B28`.
2. Import registry maps thunk `0x1009FD40` to `FBSCLI[10003a15].DLL` ordinal 17, IAT slot `0x10100808`.
3. The fresh trace records the call as:
   `r0=0x10110718, r1=0x1017FB00, r2=1, r3=0, lr=0x10023B2C`.
   Immediately afterwards, the caller stores returned `r0` into `*(engine_child + 0x480)`.
4. The same object `0x10110718` was allocated as a 24-byte object at `0x1000B9E0`; earlier calls on it include FBSCLI ordinal 135 and ordinal 16. This sequence is consistent with a bitmap-like object and a filename/descriptor operation, but the exact names/signatures of ordinals 135, 16 and 17 are NOT established by an FP1 SDK export table.
5. The HLE dispatcher has no implementation for FBSCLI ordinal 17. It logs `UNIMPLEMENTED ... ordinal 17` and sets `r0=0`. The caller therefore stores zero in the child object's `+0x480` field.
6. Later, before `sub_1000EA00`, caller `0x10023F3C–0x10023F48` loads `r1 = *(parent + 0x300)` and copies it to `r2`. In this trace that value is zero. The child constructor stores these two arguments at child offsets `+0x47C` and `+0x480`.
7. The explicit diagnostic override in lifted code replaces both actual zero arguments with `0x101D0000`. That changes the guest object's state and is not a faithful implementation of the original call path. It remains diagnostic-only and must not be mistaken for platform behaviour.
8. The later faulting field is distinct: `source + 0x14A3C` (absolute `0x10125C44` in this run). It is read by `sub_1001F9AC` and is still zero. No evidence yet proves FBSCLI ordinal 17 is the producer of this field; the direct proven consequence of the missing ordinal implementation is the zero stored at child `+0x480` and passed as constructor arguments.

## Interpretation / confidence

- **Proven:** FBSCLI ordinal 17 is unimplemented in the harness; its zero return propagates through engine `+0x300`, then into child constructor args `r1/r2` and child fields `+0x47C/+0x480`.
- **Strong lead, not proven:** given the call shape `(object, descriptor, 1)` and the earlier bitmap-like object setup, ordinal 17 may be a bitmap load/open operation. Do not label it `CFbsBitmap::Load` or implement it until checked against the exact S60 3rd Edition FP1 `fbscli` export table or ROM export data.
- **Not proven:** a causal link from ordinal 17 to `source+0x14A3C`.

## Source changes

No runtime/source implementation was changed in this step. Only this forensic report was added. In particular, no fake pointer was installed and no FBSCLI ordinal was assigned a guessed symbol.

## Next step

Obtain the exact S60 3rd Edition FP1 `fbscli` import/export definition (or N95 ROM EAT) and resolve ordinals 135, 16 and 17. Then trace the object at `0x10110718` through those calls and inspect the subsequent object graph around `engine + 0x300`, `child + 0x47C/+0x480`, and the constructor consumer at `source+0x14A3C`. Separately audit `sub_1001F9AC`'s source descriptor contract and its sole call site in `sub_100298A4`.

## Device status

No native E32Image was produced and no execution on a physical Nokia N95 has been performed.
