cmake_minimum_required(VERSION 3.28)
project(ShadowkeyLegacyLoadProbe LANGUAGES CXX ASM)

include(SymbianApp)

symbian_add_executable(ShadowkeyLegacyLoadProbe main.cpp)
target_compile_options(ShadowkeyLegacyLoadProbe PRIVATE -fno-exceptions -fno-rtti -fno-builtin)
target_link_libraries(ShadowkeyLegacyLoadProbe PRIVATE
    Symbian::WindowServer
    Symbian::Gdi)
symbian_publish_executable(ShadowkeyLegacyLoadProbe UID3 0xE000BEF4)
