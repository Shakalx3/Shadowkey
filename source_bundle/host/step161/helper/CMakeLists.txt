cmake_minimum_required(VERSION 3.28)
project(ShadowkeyFileServerHelper161 LANGUAGES CXX ASM)
include(SymbianPic)
include(SymbianApp)
symbian_add_dynamic_library(
    ShadowkeyFileServerHelper161
    SOURCES probe.cpp
    UID3 0xE000BF69
    EXPORT_DEFINITION "${CMAKE_CURRENT_SOURCE_DIR}/probe.def"
)
target_link_libraries(ShadowkeyFileServerHelper161 PRIVATE Symbian::FileServer)
