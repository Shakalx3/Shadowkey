# Step 35 archive intake and GitHub import boundary

Date: 2026-11-07

## Source archive verified

File supplied in the conversation:

`shadowkey_recomp_bundle_v8_4_step35_direct_binary_patch_path.zip`

- Size: 23,492,696 bytes (about 22.4 MiB).
- SHA-256: `6b263d86210eff452f2c00cd099ed9cac475bbca6bff9f60782b41c61263384d`.
- ZIP entries: 2,191.
- Uncompressed size: 112,885,393 bytes (about 107.7 MiB).
- Root directory: `shadowkey_step35_work/`.

The digest exactly matches the previously recorded step35 archive digest. The archive is readable and its directory inventory was inspected.

## Public repository import policy

The destination repository is public: https://github.com/Shakalx3/Shadowkey.

The archive contains original proprietary game executable/DLL files, extracted game resources, audio, models, textures, and large lifted/decompiled game-code outputs. These are deliberately **not mirrored into this public repository** because doing so would publicly redistribute game binaries/assets and derived game content. The archive remains the authoritative local project input supplied by the owner.

The repository will hold project-authored technical notes, reproducible test scripts, build glue, and non-game-specific tooling. Before mirroring the complete archive, change the repository to Private and confirm that private storage is intended; even then, large binaries/assets should be handled selectively rather than blindly committed.

## First commit

The public repository was initialized on branch `main` with a project README. The connected GitHub account has push/admin permissions. No pre-existing files were overwritten.

## Initial validation

- `shadowkey_step35_e32_patch_test.sh`: PASS.
- `build_and_test.sh`: PASS.
- Both commands were run from the supplied archive in a temporary validation workspace; this was a one-time archive inspection, not a permanent duplicate working repository.
- The structural patch test writes a temporary probe image and explicitly does not prove EKA2 loader acceptance.
- The general test suite includes diagnostic/synthetic HLE paths; passing it is not proof of a playable build.

See [Step 35 patch test](STEP35_STRUCTURAL_PATCH_TEST.md) and [Step 36 toolchain audit](STEP36_EKA2_TOOLCHAIN_AUDIT.md).
