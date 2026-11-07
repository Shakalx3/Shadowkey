#!/bin/sh
set -eu
CC=${CC:-clang}
BUILD=.build
mkdir -p "$BUILD"
$CC -std=c11 -O0 -w -c shadowkey_hle_vfs_trace.c -o "$BUILD/shadowkey_hle_vfs_trace.o"
$CC -std=c11 -O0 -w shadowkey_step28_euser711_tpoint_test.c \
  "$BUILD/shadowkey_hle_vfs_trace.o" "$BUILD/shadowkey_bitgdi_hle.o" \
  "$BUILD/shadowkey_fbs_hle.o" "$BUILD/shadowkey_cone_gc_hle.o" \
  -o "$BUILD/shadowkey_step28_euser711_tpoint_test"
"$BUILD/shadowkey_step28_euser711_tpoint_test"
