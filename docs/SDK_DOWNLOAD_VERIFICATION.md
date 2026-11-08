# S60 3rd Edition FP1 SDK download verification

Date: 2026-11-08

## Result

The archive linked from the Symbian Archive SDK list was downloaded successfully from MediaFire in GitHub Actions and published as a private-repository Actions artifact.

- Repository: `Shakalx3/Shadowkey`
- Workflow run: https://github.com/Shakalx3/Shadowkey/actions/runs/42481895728
- Artifact: `s60v3.1-sdk-verified`
- Artifact ID: `13617598444`
- Artifact size: 381,275,113 bytes (outer Actions ZIP)
- Artifact expiry: 2026-12-08
- SDK archive filename inside artifact: `s60v3.1_SDK.zip`
- SDK archive size: 381,160,113 bytes
- SDK archive SHA-256: `cd3950edb7b86abff6cd84421bcb1cb3e99ae7b1a63d02a2ce1aa2ed6e11ff24`
- ZIP CRC test: PASS
- Inner archive entries: 11

## Identity check

The downloaded installer metadata identifies the package as:

- Product: `S60_3rd_Edition_SDK_FP1_for_symbian_OS`
- Company: Nokia
- InstallShield engine: 12.0.0.49974
- Installer payload: `data2.cab` (InstallShield Cabinet v4/5)

This is the S60 3rd Edition FP1 SDK package needed for the Nokia N95 / Symbian OS 9.2 target. The download is verified as a structurally valid ZIP; the SDK installer has not yet been installed or its full contents audited.

## Retrieval

Open the workflow run above and download the `s60v3.1-sdk-verified` artifact. GitHub Actions artifact retention is 30 days; download it before expiry if a permanent local copy is needed.

Source page: https://www.mediafire.com/file/9uc7fjb2ynmxlud/s60v3.1_SDK.zip/file


## InstallShield extraction (2026-11-08)

The nested InstallShield cabinets were successfully extracted with `unshield` in GitHub Actions.

- Outer InstallShield cabinet: 28 entries.
- Inner SDK payload cabinet: 9,915 entries.
- Extracted payload size: approximately 847 MiB.
- Full extracted payload archive: `s60-sdk-full-extracted.tar.gz` (347,301,612 bytes).
- Curated developer bundle: `s60-sdk-devkit-core.tar.gz` (150,578,048 bytes).

### Confirmed ARMv5 build components

The extracted SDK contains the following tools:

- `Epoc32/tools/elf2e32.exe`
- `Epoc32/tools/petran.exe`
- `Epoc32/tools/makesis.exe`
- `Epoc32/tools/distrib/arm-none-symbianelf-2005-q1c.exe` (GCCE toolchain installer)

ARMv5 import libraries and EABI import descriptions are present under `Epoc32/release/armv5/lib`, including:

- `euser.lib` / `euser.dso`
- `cone.lib` / `cone.dso`
- `gdi.lib` / `gdi.dso`
- `eikcore.lib` / `eikcore.dso`
- `bitgdi.lib` / `bitgdi.dso`

The SDK's `gcce_readme.txt` states that GCCE emits ARM ABI version 2 (ABIv2) binaries, interoperable with RVCT 2.2 ABIv2 but not RVCT 2.1 ABIv1. It also confirms that the GCCE compiler itself is supplied as a separate installer in `Epoc32/tools/distrib`; the SDK's E32 tools and libraries are separate from that compiler.

### Persistent repository storage

Release: https://github.com/Shakalx3/Shadowkey/releases/tag/s60-sdk-3.1-fp1-20261108

The private GitHub Release contains three assets:

1. `s60v3.1_SDK.zip` — original installer archive.
2. `s60-sdk-full-extracted.tar.gz` — complete extracted SDK payload.
3. `s60-sdk-devkit-core.tar.gz` — headers, build tools, ARMv5 import libraries and SDK documentation.

Unlike Actions artifacts, GitHub Release assets do not have the Actions artifact retention expiry. The Actions artifacts are currently retained for 90 days (until 2027-02-06), but the release assets provide the persistent copy.

### Next validation

The presence of `elf2e32.exe` confirms the SDK ships the official ELF-to-E32Image tool. Its actual invocation, accepted input ABI, required export/import metadata and output image compatibility still need to be tested on a Windows runner; presence alone is not proof that the current Shadowkey ELF can be converted unchanged.
