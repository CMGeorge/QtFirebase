cmake_minimum_required(VERSION 3.24)
SET(LIB_NAME QtFirebaseLib)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-builtin")

#Should be added in target (and checked as Target Memembersip to fix Swift inclusion error
set(EMPTY_SWIFT_FILE ${CMAKE_CURRENT_SOURCE_DIR}/Helper.swift)

option(BUILD_SHARED_LIBS "Build in shared lib mode" OFF)

include(ModImportHelper.cmake)





set(CMAKE_FIREBASE_SDK_PATH "")

set(CMAKE_AUTOMOC ON)
set(QML_IMPORT_PATH ${CMAKE_CURRENT_SOURCE_DIR})
find_package(Qt6
    REQUIRED COMPONENTS
    Gui
    Qml
    Quick
)

#find_library(SWIFT_CORE_LIBRARY
#    NAMES SwiftCore
#    PATHS "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos"
#    NO_DEFAULT_PATH
#    REQUIRED
#)

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
set(FETCHCONTENT_BASE_DIR ${CMAKE_SOURCE_DIR}/external/downloads)
if (NOT CMAKE_FIREBASE_SDK_PATH)
    message("Retrieving firebase sdk first...")
    set(CMAKE_FIREBASE_SDK_PATH "${CMAKE_SOURCE_DIR}/external/FirebaseSDK-${FIREBASE_VERSION}")
    set(QTFIREBASE_SDK_LIBS_PREFIX "firebase_")
    Set(FETCHCONTENT_QUIET FALSE)
    #    if (NOT EXISTS "${CMAKE_FIREBASE_SDK_PATH}")
    FetchContent_Declare(
        FirebaseSDK
        URL "https://dl.google.com/firebase/sdk/cpp/firebase_cpp_sdk_${FIREBASE_VERSION}.zip"
        URL_HASH SHA256=9361a51f570d6a5d4779ea1f7e2400eabc593877d587a1587d4b2472af769962
        DOWNLOAD_EXTRACT_TIMESTAMP OLD
        SOURCE_DIR ${CMAKE_FIREBASE_SDK_PATH}
        UPDATE_DISCONNECTED
    )
FetchContent_MakeAvailable(FirebaseSDK)

message("We have FIREBASE SDK At ${FirebaseSDKFromGoogle_VERSION}")
message("We have FIREBASE SDK At ${FirebaseSDKFromGoogle_FIREBASE_SDK_LIBDIR}")
else()
    SET(CMAKE_FIREBASE_SDK_PATH "${CMAKE_SOURCE_DIR}/external/FirebaseSDK-${FIREBASE_VERSION}")
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
        ${CMAKE_CURRENT_SOURCE_DIR}/qtfirebaseanalytics.cpp
    )
endif()
if (Messaging)
    message(STATUS "Will compile messaging")
    add_definitions(-DQTFIREBASE_BUILD_MESSAGING)
    LIST(APPEND
        SOURCE_FILES
        ${CMAKE_CURRENT_SOURCE_DIR}/qtfirebasemessaging.cpp
    )
LIST(APPEND
    SOURCE_FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/qtfirebasemessaging.h
)
LIST(APPEND
    EXTRA_LIBS
    firebase_messaging
    firebase_analytics
)

endif()
if (AdMob)
    message(STATUS "Will compile admob")
    add_definitions(-DQTFIREBASE_BUILD_ADMOB)
    LIST(APPEND
        SOURCE_FILES
        ${CMAKE_CURRENT_SOURCE_DIR}/qtfirebaseadmobtestdevices.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/qtfirebaseadmob.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/qtfirebaseadmobrequest.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/qtfirebaseadmobbase.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/qtfirebaseadmobbanner.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/qtfirebaseadmobinterstitial.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/qtfirebaseadmobrewardedvideoad.cpp
    )
endif()
if (RemoteConfig)
    message(STATUS "Will compile remote_config")
    add_definitions(-DQTFIREBASE_BUILD_REMOTE_CONFIG)
    LIST(APPEND
        SOURCE_FILES
        ${CMAKE_CURRENT_SOURCE_DIR}/qtfirebaseremoteconfig.cpp
    )
endif()
if (Auth)
    message(STATUS "Will compile auth")
    add_definitions(-DQTFIREBASE_BUILD_AUTH)
    LIST(APPEND
        SOURCE_FILES
        ${CMAKE_CURRENT_SOURCE_DIR}/qtfirebaseauth.cpp
    )
