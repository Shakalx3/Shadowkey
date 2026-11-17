# Step128 — original 6R51.APP E32 loader acceptance probe

Date: 2026-11-17

## Purpose

Step105 confirmed that the N95 can load a project-built EKA2 compatibility DLL and call its ordinal-1 export. Step128 asks the next independent question: can the handset's EKA2 loader accept the original, unmodified N-Gage `6R51.APP` image as a library?

The tracked image was independently identified by the Step123 audit as:

- UID1: `0x10000079` (DLL)
- UID2: `0x100039CE`
- UID3: `0x101FD3F6`
- export count: 1
- code base: `0x10000000`
- code size: 1,051,076 bytes
- flags: `0x01000003`
- source SHA-256: `3c3376945f6798a17bd4972f17a3f5c8ba1b9515386acc1c86f9ab1f9e07e98e`

## Probe behavior

The SIS installs a byte-for-byte copy of the tracked APP under the temporary name `ShadowkeyLegacyProbe.dll`. A separate EKA2 EXE calls:

1. `RLibrary::Load("ShadowkeyLegacyProbe.dll")`
2. `RLibrary::Lookup(1)`
3. `RLibrary::Close()`

It never calls the game's factory export and never writes to the original APP or any ROM/system DLL.

Display:
- Green field + white cross: the loader accepted the original image, resolved its imports sufficiently to load it, and found export 1.
- Red field + a 32-bit white/black grid: load or lookup failed. The grid encodes the signed Symbian error code in two's-complement, most-significant bit first, four rows by eight columns.

A green result would be a major loader-compatibility milestone, but it would not establish that the imported N-Gage APIs have matching target semantics or that the game can initialize. A red result gives a concrete error code for the next loader investigation.

## Build and package

GitHub Actions run [44019087013](https://github.com/Shakalx3/Shadowkey/actions/runs/44019087013) completed successfully. The EKA2 EXE build, E32 identity checks, SIS packaging and release publication all passed.

- Package: [ShadowkeyLegacyLoadProbe.sis](https://github.com/Shakalx3/Shadowkey/releases/download/shadowkey-step128-sis-44019087013/ShadowkeyLegacyLoadProbe.sis)
- Size: 459,316 bytes
- SHA-256: `C1115169DC6705D0926AC2F4D26C54A79CF066AC5E1821D3A54E68D0C2A24B33`

No physical-device result is recorded yet.
