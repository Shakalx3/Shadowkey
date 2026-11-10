# Step90 — EKA2 host executable prototype

Date: 2026-11-10

## Objective

Build a minimal EKA2 EXE with the pinned S60 3.1 FP1 ARMv5 SDK and the GCCE 2005Q1C EABI4 toolchain. The host loads the legacy `6R51.APP` application DLL, looks up its ordinal-1 application factory, and passes that factory to the public `EikStart::RunApplication` API.

This is a loader/entry-point prototype. It is not a successful load of `6R51.APP`, and it is not a device test.

## Verified progress — run 42805916801

- GCCE 2005Q1C compiles the host source.
- Direct linking against the target EUSER, APPARC, and EIKCORE DSOs now succeeds.
- The resulting host ELF has ARM EABI4 and explicit `DT_NEEDED` entries for:
  - `euser{000a0000}.dso`
  - `APPARC{000a0000}.dso`
  - `eikcore{000a0000}.dso`
- Its undefined imports include the expected target APIs: `CTrapCleanup::New`, `RLibrary::Load/Lookup/Close`, `TPtrC16` construction, `TApaApplicationFactory`, `EikStart::RunApplication`, and `User::Leave`.
- The earlier `TTrap::Trap/UnTrap` link failure came from the GCCE `TRAP` macro. The host entry point now avoids those private symbols and calls the non-leaving `TInt EikStart::RunApplication(...)` API directly.

## Current conversion blocker

The first `elf2e32` conversion now gets past undefined-symbol resolution but reports:

```
E1034: DSO .../APPARC{000a0000}.dso not found
```

The SDK file is stored as `apparc.dso`, while its ELF SONAME is `APPARC{000a0000}.dso`. The build script now creates temporary SONAME aliases in the extracted SDK directory before invoking `elf2e32`. The next workflow run must confirm conversion and validate the resulting E32 header and import table.

## Boundaries

- A successful EKA2 host E32 conversion will validate the host toolchain and E32 packaging path only.
- It will not prove that the EKA1-era `6R51.APP` DLL is accepted by the N95 EKA2 loader, that its patched dependencies are complete, or that the game reaches its application startup.
- No N95 hardware is currently available for runtime testing.
- Raw ROM modules and firmware binaries remain excluded from Git history and compact artifacts.
