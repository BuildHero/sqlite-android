cmake_minimum_required(VERSION 3.18.1)

project(sqlite-android)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Define the same flags used in Android.mk
set(SQLITE_FLAGS
    -DNDEBUG=1
    -DHAVE_USLEEP=1
    -DSQLITE_HAVE_ISNAN
    -DSQLITE_DEFAULT_JOURNAL_SIZE_LIMIT=1048576
    -DSQLITE_THREADSAFE=2
    -DSQLITE_TEMP_STORE=3
    -DSQLITE_POWERSAFE_OVERWRITE=1
    -DSQLITE_DEFAULT_FILE_FORMAT=4
    -DSQLITE_DEFAULT_AUTOVACUUM=1
    -DSQLITE_ENABLE_MEMORY_MANAGEMENT=1
    -DSQLITE_ENABLE_FTS3
    -DSQLITE_ENABLE_FTS3_PARENTHESIS
    -DSQLITE_ENABLE_FTS4
    -DSQLITE_ENABLE_FTS4_PARENTHESIS
    -DSQLITE_ENABLE_FTS5
    -DSQLITE_ENABLE_FTS5_PARENTHESIS
    -DSQLITE_ENABLE_JSON1
    -DSQLITE_ENABLE_RTREE=1
    -DSQLITE_UNTESTABLE
    -DSQLITE_OMIT_COMPILEOPTION_DIAGS
    -DSQLITE_DEFAULT_FILE_PERMISSIONS=0600
    -DSQLITE_DEFAULT_MEMSTATUS=0
    -DSQLITE_MAX_EXPR_DEPTH=0
    -DSQLITE_USE_ALLOCA
    -DSQLITE_ENABLE_BATCH_ATOMIC_WRITE
    -O3
)

# Add architecture-specific flags
if(ANDROID_ABI STREQUAL "armeabi-v7a")
    list(APPEND SQLITE_FLAGS -DPACKED="__attribute__ ((packed))")
else()
    list(APPEND SQLITE_FLAGS -DPACKED="")
endif()

# Define source files
set(SQLITE_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/../jni/sqlite/android_database_SQLiteCommon.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/../jni/sqlite/android_database_SQLiteConnection.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/../jni/sqlite/android_database_SQLiteFunction.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/../jni/sqlite/android_database_SQLiteGlobal.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/../jni/sqlite/android_database_SQLiteDebug.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/../jni/sqlite/android_database_CursorWindow.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/../jni/sqlite/CursorWindow.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/../jni/sqlite/JNIHelp.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/../jni/sqlite/JNIString.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/../jni/sqlite/sqlite3.c
)

# Create the shared library
add_library(sqlite3x SHARED ${SQLITE_SOURCES})

# Set include directories
target_include_directories(sqlite3x PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/../jni/sqlite
)

# Apply compiler flags
target_compile_options(sqlite3x PRIVATE 
    ${SQLITE_FLAGS}
    -Wno-unused-parameter
    -Wno-int-to-pointer-cast
    -Wno-uninitialized
    -Wno-parentheses
)

# Set C++ specific flags
target_compile_options(sqlite3x PRIVATE
    $<$<COMPILE_LANGUAGE:CXX>:-Wno-conversion-null>
)

# Link libraries
target_link_libraries(sqlite3x 
    log
    dl
    atomic
)

# Create alias target for find_package compatibility
add_library(sqlite-android::sqlite-android ALIAS sqlite3x)

# Install the library and headers for packaging
install(TARGETS sqlite3x
    LIBRARY DESTINATION lib/${ANDROID_ABI}
    ARCHIVE DESTINATION lib/${ANDROID_ABI}
)

install(FILES 
    ${CMAKE_CURRENT_SOURCE_DIR}/../jni/sqlite/sqlite3.h
    DESTINATION include
)

# Export targets for find_package
install(EXPORT sqlite-android-targets
    FILE sqlite-android-targets.cmake
    NAMESPACE sqlite-android::
    DESTINATION lib/cmake/sqlite-android
)

