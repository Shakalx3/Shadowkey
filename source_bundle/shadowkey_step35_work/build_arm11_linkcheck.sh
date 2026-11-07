#!/bin/sh
# Produces a statically linked ARM ELF solely to validate the native linker stage.
# The E32Main stub returns immediately; this is NOT a playable or device-ready game.
set -eu
CC=${CC:-clang}
LD=${LD:-ld.lld}
NM=${NM:-nm}
OUT=arm11_objects
mkdir -p "$OUT"
./build_arm11_core.sh
"$CC" --target=arm-none-eabi -mcpu=arm1136jf-s -marm -std=c11 -ffreestanding -fno-builtin -Iarm11_probe_headers -c arm11_freestanding_stubs.c -o "$OUT/arm11_freestanding_stubs.o"
"$LD" -m armelf_linux_eabi -static --no-undefined -e E32Main -Ttext=0x8000 \
  -o "$OUT/shadowkey_arm11_linkcheck.elf" \
  "$OUT/shadowkey_arm11_core.o" "$OUT/arm11_freestanding_stubs.o"
file "$OUT/shadowkey_arm11_linkcheck.elf"
readelf -h "$OUT/shadowkey_arm11_linkcheck.elf" | grep -E 'Type:|Machine:|Entry point|Flags:'
if "$NM" -u "$OUT/shadowkey_arm11_linkcheck.elf" | grep .; then
  echo "ERROR: unresolved symbols remain" >&2
  exit 3
fi
echo "PASS: statically linked ARM ELF; no undefined symbols. E32Main is deliberately a no-op stub."
