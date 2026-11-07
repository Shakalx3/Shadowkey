# Step 35 archive intake and GitHub import status

Date: 2026-11-07 (updated during step 37)

## Source archive verified

File supplied in the conversation:

`shadowkey_recomp_bundle_v8_4_step35_direct_binary_patch_path.zip`

- Size: 23,492,696 bytes (about 22.4 MiB).
- SHA-256: `6b263d86210eff452f2c00cd099ed9cac475bbca6bff9f60782b41c61263384d`.
- ZIP entries: 2,191.
- Uncompressed size: 112,885,393 bytes (about 107.7 MiB).
- Root directory: `shadowkey_step35_work/`.

The digest exactly matches the recorded step35 archive digest. The archive is readable and its directory inventory was inspected in the current working session.

## Destination repository

Destination: https://github.com/Shakalx3/Shadowkey

The repository has been verified as **private**. The connected GitHub account has read, push and admin permissions. Technical reports and project-authored research utilities can be committed directly.

## Binary archive transfer status

The complete ZIP is **not yet present in GitHub**. The GitHub connector available to this session exposes text-file and Git-object operations but no binary upload operation from the working container. No upload is claimed.

The archive is 23,492,696 bytes, below GitHub's documented 25 MiB web-upload limit for a single file. The owner can add it through the repository page using **Add file → Upload files** and commit it, for example at:

`archive/shadowkey_recomp_bundle_v8_4_step35_direct_binary_patch_path.zip`

After upload, verify the SHA-256 against the value above. Do not rename or repackage it before verification.

## Work completed while archive transfer is pending

- Step 35 archive test and host test-suite results were retained in the repository's technical reports.
- Step 37 re-ran the ARM ELF link checks from a clean executable-permission state.
- A portability correction was prepared for the two ARM build scripts that previously relied on an executable bit for `build_arm11_core.sh`.
- Step 37 audited the current EKA2/ARMv6 toolchain candidate against the target RM-320 and found no published N95 firmware test evidence.

See [Step 37 EKA2 target-compatibility audit](STEP37_EKA2_TOOLCHAIN_TARGET_COMPATIBILITY.md) and [Step 37 build-script patch](../patches/STEP37_BUILD_SCRIPT_PORTABILITY.patch).

## Validation boundaries

Passing the archive tests and ARM ELF link checks does not establish:
- a valid Symbian EKA2 E32 image;
- compatibility with the exact N95 RM-320 ROM export tables;
- a real Symbian startup/runtime;
- working graphics, fonts, audio, input or filesystem behavior on the handset;
- a successful launch on physical hardware.
