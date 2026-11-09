#!/usr/bin/env bash
set -euo pipefail
WORK="$RUNNER_TEMP/step81-epoc-demangler"
OUT="$GITHUB_WORKSPACE/step81-demangler-probe"
ARCHIVE="$WORK/gcce-2005q1c.tar.bz2"
ROOT="$WORK/gcce"
mkdir -p "$WORK" "$OUT" "$ROOT"
sudo dpkg --add-architecture i386
sudo apt-get update -qq
sudo apt-get install -y -qq libc6-i386 lib32stdc++6 lib32gcc-s1 lib32z1
URL="https://www.martin.st/symbian/gnu-csl-arm-2005Q1C-arm-none-symbianelf-i686-pc-linux-gnu.tar.bz2"
curl -fL --retry 3 "$URL" -o "$ARCHIVE"
test "$(stat -c '%s' "$ARCHIVE")" = "10896869"
test "$(md5sum "$ARCHIVE" | awk '{print $1}')" = "622e4db70cfae6a9eec26892a9932633"
tar -xjf "$ARCHIVE" -C "$ROOT"
DEM=$(find "$ROOT" -type f -name 'arm-none-symbianelf-c++filt' | head -n1)
test -n "$DEM" && test -x "$DEM"
BIN=$(dirname "$DEM")
export LD_LIBRARY_PATH="$BIN/../lib:$BIN/../lib32"
cat > "$WORK/symbols.txt" <<'EOF'
__7TPtrC16PCUs
__ne__C6TInt64RC6TInt64
Rect__C11CCoeControl
SetPosture__10TFontStyle12TFontPosture
SetStrokeWeight__10TFontStyle17TFontStrokeWeight
__9TFontSpecRC7TDesC16i
__nw__5CBaseUi
__5TRectiiii
Height__C5TRect
Move__5TRectii
EOF
"$DEM" < "$WORK/symbols.txt" > "$OUT/epoc-demangled.txt" 2> "$OUT/epoc-demangler.stderr"
cp "$WORK/symbols.txt" "$OUT/epoc-mangled.txt"
"$DEM" --version > "$OUT/demangler-version.txt" 2>&1 || true
{
  echo "Demangler: $DEM"
  echo "Input:"
  cat "$OUT/epoc-mangled.txt"
  echo
  echo "Output:"
  cat "$OUT/epoc-demangled.txt"
  echo
  echo "Stderr:"
  cat "$OUT/epoc-demangler.stderr"
} > "$OUT/STEP81_EPOC_DEMANGLER_PROBE.txt"
cat "$OUT/STEP81_EPOC_DEMANGLER_PROBE.txt"
