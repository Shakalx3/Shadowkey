#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${1:-${TMPDIR:-/tmp}/step116_e32inflate}"
WORK="${TMPDIR:-/tmp}/step117-elf2e32-next"
COMMIT="6a1d311f54098d2e41e43c2117bfbfe08ba00f11"
BASE="https://raw.githubusercontent.com/fedor4ever/elf2e32_next/${COMMIT}"
SRC="$WORK/src"

mkdir -p "$WORK" "$(dirname "$OUT")"
rm -rf "$SRC"
mkdir -p "$SRC"

fetch_upstream() {
  local path="$1"
  mkdir -p "$SRC/$(dirname "$path")"
  curl --fail --location --retry 3 --retry-delay 2 --connect-timeout 20 \
    "$BASE/$path" -o "$SRC/$path"
}

# Fetch only the pinned, audited codec translation units and their direct headers.
# Raw-file URLs avoid relying on Git smart-HTTP or codeload archive routing.
SOURCE_FILES=(
  "src/common.hpp"
  "include/elf2e32_version.hpp"
  "lib/e32/e32common.h"
  "lib/e32/e32compressor.h"
  "lib/e32/byte_pair.h"
  "lib/e32/byte_pair.cpp"
  "lib/e32/bpe_manager.cpp"
  "lib/e32/inflate.h"
  "lib/e32/inflate.cpp"
  "lib/e32/huffman.h"
  "lib/e32/huffman.cpp"
  "lib/e32/farray.h"
  "lib/e32/deflatecompress.cpp"
)
for path in "${SOURCE_FILES[@]}"; do
  fetch_upstream "$path"
done

CXX="${CXX:-g++}"
"$CXX" -std=c++17 -O1 -g -Wall -Wextra -fsanitize=address,undefined -fno-omit-frame-pointer \
  -Wno-unused-parameter -Wno-sign-compare -Wno-misleading-indentation -Wno-shadow \
  -include cstdint \
  -I"$SRC/src" -I"$SRC/lib/e32" -I"$SRC/include" \
  "$ROOT/tools/step116_e32_native_codec.cpp" \
  "$SRC/lib/e32/bpe_manager.cpp" \
  "$SRC/lib/e32/byte_pair.cpp" \
  "$SRC/lib/e32/inflate.cpp" \
  "$SRC/lib/e32/huffman.cpp" \
  "$SRC/lib/e32/deflatecompress.cpp" \
  -o "$OUT"

ASAN_OPTIONS="detect_leaks=0:halt_on_error=1:abort_on_error=1" "$OUT" --self-test

{
  printf 'upstream_repository=https://github.com/fedor4ever/elf2e32_next\n'
  printf 'upstream_commit=%s\n' "$COMMIT"
  printf 'compiler=%s\n' "$("$CXX" --version | head -n 1)"
  printf 'source_file_sha256s:\n'
  (cd "$SRC" && sha256sum "${SOURCE_FILES[@]}")
  printf 'binary_sha256=%s\n' "$(sha256sum "$OUT" | awk '{print $1}')"
  printf 'self_test=PASS\n'
} | tee "${OUT}.manifest.txt"

printf 'Native E32 codec executable: %s\n' "$OUT"
