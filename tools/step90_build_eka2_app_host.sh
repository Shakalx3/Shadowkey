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
find "$SDK_ROOT/Epoc32/include" -iname 'eikstart.h' -o -iname 'apparc.h' > "$OUT/host-sdk-headers.txt"

echo "GCCE compiler: $CXX" | tee "$OUT/build.log"
"$CXX" --version >> "$OUT/build.log" 2>&1
file "$LIB/euser.dso" "$LIB/apparc.dso" "$LIB/eikcore.dso" > "$OUT/import-library-file-types.txt"

SRC="${GITHUB_WORKSPACE}/source_bundle/host/legacy_app_host.cpp"
GCCE_HEADER="$SDK_ROOT/Epoc32/include/gcce/gcce.h"
VARIANT_DIR="$SDK_ROOT/Epoc32/include/variant"
test -f "$GCCE_HEADER"
test -d "$VARIANT_DIR"
test -f "$SDK_ROOT/Epoc32/include/symcpp.h"
test -f "$SDK_ROOT/Epoc32/include/apparc.h"
test -f "$SDK_ROOT/Epoc32/include/eikstart.h"
# The legacy SDK gcce.h uses Windows-style relative include separators.
# Normalize only the temporary extracted SDK copy for Linux GCC preprocessing.
python3 - "$GCCE_HEADER" <<'PY'
from pathlib import Path
import sys
path = Path(sys.argv[1])
text = path.read_text(encoding="latin-1")
path.write_text(text.replace(chr(92), "/"), encoding="latin-1")
PY
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
if ! "$LD" --no-as-needed -e E32Main -Ttext 0x10000 -o "$OUT/legacy_app_host.elf" \
    "$OUT/legacy_app_host.o" "$LIB/euser.dso" "$LIB/apparc.dso" "$LIB/eikcore.dso" \
    >> "$OUT/build.log" 2>&1; then
  echo "Direct DSO link failed; retrying with unresolved symbols for elf2e32 import resolution" | tee -a "$OUT/build.log"
  LINK_MODE="elf2e32-libpath"
  "$LD" --no-as-needed -e E32Main -Ttext 0x10000 --unresolved-symbols=ignore-all \
    -o "$OUT/legacy_app_host.elf" "$OUT/legacy_app_host.o" >> "$OUT/build.log" 2>&1
fi
"$READELF" -h "$OUT/legacy_app_host.elf" > "$OUT/host-elf-header.txt"
"$READELF" -A "$OUT/legacy_app_host.elf" > "$OUT/host-elf-attributes.txt"
"$READELF" -s "$OUT/legacy_app_host.elf" > "$OUT/host-elf-symbols.txt"
"$READELF" -d "$OUT/legacy_app_host.elf" > "$OUT/host-elf-dynamic.txt"
"$READELF" -V "$OUT/legacy_app_host.elf" > "$OUT/host-elf-versions.txt"

echo "Build portable elf2e32" | tee -a "$OUT/build.log"
if [ ! -d "$ELF2E32_SRC/.git" ]; then
  git clone --depth 1 https://github.com/fedor4ever/elf2e32.git "$ELF2E32_SRC"
fi
cmake -S "$ELF2E32_SRC" -B "$ELF2E32_BUILD" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
  -DCMAKE_C_FLAGS=-m32 \
  -DCMAKE_CXX_FLAGS="-m32 -std=gnu++14 -D__LINUX__ -include string.h -include string -include strings.h -Dstricmp=strcasecmp -Dstrnicmp=strncasecmp" \
  -DCMAKE_EXE_LINKER_FLAGS=-m32 >> "$OUT/build.log" 2>&1
cmake --build "$ELF2E32_BUILD" --parallel 2 >> "$OUT/build.log" 2>&1
ELF2E32="$ELF2E32_BUILD/elf2e32"
if [ ! -x "$ELF2E32" ]; then
  ELF2E32=$(find "$ELF2E32_BUILD" -type f -name elf2e32 -perm -111 | head -n1)
fi
test -x "$ELF2E32"
"$ELF2E32" --help > "$OUT/elf2e32-help.txt" 2>&1 || true

