# Step 56 — executable Step48 consistency gate

Date: 2026-11-08

## Change

Added `.github/workflows/step48-consistency.yml`.

The workflow runs the existing fail-closed checker:

```sh
python3 tools/step48_import_hle_consistency_test.py
```

It is triggered by changes to the checker, its evidence documents, the import dispatch table, and the relevant HLE/bootstrap/VFS source files. It also supports manual `workflow_dispatch`.

The workflow uses only the GitHub-hosted Ubuntu runner and Python 3 already present on the runner; it does not download SDK binaries, modify source files, or require a phone.

## Why this is useful

The Step48 checker was previously a static script without an automatically enforced CI gate. The new workflow makes changes to the ARM/WINS identity distinction and the related HLE routing fail the CI check if its assertions stop matching repository contents.

This is deliberately a narrow consistency gate. It does not execute the HLE runtime, validate ARM machine code, prove N95 export compatibility, or launch the game.

## Verification state

- Workflow definition committed: `bf3f687a393ffd207014e551798e76779985a611`.
- The workflow definition is present in the repository.
- The commit status endpoint returned no status entries at the time of this report.
- Therefore, **the new workflow's execution result is pending/unverified**. Do not report a CI PASS until a corresponding Actions run and completed job are observed.

## Next independent work while device ROMs are unavailable

Continue with the EKA2-side path that does not depend on the missing N-Gage/N95 EIKCORE binaries:

1. Inspect the ARMv6 object artifact and compile report from Step54.
2. Establish the complete source/link input inventory and identify unresolved external symbols.
3. Separate game-recovered C objects from host-only diagnostic code and synthetic HLE.
4. Prepare a minimal EKA2 bootstrap target with an explicit import manifest and a generated E32 inspection report.
5. Keep EIKCORE 224 fail-closed; do not fabricate the missing `MCoeMessageObserver` vptr.
