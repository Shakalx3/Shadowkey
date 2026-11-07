#!/bin/sh
# Unmodified constructor state + one direct RunL probe. The harness still
# bypasses CActiveScheduler, but does not write engine+0x34 or fake a RunL state.
set -eu
CC=${CC:-clang}
BUILD=.build
mkdir -p "$BUILD"
$CC -std=c11 -O0 -w -c shadowkey_engine_init_live_test.c -o "$BUILD/engine_live_test.o"
$CC -std=c11 -O0 -w -c shadowkey_hle_vfs_trace.c -o "$BUILD/shadowkey_hle_vfs_trace.o"
$CC -std=c11 -O0 -w -c shadowkey_bitgdi_hle.c -o "$BUILD/shadowkey_bitgdi_hle.o"
$CC -o "$BUILD/shadowkey_engine_init_live_vfs_trace" \
  "$BUILD/engine_live_test.o" "$BUILD/shadowkey_lifted.o" \
  "$BUILD/shadowkey_function_registry.o" "$BUILD/shadowkey_import_dispatch.o" \
  "$BUILD/shadowkey_dispatch.o" "$BUILD/shadowkey_cone_gc_hle.o" "$BUILD/shadowkey_fbs_hle.o" "$BUILD/shadowkey_bitgdi_hle.o" "$BUILD/shadowkey_hle_vfs_trace.o" \
  "$BUILD/simkin_lifted.o" "$BUILD/simkin_function_registry.o" \
  "$BUILD/simkin_export_registry.o" "$BUILD/simkin_import_dispatch.o" \
  "$BUILD/arm_fallback.o"
ASSET_ROOT=${SHADOWKEY_ASSET_ROOT:-"$(pwd)/game_assets/The_Elder_Scrolls_Travels_Shadowkey/system/apps/6R51"}
SHADOWKEY_HLE_FREE_RAM_BYTES=${SHADOWKEY_HLE_FREE_RAM_BYTES:-33554432} \
SHADOWKEY_ASSET_ROOT="$ASSET_ROOT" \
  "$BUILD/shadowkey_engine_init_live_vfs_trace" ./6R51.APP ./SIMKIN_relocated.DLL > "$BUILD/live_hal_vfs_trace.log" 2>&1
python3 shadowkey_step23_hal_threshold_audit.py "$BUILD/live_hal_vfs_trace.log" "${SHADOWKEY_HLE_FREE_RAM_BYTES:-33554432}"
