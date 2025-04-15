cmake_minimum_required(VERSION 3.24)
set(QTFIREBASE_VERSION 1.5.1)

SET(FIREBASE_VERSION "12.0.0")
SET(FIREBASE_IOS_VERSION "10.9.0")

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

