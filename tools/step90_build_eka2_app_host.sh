#!/usr/bin/env bash
set -euo pipefail

WORK="${RUNNER_TEMP:-/tmp}/step90-eka2-host"
OUT="${GITHUB_WORKSPACE}/firmware-input/STEP90_LEGACY_APP_HOST"
SDK_ROOT="/tmp/s60-devkit"
TOOLCHAIN_ROOT="${RUNNER_TEMP:-/tmp}/step82-gcce/root"
ELF2E32_SRC="$WORK/elf2e32-src"
ELF2E32_BUILD="$WORK/elf2e32-build"
mkdir -p "$WORK" "$OUT"
on_error() {
  status=$?
  echo "Step90 failed (exit=$status, line=${BASH_LINENO[0]:-unknown}); build log follows:" >&2
  [ ! -f "$OUT/build.log" ] || tail -n 100 "$OUT/build.log" >&2
  [ ! -f "$OUT/elf2e32-conversion.log" ] || tail -n 100 "$OUT/elf2e32-conversion.log" >&2
  exit "$status"
}
trap on_error ERR
sudo apt-get update -qq
sudo apt-get install -y -qq gcc-multilib g++-multilib libc6-dev-i386

CXX=$(find "$TOOLCHAIN_ROOT" -type f -name arm-none-symbianelf-g++ | head -n1)
LD=$(find "$TOOLCHAIN_ROOT" -type f -name arm-none-symbianelf-ld | head -n1)
READELF=$(find "$TOOLCHAIN_ROOT" -type f -name arm-none-symbianelf-readelf | head -n1)
test -x "$CXX" && test -x "$LD" && test -x "$READELF"
BIN_DIR=$(dirname "$CXX")
export PATH="$BIN_DIR:$PATH"
export LD_LIBRARY_PATH="$BIN_DIR/../lib:$BIN_DIR/../lib32:${LD_LIBRARY_PATH:-}"

LIB="$SDK_ROOT/Epoc32/release/armv5/lib"
for name in euser apparc eikcore; do
  test -f "$LIB/$name.dso" || { echo "missing target import library: $LIB/$name.dso"; exit 2; }
done
find "$SDK_ROOT/Epoc32/include" -iname 'eikstart.h' -o -iname 'aparc.h' > "$OUT/host-sdk-headers.txt"

echo "GCCE compiler: $CXX" | tee "$OUT/build.log"
"$CXX" --version >> "$OUT/build.log" 2>&1
file "$LIB/euser.dso" "$LIB/apparc.dso" "$LIB/eikcore.dso" > "$OUT/import-library-file-types.txt"

SRC="${GITHUB_WORKSPACE}/source_bundle/host/legacy_app_host.cpp"
GCCE_HEADER="$SDK_ROOT/Epoc32/include/gcce/gcce.h"
VARIANT_DIR="$SDK_ROOT/Epoc32/include/variant"
test -f "$GCCE_HEADER"
test -d "$VARIANT_DIR"
test -f "$SDK_ROOT/Epoc32/include/symcpp.h"
test -f "$SDK_ROOT/Epoc32/include/aparc.h"
test -f "$SDK_ROOT/Epoc32/include/eikstart.h"
# The legacy SDK gcce.h uses Windows-style relative include separators.
# Normalize only the temporary extracted SDK copy for Linux GCC preprocessing.
sed -i 's#\\\\#/#g' "$GCCE_HEADER"
{
  echo "GCCE preinclude: $GCCE_HEADER"
  echo "Platform defines: __SYMBIAN32__ __EPOC32__ __GCCE__ __MARM__ __EABI__ __EXE__ __S60_3X__"
} >> "$OUT/build.log"
"$CXX" -march=armv5te -marm -O1 -fno-exceptions -fno-rtti -fno-builtin -fshort-wchar \
  -D__SYMBIAN32__ -D__EPOC32__ -D__GCCE__ -D__MARM__ -D__MARM_ARMV5__ \
  -D__MARM_THUMB__ -D__MARM_INTERWORK__ -D__EABI__ -D__EXE__ -D_UNICODE \
  -D__S60_3X__ -D__SERIES60_3X__ -D__S60_31__ \
  -I"$SDK_ROOT/Epoc32/include" -I"$VARIANT_DIR" \
  -include "$GCCE_HEADER" \
  -c "$SRC" -o "$OUT/legacy_app_host.o" >> "$OUT/build.log" 2>&1

