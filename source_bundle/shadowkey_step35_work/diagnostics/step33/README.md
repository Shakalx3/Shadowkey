# Step33 reproducibility artifacts

- `live_hal_vfs_trace.log` — full VFS-backed diagnostic trace with 8/16/32-bit receiver watch enabled.
- `build_and_test.log` — complete host build/regression output.
- `trace_runner_summary.log` — live trace runner summary and stated limitations.
- `step32_forensics_audit.log` — rerun of the step32 font-layout forensic checks against the freshly generated `.build` trace.
- `step33_callsite_audit.log` — static provenance audit for all five GDI108 callsites.
- `arm11_build.log` — ARM11 cross-build recheck.

The `.build` directory and generated `.o` files are intentionally not bundled; the scripts regenerate them.
