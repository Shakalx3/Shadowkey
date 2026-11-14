#!/usr/bin/env bash
set -euo pipefail

WORK="${RUNNER_TEMP:-/tmp}/step90-eka2-host"
OUT="${GITHUB_WORKSPACE}/firmware-input/STEP90_LEGACY_APP_HOST"
E32_UID3="${STEP90_UID3:-0xE000BEEF}"
E32_OUTPUT="${STEP90_OUTPUT_NAME:-6R51Host.exe}"
SDK_ROOT="/tmp/s60-devkit"
TOOLCHAIN_ROOT="${RUNNER_TEMP:-/tmp}/step82-gcce/root"
ELF2E32_SRC="$WORK/elf2e32-src"
ELF2E32_BUILD="$WORK/elf2e32-build"
mkdir -p "$WORK" "$OUT"
on_error() {
  status=$?
  echo "Step90 failed (exit=$status, line=${BASH_LINENO[0]:-unknown}); build log follows:" >&2
  [ ! -f "$OUT/build.log" ] || tail -n 100 "$OUT/build.log" >&2
  [ ! -f "$OUT/build.log" ] || grep -E 'Target AVKON exports|CAknAppUi|CAknApplication|CAknDocument|DSO files containing|_ZN9CAknAppUi' "$OUT/build.log" >&2 || true
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
for name in euser apparc eikcore avkon; do
  test -f "$LIB/$name.dso" || { echo "missing target import library: $LIB/$name.dso"; exit 2; }
done
find "$SDK_ROOT/Epoc32/include" -iname 'eikstart.h' -o -iname 'apparc.h' > "$OUT/host-sdk-headers.txt"

echo "GCCE compiler: $CXX" | tee "$OUT/build.log"
"$CXX" --version >> "$OUT/build.log" 2>&1
file "$LIB/euser.dso" "$LIB/apparc.dso" "$LIB/eikcore.dso" "$LIB/avkon.dso" > "$OUT/import-library-file-types.txt"
{
  echo "Target AVKON exports relevant to application construction/destruction:"
  readelf --wide -Ws "$LIB/avkon.dso" | c++filt | grep -E 'CAknAppUi::(CAknAppUi|~CAknAppUi)|CAknApplication::(CAknApplication|~CAknApplication)|CAknDocument::(CAknDocument|~CAknDocument)' || true
  echo "DSO files containing raw CAknAppUi ctor/dtor ABI names:"
  for symbol in _ZN9CAknAppUiC1Ev _ZN9CAknAppUiC2Ev _ZN9CAknAppUiD0Ev _ZN9CAknAppUiD1Ev _ZN9CAknAppUiD2Ev; do
    printf '%s: ' "$symbol"
    grep -a -l -F "$symbol" "$LIB"/*.dso 2>/dev/null | sed "s#$LIB/##g" | tr '\n' ' '
    echo
  done
} >> "$OUT/build.log"

SRC="${STEP90_SOURCE:-${GITHUB_WORKSPACE}/source_bundle/host/legacy_app_host.cpp}"
GCCE_HEADER="$SDK_ROOT/Epoc32/include/gcce/gcce.h"
VARIANT_DIR="$SDK_ROOT/Epoc32/include/variant"
test -f "$GCCE_HEADER"
test -d "$VARIANT_DIR"
test -f "$SDK_ROOT/Epoc32/include/symcpp.h"
test -f "$SDK_ROOT/Epoc32/include/apparc.h"
test -f "$SDK_ROOT/Epoc32/include/eikstart.h"
# The original Windows SDK was extracted on a case-sensitive Linux filesystem.
# Symbian's SDK was authored for Windows and contains mixed-case include paths.
# Build temporary aliases for every referenced include whose path differs only
# by case; this changes only the disposable SDK extraction on the CI runner.
python3 - "$SDK_ROOT/Epoc32/include" <<'PY'
from pathlib import Path
import os
import re
import sys

root = Path(sys.argv[1])

# The ECom include is referenced with an uppercase directory name on Linux.
ecom_candidates = [p for p in root.iterdir() if p.is_dir() and p.name.casefold() == "ecom"]
if ecom_candidates and not (root / "Ecom").exists():
    (root / "Ecom").symlink_to(ecom_candidates[0], target_is_directory=True)

def resolve_casefold(base, include):
    current = base
    for part in include.replace(chr(92), "/").split("/"):
        if part in ("", "."):
            continue
        if part == "..":
            current = current.parent
            continue
        direct = current / part
        if direct.exists():
            current = direct
            continue
        try:
            matches = [p for p in current.iterdir() if p.name.casefold() == part.casefold()]
        except (FileNotFoundError, NotADirectoryError):
            return None
        if not matches:
            return None
        current = matches[0]
    return current if current.exists() else None

include_re = re.compile(r'^\s*#\s*include\s*[<"]([^>"]+)[>"]', re.M)
headers = list(root.rglob("*.h")) + list(root.rglob("*.hrh")) + list(root.rglob("*.inl"))
aliases = 0
for header in headers:
    try:
        content = header.read_text(encoding="latin-1")
    except OSError:
        continue
    for include in include_re.findall(content):
        if include.startswith(("/", "\\", "$")):
            continue
        bases = [header.parent, root]
        for base in bases:
            expected = base / include.replace(chr(92), "/")
            if expected.exists():
                break
            target = resolve_casefold(base, include)
            if target is None or target == expected:
                continue
            expected.parent.mkdir(parents=True, exist_ok=True)
            if not expected.exists():
                expected.symlink_to(os.path.relpath(target, expected.parent))
                aliases += 1
            break
print(f"Created {aliases} case-normalized SDK include aliases from {len(headers)} headers.")
PY
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

echo "Linking host ELF against EUSER, APPARC, EIKCORE and AVKON import DSOs" | tee -a "$OUT/build.log"
LINK_MODE="direct-import-dso"
if ! "$LD" --no-as-needed -e E32Main -Ttext 0x10000 -o "$OUT/legacy_app_host.elf" \
    "$OUT/legacy_app_host.o" "$LIB/euser.dso" "$LIB/apparc.dso" "$LIB/eikcore.dso" "$LIB/avkon.dso" \
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
  --output="$OUT/$E32_OUTPUT" \
  --targettype=EXE \
  --uid1=0x1000007A --uid2=0x100039CE --uid3="$E32_UID3" \
  --sid="$E32_UID3" --capability=none --version=1.0 \
  --stack=8192 --heap=4096,1048576 --libpath="$LIB" \
  > "$OUT/elf2e32-conversion.log" 2>&1

test -s "$OUT/$E32_OUTPUT"
"$ELF2E32" --dump=hi --e32input="$OUT/$E32_OUTPUT" > "$OUT/host-e32-dump.txt" 2>&1

python3 - "$OUT/$E32_OUTPUT" "$OUT/host-e32-header.json" "$OUT/legacy_app_host.elf" "$OUT/host-e32-dump.txt" "$OUT/host-e32-validated.txt" "$E32_UID3" <<'PY'
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
expected_uid3 = "0x" + f"{int(sys.argv[6], 0):08X}"
assert h["uid3"] == expected_uid3, h
assert code_size>0 and code_base!=0, h
assert code_base <= entry_va < code_base+code_size, h
assert entry_va==elf_entry, h
assert u(0x54)>=4, h
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
- Target import libraries: EUSER, APPARC, EIKCORE, AVKON
- Host source: source_bundle/host/legacy_app_host.cpp
- E32 output: 6R51Host.exe
- UID3/SID: 0xE000BEEF (development prototype; capability set is currently none)

The host dynamically loads \`6R51\`, looks up ordinal 1, wraps it in \`TApaApplicationFactory\`, and calls \`EikStart::RunApplication\`.

This verifies the EKA2 host build path only. It does not prove that the original APP DLL or its dependencies load successfully on the N95.
EOF

echo "Step90 host build completed: $OUT/$E32_OUTPUT"
