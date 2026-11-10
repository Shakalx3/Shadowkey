# Step91 — RM-320 v35 ROM exports and Shadowkey import map

Date: 2026-11-10

## Verified ROM reconstruction

The N95 RM-320 v35.0.001 C0R SOS+CORE partition was reconstructed as a demand-paged Symbian ROM:

- ROM base: 0x80000000; ROM size: 0x03A00000
- reconstructed image: 60,600,320 bytes
- pageable pages: 12,671; BytePair decode failures: 0
- ROM directory: 1 root, 2,726 entries
- target system modules: 25
- raw ROM export-address rows: 15,412

The pinned S60 3.1 FP1 ARMv5 SDK comparison found 24 matching DSO files, 11 modules with equal export counts, and 15,325 SDK-symbolized export-map rows. SIMKIN and GAMECOMMS are bundled private game DLLs and are not expected in the N95 ROM.

## Seven critical system DLLs

The successful Step91 summary from run 42797908530 confirms all seven requested OS modules exist in the reconstructed ROM:

| Module | UID3 | ROM exports | SDK DSO exports | Result |
|---|---:|---:|---:|---|
| CONE | 10003A41 | 722 | 721 | ROM has 1 extra export |
| EFSRV | 100039E4 | 351 | 335 | ROM has 16 extra exports |
| EIKCORE | 10004892 | 590 | 590 | Count match |
| EUSER | 100039E5 | 2,229 | 2,210 | ROM has 19 extra exports |
| FBSCLI | 10003A15 | 241 | 240 | ROM has 1 extra export |
| GDI | 10003B15 | 348 | 344 | ROM has 4 extra exports |
| WS32 | 10003B21 | 580 | 578 | ROM has 2 extra exports |

The 5,061 selected export rows are available as STEP91_TARGET_EXPORTS.tsv. The import audit also produced 395 mappings touching these modules: 271 exact signature matches, 35 same-address aliases, 9 destructor candidates, 8 PASS overrides, 1 typedef/ABI alias, 2 subsession-close wrapper cases, and 68 unresolved signatures. The unresolved count is not proof that the functions are absent from the ROM.

## Ordinal cases requiring explicit review

The earlier WINS-based hypotheses for EUSER 1407/1575, CONE 160 and GDI 101/108/151 must be checked against the actual N-Gage ARM UREL import symbols and the reconstructed N95 ROM exports. The current Step91 report records those exact cases, including the ARM UREL symbol and target symbol/ordinal. A PASS override is accepted only after the ARM UREL and target SDK signatures normalize to the same ABI signature; otherwise it is emitted as a mismatch diagnostic.

The EUSER 1575 case has no direct target API symbol in the Step58 SDK remap and remains unresolved. It must not be assigned a guessed ordinal.

## Validation caveats

1. ROM export addresses come from the reconstructed RM-320 ROM. SDK symbol names are cross-checked against S60 3.1 FP1 DSO exports; the modules with extra ROM exports need per-ordinal review.
2. The SDK DSO parser emits readelf virtual-address/segment warnings. An independent ELF dynsym parser is the next validation step.
3. A successful host harness does not establish Symbian loader compatibility.
4. No N95 hardware launch has been performed; the phone is not available.

## Next checkpoints

1. Review Step91's exact key ordinal cases and any OVERRIDE_ARM_SIGNATURE_MISMATCH results.
2. Independently parse the SDK DSO dynsym tables and compare symbol-to-ordinal mappings with the current readelf implementation.
3. Resolve the remaining import signatures/wrappers, then patch a copy of the E32 import tables.
4. Keep raw ROM/system binaries out of Git history and compact diagnostic artifacts.
