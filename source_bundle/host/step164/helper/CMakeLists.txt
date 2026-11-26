cmake_minimum_required(VERSION 3.28)
project(ShadowkeyFileServerHelper164 LANGUAGES CXX ASM)
include(SymbianPic)
include(SymbianApp)
symbian_add_dynamic_library(
    ShadowkeyFileServerHelper164
    SOURCES probe.cpp
    UID3 0xE000BF99
    EXPORT_DEFINITION "${CMAKE_CURRENT_SOURCE_DIR}/probe.def"
)
target_link_libraries(ShadowkeyFileServerHelper164 PRIVATE Symbian::FileServer)
