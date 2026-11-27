cmake_minimum_required(VERSION 3.28)
project(Shadowkey3DViewer LANGUAGES CXX ASM)

include(SymbianApp)

symbian_add_executable(Shadowkey3DViewer main.cpp)
target_compile_options(Shadowkey3DViewer PRIVATE -fno-exceptions -fno-rtti -fno-builtin)
target_link_libraries(Shadowkey3DViewer PRIVATE
    Symbian::WindowServer
    Symbian::Gdi)
symbian_publish_executable(Shadowkey3DViewer UID3 0xE000BEF1)
