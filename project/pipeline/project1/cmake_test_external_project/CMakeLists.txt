cmake_minimum_required(VERSION 2.8.4)
project(test_use_libnmea)

SET(CMAKE_BUILD_TYPE "Debug")

# Global settings
set(GLOBAL_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin)
set(CMAKE_INSTALL_PREFIX ${PROJECT_BINARY_DIR}/install)

# Sets global output directory for single configuration (GCC)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${GLOBAL_OUTPUT_PATH})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${GLOBAL_OUTPUT_PATH})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${GLOBAL_OUTPUT_PATH})

# Sets global output directory for sub-configurations (msvc, mingw)
foreach(OUTPUTCONFIG ${CMAKE_CONFIGURATION_TYPES})
    string(TOUPPER ${OUTPUTCONFIG} OUTPUTCONFIG)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${GLOBAL_OUTPUT_PATH})
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${GLOBAL_OUTPUT_PATH})
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUTCONFIG} ${GLOBAL_OUTPUT_PATH})
endforeach(OUTPUTCONFIG CMAKE_CONFIGURATION_TYPES)


# 3rdparty Libraries
include(CMakeLists-ExternalProjects.txt)


# Global compiler flags
# -std=c++11  =>  Used by HumbleLogging
if(CMAKE_COMPILER_IS_GNUCXX)
  set(CMAKE_CXX_FLAGS -std=c++11)
else()
  add_definitions(-DWIN32) # TMP
endif()


# Global link directories
MESSAGE(GLOBAL_OUTPUT_PATH: ${GLOBAL_OUTPUT_PATH})
link_directories(${GLOBAL_OUTPUT_PATH})


file(GLOB app_sources src/*.cpp)
add_executable(app ${app_sources})

# Link against external project "libneam"
target_link_libraries(app ${libnmea_LIBRARIES})
add_dependencies(app libnmea)


# Installation
# Copies files from build directory into install directory.
file(GLOB executables "${GLOBAL_OUTPUT_PATH}/*.exe")
install(FILES ${executables} DESTINATION "bin")

file(GLOB libraries "${GLOBAL_OUTPUT_PATH}/*.dll")
install(FILES ${libraries} DESTINATION "bin")


# SDK Installation
install(DIRECTORY "src/lib1/include/" DESTINATION "include" FILES_MATCHING PATTERN "*.h")
install(DIRECTORY "src/lib2/include/" DESTINATION "include" FILES_MATCHING PATTERN "*.h")
