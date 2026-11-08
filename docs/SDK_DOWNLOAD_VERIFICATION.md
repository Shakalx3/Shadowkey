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
