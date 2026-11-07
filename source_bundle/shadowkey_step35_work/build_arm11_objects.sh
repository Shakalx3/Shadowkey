#!/bin/sh
# Cross-compile the recovered guest code for the ARM11 CPU used by Nokia N95.
# Output is ARM EABI relocatable object code, NOT a Symbian E32 executable.
set -eu
CC=${CC:-clang}
OUT=arm11_objects
mkdir -p "$OUT"
FLAGS="--target=arm-none-eabi -mcpu=arm1136jf-s -marm -std=c11 -O0 -w"
for src in \
  shadowkey_lifted_v6.c \
  simkin_lifted_runtime_v4.c \
  shadowkey_function_registry.c \
  shadowkey_import_dispatch.c \
  simkin_function_registry.c \
  simkin_export_registry.c \
  simkin_import_dispatch.c; do
  obj="$OUT/${src%.c}.o"
  echo "[ARM11] $src"
  "$CC" $FLAGS -c "$src" -o "$obj"
done
file "$OUT"/*.o
