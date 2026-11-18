cmake_minimum_required(VERSION 3.28)
project(ShadowkeyInlineShimProbe LANGUAGES CXX ASM)

include(SymbianApp)

# ASM is required by the EKA2 startup path that defines _E32Startup.
symbian_add_executable(ShadowkeyInlineShimProbe main.cpp)
target_compile_options(ShadowkeyInlineShimProbe PRIVATE -fno-exceptions -fno-rtti -fno-builtin)
target_link_libraries(ShadowkeyInlineShimProbe PRIVATE
    Symbian::WindowServer
    Symbian::Gdi)
symbian_publish_executable(ShadowkeyInlineShimProbe UID3 0xE000BEFB)
