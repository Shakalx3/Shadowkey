#!/bin/sh
set -u
CC=${CC:-clang}
BUILD=.build
mkdir -p "$BUILD"
CFLAGS="-std=c11 -O0 -w"
$CC $CFLAGS -c shadowkey_engine_init_test.c -o "$BUILD/engine_trace_test.o"
$CC $CFLAGS -c shadowkey_hle_trace.c -o "$BUILD/shadowkey_hle_trace.o"
# Reuse the core objects built by build_and_test.sh.
if [ ! -f "$BUILD/shadowkey_lifted.o" ]; then
  echo "Run ./build_and_test.sh first to build the shared objects." >&2
  exit 2
fi
$CC -o "$BUILD/shadowkey_engine_init_trace" \
  "$BUILD/engine_trace_test.o" "$BUILD/shadowkey_lifted.o" \
  "$BUILD/shadowkey_function_registry.o" "$BUILD/shadowkey_import_dispatch.o" \
  "$BUILD/shadowkey_dispatch.o" "$BUILD/shadowkey_hle_trace.o" \
  "$BUILD/simkin_lifted.o" "$BUILD/simkin_function_registry.o" \
  "$BUILD/simkin_export_registry.o" "$BUILD/simkin_import_dispatch.o" \
  "$BUILD/arm_fallback.o"
set +e
"$BUILD/shadowkey_engine_init_trace" ./6R51.APP ./SIMKIN_relocated.DLL > "$BUILD/asset_trace.log" 2>&1
rc=$?
set -e
grep -E 'RFile::Open candidate path|OOB|ARM fallback|ENGINE RUNL' "$BUILD/asset_trace.log" || true
echo "Diagnostic run exit code: $rc (90 currently means the trace stopped at the first unmapped/null resource path after missing-file handling)."
