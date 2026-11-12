# Step107 — ROFS/ROFx cursor-boundary correction

Date: 2026-11-12

## Baseline and verified inputs

The requested historical workflow run **42604419519** is complete and failed before firmware parsing. Its log shows the unpacker objects compiled, but the final link failed with:

```text
ld.bfd: cannot find -lunix++
make: *** [Makefile:29: unpacker] Error 1
```

This is a dependency installation/link search-path failure, not evidence that UDA, PPM, or C0R data is malformed.

The later firmware workflow run **43201674903** completed its extraction, ROM reconstruction, export inventory, Step102 package creation, and initial Step106 audit. It used the corrected `/usr/local/lib64` link path and runtime library path. The generic FPSX parser produced:

- UDA: one 41,206,272-byte user-area image. This is not the system ROM.
- PPM: a 104,101,376-byte sparse flash-address image; its SOS+ROFx partition is carved and audited separately.
- C0R/CORE: a sparse flash image plus the separate SOS+CORE path used for reconstructed ROM pages and XIP export tables.

The Step106 synthetic tests passed 2/2, but both real directory audits were marked PARTIAL.

## Root cause isolated in the Step106 audit

The Step106 log reported many entry failures of the form:

- a file or subdirectory entry declares `iStructSize` 2 bytes larger than the local directory/file-block cursor end;
- the record itself remains inside the enclosing global directory-tree or file-entry table;
- the audit rejected the entry because it passed the *local* cursor end as the hard read limit.

The published Symbian implementation does not use the local end that way:

- `TDirectoryEntry::AddFiles` loops while `currentPos < endPos`, reads the complete `TRofsEntry`, then advances by `iStructSize`.
- `TDirectoryEntry::AddSubDirs` similarly reads the complete entry, advances by `iStructSize`, and rounds the next cursor to a 32-bit boundary.
- The end value is therefore a loop/cursor stop condition. It is not a hard cap on the bytes read for the final entry. The read still has to remain within the enclosing image/table.

This matches the observed two-byte overruns and does not require assuming firmware corruption.

A second Step106 warning was also invalid: the header's `iDirTreeSize` and `iDirFileEntriesSize` describe global regions. A root `TRofsDir::iStructSize` and its per-directory file block are not expected to equal those global sizes.

## Step107 correction

Updated `tools/step106_audit_rofs_tree.py` to:

1. Keep the header's global directory-tree and file-entry ranges as hard safety boundaries.
2. Validate each per-directory file block is contained by the global file-entry table.
3. Validate each directory record is contained by the global directory-tree table.
4. Test each local cursor with the official `currentPos < endPos` rule, then read the full entry against the enclosing table boundary.
5. Record every final entry that crosses a per-directory cursor end, including its offset and overrun length.
6. Remove the invalid comparison between root-local sizes and global header sizes.
7. Add synthetic ROFS and ROFx tests for both file-block and subdirectory-list crossings.

The updated self-test expects **6/6** cases: normal ROFS, normal ROFx, short file-block cursor for both formats, and short subdirectory cursor for both formats. A crossing is accepted only if the full record remains inside its enclosing metadata table.

## Real-image baseline before the correction

The previous Step106 run recorded:

| Image | Directories | File entries | Local | External | Invalid local ranges |
|---|---:|---:|---:|---:|---:|
| C0R SOS+ROFS | 220 | 1,217 | 1,217 | 0 | 0 |
| PPM SOS+ROFx | 259 | 5,511 | 4,278 | 1,233 | 0 |

Both audits stopped at repeated two-byte cursor-boundary errors. The PPM external references are retained as references into the base image; they are not files that should be extracted from the ROFx extension.

## Next validation gate

The workflow triggered by this correction must establish:

- 6/6 synthetic tests pass;
- the real C0R and PPM walks complete without out-of-table reads;
- any remaining errors are reported with exact entry/table offsets;
- local file extents stay within the carved image;
- ROFx external references remain unresolved rather than being mis-extracted.

If the metadata walks pass, the next step is a separate bounded extractor for local file extents only, with a manifest and per-file hashes. It must not alter the source image. Do not claim a complete firmware filesystem until extraction counts, file extents, and directory coverage are reconciled.

## Separate system-ROM result

The system ROM export inventory comes from reconstructed C0R SOS+CORE, not the generic UDA/PPM/C0R sparse-image parser outputs. The previous successful workflow reported 25 XIP target modules, 15,412 raw export-address rows, 5,061 selected SDK-symbolized rows, and 43 ROM-only exports across EUSER, CONE, GDI, FBSCLI, EIKCORE, WS32, and EFSRV. The module counts remain:

| Module | UID3 | ROM exports |
|---|---:|---:|
| EUSER | 0x100039E5 | 2,229 |
| CONE | 0x10003A41 | 722 |
| GDI | 0x10003B15 | 348 |
| FBSCLI | 0x10003A15 | 241 |
| EIKCORE | 0x10004892 | 590 |
| WS32 | 0x10003B21 | 580 |
| EFSRV | 0x100039E4 | 351 |

These are real reconstructed ROM export tables, cross-checked against the pinned S60 3.1 FP1 SDK DSOs. SDK symbol matches are candidate names, not proof of runtime ABI equivalence. No firmware image or protected system DLL is committed.

## Limits and safety

- The Step102 prerelease package is only an EKA2 loader probe, not a Shadowkey build.
- No Symbian loader execution or physical N95 test has been demonstrated.
- The Actions diagnostic artifact upload was rejected because the repository's Actions storage quota was full; the text reports remain in the run log/job summary and the small Step102 package was published separately.
- Do not overwrite ROM DLLs, flash firmware, or ask for device actions until a concrete package and rollback procedure are ready.
