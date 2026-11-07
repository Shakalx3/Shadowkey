#!/bin/sh
set -eu
CC=${CC:-clang}
BUILD=.build
mkdir -p "$BUILD"
$CC -std=c11 -O2 -Wall -Wextra -Werror shadowkey_arm_shift_test.c -o "$BUILD/shadowkey_arm_shift_test"
"$BUILD/shadowkey_arm_shift_test"
