cmake_minimum_required(VERSION 3.28)
project(ShadowkeyAbiProbe LANGUAGES CXX ASM)

include(SymbianApp)

# A normal EKA2 executable. The workflow selects the older-EKA2 runtime
# profile and replaces its import proxies with the S60 3.1 FP1 SDK DSOs.
symbian_add_executable(ShadowkeyAbiProbe main.cpp)
target_compile_options(ShadowkeyAbiProbe PRIVATE -fno-exceptions -fno-rtti -fno-builtin)
symbian_publish_executable(ShadowkeyAbiProbe UID3 0xE000BEF0)

# The test DLL is intentionally self-contained. It exports one C ABI function
# at ordinal 1 and is loaded dynamically by RLibrary in the executable.
symbian_add_dynamic_library(
    ShadowkeyCompat
    SOURCES compat.cpp
    UID3 0xE000BEEF
    EXPORT_DEFINITION "${CMAKE_CURRENT_SOURCE_DIR}/compat.def"
)
