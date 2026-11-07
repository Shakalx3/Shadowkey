#!/bin/sh
set -eu
CC=${CC:-clang}
BUILD=.build
mkdir -p "$BUILD"
CFLAGS="-std=c11 -O0 -w"

$CC $CFLAGS -c shadowkey_appui_construct_test.c -o "$BUILD/appui_test.o"
$CC $CFLAGS -c shadowkey_lifted_v6.c -o "$BUILD/shadowkey_lifted.o"
$CC $CFLAGS -c shadowkey_function_registry.c -o "$BUILD/shadowkey_function_registry.o"
$CC $CFLAGS -c shadowkey_import_dispatch.c -o "$BUILD/shadowkey_import_dispatch.o"
$CC $CFLAGS -c shadowkey_dispatch_trace.c -o "$BUILD/shadowkey_dispatch.o"
$CC $CFLAGS -c shadowkey_cone_gc_hle.c -o "$BUILD/shadowkey_cone_gc_hle.o"
$CC $CFLAGS -c shadowkey_fbs_hle.c -o "$BUILD/shadowkey_fbs_hle.o"
$CC $CFLAGS -c shadowkey_bitgdi_hle.c -o "$BUILD/shadowkey_bitgdi_hle.o"
$CC $CFLAGS -c shadowkey_hle_bootstrap_v2.c -o "$BUILD/shadowkey_hle.o"
$CC $CFLAGS -c simkin_lifted_runtime_v4.c -o "$BUILD/simkin_lifted.o"
$CC $CFLAGS -c simkin_function_registry.c -o "$BUILD/simkin_function_registry.o"
$CC $CFLAGS -c simkin_export_registry.c -o "$BUILD/simkin_export_registry.o"
$CC $CFLAGS -c simkin_import_dispatch.c -o "$BUILD/simkin_import_dispatch.o"
$CC $CFLAGS -c arm_fallback.c -o "$BUILD/arm_fallback.o"
$CC -o "$BUILD/shadowkey_appui_construct_test" \
  "$BUILD/appui_test.o" "$BUILD/shadowkey_lifted.o" \
  "$BUILD/shadowkey_function_registry.o" "$BUILD/shadowkey_import_dispatch.o" \
  "$BUILD/shadowkey_dispatch.o" "$BUILD/shadowkey_cone_gc_hle.o" "$BUILD/shadowkey_fbs_hle.o" "$BUILD/shadowkey_bitgdi_hle.o" "$BUILD/shadowkey_hle.o" \
  "$BUILD/simkin_lifted.o" "$BUILD/simkin_function_registry.o" \
  "$BUILD/simkin_export_registry.o" "$BUILD/simkin_import_dispatch.o" \
  "$BUILD/arm_fallback.o"
"$BUILD/shadowkey_appui_construct_test" ./6R51.APP ./SIMKIN_relocated.DLL
$CC $CFLAGS -c shadowkey_hle_vfs_trace.c -o "$BUILD/shadowkey_hle_vfs_trace.o"
$CC $CFLAGS -c shadowkey_fbs_chunk_test.c -o "$BUILD/shadowkey_fbs_chunk_test.o"
$CC -o "$BUILD/shadowkey_fbs_chunk_test" "$BUILD/shadowkey_fbs_chunk_test.o" "$BUILD/shadowkey_fbs_hle.o"
"$BUILD/shadowkey_fbs_chunk_test"
$CC $CFLAGS -c shadowkey_efsrv_size_test.c -o "$BUILD/shadowkey_efsrv_size_test.o"
$CC -o "$BUILD/shadowkey_efsrv_size_test" "$BUILD/shadowkey_efsrv_size_test.o" "$BUILD/shadowkey_hle_vfs_trace.o" "$BUILD/shadowkey_fbs_hle.o" "$BUILD/shadowkey_bitgdi_hle.o"
"$BUILD/shadowkey_efsrv_size_test" "$(pwd)/game_assets/The_Elder_Scrolls_Travels_Shadowkey/system/apps/6R51"
python3 shadowkey_cone_ordinal226_analysis.py
python3 shadowkey_fbscli17_abi_audit.py
$CC $CFLAGS -c shadowkey_step23_drawtext_abi_test.c -o "$BUILD/step23_drawtext_abi_test.o"
$CC -o "$BUILD/step23_drawtext_abi_test" "$BUILD/step23_drawtext_abi_test.o" "$BUILD/shadowkey_bitgdi_hle.o"
"$BUILD/step23_drawtext_abi_test"
$CC $CFLAGS -c shadowkey_step28_euser711_tpoint_test.c -o "$BUILD/step28_euser711_tpoint_test.o"
$CC -o "$BUILD/step28_euser711_tpoint_test"
$CC $CFLAGS -c shadowkey_step39_euser1407_test.c -o "$BUILD/step39_euser1407_test.o"
$CC -o "$BUILD/step39_euser1407_test" "$BUILD/step39_euser1407_test.o" "$BUILD/shadowkey_hle.o" "$BUILD/shadowkey_bitgdi_hle.o" "$BUILD/shadowkey_fbs_hle.o"
"$BUILD/step39_euser1407_test" "$BUILD/step28_euser711_tpoint_test.o" "$BUILD/shadowkey_hle_vfs_trace.o" "$BUILD/shadowkey_bitgdi_hle.o" "$BUILD/shadowkey_fbs_hle.o" "$BUILD/shadowkey_cone_gc_hle.o"
"$BUILD/step28_euser711_tpoint_test"
bash shadowkey_arm_shift_test.sh
python3 shadowkey_step29_shift_operand_audit.py
bash shadowkey_step30_point_import_test.sh
