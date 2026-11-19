cmake_minimum_required(VERSION 3.28)
project(ShadowkeyFileServerHelper160 LANGUAGES CXX ASM)
include(SymbianPic)
include(SymbianApp)
symbian_add_dynamic_library(
    ShadowkeyFileServerHelper160
    SOURCES probe.cpp
    UID3 0xE000BF59
    EXPORT_DEFINITION "${CMAKE_CURRENT_SOURCE_DIR}/probe.def"
)
target_link_libraries(ShadowkeyFileServerHelper160 PRIVATE Symbian::FileServer)
