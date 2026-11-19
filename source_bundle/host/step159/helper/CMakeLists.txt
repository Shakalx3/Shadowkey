cmake_minimum_required(VERSION 3.28)
project(ShadowkeyFileServerHelper159 LANGUAGES CXX ASM)
include(SymbianPic)
symbian_add_dynamic_library(
    ShadowkeyFileServerHelper159
    SOURCES probe.cpp
    UID3 0xE000BF49
    EXPORT_DEFINITION "${CMAKE_CURRENT_SOURCE_DIR}/probe.def"
)
target_link_libraries(ShadowkeyFileServerHelper159 PRIVATE Symbian::FileServer)
