#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "\${BASH_SOURCE[0]}")/.." && pwd)"
OUT="\${1:-\${TMPDIR:-/tmp}/step116_e32inflate}"
WORK="\${TMPDIR:-/tmp}/step117-elf2e32-next"
COMMIT="6a1d311f54098d2e41e43c2117bfbfe08ba00f11"
URL="https://codeload.github.com/fedor4ever/elf2e32_next/tar.gz/\${COMMIT}"
ARCHIVE="$WORK/elf2e32_next.tar.gz"
SRC="$WORK/src"

mkdir -p "$WORK" "$(dirname "$OUT")"
rm -rf "$SRC"
mkdir -p "$SRC"

curl --fail --location --retry 3 --retry-delay 2 --connect-timeout 20 \
  "$URL" -o "$ARCHIVE"
tar -xzf "$ARCHIVE" --strip-components=1 -C "$SRC"

test -f "$SRC/src/common.hpp"
test -f "$SRC/lib/e32/e32common.h"
test -f "$SRC/lib/e32/bpe_manager.cpp"
test -f "$SRC/lib/e32/byte_pair.cpp"
test -f "$SRC/lib/e32/inflate.cpp"
test -f "$SRC/lib/e32/huffman.cpp"
test -f "$SRC/lib/e32/deflatecompress.cpp"

CXX="\${CXX:-g++}"
"$CXX" -std=c++17 -O2 -Wall -Wextra \
  -Wno-unused-parameter -Wno-sign-compare -Wno-misleading-indentation -Wno-shadow \
  -I"$SRC/src" -I"$SRC/lib/e32" -I"$SRC/include" \
  "$ROOT/tools/step116_e32_native_codec.cpp" \
  "$SRC/lib/e32/bpe_manager.cpp" \
  "$SRC/lib/e32/byte_pair.cpp" \
  "$SRC/lib/e32/inflate.cpp" \
  "$SRC/lib/e32/huffman.cpp" \
  "$SRC/lib/e32/deflatecompress.cpp" \
  -o "$OUT"

"$OUT" --self-test

{
  printf 'upstream_repository=https://github.com/fedor4ever/elf2e32_next\n'
  printf 'upstream_commit=%s\n' "$COMMIT"
  printf 'compiler=%s\n' "$("$CXX" --version | head -n 1)"
  printf 'archive_sha256=%s\n' "$(sha256sum "$ARCHIVE" | awk '{print $1}')"
  printf 'binary_sha256=%s\n' "$(sha256sum "$OUT" | awk '{print $1}')"
  printf 'self_test=PASS\n'
} | tee "\${OUT}.manifest.txt"

printf 'Native E32 codec executable: %s\n' "$OUT"
