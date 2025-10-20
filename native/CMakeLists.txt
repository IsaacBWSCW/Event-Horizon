cmake_minimum_required(VERSION 4.0)
project(NativeCode LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_C_STANDARD 17)

add_subdirectory(godot-cpp godot-cpp/build)

add_library(native SHARED
        src/register.cpp
        src/EventHorizonGame.cpp
        src/EventHorizonGame.hpp
        src/Event.cpp
        src/Event.hpp
        src/Object.cpp
        src/Object.hpp
        src/GravitationalObject.cpp
        src/GravitationalObject.hpp
)

target_include_directories(native PRIVATE
        godot-cpp/include
        godot-cpp/include/godot_cpp
)

target_link_libraries(native PRIVATE godot-cpp)

if(WIN32)
    set(PLATFORM_ID "windows")
elseif(UNIX)
    set(PLATFORM_ID "linux")
else()
    set(PLATFORM_ID "unknown")
endif()

set_target_properties(native PROPERTIES PREFIX "lib")

set_target_properties(native PROPERTIES
        OUTPUT_NAME
        "${CMAKE_PROJECT_NAME}.${PLATFORM_ID}.x86_64"
)

install(TARGETS native
        LIBRARY DESTINATION "${CMAKE_CURRENT_SOURCE_DIR}/../bin"
        RUNTIME DESTINATION "${CMAKE_CURRENT_SOURCE_DIR}/../bin"
        ARCHIVE DESTINATION "${CMAKE_CURRENT_SOURCE_DIR}/../bin"
)