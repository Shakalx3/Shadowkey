# Step91 — RM-320 v35 ROM exports and Shadowkey import map

Date: 2026-11-10

## Verified firmware extraction result

The N95 RM-320 v35.0.001 firmware package is no longer limited to its UDA user area. The workflow extracts the SOS+CORE partition and reconstructs the demand-paged ROM:

- ROM base: `0x80000000`
- ROM size: `0x03A00000`
- reconstructed uncompressed image: 60,600,320 bytes
- pageable pages: 12,671
- BytePair decode failures: 0
- ROM directory: 1 root, 2,726 directory entries
- selected system-module candidates: 25
- raw ROM export-address rows: 15,412

The reconstruction is based on the RM-320 v35.0.001 C0R image, not on the N-Gage QD WINS import ordinals. The raw reconstructed ROM and extracted module binaries are transient workflow inputs; they are not committed to Git or retained in the compact diagnostic artifact.

## SDK symbolization and import mapping

The successful full audit (Actions run [42777589219](https://github.com/Shakalx3/Shadowkey/actions/runs/42777589219)) compared ROM module export addresses with S60 3.1 FP1 SDK DSO symbol tables:

- 25 target ROM modules
- 24 matching SDK DSO modules found
- 11 modules with equal ROM/SDK export counts
- 15,223 symbolized ROM/SDK export-map rows
- 415 game IAT slots, including the previously unrecognized final slot
- 79 SIMKIN imports
- 205 GAMECOMMS imports

The mapping audit reported 34 game imports, 28 SIMKIN imports, and 16 GAMECOMMS imports without a target signature. These are unresolved signature matches, not proof that the target ROM lacks the functions. Other categories include destructor candidates, same-address aliases, one AVKON base-class alias, a provisional forwarder, and an RFs subsession-close wrapper candidate. Those categories must not be patched as if they were proven ABI matches.

The seven modules central to the current compatibility investigation are `EUSER`, `CONE`, `GDI`, `FBSCLI`, `EIKCORE`, `WS32`, and `EFSRV`. Step91 emits their module IDs, export counts, SDK names, ROM addresses, and import remaps into:

- `STEP91_N95_ROM_EXPORT_SUMMARY.md`
- `STEP91_TARGET_EXPORTS.tsv`
- `STEP91_SELECTED_IMPORTS.tsv`

The exact per-module rows are generated from the extracted ROM and SDK DSO data; no ordinal should be inferred from the old N-Gage WINS library.

## Important caveats

1. SDK DSO symbolization is an ABI/name cross-check against the matching S60 3.1 FP1 SDK. ROM export addresses come from the reconstructed target ROM, but SDK symbol names still require independent confirmation where export counts differ or the SDK reader emits segment warnings.
2. A matching export count does not prove every ordinal has the same meaning. Use exact symbol and code-address evidence.
3. A successful host build or host harness does not establish Symbian loader acceptance.
4. No N95 hardware test has been performed; the device is not currently available.

## Next technical checkpoints

1. Review the Step91 selected-module table, especially count mismatches and absent target modules.
2. Independently validate SDK DSO-to-ROM export ordinal mapping for the seven core system DLLs, using import-library symbols and disassembly where needed.
3. Resolve remaining game/SIMKIN/GAMECOMMS import signatures and wrappers before generating any binary patch.
4. Keep the EKA2 launcher prototype isolated from the firmware/import audit so a host-build failure cannot suppress ROM export reports.