# elf2e32 resolves DT_NEEDED entries by the DSO SONAME, not necessarily by
# the SDK archive's short on-disk filename (e.g. APPARC{000a0000}.dso vs
# apparc.dso). Create temporary aliases inside the extracted SDK tree.
: > "$OUT/soname-aliases.txt"
for dso in "$LIB"/*.dso; do
  [ -f "$dso" ] || continue
  soname=$("$READELF" -d "$dso" | sed -n 's/.*Library soname: \[\(.*\)\].*/\1/p' | head -n1)
  [ -n "$soname" ] || continue
  if [ ! -e "$LIB/$soname" ]; then
    ln -s "$(basename "$dso")" "$LIB/$soname"
    printf '%s -> %s\n' "$soname" "$(basename "$dso")" >> "$OUT/soname-aliases.txt"
  fi
done

echo "Convert EKA2 host ELF to E32 EXE" | tee -a "$OUT/build.log"
"$ELF2E32" --elfinput="$OUT/legacy_app_host.elf" \
  --output="$OUT/6R51Host.exe" \
  --targettype=EXE \
  --uid1=0x1000007A --uid2=0x100039CE --uid3=0xE000BEEF \
  --sid=0xE000BEEF --capability=none --version=1.0 \
  --stack=8192 --heap=4096,1048576 --libpath="$LIB" \
  > "$OUT/elf2e32-conversion.log" 2>&1

test -s "$OUT/6R51Host.exe"
"$ELF2E32" --dump=hi --e32input="$OUT/6R51Host.exe" > "$OUT/host-e32-dump.txt" 2>&1

python3 - "$OUT/6R51Host.exe" "$OUT/host-e32-header.json" "$OUT/legacy_app_host.elf" "$OUT/host-e32-dump.txt" "$OUT/host-e32-validated.txt" <<'PY'
import json, struct, sys
from pathlib import Path
p=Path(sys.argv[1]); d=p.read_bytes()
elf=Path(sys.argv[3]).read_bytes()
dump=Path(sys.argv[4]).read_text(encoding="utf-8",errors="replace")
if len(d)<0x7c or d[0x10:0x14]!=b"EPOC":
    raise SystemExit("converted output is not a valid E32 image")
if len(elf)<52 or elf[:4]!=bytes((127,69,76,70)):
    raise SystemExit("host input is not an ELF image")
u=lambda o: struct.unpack_from("<I",d,o)[0]
elf_entry=struct.unpack_from("<I",elf,24)[0]
entry_offset=u(0x48)
code_base=u(0x4c)
code_size=u(0x30)
entry_va=(code_base+entry_offset)&0xffffffff
h={
 "file_size":len(d),
 "uid1":f"0x{u(0):08X}",
 "uid2":f"0x{u(4):08X}",
 "uid3":f"0x{u(8):08X}",
 "flags":f"0x{u(0x2c):08X}",
 "code_size":code_size,
 "entry_point_offset":f"0x{entry_offset:08X}",
 "entry_point_va":f"0x{entry_va:08X}",
 "elf_entry_point":f"0x{elf_entry:08X}",
 "entry_point_matches_elf":entry_va==elf_entry,
 "code_base":f"0x{code_base:08X}",
 "dll_ref_count":u(0x54),
 "export_count":u(0x5c),
 "code_offset":u(0x64),
 "import_offset":u(0x6c),
 "elf2e32_dump_bytes":len(dump.encode("utf-8")),
}
Path(sys.argv[2]).write_text(json.dumps(h,indent=2)+"\n")
assert h["uid1"]=="0x1000007A", h
assert h["uid2"]=="0x100039CE", h
assert h["uid3"]=="0xE000BEEF", h
assert code_size>0 and code_base!=0, h
assert code_base <= entry_va < code_base+code_size, h
assert entry_va==elf_entry, h
assert u(0x54)==3, h
assert len(dump.strip())>0, "elf2e32 did not produce a header/import dump"
Path(sys.argv[5]).write_text(
    "PASS\n"
    f"entry_point_va={entry_va:#010x}\n"
    f"ELF_e_entry={elf_entry:#010x}\n"
    f"dll_ref_count={u(0x54)}\n"
    "elf2e32_header_and_import_dump=present\n",
    encoding="utf-8"
)
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
