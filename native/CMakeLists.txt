cmake_minimum_required(VERSION 4.0)
project(NativeCode LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)

add_subdirectory(godot-cpp godot-cpp/build)

add_library(Engine SHARED src/engine.cpp)

target_include_directories(Engine PRIVATE
        godot-cpp/include
        godot-cpp/include/godot_cpp
)

target_link_libraries(Engine PRIVATE godot-cpp)