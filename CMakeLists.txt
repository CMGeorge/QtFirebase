cmake_minimum_required(VERSION 3.24)
set(QTFIREBASE_VERSION 1.5.1)

set(FIREBASE_VERSION "12.0.0")
set(_FIREBASE_HASHES
    "12.0.0:4c93af15a386dfa89b446cf5f5e176cef20e41e5a4456738e82be8acd3b3faf5"
    # "12.1.0:..."  ; add more here
)

set(FIREBASE_ZIP_HASH "")
foreach(entry IN LISTS _FIREBASE_HASHES)
    string(REPLACE ":" ";" parts "${entry}")
    list(GET parts 0 ver)
    list(GET parts 1 hash)
    if(ver STREQUAL FIREBASE_VERSION)
        set(FIREBASE_ZIP_HASH "${hash}")
    endif()
endforeach()

if(NOT FIREBASE_ZIP_HASH)
    message(FATAL_ERROR "Missing hash for Firebase version ${FIREBASE_VERSION}")
endif()
set(FIREBASE_IOS_VERSION "10.9.0")

project(
    QtFirebase
    VERSION ${QTFIREBASE_VERSION}
    LANGUAGES CXX
)


set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN 1)
# As moc files are generated in the binary dir, tell CMake
# to always look for includes there:
set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-builtin")



add_subdirectory(src)
if (ANDROID OR IOS)
    if (ENABLE_EXAMPLE)
        add_subdirectory(example)
    endif()
endif()