echo "Linking host ELF against EUSER, APPARC and EIKCORE import DSOs" | tee -a "$OUT/build.log"
LINK_MODE="direct-import-dso"
if ! "$LD" -e E32Main -Ttext 0x10000 -o "$OUT/legacy_app_host.elf" \
    "$OUT/legacy_app_host.o" "$LIB/euser.dso" "$LIB/apparc.dso" "$LIB/eikcore.dso" \
    >> "$OUT/build.log" 2>&1; then
  echo "Direct DSO link failed; retrying with unresolved symbols for elf2e32 import resolution" | tee -a "$OUT/build.log"
  LINK_MODE="elf2e32-libpath"
  "$LD" -e E32Main -Ttext 0x10000 --unresolved-symbols=ignore-all \
    -o "$OUT/legacy_app_host.elf" "$OUT/legacy_app_host.o" >> "$OUT/build.log" 2>&1
fi
"$READELF" -h "$OUT/legacy_app_host.elf" > "$OUT/host-elf-header.txt"
"$READELF" -A "$OUT/legacy_app_host.elf" > "$OUT/host-elf-attributes.txt"
"$READELF" -s "$OUT/legacy_app_host.elf" > "$OUT/host-elf-symbols.txt"

echo "Build portable elf2e32" | tee -a "$OUT/build.log"
if [ ! -d "$ELF2E32_SRC/.git" ]; then
  git clone --depth 1 https://github.com/fedor4ever/elf2e32.git "$ELF2E32_SRC"
fi
cmake -S "$ELF2E32_SRC" -B "$ELF2E32_BUILD" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
  -DCMAKE_C_FLAGS=-m32 \
  -DCMAKE_CXX_FLAGS="-m32 -std=gnu++14 -D__LINUX__ -include string.h" \
  -DCMAKE_EXE_LINKER_FLAGS=-m32 >> "$OUT/build.log" 2>&1
cmake --build "$ELF2E32_BUILD" --parallel 2 >> "$OUT/build.log" 2>&1
ELF2E32="$ELF2E32_BUILD/elf2e32"
if [ ! -x "$ELF2E32" ]; then
  ELF2E32=$(find "$ELF2E32_BUILD" -type f -name elf2e32 -perm -111 | head -n1)
fi
test -x "$ELF2E32"
"$ELF2E32" --help > "$OUT/elf2e32-help.txt" 2>&1 || true

echo "Convert EKA2 host ELF to E32 EXE" | tee -a "$OUT/build.log"
"$ELF2E32" --elfinput="$OUT/legacy_app_host.elf" \
  --output="$OUT/6R51Host.exe" \
  --targettype=EXE \
  --uid1=0x1000007A --uid2=0x100039CE --uid3=0xE000BEEF \
  --sid=0xE000BEEF --capability=none --version=1.0 \
  --stack=8192 --heap=4096,1048576 --libpath="$LIB" \
  > "$OUT/elf2e32-conversion.log" 2>&1

test -s "$OUT/6R51Host.exe"
python3 - "$OUT/6R51Host.exe" "$OUT/host-e32-header.json" <<'PY'
import json, struct, sys
from pathlib import Path
p=Path(sys.argv[1]); d=p.read_bytes()
if len(d)<0x7c or d[0x10:0x14]!=b"EPOC":
    raise SystemExit("converted output is not a valid E32 image")
u=lambda o: struct.unpack_from("<I",d,o)[0]
h={
 "file_size":len(d),
 "uid1":f"0x{u(0):08X}",
 "uid2":f"0x{u(4):08X}",
 "uid3":f"0x{u(8):08X}",
 "flags":f"0x{u(0x2c):08X}",
 "code_size":u(0x30),
 "entry_point":f"0x{u(0x48):08X}",
 "code_base":f"0x{u(0x4c):08X}",
 "dll_ref_count":u(0x54),
 "export_count":u(0x5c),
 "code_offset":u(0x64),
 "import_offset":u(0x6c),
}
Path(sys.argv[2]).write_text(json.dumps(h,indent=2)+"\n")
assert h["uid1"]=="0x1000007A", h
assert h["uid2"]=="0x100039CE", h
assert h["uid3"]=="0xE000BEEF", h
assert h["entry_point"]!="0x00000000", h
print(json.dumps(h,indent=2))
PY

cat > "$OUT/STEP90_BUILD_REPORT.md" <<EOF
# Step90 — EKA2 host EXE prototype

- Compiler: $CXX
- Link mode: $LINK_MODE
- Target SDK: $SDK_ROOT
- Target import libraries: EUSER, APPARC, EIKCORE
- Host source: source_bundle/host/legacy_app_host.cpp
- E32 output: 6R51Host.exe
- UID3/SID: 0xE000BEEF (development prototype; capability set is currently none)

The host dynamically loads \`6R51\`, looks up ordinal 1, wraps it in \`TApaApplicationFactory\`, and calls \`EikStart::RunApplication\`.

This verifies the EKA2 host build path only. It does not prove that the original APP DLL or its dependencies load successfully on the N95.
EOF

echo "Step90 host build completed: $OUT/6R51Host.exe"
