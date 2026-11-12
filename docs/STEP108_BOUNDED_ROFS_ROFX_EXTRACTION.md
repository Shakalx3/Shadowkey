# Step108 — bounded local ROFS/ROFx extraction

Date: 2026-11-12

## Purpose

Step107 corrected the metadata walk to follow the published Symbian cursor rules and the six synthetic ROFS/ROFx cases passed. The next safe operation is to copy only file extents that Step106 classifies as local, after re-running the metadata audit against the exact source image.

## Extraction contract

- Re-run the Step106 parser in-process and require status PASS, zero parser errors, and zero invalid local ranges.
- Recheck the complete source-image SHA-256 against the audit result.
- Convert payload offsets to source offsets using the recorded 0x400 wrapper offset where present.
- Bounds-check every extent before copying.
- Reject unsafe path components, case-insensitive duplicate paths, and file/directory prefix collisions.
- Extract into a fresh staging directory; refuse to overwrite an existing output tree.
- Record SHA-256 for every extracted file and inventory EPOC-signature candidates by path and UID fields.
- Skip no-data references and external ROFx references. Do not guess their base-image offsets.
- Keep extracted binaries in the ephemeral workflow workspace only. Commit only text manifests and candidate inventories, never firmware images or system DLLs.

## Expected interpretation

UDA is a separate FAT16 user-area image; it is not a ROFS filesystem. The C0R SOS+ROFS image is parsed as a base ROFS tree. PPM SOS+ROFx is parsed as an extension; its external references remain unresolved until a matching base-image mapping is demonstrated.

The EPOC marker and UID inventory is a candidate filter only. It does not validate an E32 image or replace the separate C0R SOS+CORE ROM export-table reconstruction.

## Validation

The script includes synthetic checks for:
1. local file extraction from a plain ROFS image;
2. correct adjustment for a 0x400 wrapper;
3. skipping a ROFx external reference;
4. rejection of path traversal;
5. rejection of case-insensitive path collisions.

The firmware workflow runs these checks and then extracts the local extents from the carved C0R and PPM partitions. Results are written to a text report, JSON manifest, and E32 candidate TSV. The source images are not modified.

No physical N95 test or Shadowkey launch is claimed by this step.
