cmake_minimum_required(VERSION 3.28)
project(ShadowkeyFreestandingDll155 LANGUAGES CXX ASM)
include(SymbianPic)
symbian_add_dynamic_library(
    ShadowkeyValidProbe155
    SOURCES probe_dll.cpp
    UID3 0xE000BF22
    EXPORT_DEFINITION "${CMAKE_CURRENT_SOURCE_DIR}/probe_dll.def"
)
