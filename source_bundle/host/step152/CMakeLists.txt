cmake_minimum_required(VERSION 3.28)
project(ShadowkeyE32LoaderProbe152 LANGUAGES CXX ASM)
include(SymbianApp)
symbian_add_executable(ShadowkeyE32LoaderProbe152 main.cpp)
target_compile_options(ShadowkeyE32LoaderProbe152 PRIVATE -fno-exceptions -fno-rtti -fno-builtin)
target_link_libraries(ShadowkeyE32LoaderProbe152 PRIVATE Symbian::WindowServer Symbian::Gdi Symbian::C)
symbian_publish_executable(ShadowkeyE32LoaderProbe152 UID3 0xE000BF18)
symbian_add_dynamic_library(
    ShadowkeyValidProbe152
    SOURCES probe_dll.cpp
    UID3 0xE000BF19
    EXPORT_DEFINITION "${CMAKE_CURRENT_SOURCE_DIR}/probe_dll.def"
)
