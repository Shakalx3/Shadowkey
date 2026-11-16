cmake_minimum_required(VERSION 3.28)
project(ShadowkeyShimProbe LANGUAGES CXX ASM)

include(SymbianApp)

symbian_add_executable(ShadowkeyShimProbe main.cpp)
target_compile_options(ShadowkeyShimProbe PRIVATE -fno-exceptions -fno-rtti -fno-builtin)
target_link_libraries(ShadowkeyShimProbe PRIVATE
    Symbian::WindowServer
    Symbian::Gdi)
symbian_publish_executable(ShadowkeyShimProbe UID3 0xE000BEF1)

symbian_add_dynamic_library(
    ShadowkeyCompat105
    SOURCES compat.cpp
    UID3 0xE000BEEF
    EXPORT_DEFINITION "${CMAKE_CURRENT_SOURCE_DIR}/compat.def"
)
