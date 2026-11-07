#!/bin/sh
set -u
CC=${CC:-clang}
BUILD=.build
mkdir -p "$BUILD"
$CC -std=c11 -O0 -w -c shadowkey_engine_init_test.c -o "$BUILD/engine_trace_test.o"
$CC -std=c11 -O0 -w -c shadowkey_hle_vfs_trace.c -o "$BUILD/shadowkey_hle_vfs_trace.o"
$CC -std=c11 -O0 -w -c shadowkey_cone_gc_hle.c -o "$BUILD/shadowkey_cone_gc_hle.o"
$CC -std=c11 -O0 -w -c shadowkey_fbs_hle.c -o "$BUILD/shadowkey_fbs_hle.o"
$CC -std=c11 -O0 -w -c shadowkey_bitgdi_hle.c -o "$BUILD/shadowkey_bitgdi_hle.o"
if [ ! -f "$BUILD/shadowkey_lifted.o" ]; then ./build_and_test.sh >/dev/null 2>&1; fi
$CC -o "$BUILD/shadowkey_engine_init_vfs_trace" \
  "$BUILD/engine_trace_test.o" "$BUILD/shadowkey_lifted.o" \
  "$BUILD/shadowkey_function_registry.o" "$BUILD/shadowkey_import_dispatch.o" \
  "$BUILD/shadowkey_dispatch.o" "$BUILD/shadowkey_cone_gc_hle.o" "$BUILD/shadowkey_fbs_hle.o" "$BUILD/shadowkey_bitgdi_hle.o" "$BUILD/shadowkey_hle_vfs_trace.o" \
  "$BUILD/simkin_lifted.o" "$BUILD/simkin_function_registry.o" \
  "$BUILD/simkin_export_registry.o" "$BUILD/simkin_import_dispatch.o" \
  "$BUILD/arm_fallback.o"
set +e
SHADOWKEY_ASSET_ROOT="${SHADOWKEY_ASSET_ROOT:-$(pwd)/game_assets/The_Elder_Scrolls_Travels_Shadowkey/system/apps/6R51}" \
  "$BUILD/shadowkey_engine_init_vfs_trace" ./6R51.APP ./SIMKIN_relocated.DLL > "$BUILD/asset_vfs_trace.log" 2>&1
rc=$?
set -e
grep -E 'VFS RFile::Open|OOB|ARM fallback|ENGINE RUNL|PASS' "$BUILD/asset_vfs_trace.log" || true
echo "Diagnostic VFS run exit code: $rc (real asset opens/reads are enabled; this is not a game-launch test)."
if [ -f "$BUILD/asset_vfs_trace.log" ]; then
  python3 shadowkey_frontier_regression.py "$BUILD/asset_vfs_trace.log"
fi
