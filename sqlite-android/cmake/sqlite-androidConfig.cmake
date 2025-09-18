# sqlite-androidConfig.cmake
# CMake configuration file for sqlite-android library

# Only works on Android
if(NOT ANDROID)
    message(FATAL_ERROR "sqlite-android can only be used on Android projects")
endif()

set(sqlite-android_FOUND TRUE)

# The library should be available as an implementation dependency
# Consumers should add: implementation 'io.requery:sqlite-android:x.x.x' to their build.gradle

# Create an imported target for the native library
if(NOT TARGET sqlite-android::sqlite-android)
    add_library(sqlite-android::sqlite-android SHARED IMPORTED)
    
    # Set the imported location based on the ABI
    set_target_properties(sqlite-android::sqlite-android PROPERTIES
        IMPORTED_LOCATION "${CMAKE_CURRENT_LIST_DIR}/../jni/${ANDROID_ABI}/libsqlite3x.so"
    )
    
    # Try common locations where the AAR might extract the native library
    foreach(possible_path 
        "${CMAKE_CURRENT_LIST_DIR}/../jni/${ANDROID_ABI}/libsqlite3x.so"
        "${CMAKE_CURRENT_LIST_DIR}/../../jni/${ANDROID_ABI}/libsqlite3x.so"
        "${CMAKE_CURRENT_LIST_DIR}/../../../jni/${ANDROID_ABI}/libsqlite3x.so")
        
        if(EXISTS "${possible_path}")
            set_target_properties(sqlite-android::sqlite-android PROPERTIES
                IMPORTED_LOCATION "${possible_path}"
            )
            break()
        endif()
    endforeach()
endif()

# Legacy variables for backwards compatibility
set(sqlite-android_LIBRARIES sqlite-android::sqlite-android)
set(sqlite-android_INCLUDE_DIRS)

