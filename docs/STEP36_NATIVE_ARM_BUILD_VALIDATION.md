# Step 36 — native ARM build validation

Date: 2026-11-07

## Results from the supplied archive

The following checks were run from the one-time temporary extraction of the supplied step35 archive:

| Check | Result | Meaning |
|---|---|---|
| `shadowkey_step35_e32_patch_test.sh` | PASS | Old-E32 structural rewrite only |
| `build_and_test.sh` | PASS | Existing host-side harness assertions pass |
| `build_arm11_core.sh` | PASS | Produces an ARM11/EABI5 relocatable object |
| `build_arm11_linkcheck.sh` | Initially fails | It invokes `./build_arm11_core.sh`, but the archive's file mode is not executable |
| Linkcheck after temporary `chmod +x build_arm11_core.sh` | PASS | Produces a statically linked ARM ELF with no undefined symbols |

## ELF inspection

`file` and `readelf -h` report:

- Core: ELF32, little-endian, ARM, EABI5, type REL (relocatable), no program entry point.
- Linkcheck: ELF32, little-endian, ARM, EABI5, type EXEC, statically linked, entry point `0x5371fc`.
- Linkcheck ELF flags: `0x5000200`, soft-float ABI.
- Linkcheck output explicitly reports: `E32Main is deliberately a no-op stub`.

The linkcheck output is still a Linux/System-V ARM ELF executable. It is not a Symbian E32Image, has no N95 platform import bindings, and does not launch the game. The only change made for the successful linkcheck was a temporary executable-bit correction in the validation extraction; the supplied archive was not modified.

## Remaining harness gaps visible in the passing test

The passing `build_and_test.sh` emits UNIMPLEMENTED import diagnostics, including calls from AVKON, EIKCORE, CONE, EUSER, ETEL, MSGS and HAL. The test suite's PASS result means its explicit assertions pass; it does not mean all imported OS services are implemented. The current FBS/GDI path includes synthetic diagnostic objects and a DrawText recorder without glyph rasterization.

## Immediate build-system fix

When these scripts are brought into a writable source branch, change the linkcheck script to invoke the core build as `sh ./build_arm11_core.sh` (or preserve executable mode 100755 in Git). This is a packaging/permission defect, not a compiler failure.

## Next gate

Use the EKA2 ARMv6 SDK candidate in [Step 36 toolchain audit](STEP36_EKA2_TOOLCHAIN_AUDIT.md) to replace the Linux/System-V linkcheck with a genuine EKA2 E32 EXE. Inspect its import table and startup metadata before attempting to link the lifted engine.
