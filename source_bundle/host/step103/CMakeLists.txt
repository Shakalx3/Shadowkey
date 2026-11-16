cmake_minimum_required(VERSION 3.28)
project(ShadowkeyAbiProbe LANGUAGES CXX ASM)

include(SymbianApp)

# A real Window Server process, not a console-style main registered as an app.
# No AVKON/EIKCORE dependency: this isolates EKA2 startup, WSERV and GDI.
symbian_add_executable(ShadowkeyAbiProbe main.cpp)
target_compile_options(ShadowkeyAbiProbe PRIVATE -fno-exceptions -fno-rtti -fno-builtin)
target_link_libraries(ShadowkeyAbiProbe PRIVATE
    Symbian::WindowServer
    Symbian::Gdi)
symbian_publish_executable(ShadowkeyAbiProbe UID3 0xE000BEF0)

# Retain the small self-contained DLL so this probe still checks RLibrary,
# ordinal 1 lookup and a real ARM DLL call after the visible startup stage.
symbian_add_dynamic_library(
    ShadowkeyCompat
    SOURCES compat.cpp
    UID3 0xE000BEEF
    EXPORT_DEFINITION "${CMAKE_CURRENT_SOURCE_DIR}/compat.def"
)
