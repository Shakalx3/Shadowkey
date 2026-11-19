cmake_minimum_required(VERSION 3.28)
project(ShadowkeyE32LoaderProbe153 LANGUAGES CXX ASM)
include(SymbianApp)
symbian_add_executable(ShadowkeyE32LoaderProbe153 main.cpp)
target_compile_options(ShadowkeyE32LoaderProbe153 PRIVATE -fno-exceptions -fno-rtti -fno-builtin)
target_link_libraries(ShadowkeyE32LoaderProbe153 PRIVATE Symbian::WindowServer Symbian::Gdi Symbian::C)
symbian_publish_executable(ShadowkeyE32LoaderProbe153 UID3 0xE000BF1B)
symbian_add_dynamic_library(
    ShadowkeyValidProbe153
    SOURCES probe_dll.cpp
    UID3 0xE000BF1C
    EXPORT_DEFINITION "${CMAKE_CURRENT_SOURCE_DIR}/probe_dll.def"
)
