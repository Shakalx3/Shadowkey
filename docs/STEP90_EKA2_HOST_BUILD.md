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

The first conversion after the SONAME-alias fix produced a 557-byte E32 EXE with the expected three DLL references and development UIDs. Its E32 entry-point field is `0`; the host ELF entry is `0x10000` and the E32 code base is also `0x10000`, so the field is a code-relative offset and resolves to the correct entry VA.

The first validation script incorrectly treated a zero entry-point offset as invalid. The workflow also marked the build successful merely because the output and header JSON existed, even though that assertion had failed. Both checks have been corrected: the build now verifies `code_base + entry_point_offset == ELF e_entry`, requires the offset to lie inside the code segment, runs `elf2e32 --dump=hi`, and writes an explicit validation marker. The workflow reports success only when that marker exists. Run 42807134440 passed the stricter validation. The resulting 557-byte `6R51Host.exe` is reported by `elf2e32 --dump=hi` as an EKA2 ARMv5 / ARM EABI executable compressed with DEFLATE. Its entry VA is `0x00010000` (E32 code-relative offset `0` plus code base `0x00010000`), and the E32 dump confirms three import DLLs and eight imports:

- APPARC ordinal 171 — `TApaApplicationFactory` constructor
- EIKCORE ordinal 394 — `EikStart::RunApplication`
- EUSER ordinals 196, 1311, 1169, 1308, 1838, 649 — `CTrapCleanup::New`, `RLibrary::Close`, `TPtrC16` constructor, `RLibrary::Load`, `RLibrary::Lookup`, and `User::Leave`

This validates the minimal EKA2 host build and import-table packaging path. It still does not test loading the original `6R51.APP` DLL or running on the phone.

## Boundaries

- A successful EKA2 host E32 conversion will validate the host toolchain and E32 packaging path only.
- It will not prove that the EKA1-era `6R51.APP` DLL is accepted by the N95 EKA2 loader, that its patched dependencies are complete, or that the game reaches its application startup.
- No N95 hardware is currently available for runtime testing.
- Raw ROM modules and firmware binaries remain excluded from Git history and compact artifacts.
