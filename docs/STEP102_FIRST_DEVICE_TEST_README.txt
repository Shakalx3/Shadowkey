Shadowkey Step102 — first-device DLL loader probe
=================================================

Purpose
-------
This is a small, reversible EKA2 loader test for the Nokia N95 target. It does
NOT contain Shadowkey game code and does NOT patch 6R51.APP.

Files
-----
- ShadowkeyCompat.dll
  - UID1: 0x10000079 (DLL)
  - UID2: 0x1000008D (shared-library UID)
  - UID3/SID: 0xE000BEEF
  - One export: ordinal 1, a two-word TInt64 inequality function.
- ShadowkeyAbiProbe.exe
  - UID1: 0x1000007A (EXE)
  - UID2: 0x100039CE
  - UID3/SID: 0xE000BEF0
  - Loads ShadowkeyCompat.dll with RLibrary::Load, resolves ordinal 1 with
    RLibrary::Lookup, then checks equal, low-word-different and high-word-
    different operands.

Install prerequisites
---------------------
The target is Symbian OS 9.2 / S60 3rd Edition FP1. On Symbian OS 9 and later,
executable binaries must reside in \sys\bin. The operating system refuses to
load executables or DLLs from ordinary folders.

Only use a writable drive's \sys\bin if you already have an authorized way to
write there. Do not try to bypass access controls. If the file manager reports
access denied, STOP and report that result; do not modify ROM or firmware.

Before copying, check that these exact filenames do not already exist:
- ShadowkeyCompat.dll
- ShadowkeyAbiProbe.exe

If either filename already exists, do not overwrite it. Stop and report the
collision.

Test
----
1. Copy both files to the same writable drive's \sys\bin directory.
2. Launch ShadowkeyAbiProbe.exe with an existing trusted file manager/launcher.
3. Watch for the system information message:
   - "SK DLL PASS" — the EKA2 loader accepted the DLL, ordinal 1 was resolved,
     and all three comparison checks passed.
   - "SK DLL LOAD FAIL" — the DLL could not be loaded.
   - "SK DLL LOOKUP FAIL" — the DLL loaded, but ordinal 1 was not resolved.
   - "SK DLL CALL FAIL" — the function was called but returned wrong results.

The EXE also returns a Symbian error code. This test does not launch Shadowkey,
does not validate graphics/audio/input, and does not establish that the legacy
6R51.APP can run on EKA2.

Rollback
--------
Close the test process, then delete only these two files from the same
writable drive's \sys\bin:
- ShadowkeyCompat.dll
- ShadowkeyAbiProbe.exe

No ROM file, firmware image, Nokia system DLL, original game file, registry
setting or persistent configuration is changed by this test. Do not flash the
phone and do not replace any ROM DLL.
