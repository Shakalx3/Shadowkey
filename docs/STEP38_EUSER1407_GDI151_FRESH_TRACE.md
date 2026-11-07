# Step 38 — fresh archive revalidation and EUSER1407/GDI151 boundary

Date: 2026-11-07

## Archive intake in this execution

The user reattached the source ZIP directly to the active conversation. It was read from the mounted attachment and safely extracted to a temporary working directory.

- File: `shadowkey_recomp_bundle_v8_4_step35_direct_binary_patch_path.zip`
- Size: 23,492,696 bytes
- SHA-256: `6b263d86210eff452f2c00cd099ed9cac475bbca6bff9f60782b41c61263384d`
- ZIP entries: 2,191
- Uncompressed bytes: 112,885,393

The SHA-256 matches the expected digest exactly. This is the first current-session extraction and test run from the attached archive. The original archive itself was not modified.

## Fresh test results

| Command | Result | Interpretation |
|---|---|---|
| `bash ./shadowkey_step35_e32_patch_test.sh` | PASS | Old-E32 structural rewrite test only |
| `bash ./build_and_test.sh` | PASS | Host harness assertions pass; not full OS emulation |
| `bash ./build_arm11_core.sh` | PASS | ARM EABI5 relocatable object |
| `bash ./build_arm11_linkcheck.sh` | FAIL on clean ZIP permissions | Script directly executes non-executable `build_arm11_core.sh` |
| `bash ./build_arm11_symbian_base.sh` | FAIL on clean ZIP permissions | Same executable-bit defect |
| Both ARM link checks after temporary script edit | PASS | Static ARM ELF only; E32Main remains a no-op |
| `python3 shadowkey_step33_gdi108_callsite_audit.py` | PASS | Static/callsite assertions pass |
| `python3 shadowkey_step34_gdi108_arg_audit.py` | PASS | Caller stack arguments and GDI108 r1=0 path verified |
| `python3 shadowkey_step32_gdi108_forensics.py` | FAIL | Required fresh live trace file absent; script explicitly requests running VFS trace first |

The two build scripts were edited only in the temporary extraction to invoke `sh ./build_arm11_core.sh`. With that temporary correction both link checks passed. No such script fix has yet been committed as an archive source change. Their outputs are Linux/System-V ARM ELF executables, not Symbian E32 images. `E32Main` is explicitly a no-op.

The live VFS trace was attempted and stopped with exit code 95 at unresolved GDI ordinal 151. The saved trace is at `.build/live_hal_vfs_trace.log`.

## Important new finding: GDI151 receiver is not yet proven to be TFontSpec

The live trace at return address `0x1002325C` shows:

1. EUSER ordinal 1407 is called with destination `r0=0x102FE6D8`, source `r1=0x100AC718`, and `r3=0xA0`.
2. The source bytes at `0x100AC718` begin with UTF-16 `"Swiss"`.
3. However, the destination bytes before EUSER1407 still contain the UTF-16 path `"apps\\6R51\\"` (followed by descriptor length/capacity data).
4. EUSER ordinal 1407 is unimplemented in the current HLE, so the trace cannot claim that the destination was correctly assigned the Swiss font name.
5. EUSER ordinal 1282 then copies 20 bytes from that destination into `0x102FED30`.
6. GDI ordinal 151 receives `r0=0x102FECF0`, `r1=0x102FED30`, `r2=0xD5`, `r3=0xA0`. The descriptor at r1 decodes as UTF-16 `"apps\\6R51\\"`, not as an inline TBuf/TFontSpec.

The GDI151 handler correctly fails closed at this unresolved callsite. This trace is a strong warning against treating the prior 60-byte or 72-byte TFontSpec hypotheses as proven for every GDI151 call. Before any font-object interpretation is applied, EUSER1407's exact FP1 identity and descriptor assignment semantics must be recovered, and the destination's real post-call bytes must be observed.

This does not invalidate the separate step32 callsite-specific structural evidence for the other GDI108 receiver candidates. It does mean the GDI151 path at `0x1002325C` cannot be generalized from the current synthetic/experimental object assumptions.

## Existing technical boundary remains unchanged

- `6R51.APP` is a legacy pre-OS-9 App-DLL-style image.
- The N95 target requires a real EKA2/ARM EABI executable and any compatible EKA2 support DLLs.
- The old-E32 patcher is a structural format experiment, not a conversion to EKA2.
- No `elf2e32` executable or N95 RM-320 export tables/firmware DLLs are included in the verified test output here.
- No N95 device launch is claimed.

## Next concrete tasks

1. Resolve EUSER ordinal 1407 against the exact S60 3rd FP1 EUSER export map/ROM and determine the descriptor ABI, including whether the call is assignment, copy, construction, or another descriptor operation.
2. Add a focused unit test for EUSER1407 using the observed arguments and descriptor memory; require byte-for-byte post-call output before allowing the GDI151 callsite to advance.
3. Re-run the live VFS trace and step32 forensic audit after the correct descriptor behavior is implemented. Keep GDI151 fail-closed until its object contract is established.
4. Apply and commit the shell portability fix to the two archive build scripts as a separate source change after confirming their exact current contents.
5. Continue the EKA2 SDK/elf2e32 investigation only with a verifiable downloaded toolchain and exact target import data.

