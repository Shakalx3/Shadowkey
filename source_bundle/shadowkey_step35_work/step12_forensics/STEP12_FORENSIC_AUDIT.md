# Shadowkey v8.4 — step12 forensic audit (from uploaded step11)

## Scope and honesty note
Input was `shadowkey_recomp_bundle_v8_4_step11_eikcore243_decoder_breakthrough.zip`.
This archive does NOT contain the step12 fix previously claimed in the conversation. Its own trace reproduces the old failure. No claim of a successful fix or physical N95 launch is made here.

## CONE ordinal 160: recovered ABI and likely role
Import thunk `0x1009f510` loads IAT slot `0x1010040c`, which resolves to `CONE[10003a41].DLL` ordinal 160.

Four static call sites are present:
- `0x10021400` in `sub_10021244`: `r0=sp+0x0c`, `r1=r7`.
- `0x10021d8c` in `sub_10021b98`: `r0=sp+0x430`, `r1=r7`.
- `0x10022ad4` in `sub_10022898`: `r0=sp+0x3c`, `r1=r8`.
- `0x100282a8` in `sub_10028260`: `r0=sp+0x204`, `r1=r6`.

The first argument is consistently a caller-owned stack temporary, and the second is consistently a control-like object. This is the ARM C++ ABI shape of a non-trivial aggregate returned by value through a hidden result pointer, with `this` shifted into r1. It is therefore not a conventional two-argument mutator.

The strongest candidate is a `CCoeControl` geometry getter returning a value object (`TRect`/`TSize` family). `TRect`/rectangle geometry is favored by the later use at the third call site, where the result is passed as an argument to a graphics/control virtual slot. However, the exact C++ symbol and exact structure type cannot be proven from the game call sites alone. The exact FP1 export table (or the matching N95 ROM's CONE export directory / SDK import library) is required to name ordinal 160 conclusively. No guessed HLE behavior was added.

## Return/callback audit
A source scan found several functions that temporarily reuse LR:
- `sub_1000df3c` saves LR, uses LR as an output pointer (`r2`), restores the saved continuation into r12, then branches through r12. This is a nonstandard epilogue from the lifted-C dispatcher perspective; the memory write through LR is not a return target.
- `sub_1001a610`, `sub_1004ad40`, and `sub_10092d88` also reuse LR as scratch, but save/restore it with normal stack frames before returning via LR. These are not equivalent failure cases.
- `sub_1006c730` writes LR=0 during object initialization, then restores the saved return word into r12 and branches through r12. In ARM terms this is an ordinary `pop {r12}; bx r12` return idiom after a compiler register-allocation choice. A lifted dispatcher must treat the final branch as a return, not as an independent guest callback.

## Reproduced current barrier
Running `sh trace_asset_loader_vfs.sh` on the uploaded step11 archive yields:
- VFS successfully opens `StringTable.eng`, `global.spr`, `entities.txt`, and `menu_sprites.txt`.
- `global.spr` remains decoded into a persistent non-zero RGB444 (12-bit values in 16-bit storage) bitmap buffer.
- The trace still stops with:
  `ARM fallback BX out-of-range at pc=100322a4 target=00000000; treat as tail-return to 102fdc68`
  followed by
  `OOB 00000004/4 pc=102fdc68 lr=1003229c ...`
- The heuristic in `arm_fallback.c` treats any out-of-range BX target as a tail return. In this trace, the branch target is zero; that is not sufficient evidence that the intended return target is the stack address `0x102fdc68`. This heuristic masks the actual control-flow error and should be instrumented/fixed before attributing the fault to CONE ordinal 160.

## Tests
`sh build_and_test.sh` passes the existing application-construction, FBS chunk, EFSRV size, and static callsite audits. The test output still records CONE ordinal 160 as unimplemented. `sh trace_asset_loader_vfs.sh` reproduces the frontier above. These are host diagnostic tests, not a full game launch.
