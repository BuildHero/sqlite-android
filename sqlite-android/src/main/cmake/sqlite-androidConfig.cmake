# sqlite-androidConfig.cmake
# CMake configuration file for sqlite-android library

# Find the Android Gradle Plugin's prefab support
if(NOT ANDROID)
    message(FATAL_ERROR "sqlite-android can only be used on Android")
endif()

# Set the target name that consumers will use
set(sqlite-android_FOUND TRUE)

# Get the AAR extract location
get_filename_component(PACKAGE_PREFIX_DIR "${CMAKE_CURRENT_LIST_DIR}/../../.." ABSOLUTE)

# Find the native library in the AAR structure
find_library(sqlite-android_LIBRARY
    NAMES sqlite3x
    PATHS 
        "${PACKAGE_PREFIX_DIR}/jni/${ANDROID_ABI}"
        "${PACKAGE_PREFIX_DIR}/.cxx/Debug/${CMAKE_ANDROID_ARCH_ABI}"
        "${PACKAGE_PREFIX_DIR}/.cxx/Release/${CMAKE_ANDROID_ARCH_ABI}"
    NO_DEFAULT_PATH
)

if(NOT sqlite-android_LIBRARY)
    set(sqlite-android_FOUND FALSE)
    if(sqlite-android_FIND_REQUIRED)
        message(FATAL_ERROR "sqlite-android library not found for ABI: ${ANDROID_ABI}")
    endif()
    return()
endif()

# Create imported target
if(NOT TARGET sqlite-android::sqlite3x)
    add_library(sqlite-android::sqlite3x SHARED IMPORTED)
    set_target_properties(sqlite-android::sqlite3x PROPERTIES
        IMPORTED_LOCATION "${sqlite-android_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${PACKAGE_PREFIX_DIR}/include"
    )
endif()

# Set variables for consumers
set(sqlite-android_LIBRARIES sqlite-android::sqlite3x)
set(sqlite-android_INCLUDE_DIRS "${PACKAGE_PREFIX_DIR}/include")