endif()
if (Database)
    message(STATUS "Will compile database")
    add_definitions(-DQTFIREBASE_BUILD_DATABASE)
    LIST(APPEND
        SOURCE_FILES
        ${CMAKE_CURRENT_SOURCE_DIR}/qtfirebasedatabase.cpp
    )
endif()

if (ANDROID OR IOS) #only here we supported targets in firebase
else()
    #if desktop

    #else

    #endif
endif()



#find_package(FirebaseSDK)



message("We have FIREBASE SDK At ${firebasesdkfromgoogle_VERSION}")
include_directories(${CMAKE_FIREBASE_SDK_PATH}/include)
#include(${CMAKE_FIREBASE_SDK_PATH}/CMakeLists.txt)
message("We have FIREBASE SDK At ${FIREBASE_SDK_LIBDIR}")
LIST(APPEND
    SOURCE_FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/qtfirebase.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/qtfirebaseservice.cpp
)
LIST(APPEND
    HEADER_FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/qtfirebase.h
    ${CMAKE_CURRENT_SOURCE_DIR}/qtfirebaseservice.h
)
LIST(APPEND
    HEADER_FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/platformutils.h
)

if (NOT IOS)
    LIST(APPEND
        SOURCE_FILES
        ${CMAKE_CURRENT_SOURCE_DIR}/platformutils.cpp
    )
else()
    LIST(APPEND
        SOURCE_FILES
        ${CMAKE_CURRENT_SOURCE_DIR}/ios/platformutils.mm
    )
endif()


include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)
#TODO: Construct version from project version major+minor
#also maybe is not ok this there.. shoukd be removed...
SET(FB_MODE "")
if (ANDROID)
    #    SET(FB_MODE STATIC)
elseif(IOS)
    #        SET(FB_MODE "SHARED")
endif()
add_library(QtFirebaseLib ${FB_MODE})
#${FB_MODE})
target_link_directories(QtFirebaseLib PUBLIC "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos")
set_target_properties(QtFirebaseLib PROPERTIES CMAKE_FIREBASE_SDK_PATH ${CMAKE_FIREBASE_SDK_PATH})
if (IOS)

    message("QtFirebase iOS base. If you did not complete the framework download remove ${FIREBASE_IOS_SDK_VERSIONED} to redeownload")
    if (NOT EXISTS "${FIREBASE_IOS_SDK_VERSIONED}")
        FetchContent_Declare(
            IOSFirebaseFramework
            URL https://github.com/firebase/firebase-ios-sdk/releases/download/${FIREBASE_IOS_VERSION}/Firebase.zip
            DOWNLOAD_EXTRACT_TIMESTAMP OLD
            SOURCE_DIR ${FIREBASE_IOS_SDK_VERSIONED}
        )
    FetchContent_MakeAvailable(IOSFirebaseFramework)
    file(CREATE_LINK ${FIREBASE_IOS_SDK_VERSIONED} ${FIREBASE_IOS_SDK} SYMBOLIC)

endif()
target_link_options(QtFirebaseLib PRIVATE -ObjC)
LIST(APPEND
    HEADER_FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/ios/AppDelegate.h
)
LIST(APPEND
    SOURCE_FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/ios/platformutils.mm
    ${CMAKE_CURRENT_SOURCE_DIR}/ios/AppDelegate.mm
)
LIST(APPEND
    EXTRA_LIBS
    #    ObjC
    sqlite3
    z

)
message("Extra include directory ${FIREBASE_IOS_SDK}")
include_directories(
    ${FIREBASE_IOS_SDK}
    ${FIREBASE_IOS_SDK}/..
)

else()
endif()
qt6_add_qml_module(QtFirebaseLib
    URI "ro.wesell.firebase"
    VERSION 1.0
    SOURCES
    "${HEADER_FILES}"
    "${SOURCE_FILES}"
    "${extra_sources}"
)
target_link_libraries(QtFirebaseLib PRIVATE
    Qt${QT_VERSION_MAJOR}::Quick
    Qt${QT_VERSION_MAJOR}::Qml
    Qt${QT_VERSION_MAJOR}::GuiPrivate

)

target_link_libraries(QtFirebaseLib PRIVATE
    firebase_app
    firebase_functions

    #    firebase_performance
    ${EXTRA_LIBS}
)
#set_target_properties(QtFirebaseLib PROPERTIES
#    XCODE_ATTRIBUTE_MACH_O_TYPE "dynamiclib"
#)
importForMessenging(QtFirebaseLib)




