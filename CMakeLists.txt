cmake_minimum_required(VERSION 3.24)
set(QTFIREBASE_VERSION 1.5.0)
set(CMAKE_FIREBASE_SDK_PATH "")
project(
    QtFirebase
    VERSION ${QTFIREBASE_VERSION}
    LANGUAGES CXX
)

set(CMAKE_AUTOMOC ON)
set(QML_IMPORT_PATH ${CMAKE_CURRENT_SOURCE_DIR})
find_package(Qt6
    REQUIRED COMPONENTS
        Gui
        Qml
        Quick
)

set(NoAutoRegister OFF CACHE BOOL "Disable auto register")
set_property(CACHE NoAutoRegister PROPERTY TYPE BOOL)

set(Analytics OFF CACHE BOOL "Enable analitycs")
set_property(CACHE Analytics PROPERTY TYPE BOOL)

set(Messaging ON CACHE BOOL "Enable messaging")
set_property(CACHE Messaging PROPERTY TYPE BOOL)

set(AdMob OFF CACHE BOOL "Enable AdMob")
set_property(CACHE AdMob PROPERTY TYPE BOOL)

set(RemoteConfig OFF CACHE BOOL "Enable RemoteConfig")
set_property(CACHE RemoteConfig PROPERTY TYPE BOOL)

set(Auth OFF CACHE BOOL "Enable Authentication")
set_property(CACHE Auth PROPERTY TYPE BOOL)

set(Database OFF CACHE BOOL "Enable Database")
set_property(CACHE Database PROPERTY TYPE BOOL)

#Let's get the SDK
include(FetchContent)
if (NOT CMAKE_FIREBASE_SDK_PATH)
    message("Retrieving firebase sdk first...")
    set(CMAKE_FIREBASE_SDK_PATH "${CMAKE_CURRENT_SOURCE_DIR}/FirebaseSDK")
    set(QTFIREBASE_SDK_LIBS_PREFIX "firebase_")
    Set(FETCHCONTENT_QUIET FALSE)
    FetchContent_Declare(
        FirebaseSDK
        URL "https://dl.google.com/firebase/sdk/cpp/firebase_cpp_sdk_10.5.0.zip"
        DOWNLOAD_EXTRACT_TIMESTAMP OLD
        SOURCE_DIR ${CMAKE_FIREBASE_SDK_PATH}
    )
    FetchContent_MakeAvailable(FirebaseSDK)
#    FetchContent_GetProperties(FirebaseSDKFromGoogle)
    message("We have FIREBASE SDK At ${FirebaseSDKFromGoogle_VERSION}")
    message("We have FIREBASE SDK At ${FirebaseSDKFromGoogle_FIREBASE_SDK_LIBDIR}")
endif()


set(extra_sources "")
set(SOURCE_FILES "")
set(HEADER_FILES "")
set(EXTRA_LIBS "")

#Prepare definitions
if (NOT NoAutoRegister)
    message(STATUS "Will use auto registration for QML")
    add_definitions(-DQTFIREBASE_AUTO_REGISTER)
    LIST(APPEND extra_sources "${CMAKE_CURRENT_SOURCE_DIR}/qtfirebase_register.cpp")
else()
    message(STATUS "Will NOT use auto registration for QML")
endif()

if (Analytics)
    message(STATUS "Will compile analitycs")
    add_definitions(-DQTFIREBASE_BUILD_ANALYTICS)
    LIST(APPEND
        SOURCE_FILES
            ${CMAKE_CURRENT_SOURCE_DIR}/src/qtfirebaseanalytics.cpp
    )
endif()
if (Messaging)
    message(STATUS "Will compile messaging")
    add_definitions(-DQTFIREBASE_BUILD_MESSAGING)
    LIST(APPEND
        SOURCE_FILES
            ${CMAKE_CURRENT_SOURCE_DIR}/src/qtfirebasemessaging.cpp
    )
    LIST(APPEND
        EXTRA_LIBS
            firebase_messaging
    )

endif()
if (AdMob)
    message(STATUS "Will compile admob")
    add_definitions(-DQTFIREBASE_BUILD_ADMOB)
    LIST(APPEND
        SOURCE_FILES
            ${CMAKE_CURRENT_SOURCE_DIR}/src/qtfirebaseadmobtestdevices.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/src/qtfirebaseadmob.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/src/qtfirebaseadmobrequest.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/src/qtfirebaseadmobbase.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/src/qtfirebaseadmobbanner.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/src/qtfirebaseadmobinterstitial.cpp
            ${CMAKE_CURRENT_SOURCE_DIR}/src/qtfirebaseadmobrewardedvideoad.cpp
    )
endif()
if (RemoteConfig)
    message(STATUS "Will compile remote_config")
    add_definitions(-DQTFIREBASE_BUILD_REMOTE_CONFIG)
    LIST(APPEND
        SOURCE_FILES
            ${CMAKE_CURRENT_SOURCE_DIR}/src/qtfirebaseremoteconfig.cpp
    )
endif()
if (Auth)
    message(STATUS "Will compile auth")
    add_definitions(-DQTFIREBASE_BUILD_AUTH)
    LIST(APPEND
        SOURCE_FILES
            ${CMAKE_CURRENT_SOURCE_DIR}/src/qtfirebaseauth.cpp
    )
endif()
if (Database)
    message(STATUS "Will compile database")
    add_definitions(-DQTFIREBASE_BUILD_DATABASE)
    LIST(APPEND
        SOURCE_FILES
            ${CMAKE_CURRENT_SOURCE_DIR}/src/qtfirebasedatabase.cpp
    )
endif()

if (ANDROID OR IOS) #only here we supported targets in firebase
else()
    #if desktop

    #else

    #endif
endif()



#find_package(FirebaseSDK)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

message("We have FIREBASE SDK At ${firebasesdkfromgoogle_VERSION}")
include_directories(${CMAKE_FIREBASE_SDK_PATH}/include)
#include(${CMAKE_FIREBASE_SDK_PATH}/CMakeLists.txt)
message("We have FIREBASE SDK At ${FIREBASE_SDK_LIBDIR}")
LIST(APPEND
    SOURCE_FILES
        ${CMAKE_CURRENT_SOURCE_DIR}/src/qtfirebase.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/qtfirebaseservice.cpp
)
LIST(APPEND
    HEADER_FILES
        ${CMAKE_CURRENT_SOURCE_DIR}/src/platformutils.h
)

if (NOT IOS)
    LIST(APPEND
        SOURCE_FILES
            ${CMAKE_CURRENT_SOURCE_DIR}/src/platformutils.cpp
        )
else()
    LIST(APPEND
        SOURCE_FILES
            ${CMAKE_CURRENT_SOURCE_DIR}/src/ios/platformutils.mm
        )
endif()
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)
#TODO: Construct version from project version major+minor
qt6_add_qml_module(QtFirebase
    URI "ro.wesell.firebase"
    VERSION 1.0
    SOURCES
        "${HEADER_FILES}"
        "${SOURCE_FILES}"
        "${extra_sources}"
)

target_link_libraries(QtFirebase PRIVATE
    Qt${QT_VERSION_MAJOR}::Quick
    Qt${QT_VERSION_MAJOR}::Qml
    Qt${QT_VERSION_MAJOR}::GuiPrivate
    firebase_app
    ${EXTRA_LIBS}
)
#add_dependencies(QtFirebase FirebaseSDKFromGoogle)
