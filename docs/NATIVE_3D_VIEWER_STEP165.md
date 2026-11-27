# Native Shadowkey 3D viewer — prototype notes

## Goal

Build a small installable S60 3rd Edition FP1 application for Nokia N95 that opens a Window Server window and continuously rotates a model extracted from the game's `models.huge`. This is a native Symbian E32/SIS application; it is not an HTML wrapper.

## Selected asset

The first candidate is model slot 4, `bottle.bin`, from `models.txt`. Its record is located through `models.idx`, not by guessing byte offsets.

## Index file format

`models.idx` is 1,900 bytes:
- 32-bit little-endian record count: 237
- 237 pairs of 32-bit little-endian values: record offset and record size

The first records align exactly with the model table:
- slot 0 `fern.bin`: offset 0, size 2,760
- slot 1 `foxgloveplant.bin`: offset 2,760, size 8,898
- slot 2 `lantern.bin`: offset 11,658, size 2,682
- slot 3 `stalagmite.bin`: offset 14,340, size 9,186
- slot 4 `bottle.bin`: offset 23,526, size 1,578

For the selected bottle record, the first seven little-endian 16-bit header values are:
`7, 1, 21, 114, 38, 63, 1`.

The following structure is consistent with the observed record length:
- 21 × 3 signed 16-bit coordinate values (63 scalars)
- two 114-value two-component tables
- two 114-value index tables (38 triangles each)
- a three-word tail header `1, 16, 16`
- 16 × 16 16-bit payload
- 8 trailing bytes

This is a structural interpretation of the record. The two component tables look like texture-coordinate tables, but channel semantics and exact index-to-position remapping still need validation.

## Current viewer mapping hypothesis

`tools/export_native_viewer_mesh.py` exports the 21 coordinate triples and combines the two index sets using `index % 21`. This is explicitly a candidate remapping, not a proven statement about the original engine's vertex encoding. The viewer currently draws the resulting triangles as a rotating wireframe and deliberately does not claim to reproduce original materials or lighting.

## Build pipeline

Workflow: `.github/workflows/step165-native-3d-viewer.yml`

1. Downloads the verified modern EKA2 ARMv5 toolchain.
2. Extracts model slot 4 from the original assets.
3. Compiles a native Window Server/GDI executable.
4. Uses the archived S60 3.1 FP1 SDK tools to compile the registration resource and package a SIS.
5. Publishes the SIS as a GitHub Release asset.

Target device: Nokia N95 8GB RM-320, Symbian OS 9.2 / S60 3rd Edition FP1.

## Acceptance tests

Build-side:
- E32 image has the expected UID3 `0xE000BEF1`.
- SIS is created successfully by the original S60 SDK `makesis`.
- SIS installs and registers in the application menu.

Device-side:
- app launches without `Feature not supported` or immediate exit;
- the model is visible and rotates smoothly;
- no crash occurs during the viewing interval.

The first device test will also validate whether the candidate index remapping produces a recognizable bottle. If it does not, the next task is to recover the exact vertex/index mapping before adding textures.


## First successful SIS build — 2026-11-27

GitHub Actions run: https://github.com/Shakalx3/Shadowkey/actions/runs/45986562367

The ARMv5 E32 compile, S60 registration-resource compile, and `makesis` packaging stages all completed successfully. The resulting `Shadowkey3DViewer.sis` is 27,552 bytes and was identified by the host `file` utility as a Symbian OS 9.x installation file.

SHA-256:
`ced7d9e70453d3dcf9dbf1ebed09f0f88df99ddab16ff11e85b70162377d88be`

This is a build/package verification only. It has not yet been installed or run on a physical Nokia N95. The first device test is required to validate launch, rendering, rotation, and the candidate mesh index remapping.


## Multi-model textured viewer iteration — 2026-11-27

The first on-device validation was reported by the user: slot 4 (`bottle.bin`) installs and displays with recognizable, correct geometry. Rotation was not visible and is intentionally deferred; texture support and multiple models are the next acceptance targets.

The exporter now validates and embeds three records from the model index:
- slot 4: `bottle.bin`
- slot 5: `sbarrel.bin`
- slot 6: `pinetree.bin`

All three records passed the exporter’s structural checks in CI: coordinate count, both component arrays, both triangle-index arrays, texture dimensions, texture payload bounds, and 12-bit pixel-word range. The two component arrays are currently interpreted as U and V channels; the triangle indices are used to look up those channels, while position indices use the same candidate modulo mapping that was visually validated for the bottle. This interpretation is still provisional.

The native viewer now uses a software triangle rasterizer and converts candidate RGB444 texels to the N95-friendly RGB565 framebuffer. It displays the bottle, barrel, and pine tree sequentially. This build has not yet passed native compilation/package validation, and none of the new textured models has been tested on the phone. Treat UV scaling, channel order, transparency, depth ordering, and the position remap as hypotheses until the device output is inspected.
