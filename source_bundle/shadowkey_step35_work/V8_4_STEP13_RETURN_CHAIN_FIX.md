# Shadowkey v8.4 — step13: remove false BX tail-return and advance trace

## Input and scope

Started from the uploaded step11 bundle plus the step12 forensic-audit snapshot. The previous heuristic in `arm_fallback.c` converted *any* out-of-range ARM `BX` target into a synthetic return to the fallback's saved `return_addr`. That was unsafe: an invalid target of zero was treated as permission to jump to a stack address.

## Root cause confirmed in lifted helpers

Two lifted helper bodies had a specific ARM epilogue:

- `sub_1000df3c`: saves caller LR on stack; reuses architectural LR as an output pointer (`r2`); restores the saved continuation into `r12`; ends with `BX r12`.
- `sub_1006c730`: saves caller LR; deliberately writes zero into LR while initializing object fields; restores saved continuation into `r12`; ends with `BX r12`.

The old lifted C translated the final `BX r12` as `ngage_call(c, c->r[12]); return;`. This incorrectly launched the restored continuation as a *second guest function call*. The original lifted caller already resumes at the instruction after `ngage_call`, so the continuation ran twice. In the `sub_1000df3c` path, that re-entry occurred while LR was still the stack-output pointer, ultimately creating the bogus fallback entry with `return_lr=0x102fdc68`.

Correction: in these two helper bodies, model the final `BX r12` as a C `return`. The caller's lifted C code resumes naturally after the helper call, while the architectural register side effects (including LR being repurposed) remain intact.

## Fallback safety correction

Removed the permissive behavior that rewrote an out-of-range `BX` into a synthetic return. A real return is accepted only when the branch target matches the fallback invocation's saved return PC. Any other out-of-range target is reported as `ARM fallback INVALID BX` and is not silently redirected to a stack address.

## Reproduced result after correction

Commands:

- `sh build_and_test.sh` — PASS.
- `sh trace_asset_loader_vfs.sh` — PASS, diagnostic exit code 0.
- `sh build_arm11_core.sh` — PASS; ARM EABI5 relocatable core built.
- `sh build_arm11_linkcheck.sh` — PASS; static ARM ELF links with no undefined symbols. The E32Main entry is deliberately a no-op test stub, not a runnable game.

New trace observations:

- Reads of `StringTable.eng` (338,078 bytes), `global.spr` (37,956 bytes), `entities.txt` (22,064 bytes), and `menu_sprites.txt` (252 bytes) complete.
- `global.spr` decode still leaves 6,909 non-zero bytes in the 82,016-byte RGB444 (12-bit values in 16-bit storage) bitmap buffer.
- BITGDI bitmap device/context and diagnostic CFont model are reached.
- CONE ordinal 160 is reached at three call sites in this run.
- No `ARM fallback BX out-of-range`, no `ARM fallback INVALID BX`, and no OOB at `0x102FDC68` remain in the new trace.
- The harness then reports `ENGINE RUNL forced-zero returned ...`. This is the deliberately controlled RunL test path, not proof that the full application launched.

## New frontier / remaining work

The next work is not another return-address heuristic. It is the platform/HLE dependency chain reached during UI setup. The trace still shows unimplemented calls including EUSER ordinals 1431, 1575 and 21, as well as other EUSER/ESTLIB/GDI calls. Their semantics must be recovered from callsites and matching Symbian FP1 ABI evidence before implementing them. CONE ordinal 160 remains unresolved by exact export-table name; no guessed behavior was added.

## Limitations

This is a host-side lifted-code diagnostic trace using HLE models. It is not a complete Symbian kernel/window-server implementation, not a complete game launch, and not a physical Nokia N95 test.
