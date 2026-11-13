# Step121 — metadata-only N95 E32 inventory package

Step121 packages the Step109 detailed module/export/import tables together with the independent Step120 format-aware cross-check and the Step117–119 diagnostic reports.

## Contents and validation

- Step109: per-module metadata, export rows, and import rows. For ELF-format modules, the import list contains code-relative relocation places; the referenced code word encodes the imported ordinal in its low 16 bits and the addend in its high 16 bits.
- Step120: independent module/export/import row counts and import-format validation.
- Step117–119: decompression, bulk-parse, and offset/IAT diagnostic reports.
- The package script verifies that Step109 and Step120 module paths and row counts agree with the Step120 summary JSON.
- The archive is restricted to .tsv, .json, .md, and .txt members and rejects NUL-containing files. It contains no firmware images, ROFS/ROFx/UDA payloads, ROM system DLLs, E32 binaries, or game executable.

## Publication

The workflow attaches Shadowkey-N95-E32-Metadata.zip and SHA256SUMS.txt to the same prerelease as the reversible Step102 loader probe, using tag shadowkey-step102-<workflow-run-id>. This avoids relying on Actions artifact storage, which has previously rejected uploads because of quota.

The inventory is metadata-only. It does not validate Symbian loader acceptance, runtime ABI compatibility, or a real Nokia N95 launch. Step102 remains a separate EKA2 loader probe and is not a Shadowkey game build.
