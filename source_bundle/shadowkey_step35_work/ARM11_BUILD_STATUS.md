# ARM11 cross-compilation milestone — 2026-10-29

## What is now concrete

- The recovered Shadowkey code and relocated SIMKIN code compile with Clang for `arm-none-eabi`, CPU `arm1136jf-s` (ARM11-class target used by the Nokia N95).
- The main lifted game object is approximately 5.3 MiB; the lifted SIMKIN object is approximately 1.1 MiB.
- The dispatcher, function registries, HLE bootstrap, ARM fallback, and a reusable guest-memory/flags runtime also compile for the same ARM target.
- `arm11_objects/shadowkey_arm11_core.o` is a combined 32-bit ARM EABI relocatable object. Its remaining external references are only basic C runtime functions (`exit`, `fprintf`, `stderr`, `strcmp`, `strncmp`) and compiler memory helpers (`__aeabi_memclr`, `__aeabi_memmove`, `__aeabi_memset`). The guest-runtime symbols are resolved inside the combined object.
- The original host-side smoke test still passes.

## What this is not

This is **not yet an executable for the N95**. The file is ELF relocatable object code, not Symbian's E32Image format. It has no Symbian process entry point, no finished native file/UI/audio/graphics backend, and it is not linked against the phone's OS libraries. The probe headers under `arm11_probe_headers/` are declaration-only headers used to verify target compilation without a Symbian SDK; they are not runtime implementations.

## Next technical gates

1. Provide a real Symbian OS 9.2/S60 3rd Edition FP1 GCCE build environment or an E32Image conversion/linker toolchain.
2. Replace or bind the remaining C runtime functions to implementations available on the N95; add an E32 executable entry point and process/thread setup.
3. Implement file-backed Symbian filesystem calls and load the actual game assets. The first observed resources are `Z:\system\apps\6R51\StringTable.eng` and `E:\system\apps\6R51\global.spr`.
4. Replace provisional HLE stubs for Symbian GUI, bitmap/font, audio, active-scheduler, and file APIs before expecting the game to reach a playable state.

The ARM compilation milestone proves that the recovered game logic can be translated into ARM object code; it does not yet prove that the OS can load or run it.

## Recheck — 2026-11-06 (step33)

`bash build_arm11_core.sh` was rerun against the current source tree. All ARM11 objects were up to date and the combined output remains an ELF 32-bit ARM EABI5 relocatable object. This is a regression confirmation only; it does not change the native-port status or satisfy the E32/SIS gates above. The command log is preserved at `diagnostics/step33/arm11_build.log`.
