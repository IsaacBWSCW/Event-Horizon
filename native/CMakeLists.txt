cmake_minimum_required(VERSION 4.0)
project(NativeCode LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_C_STANDARD 17)

add_subdirectory(godot-cpp godot-cpp/build)

add_library(native SHARED
        src/register.cpp
        src/Engine.cpp
        src/Engine.hpp
)

target_include_directories(native PRIVATE
        godot-cpp/include
        godot-cpp/include/godot_cpp
)

target_link_libraries(native PRIVATE godot-cpp)

if(WIN32)
    set(PLATFORM_ID "windows")
elseif(APPLE)
    set(PLATFORM_ID "macos")
elseif(UNIX)
    set(PLATFORM_ID "linux")
else()
    set(PLATFORM_ID "unknown")
endif()

# Ensure 'lib' prefix is present on all platforms (matches your filenames)
set_target_properties(native PROPERTIES PREFIX "lib")

# Handle multi-config generators (Visual Studio, Xcode) with generator expressions.
# For single-config (Ninja, Make) use CMAKE_BUILD_TYPE at configure time.
if(CMAKE_CONFIGURATION_TYPES) # multi-config
    # OUTPUT_NAME does not include extension. CMake will append the platform-specific extension.
    set_target_properties(native PROPERTIES
            OUTPUT_NAME
            "$<IF:$<CONFIG:Debug>,Native.${PLATFORM_ID}.debug.x86_64,Native.${PLATFORM_ID}.release.x86_64>"
    )
else() # single-config
    if(NOT CMAKE_BUILD_TYPE)
        set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Build type" FORCE)
    endif()
    string(TOLOWER "${CMAKE_BUILD_TYPE}" _bt)
    if(_bt STREQUAL "debug")
        set(_cfg "debug")
    else()
        set(_cfg "release")
    endif()
    set_target_properties(native PROPERTIES
            OUTPUT_NAME "Native.${PLATFORM_ID}.${_cfg}.x86_64"
    )
endif()

# Place built artifacts inside build/bin for convenience
set_target_properties(native PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
        LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
        ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
)

install(TARGETS native
        LIBRARY DESTINATION "${CMAKE_CURRENT_SOURCE_DIR}/bin"
        RUNTIME DESTINATION "${CMAKE_CURRENT_SOURCE_DIR}/bin"
        ARCHIVE DESTINATION "${CMAKE_CURRENT_SOURCE_DIR}/bin"
)