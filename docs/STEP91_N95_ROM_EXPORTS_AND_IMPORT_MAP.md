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

The pinned S60 3.1 FP1 ARMv5 SDK comparison found 24 matching DSO files, 11 modules with equal export counts, and 15,325 SDK-symbolized export-map rows. All 25 expected ROM modules are present. The one ROM module without a matching SDK DSO is BTENG; it must be checked against the N-Gage ARM UREL library and ROM code rather than assumed absent. SIMKIN and GAMECOMMS are bundled private game DLLs, not expected ROM modules.

## Seven critical system DLLs

The Step91 summary was reproduced in firmware audit run 43006595394 on 2026-11-11. That run confirms all seven requested OS modules exist in the reconstructed ROM:

| Module | UID3 | ROM exports | SDK DSO exports | Result |
|---|---:|---:|---:|---|
| CONE | 10003A41 | 722 | 721 | ROM has 1 extra export |
| EFSRV | 100039E4 | 351 | 335 | ROM has 16 extra exports |
| EIKCORE | 10004892 | 590 | 590 | Count match |
| EUSER | 100039E5 | 2,229 | 2,210 | ROM has 19 extra exports |
| FBSCLI | 10003A15 | 241 | 240 | ROM has 1 extra export |
| GDI | 10003B15 | 348 | 344 | ROM has 4 extra exports |
| WS32 | 10003B21 | 580 | 578 | ROM has 2 extra exports |

The run generated 5,061 selected export rows in `STEP91_TARGET_EXPORTS.tsv` and the import audit produced 395 mappings touching these modules: 271 exact signature matches, 35 same-address aliases, 9 destructor candidates, 8 PASS overrides, 1 typedef/ABI alias, 2 subsession-close wrapper cases, and 68 unresolved signatures. The unresolved count is not proof that the functions are absent from the ROM.

## Key ordinal cases — now checked against ARM UREL symbols

Step82 now validates each PASS override against the actual N-Gage ARM UREL import symbol and the target SDK symbol, rather than trusting the earlier WINS ordinal name alone:

| N-Gage ARM UREL import | N95 target export | Status |
|---|---|---|
| EUSER 1407 — TPtrC16 constructor | EUSER 1169 — TPtrC16 constructor | PASS |
| EUSER 1575 — TInt64 operator!= | No direct target symbol | NO_TARGET_SIGNATURE |
| CONE 160 — CCoeControl::Rect() const | CONE 276 — CCoeControl::Rect() const | PASS |
| EIKCORE 224 — CEikAppUi constructor | EIKCORE 178 — CEikAppUi constructor | PASS |
| GDI 151 — TFontSpec constructor | GDI 169 — TFontSpec constructor | PASS |
| GDI 101 — TFontStyle::SetPosture | GDI 12 — TFontStyle::SetPosture | PASS |
| GDI 108 — TFontStyle::SetStrokeWeight | GDI 14 — TFontStyle::SetStrokeWeight | PASS |

The exact mangled ARM UREL and SDK symbol names, ROM addresses, and per-import rows are written to STEP91_KEY_IMPORT_CASES.tsv and STEP91_SELECTED_IMPORTS.tsv. EUSER 1575 remains unresolved; do not assign it a guessed ordinal. It may require a local compatibility implementation or call-site patch after inspecting the caller and the expected TInt64 comparison semantics.

## Validation caveats

1. ROM export addresses come from the reconstructed RM-320 ROM. SDK symbol names are cross-checked against S60 3.1 FP1 DSO exports; modules with extra ROM exports need per-ordinal review.
2. Step92 independently parsed all 24 matching SDK DSOs and verified every export ordinal/name map: 24/24 PASS, zero parse errors, zero mapping mismatches (run 42805802416). This validates SDK DSO ordinal extraction, not the identity of SDK code with ROM code.
3. Firmware run 43006595394 reproduced the ROM/export inventory and passed the isolated Step99 E32 DLL conversion. The overall job ended as `failure` only because GitHub rejected the final artifact upload after the Actions storage quota was hit. The full TSVs were generated in the ephemeral runner, but the artifact was not persisted; use the text-only Step102 job summary for the durable compact checkpoint.
4. A successful host harness or static E32 build does not establish Symbian loader compatibility.
5. No N95 hardware launch has been performed; a physical-device test remains pending.

## Next checkpoints

1. Verify the EKA2 host build after adding the proper GCCE preinclude and platform defines.
2. Independently parse the SDK DSO dynsym tables and compare symbol-to-ordinal mappings with the current readelf implementation.
3. Resolve remaining import signatures/wrappers, then patch a copy of the E32 import tables.
5. Keep raw ROM/system binaries out of Git history and compact diagnostic artifacts.
