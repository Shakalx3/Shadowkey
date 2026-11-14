Step103 — EKA2 Legacy runtime loader probe

This is a diagnostic application for Nokia N95 / S60 3rd Edition FP1.
It is not the Shadowkey game port.

The menu application uses the Symbian EKA2 application startup and the
Legacy EKA2 runtime profile. It does not use AVKON, EIKCORE, or GUI controls.
On launch it loads ShadowkeyCompat.dll through RLibrary, resolves ordinal 1,
and runs three two-word comparison checks.

Expected system information message:
  SK DLL PASS

Other messages:
  SK DLL LOAD FAIL
  SK DLL LOOKUP FAIL
  SK DLL CALL FAIL

The SIS package is built separately with the S60 3.1 FP1 SDK makesis tools.
It installs only the test EXE, the test DLL, and its app registration resource
under the test UIDs E000BEF0 and E000BEEF.
