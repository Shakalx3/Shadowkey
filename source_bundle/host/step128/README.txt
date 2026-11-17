Step128 — original 6R51.APP loader acceptance probe

The SIS installs the original, unmodified 6R51.APP image under the temporary
name ShadowkeyLegacyProbe.dll and starts a separate EKA2 test application.

The probe calls RLibrary::Load() and Lookup(1), then closes the library.
It does NOT call the game's factory export, execute game code, or modify ROM.

Display:
- Green field + white cross: the N95 loader accepted the legacy E32 DLL and
  resolved export 1. This does not prove the imported APIs have compatible
  semantics or that the game can initialize.
- Red field + 32-bit white/black grid: the library load or export lookup failed.
  The grid encodes the signed Symbian error code in two's-complement form,
  most-significant bit first, four rows by eight columns. Send a photo to decode.

The probe is deliberately isolated from the Step105 TInt64 test.
