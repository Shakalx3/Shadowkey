#!/bin/sh
# Build the lifted guest runtime as ARM11/EABI relocatable objects.
# Requires clang + ld.lld. This does NOT create a Symbian E32Image.
set -eu
CC=${CC:-clang}
LD=${LD:-ld.lld}
OUT=arm11_objects
mkdir -p "$OUT"
FLAGS="--target=arm-none-eabi -mcpu=arm1136jf-s -marm -std=c11 -O0 -w -Iarm11_probe_headers"
for src in shadowkey_lifted_v6.c simkin_lifted_runtime_v4.c shadowkey_function_registry.c shadowkey_import_dispatch.c shadowkey_dispatch_trace.c shadowkey_hle_bootstrap_v2.c shadowkey_cone_gc_hle.c shadowkey_fbs_hle.c shadowkey_bitgdi_hle.c simkin_function_registry.c simkin_export_registry.c simkin_import_dispatch.c arm_fallback.c shadowkey_runtime_core.c; do
  obj="$OUT/${src%.c}.o"
  if [ ! -f "$obj" ] || [ "$src" -nt "$obj" ]; then
    echo "[ARM11] $src"
    "$CC" $FLAGS -c "$src" -o "$obj"
  else
    echo "[ARM11] up to date: $src"
  fi
done
needs_link=0
[ -f "$OUT/shadowkey_arm11_core.o" ] || needs_link=1
for obj in "$OUT"/*.o; do
  [ "$obj" = "$OUT/shadowkey_arm11_core.o" ] && continue
  [ "$obj" -nt "$OUT/shadowkey_arm11_core.o" ] && needs_link=1
done
if [ "$needs_link" -eq 1 ]; then
"$LD" -r -m armelf_linux_eabi -o "$OUT/shadowkey_arm11_core.o" \
 "$OUT/shadowkey_lifted_v6.o" "$OUT/simkin_lifted_runtime_v4.o" \
 "$OUT/shadowkey_function_registry.o" "$OUT/shadowkey_import_dispatch.o" \
 "$OUT/shadowkey_dispatch_trace.o" "$OUT/shadowkey_hle_bootstrap_v2.o" "$OUT/shadowkey_cone_gc_hle.o" "$OUT/shadowkey_fbs_hle.o" "$OUT/shadowkey_bitgdi_hle.o" \
 "$OUT/simkin_function_registry.o" "$OUT/simkin_export_registry.o" \
 "$OUT/simkin_import_dispatch.o" "$OUT/arm_fallback.o" "$OUT/shadowkey_runtime_core.o"
fi
file "$OUT/shadowkey_arm11_core.o"
