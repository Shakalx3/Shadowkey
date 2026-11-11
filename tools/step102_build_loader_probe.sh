#!/usr/bin/env bash
set -euo pipefail

ROOT="$GITHUB_WORKSPACE"
SDK_ROOT="/tmp/s60-devkit"
TOOLCHAIN_ROOT="$RUNNER_TEMP/step82-gcce/root"
CONVERTER_ROOT="$RUNNER_TEMP/step99-elf2e32/build"
LIB="$SDK_ROOT/Epoc32/release/armv5/lib"
OUT="$ROOT/firmware-input/STEP102_TINT64_LOADER_PROBE"
DLL="$ROOT/firmware-input/STEP99_TINT64_E32_DLL/ShadowkeyCompat.dll"
mkdir -p "$OUT"

on_error() {
  status=$?
  echo "Step102 failed (exit=$status, line=${BASH_LINENO[0]:-unknown}); command=${BASH_COMMAND}"
  for f in "$OUT/build.log" "$OUT/elf-symbols.txt" "$OUT/elf-symbols-demangled.txt" "$OUT/elf-dynamic.txt" "$OUT/elf2e32.log" "$OUT/e32-dump.txt" "$OUT/probe-disassembly.txt"; do
    if [ -f "$f" ]; then echo "===== $f ====="; tail -n 100 "$f"; fi
  done
  exit "$status"
}
trap on_error ERR

CXX=$(find "$TOOLCHAIN_ROOT" -type f -name arm-none-symbianelf-g++ | head -n1)
LD=$(find "$TOOLCHAIN_ROOT" -type f -name arm-none-symbianelf-ld | head -n1)
READELF=$(find "$TOOLCHAIN_ROOT" -type f -name arm-none-symbianelf-readelf | head -n1)
OBJDUMP=$(find "$TOOLCHAIN_ROOT" -type f -name arm-none-symbianelf-objdump | head -n1)
TARGET_CXXFILT=$(command -v c++filt)
ELF2E32=$(find "$CONVERTER_ROOT" -type f -name elf2e32 -perm -111 | head -n1)
test -x "$CXX" && test -x "$LD" && test -x "$READELF"
test -x "$OBJDUMP" && test -x "$TARGET_CXXFILT" && test -x "$ELF2E32"
test -s "$DLL"
test -f "$LIB/euser.dso"

HOST_READELF=$(command -v readelf)
"$HOST_READELF" --dyn-syms -Ws "$LIB/euser.dso" > "$OUT/euser-dynsym.txt"
"$TARGET_CXXFILT" < "$OUT/euser-dynsym.txt" > "$OUT/euser-dynsym-demangled.txt"
if grep -E 'TInt64::operator!=|TTrap::(Trap|UnTrap)' "$OUT/euser-dynsym-demangled.txt"; then
  echo "Unexpected legacy TInt64/TTrap member export in target EUSER DSO" >&2
  exit 1
fi
printf '%s\n' \
  "PASS: target EUSER DSO has no legacy TInt64::operator!= export" \
  "PASS: target EUSER DSO has no TTrap::Trap/UnTrap export" \
  > "$OUT/STEP102_TARGET_DSO_ABI_CHECK.txt"

GCCE_HEADER="$SDK_ROOT/Epoc32/include/gcce/gcce.h"
VARIANT_DIR="$SDK_ROOT/Epoc32/include/variant"
test -f "$GCCE_HEADER" && test -d "$VARIANT_DIR"
test -f "$SDK_ROOT/Epoc32/include/e32std.h"

# Normalize only the disposable SDK extraction if the legacy preinclude still
# contains Windows separators. The source SDK and repository are not modified.
python3 - "$GCCE_HEADER" <<'PY'
from pathlib import Path
import sys
path = Path(sys.argv[1])
source = path.read_text(encoding="latin-1")
normalized = source.replace(chr(92), "/")
if normalized != source:
    path.write_text(normalized, encoding="latin-1")
PY

# elf2e32 resolves DT_NEEDED by the DSO SONAME, not the SDK's short filename.
SONAME=$("$HOST_READELF" -d "$LIB/euser.dso" | sed -n 's/.*Library soname: \[\(.*\)\].*/\1/p' | head -n1)
if [ -n "$SONAME" ] && [ ! -e "$LIB/$SONAME" ]; then
  ln -s "$(basename "$LIB/euser.dso")" "$LIB/$SONAME"
fi

{
  echo "GCCE=$CXX"
  echo "EUSER_DSO=$LIB/euser.dso"
  echo "ELF2E32=$ELF2E32"
  echo "DLL=$DLL"
} | tee "$OUT/build.log"

"$CXX" -march=armv5te -marm -O1 -fno-exceptions -fno-rtti -fno-builtin -fshort-wchar \
  -D__SYMBIAN32__ -D__EPOC32__ -D__GCCE__ -D__MARM__ -D__MARM_ARMV5__ \
  -D__MARM_THUMB__ -D__MARM_INTERWORK__ -D__EABI__ -D__EXE__ -D_UNICODE \
  -D__S60_3X__ -D__SERIES60_3X__ -D__S60_31__ \
  -I"$SDK_ROOT/Epoc32/include" -I"$VARIANT_DIR" -include "$GCCE_HEADER" \
  -c "$ROOT/source_bundle/host/step102_tint64_loader_probe.cpp" \
  -o "$OUT/probe.o" >> "$OUT/build.log" 2>&1

