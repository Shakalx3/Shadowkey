# Archive intake and repository status

Updated: 2026-11-07

## Repository

- Repository: https://github.com/Shakalx3/Shadowkey
- Visibility: private.
- Default branch: `main`.
- Current `main` HEAD after archive import: `67b1ab33602e2e699b6bd0d1cde7eadfd45600e9`.

## Source archive — imported and verified

The original ZIP remains at the repository root:

`shadowkey_recomp_bundle_v8_4_step35_direct_binary_patch_path.zip`

- ZIP size: 23,492,696 bytes.
- ZIP SHA-256: `6b263d86210eff452f2c00cd099ed9cac475bbca6bff9f60782b41c61263384d`.
- ZIP Git blob SHA-1: `5e6863df8eca94643636f31ca273489c145514b2`.
- ZIP entries: 2,191.
- Uncompressed size: 112,885,393 bytes.

The archive has now been extracted on a GitHub Actions runner and committed as ordinary Git files under:

`source_bundle/shadowkey_step35_work/`

The extraction was verified on the runner against the expected SHA-256, entry count, and total uncompressed byte count. The Git tree was then queried independently:
- extracted file blobs: 2,191;
- summed Git tree file sizes: 112,885,393 bytes;
- recursive tree response: not truncated.

Import commit: `67b1ab33602e2e699b6bd0d1cde7eadfd45600e9`.

Workflow run: https://github.com/Shakalx3/Shadowkey/actions/runs/42401957672
Result: success. Both extraction and commit/push steps completed successfully.

## Import workflow

`.github/workflows/import-source-archive.yml` contains the verified extraction workflow. It refuses to overwrite an existing `source_bundle/` directory and checks the archive digest and inventory before extraction. The workflow is triggered by a dedicated marker-file push or manually through GitHub Actions.

## Important distinction

The ZIP is preserved unchanged at the repository root. The extracted working copy is stored separately under `source_bundle/`, so the original archive and the previously committed `docs/`, `tools/`, and `patches/` files were not overwritten.

The archive is now available for subsequent analysis directly from the GitHub repository tree. This import operation does not itself imply that the extracted binaries are N95-compatible or that the game has launched on physical hardware.

## Technical next gate

Step 47 supersedes the earlier Step 38 focus. The original N-Gage SDK WINS UDEB import-library map identifies EUSER 1407 as `TDblQueBase::SetOffset(TInt)`, EUSER 1575 as `TLex8::Val(TInt64&, const TInt64&)`, CONE 160 as `CCoeControl::Position() const -> TPoint`, GDI 101 as `CGraphicsContext::JustificationInPixels`, GDI 108 as `CPalette::NewL`, and GDI 151 as `CPicture::StoreL`. See [Step 47 import ordinal semantics correction](STEP47_IMPORT_ORDINAL_SEMANTICS_CORRECTION.md).

The Step 46 ARM UREL parser was corrected to read the actual Step 44 WINS report format and now has explicit self-checks for those six mappings. The corrected workflow has been triggered, but its generated ARM UREL report has not yet been confirmed in the repository. Do not claim ARM/WINS equivalence until that report exists and its symbol evidence is reviewed.

No physical N95 launch is claimed.
