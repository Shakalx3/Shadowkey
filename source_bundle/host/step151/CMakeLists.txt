cmake_minimum_required(VERSION 3.28)
project(ShadowkeyE32LoaderProbe LANGUAGES CXX ASM)
include(SymbianApp)
symbian_add_executable(ShadowkeyE32LoaderProbe main.cpp)
target_compile_options(ShadowkeyE32LoaderProbe PRIVATE -fno-exceptions -fno-rtti -fno-builtin)
target_link_libraries(ShadowkeyE32LoaderProbe PRIVATE Symbian::WindowServer Symbian::Gdi Symbian::C)
symbian_publish_executable(ShadowkeyE32LoaderProbe UID3 0xE000BF15)
symbian_add_dynamic_library(
    ShadowkeyValidProbe151
    SOURCES probe_dll.cpp
    UID3 0xE000BF16
    EXPORT_DEFINITION "${CMAKE_CURRENT_SOURCE_DIR}/probe_dll.def"
)
