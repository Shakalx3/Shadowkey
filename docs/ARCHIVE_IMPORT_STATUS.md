# Archive intake and repository status

Updated: 2026-11-07

## Repository state checked in this run

- Repository: https://github.com/Shakalx3/Shadowkey
- Visibility: private.
- Default branch: `main`.
- Connected GitHub permissions: admin, maintain, pull, push, triage.
- Current `main` HEAD at inspection: `fe7c0768f7935e80f2b786e73150ece15cb8fd3d`.

## Source archive

The complete ZIP is present at the repository root:

`shadowkey_recomp_bundle_v8_4_step35_direct_binary_patch_path.zip`

Git tree metadata reports:
- Size: 23,492,696 bytes.
- Git blob SHA-1: `5e6863df8eca94643636f31ca273489c145514b2`.

The previously recorded source SHA-256 is:
`6b263d86210eff452f2c00cd099ed9cac475bbca6bff9f60782b41c61263384d`.

A prior session reported that this SHA-256 matched the original attached archive and that the Git blob SHA-1 matched the uploaded bytes. In the current execution, GitHub metadata confirms the file and blob identity, but the connector does not return the content of this 23.5 MB binary blob (the file-content response is empty). The current run therefore has **not independently recomputed** the SHA-256 or extracted/tested the ZIP.

## Existing verified technical baseline

The preceding step35–37 reports remain the last executed test evidence:
- old-E32 structural patch test: PASS (format rewrite only);
- host test suite: PASS (explicit assertions only; several HLE imports remain unimplemented);
- ARM11 core build: PASS (ELF32 ARM EABI relocatable object);
- ARM11 link checks: PASS after the recorded shell invocation portability correction (static ELF, not Symbian E32).

These results are not repeated as fresh tests in this run because the archive bytes are not currently accessible to the execution environment.

## Immediate execution blocker

The GitHub connector can read/write repository text and inspect Git trees and blob metadata, but it does not expose a binary download path for this 23.5 MB repository blob. The current container has no mounted copy of the ZIP. Consequently the source archive cannot be extracted or its scripts rerun in this execution.

To resume source-level experiments, provide the ZIP as a conversation attachment in the active run or make a binary-download-capable GitHub/working-directory path available. Do not infer source contents from the ZIP filename, Git blob SHA, or prior reports.

## Technical next gate once the archive is available

1. Inspect the archive's actual file inventory and read the step35 patch-path report, README, and native-port status from the archive itself.
2. Re-run the structural patch and host tests against the exact archive; record command lines and fresh output.
3. Continue the EKA2 ARMv6 toolchain experiment only after obtaining the SDK and validating its release digest.
4. Obtain exact N95 RM-320 / S60 3rd FP1 exports or matching firmware/SDK DEF data. Resolve EUSER, EFSRV, CONE, FBSCLI, GDI, WS32, EIKCORE and AVKON imports against the target rather than assuming newer firmware ordinal compatibility.
5. Do not treat a generated ELF or generic E32 as N95-compatible without inspecting E32 metadata, imports, capabilities and loader acceptance.

No physical N95 launch is claimed.
