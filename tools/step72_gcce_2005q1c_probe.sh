#!/usr/bin/env bash
set -euo pipefail

WORK="${RUNNER_TEMP:-/tmp}/step72-gcce-2005q1c"
OUT="${GITHUB_WORKSPACE}/step72-probe"
SDK_ARCHIVE="$WORK/s60-sdk.tar.gz"
TOOLCHAIN_ARCHIVE="$WORK/gcce-2005q1c.tar.bz2"
SDK_ROOT="$WORK/sdk"
TOOLCHAIN_ROOT="$WORK/gcce"
ELF2E32_SRC="$WORK/elf2e32-src"
ELF2E32_BUILD="$WORK/elf2e32-build"

mkdir -p "$WORK" "$OUT" "$SDK_ROOT" "$TOOLCHAIN_ROOT"

echo "Installing 32-bit runtime dependencies for the original CodeSourcery toolchain"
sudo dpkg --add-architecture i386
sudo apt-get update -qq
sudo apt-get install -y -qq libc6-i386 lib32stdc++6 lib32gcc-s1 lib32z1

echo "Downloading pinned S60 3.1 FP1 SDK"
curl -fL --retry 3 \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  -H "Accept: application/octet-stream" \
  "https://api.github.com/repos/Shakalx3/Shadowkey/releases/assets/723972349" \
  -o "$SDK_ARCHIVE"
SDK_SHA=$(sha256sum "$SDK_ARCHIVE" | awk '{print $1}')
test "$SDK_SHA" = "7ed8b62b15f191ca47d2f6ca97ee5ce74cd02ce3e42b74bc7b1f9513d7df87b5"
tar -xzf "$SDK_ARCHIVE" -C "$SDK_ROOT"

echo "Downloading original CodeSourcery GCCE 2005Q1C"
TOOLCHAIN_URL="https://www.martin.st/symbian/gnu-csl-arm-2005Q1C-arm-none-symbianelf-i686-pc-linux-gnu.tar.bz2"
curl -fL --retry 3 "$TOOLCHAIN_URL" -o "$TOOLCHAIN_ARCHIVE"
TOOLCHAIN_SIZE=$(stat -c '%s' "$TOOLCHAIN_ARCHIVE")
TOOLCHAIN_MD5=$(md5sum "$TOOLCHAIN_ARCHIVE" | awk '{print $1}')
TOOLCHAIN_SHA=$(sha256sum "$TOOLCHAIN_ARCHIVE" | awk '{print $1}')
test "$TOOLCHAIN_SIZE" = "10896869"
test "$TOOLCHAIN_MD5" = "622e4db70cfae6a9eec26892a9932633"
tar -xjf "$TOOLCHAIN_ARCHIVE" -C "$TOOLCHAIN_ROOT"

CC=$(find "$TOOLCHAIN_ROOT" -type f -name arm-none-symbianelf-gcc | head -n1)
LD=$(find "$TOOLCHAIN_ROOT" -type f -name arm-none-symbianelf-ld | head -n1)
READELF=$(find "$TOOLCHAIN_ROOT" -type f -name arm-none-symbianelf-readelf | head -n1)
test -x "$CC"
test -x "$LD"
test -x "$READELF"
BIN_DIR=$(dirname "$CC")
export PATH="$BIN_DIR:$PATH"
export LD_LIBRARY_PATH="$BIN_DIR/../lib:$BIN_DIR/../lib32:${LD_LIBRARY_PATH:-}"

echo "Compiler identity"
"$CC" --version | tee "$OUT/gcce-version.txt"
file "$CC" | tee "$OUT/gcce-file.txt"
ldd "$CC" | tee "$OUT/gcce-ldd.txt" || true

cat > "$WORK/probe.c" <<'EOF'
int E32Main(void) { return 0; }
EOF

echo "Compile and link minimal ARMv5TE E32Main"
"$CC" -march=armv5te -ffreestanding -fno-builtin -c "$WORK/probe.c" -o "$WORK/probe.o"
"$LD" -e E32Main -Ttext 0x10000 -o "$WORK/probe.elf" "$WORK/probe.o"
"$READELF" -h "$WORK/probe.o" > "$OUT/probe-object-header.txt"
"$READELF" -A "$WORK/probe.o" > "$OUT/probe-object-attributes.txt"
"$READELF" -h "$WORK/probe.elf" > "$OUT/probe-elf-header.txt"
"$READELF" -A "$WORK/probe.elf" > "$OUT/probe-elf-attributes.txt"

LIB="$SDK_ROOT/Epoc32/release/armv5/lib"
"$READELF" -h "$LIB/euser.dso" > "$OUT/euser-dso-header.txt"
"$READELF" -h "$LIB/cone.dso" > "$OUT/cone-dso-header.txt"
"$READELF" -h "$LIB/gdi.dso" > "$OUT/gdi-dso-header.txt"

echo "Build portable elf2e32 replacement"
git clone --depth 1 https://github.com/fedor4ever/elf2e32.git "$ELF2E32_SRC"
cmake -S "$ELF2E32_SRC" -B "$ELF2E32_BUILD" -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5
cmake --build "$ELF2E32_BUILD" --parallel 2
ELF2E32="$ELF2E32_BUILD/elf2e32"
if [ ! -x "$ELF2E32" ]; then ELF2E32=$(find "$ELF2E32_BUILD" -type f -name elf2e32 -perm -111 | head -n1); fi
test -x "$ELF2E32"
"$ELF2E32" --help > "$OUT/elf2e32-help.txt" 2>&1 || true

echo "Attempt EABI4 ELF to E32 conversion"
set +e
"$ELF2E32" --elfinput="$WORK/probe.elf" --output="$OUT/probe.e32" \
  --targettype=EXE --uid1=0x1000007A --uid2=0x20000001 --uid3=0x20000001 \
  --sid=0x20000001 --capability=none --version=1.0 --stack=8192 \
  --heap=4096,1048576 --libpath="$LIB" > "$OUT/elf2e32-conversion.txt" 2>&1
CONVERT_EXIT=$?
set -e

if [ -f "$OUT/probe.e32" ]; then
  stat -c '%s' "$OUT/probe.e32" > "$OUT/probe-e32-size.txt"
  sha256sum "$OUT/probe.e32" > "$OUT/probe-e32-sha256.txt"
  xxd -l 64 "$OUT/probe.e32" > "$OUT/probe-e32-first64.txt"
fi

cat > "$OUT/STEP72_GCCE_2005Q1C_PROBE.md" <<EOF
# Step72 — original GCCE 2005Q1C probe

- Toolchain URL: $TOOLCHAIN_URL
- Toolchain size: $TOOLCHAIN_SIZE
- Toolchain MD5: $TOOLCHAIN_MD5
- Toolchain SHA-256: $TOOLCHAIN_SHA
- SDK SHA-256: $SDK_SHA
- Compiler: $CC
- ELF conversion exit: $CONVERT_EXIT
- E32 created: $([ -f "$OUT/probe.e32" ] && echo yes || echo no)

See the adjacent readelf and converter logs for EABI flags and details.
EOF

cp "$WORK/probe.o" "$OUT/probe.o"
cp "$WORK/probe.elf" "$OUT/probe.elf"
echo "Step72 complete; conversion exit=$CONVERT_EXIT; E32 created=$([ -f "$OUT/probe.e32" ] && echo yes || echo no)"
