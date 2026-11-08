# Step 57 — ARMv6 object closure audit

Date: 2026-11-08

## Input artifact

Downloaded the actual GitHub Actions artifact from run `42485190637`:

- Artifact: `shadowkey-armv6-eka2-objects`
- Artifact ID: `13619008431`
- Archive size: 5,261,996 bytes
- SHA-256: `f6cfbc9be2a5cf75f67e0dd5b8d0eb5c9861da77a1e57b18b683ff0dd7e5556d`
- 14 ELF object files; total object payload: 19,996,400 bytes.

All 14 objects were independently inspected with `readelf`:
- ELF32, little-endian, ARM;
- EABI version 5;
- `Tag_CPU_arch: v6`;
- ARM1136JF-S CPU attribute;
- no mixed-architecture object was found.

## Relocatable link experiment

Combined all 14 objects with:

```sh
ld.lld -r -m armelf_linux_eabi -o combined-relocatable.o build/shadowkey-armv6/*.o
```

Result:
- successful relocatable link;
- output: ELF32 ARM EABI5;
- flags: `0x5000200` — Version5 EABI, soft-float ABI;
- combined file size: 19,901,832 bytes;
- no unresolved `sub_XXXXXXXX` game function symbols remain after combining the objects.

This closes an important gap: the recovered game-function object set is internally link-closed at the symbol level. The previous per-object undefined-symbol lists were misleading because each generated function references many functions implemented in the other translation unit; combining all objects resolves those references.

## Remaining undefined symbols

The combined object has 10 undefined symbols, but their ELF binding matters:

- **7 strong undefined symbols** remain as actual link requirements.
- **3 weak undefined symbols** are optional instrumentation hooks. Their source callsites check the weak function pointer before calling it, so the references can resolve to null when the hooks are omitted.

| Symbol | ELF binding | Classification | Next treatment |
|---|---|---|---|
| `__stderr` | GLOBAL | C/OpenC runtime | Verify availability and ABI in the exact S60 3.1 FP1 SDK |
| `exit` | GLOBAL | C/OpenC runtime | Verify target availability; native fatal-error policy still needed |
| `fprintf` | GLOBAL | C/OpenC runtime | Verify target availability; diagnostics may need Symbian-native logging |
| `memmove` | GLOBAL | C runtime | Verify target import or provide a tested local implementation |
| `memset` | GLOBAL | C runtime | Verify target import or provide a tested local implementation |
| `strcmp` | GLOBAL | C runtime | Verify target import or provide a tested local implementation |
| `strncmp` | GLOBAL | C runtime | Verify target import or provide a tested local implementation |
| `ngage_runtime_guest_function_enter` | WEAK | Project instrumentation hook | Optional; callsite checks pointer before invocation |
| `ngage_runtime_guest_function_exit` | WEAK | Project instrumentation hook | Optional; callsite checks pointer before invocation |
| `ngage_runtime_watch_bitmap_range` | WEAK | Project instrumentation hook | Optional; callsite checks pointer before invocation |

The three weak instrumentation references are not hard link blockers. The seven GLOBAL C runtime references are the actual remaining undefined-symbol set in this combined object. This still does **not** mean that all Symbian imports are implemented: the dispatch/HLE layer contains many explicit fail-closed imports, and the UI constructor gate at EIKCORE 224 remains unresolved.

## Reproducible audit tool

Added `tools/step57_arm_object_link_audit.py`. It:
1. checks every object is ELF32 ARM EABI5 with ARMv6 attributes;
2. performs a relocatable ARM link using `ld.lld -r`;
3. parses the combined symbol table;
4. separates missing recovered game functions from project instrumentation and C runtime imports;
5. writes a JSON report and exits nonzero if any `sub_XXXXXXXX` game function remains unresolved.

Example:

```sh
python3 tools/step57_arm_object_link_audit.py /path/to/extracted-artifact \
  --output build/shadowkey-armv6-combined-rel.o \
  --json build/shadowkey-armv6-link-audit.json
```

The tool was run successfully against the downloaded artifact using local LLD 17.0.0 and GNU readelf. The resulting combined object was inspected separately with `readelf -h` and `readelf -sW`.

## Validation boundary

This was a relocatable ELF link, not a final EKA2 executable link. The local LLD 17.0.0 experiment validates symbol closure and ARM object compatibility; it does not substitute for the pinned SDK's native linker/E32 converter. No E32 image, Symbian process launch, emulator launch, or physical N95 launch was produced by this step.

## Next work

1. Map the seven C runtime symbols against the S60 3.1 FP1 SDK import libraries and confirm exact DLL/ordinal/ABI data.
2. Identify all callsites and compile-time guards for the three `ngage_runtime_*` hooks; design a native diagnostics boundary without fake no-op behavior.
3. Use the pinned EKA2 SDK toolchain to link the combined game objects with explicit import libraries and fail-closed unresolved-import checks.
4. Keep EIKCORE 224 blocked until the original N-Gage ARM EIKCORE binary or equivalent verified constructor/vtable evidence is supplied.

## Import-thunk inventory recovered from the object symbols

The same audit was extended to compare the undefined import thunk references in `shadowkey_function_registry.o` against definitions in `shadowkey_lifted_v6.o`:

- 414 unique imported ordinal thunks are referenced by the function registry.
- All 414 have corresponding definitions in the lifted object.
- No missing import thunk wrapper was found.
- The import surface spans 19 DLL identities:

| DLL | Ordinals |
|---|---:|
| APPARC | 4 |
| AVKON | 20 |
| BITGDI | 5 |
| CONE | 43 |
| EFSRV | 19 |
| EIKCORE | 60 |
| ESOCK | 7 |
| ESTLIB | 29 |
| ETEL | 16 |
| EUSER | 101 |
| EZLIB | 1 |
| FBSCLI | 6 |
| GAMECOMMS | 27 |
| GDI | 3 |
| HAL | 1 |
| MEDIACLIENTAUDIOSTREAM | 1 |
| MSGS | 3 |
| SIMKIN | 64 |
| WS32 | 4 |

This proves that the import *wrapper functions* are present in the recovered lifted object. It does not prove that the 414 imported OS/game APIs have compatible target-side implementations. Their HLE/native dispatch coverage remains a separate audit.
