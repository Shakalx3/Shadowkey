cmake_minimum_required(VERSION 3.28)
project(ShadowkeyFreestandingDll157 LANGUAGES CXX ASM)
include(SymbianPic)
symbian_add_dynamic_library(
    ShadowkeyValidProbe157
    SOURCES probe_dll.cpp
    UID3 0xE000BF29
    EXPORT_DEFINITION "${CMAKE_CURRENT_SOURCE_DIR}/probe_dll.def"
)
