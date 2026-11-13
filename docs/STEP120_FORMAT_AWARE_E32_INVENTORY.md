# Step120 — format-aware E32 module inventory

Date: 2026-11-13

## Verified result

- Workflow: [43416779432](https://github.com/Shakalx3/Shadowkey/actions/runs/43416779432), completed successfully.
- Synthetic format tests: PASS 3/3 (ELF, PE and PE2).
- EPOC candidates: 135.
- Import-format distribution: ELF 135.
- Module status: VALID 135.
- Export rows: 2,752.
- Import rows: 26,485.
- ELF PE-style IAT check: NOT_APPLICABLE_ELF for every module.

All modules use E32 flags with the ELF import-format nibble 0x10000000. The independent audit confirms that ELF import code offsets lie inside the code segment and that ELF export absolute addresses map inside the code range using code_base. The counts match the authoritative Step109 format-aware parser exactly.

## Scope

Step120 is an independent bounds/count cross-check. Step109 remains the more detailed inventory because it also decodes the relocation word at each ELF import place into its imported ordinal and addend, handles named-lookup slots, and emits the authoritative per-module/export/import TSV tables.

A VALID result is static structure only; it is not a Symbian loader test, ABI compatibility result or real N95 launch. Decompressed binaries remain in the ephemeral workflow workspace and are not committed.
