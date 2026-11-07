#!/bin/sh
# Experimental ARM11 static ELF linked at the original E32 code base (0x10000000).
# This is a preparation artifact for elf2e32, NOT an E32Image or a playable game.
set -eu
CC=${CC:-clang}
LD=${LD:-ld.lld}
NM=${NM:-nm}
READELF=${READELF:-readelf}
OUT=arm11_objects
mkdir -p "$OUT"
./build_arm11_core.sh
"$CC" --target=arm-none-eabi -mcpu=arm1136jf-s -marm -std=c11 -ffreestanding -fno-builtin -Iarm11_probe_headers -c arm11_freestanding_stubs.c -o "$OUT/arm11_freestanding_stubs.o"
"$LD" -m armelf_linux_eabi -static --no-undefined -e E32Main -Ttext=0x10000000 \
  -o "$OUT/shadowkey_arm11_symbian_base.elf" \
  "$OUT/shadowkey_arm11_core.o" "$OUT/arm11_freestanding_stubs.o"
file "$OUT/shadowkey_arm11_symbian_base.elf"
"$READELF" -h "$OUT/shadowkey_arm11_symbian_base.elf" | grep -E 'Type:|Machine:|Entry point|Flags:'
ENTRY=$("$READELF" -h "$OUT/shadowkey_arm11_symbian_base.elf" | awk '/Entry point address:/ {print $4}')
TEXT_START=$("$READELF" -S "$OUT/shadowkey_arm11_symbian_base.elf" | awk '$2==".text" {print "0x"$4}')
if "$NM" -u "$OUT/shadowkey_arm11_symbian_base.elf" | grep .; then
  echo "ERROR: unresolved symbols remain" >&2; exit 3
fi
"$NM" -n "$OUT/shadowkey_arm11_symbian_base.elf" | grep -E ' E32Main$'
echo "PASS: static ARM ELF linked with .text at 0x10000000; no undefined symbols."
echo "LIMITATION: E32Main remains a no-op; this ELF still needs Symbian elf2e32 and a real startup/runtime."
