#!/bin/sh
set -eu
CC=${CC:-clang}
BUILD=.build
mkdir -p "$BUILD"
$CC -std=c11 -O0 -w -c shadowkey_hle_bootstrap_v2.c -o "$BUILD/shadowkey_hle_bootstrap_v2.o"
$CC -std=c11 -O0 -w shadowkey_step25_core_hle_test.c \
  "$BUILD/shadowkey_hle_bootstrap_v2.o" "$BUILD/shadowkey_bitgdi_hle.o" \
  "$BUILD/shadowkey_fbs_hle.o" -o "$BUILD/shadowkey_step25_core_hle_test"
"$BUILD/shadowkey_step25_core_hle_test"
