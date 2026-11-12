# Step110 — strict ROFx integration command correction

Date: 2026-11-12

## Baseline

The default branch was audited at commit `320a4403ace06aa1a91126ad0435fb2ccd7c72a6`. Step96 and Step100 remain complete and independently documented in [Step96](STEP96_TTRAP_ABI_PROBE.md), [Step101](STEP101_TINT64_TARGET_TYPE_AND_STEP99_FIX.md), and [Step102](STEP102_TINT64_DLL_LOADER_PROBE.md):

- Target GCCE compile-time checks passed: `sizeof(TInt64)==8`; `sizeof(TTrap)==76`; offsets `iState/iNext/iResult/iHandler = 0/64/68/72`.
- Target `TInt64` is a signed 64-bit built-in type, not the legacy N-Gage class.
- The target `e32def.h` documents that from Symbian OS 8.1b the old class member functions are no longer exported from EUSER.LIB. Therefore N-Gage ARM UREL EUSER ordinal 1575 (`TInt64::operator!=(TInt64 const&) const`) has no matching target export. The same-numbered N95 ordinal is a different API and is not a valid substitute.
- The isolated two-word ARM shim and Step102 E32 loader-probe executable have only compile/structure evidence; neither has been run by a Symbian loader or on an N95.

## Firmware workflow failure diagnosis

Firmware workflow run [43208955054](https://github.com/Shakalx3/Shadowkey/actions/runs/43208955054) reached and passed:

- FPSX unpacking and SOS partition carving;
- Step106 Symbian-layout metadata audit for C0R ROFS and PPM ROFx;
- Step108 bounded local-extent extraction.

The Step106 log reported 275 directories / 1,441 entries in C0R SOS+ROFS and 315 directories / 5,909 entries in PPM SOS+ROFx. Step108's previous successful baseline reported 1,441 C0R local files and 4,468 PPM local files, with 1,441 PPM external references.

The Step109 synthetic resolver tests passed 2/2. However, the production merge did **not** execute: the YAML run block contained two backslashes before each newline in the multi-line Python command. Bash treated the escaped pair as a literal backslash argument; argparse then failed with `unrecognized arguments: \\`. The synthetic self-test output must not be mistaken for a firmware merge result.

The later Step90 host-build diagnostic also failed because its expected Step82 GCCE toolchain directory had not been created after Step109 stopped the job. This is a downstream skipped-prerequisite consequence, not an independent compiler failure.

## Correction

The workflow now invokes the Step109 production resolver as one shell command line, avoiding continuation escaping. The next firmware run must be inspected to verify the actual C0R/PPM merge and exact-reference resolution. A green self-test alone is insufficient.

## Safety and limits

- The historical run 42604419519 failed earlier at link time because `-lunix++` was not found; later workflow revisions corrected the library path. It is superseded by the later extraction runs.
- Source firmware images remain read-only.
- No firmware image or protected system DLL is committed.
- E32 candidate recognition is only an inventory filter; export tables still require validated E32 parsing.
- No physical-device execution or Shadowkey launch is claimed.