# This is a genuine EKA2 ELF executable linked against the target EUSER DSO.
"$LD" --no-as-needed -e E32Main -Ttext 0x10000 \
  -o "$OUT/probe.elf" "$OUT/probe.o" "$LIB/euser.dso" \
  >> "$OUT/build.log" 2>&1

"$HOST_READELF" -h "$OUT/probe.elf" > "$OUT/elf-header.txt"
"$HOST_READELF" -s "$OUT/probe.elf" > "$OUT/elf-symbols.txt"
"$HOST_READELF" -d "$OUT/probe.elf" > "$OUT/elf-dynamic.txt"
"$TARGET_CXXFILT" < "$OUT/elf-symbols.txt" > "$OUT/elf-symbols-demangled.txt"
echo "=== Step102 target EABI imports (GNU c++filt) ==="
grep -E 'RLibrary::|User::' "$OUT/elf-symbols-demangled.txt" || true
"$OBJDUMP" -dr "$OUT/probe.o" > "$OUT/probe-disassembly.txt"
grep -q 'RLibrary::Load' "$OUT/elf-symbols-demangled.txt"
grep -q 'RLibrary::Lookup' "$OUT/elf-symbols-demangled.txt"
grep -q 'User::InfoPrint' "$OUT/elf-symbols-demangled.txt"
grep -q 'User::After' "$OUT/elf-symbols-demangled.txt"
if grep -E 'TInt64.*operator|TTrap::(Trap|UnTrap)' "$OUT/elf-symbols-demangled.txt"; then
  echo "Unexpected legacy TInt64/TTrap dependency in the loader probe" >&2
  exit 1
fi
grep -qi 'EUSER' "$OUT/elf-dynamic.txt"

if ! "$ELF2E32" --elfinput="$OUT/probe.elf" \
  --output="$OUT/ShadowkeyAbiProbe.exe" --targettype=EXE \
  --uid1=0x1000007A --uid2=0x100039CE --uid3=0xE000BEF0 \
  --sid=0xE000BEF0 --capability=none --version=1.0 \
  --stack=8192 --heap=4096,1048576 --libpath="$LIB" \
  > "$OUT/elf2e32.log" 2>&1; then
  cat "$OUT/elf2e32.log"
  exit 1
fi
test -s "$OUT/ShadowkeyAbiProbe.exe"
"$ELF2E32" --dump=hi --e32input="$OUT/ShadowkeyAbiProbe.exe" \
  > "$OUT/e32-dump.txt" 2>&1

python3 - "$OUT/ShadowkeyAbiProbe.exe" "$OUT/probe.elf" "$OUT/e32-header.json" "$OUT/e32-dump.txt" <<'PY'
import json
import struct
import sys
from pathlib import Path

image = Path(sys.argv[1]).read_bytes()
elf = Path(sys.argv[2]).read_bytes()
dump = Path(sys.argv[4]).read_text(encoding="utf-8", errors="replace")
if len(image) < 0x7c or image[0x10:0x14] != b"EPOC":
    raise SystemExit("Step102 output is not a valid E32 image")
if len(elf) < 52 or elf[:4] != bytes((127, 69, 76, 70)):
    raise SystemExit("Step102 input is not an ELF image")
u = lambda off: struct.unpack_from("<I", image, off)[0]
entry_offset = u(0x48)
code_base = u(0x4c)
code_size = u(0x30)
elf_entry = struct.unpack_from("<I", elf, 24)[0]
entry_va = (code_base + entry_offset) & 0xffffffff
h = {
    "file_size": len(image),
    "uid1": f"0x{u(0):08X}",
    "uid2": f"0x{u(4):08X}",
    "uid3": f"0x{u(8):08X}",
    "flags": f"0x{u(0x2c):08X}",
    "code_size": code_size,
    "entry_point_offset": f"0x{entry_offset:08X}",
    "entry_point_va": f"0x{entry_va:08X}",
    "elf_entry_point": f"0x{elf_entry:08X}",
    "entry_point_matches_elf": entry_va == elf_entry,
    "dll_ref_count": u(0x54),
    "export_count": u(0x5c),
    "code_offset": u(0x64),
    "import_offset": u(0x6c),
}
assert h["uid1"] == "0x1000007A", h
assert h["uid2"] == "0x100039CE", h
assert h["uid3"] == "0xE000BEF0", h
assert (u(0x2c) & 1) == 0, h
assert code_size > 0 and code_base != 0, h
assert 0 <= entry_offset < code_size, h
assert entry_va == elf_entry, h
assert h["dll_ref_count"] >= 1, h
assert h["export_count"] == 0, h
assert "Built against EKA2" in dump, dump
assert "ARM EABI" in dump, dump
Path(sys.argv[3]).write_text(json.dumps(h, indent=2) + "\n", encoding="utf-8")
print(json.dumps(h, indent=2))
PY

echo "PASS: EKA2 test EXE built with RLibrary::Load/Lookup and EUSER imports" \
  | tee "$OUT/STEP102_BUILD_STATUS.txt"
echo "NOT DEVICE TESTED: runtime loader acceptance still requires the RM-320." \
  | tee -a "$OUT/STEP102_BUILD_STATUS.txt"
cat "$OUT/STEP102_TARGET_DSO_ABI_CHECK.txt"
cat "$OUT/e32-header.json"
cat "$OUT/STEP102_BUILD_STATUS.txt"
