#!/bin/sh
set -eu
CC=${CC:-clang}
mkdir -p .build
$CC -std=c11 -O0 -Wall -Wextra -I. shadowkey_step23_drawtext_abi_test.c shadowkey_bitgdi_hle.c -o .build/shadowkey_step23_drawtext_abi_test
.build/shadowkey_step23_drawtext_abi_test > .build/step23_drawtext_abi_test.log 2>&1
cat .build/step23_drawtext_abi_test.log
grep -q 'PASS: DrawText ABI register/stack decode; TPoint coordinates' .build/step23_drawtext_abi_test.log
