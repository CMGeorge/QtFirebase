cmake_minimum_required(VERSION 3.24)
SET(FIREBASE_VERSION "10.3.0")

set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN 1)
# As moc files are generated in the binary dir, tell CMake
# to always look for includes there:
set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-builtin")

#Should be added in target (and checked as Target Memembersip to fix Swift inclusion error
set(EMPTY_SWIFT_FILE ${CMAKE_CURRENT_SOURCE_DIR}/Helper.swift)

option(BUILD_SHARED_LIBS "Build in shared lib mode" OFF)

SET(FIREBASE_IOS_SDK "${CMAKE_CURRENT_SOURCE_DIR}/external/ios/firebase")
SET(FIREBASE_IOS_SDK_VERSIONED "${CMAKE_CURRENT_SOURCE_DIR}/external/ios/firebase-${FIREBASE_VERSION}")
function(add_xcframework_to_target TARGET_NAME CATALOG_NAME FRAMEWORK_NAME)
  # Set the path to the XCFramework
  set(XCFRAMEWORK_PATH "${FIREBASE_IOS_SDK}/${CATALOG_NAME}/${FRAMEWORK_NAME}.xcframework")

  # Add the XCFramework to the link directories for all architectures
  foreach(arch IN ITEMS "ios-arm64" "ios-arm64_armv7")
    link_directories(${XCFRAMEWORK_PATH}/${arch})
  endforeach()

  # Add the header search path for all architectures
  foreach(arch IN ITEMS "ios-arm64" "ios-arm64_armv7")
    target_include_directories(${TARGET_NAME} SYSTEM PRIVATE
      "${XCFRAMEWORK_PATH}/${arch}/${FRAMEWORK_NAME}.framework/Headers"
    )
    # Add the framework directory to the include path
    target_include_directories(${TARGET_NAME} SYSTEM PRIVATE
      "${XCFRAMEWORK_PATH}/${arch}"
    )
  endforeach()

  # Link against the XCFramework for all architectures
  foreach(arch IN ITEMS "ios-arm64" "ios-arm64_armv7")
    target_link_libraries(${TARGET_NAME} PRIVATE
      "-framework ${FRAMEWORK_NAME}"
      "-F${XCFRAMEWORK_PATH}/${arch}"
#      "-arch" "${arch}"
    )
  endforeach()


#  add_library(${FRAMEWORK_NAME} SHARED IMPORTED)

#  # Set the path to the framework
#  set_target_properties(${FRAMEWORK_NAME} PROPERTIES
#      IMPORTED_LOCATION ${XCFRAMEWORK_PATH}/ios-arm64/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}
#  )

#  # Set the include directories for the framework
#  set_target_properties(${FRAMEWORK_NAME} PROPERTIES
#      INTERFACE_INCLUDE_DIRECTORIES ${XCFRAMEWORK_PATH}/ios-arm64/${FRAMEWORK_NAME}.framework/Headers
#  )

#  # Link the target to your executable or library
#  target_link_libraries(${TARGET_NAME} PRIVATE ${FRAMEWORK_NAME})
  message("Include: ${XCFRAMEWORK_PATH}/ios-arm64/${FRAMEWORK_NAME}.framework/Headers")

endfunction()



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
    set(CMAKE_FIREBASE_SDK_PATH "${CMAKE_CURRENT_SOURCE_DIR}/external/FirebaseSDK-${FIREBASE_VERSION}")
    set(QTFIREBASE_SDK_LIBS_PREFIX "firebase_")
    Set(FETCHCONTENT_QUIET FALSE)
#    if (NOT EXISTS "${CMAKE_FIREBASE_SDK_PATH}")
    FetchContent_Declare(
        FirebaseSDK
        URL "https://dl.google.com/firebase/sdk/cpp/firebase_cpp_sdk_${FIREBASE_VERSION}.zip"
        URL_HASH SHA256=c0d1c0f7ace29603379cdb10bf71b2cebf240acd330b7d1882528f2d67c51c66
        DOWNLOAD_EXTRACT_TIMESTAMP OLD
        SOURCE_DIR ${CMAKE_FIREBASE_SDK_PATH}
        UPDATE_DISCONNECTED
    )
    FetchContent_MakeAvailable(FirebaseSDK)

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
            firebase_analytics
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
#also maybe is not ok this there.. shoukd be removed...
SET(FB_MODE "")
if (ANDROID)
#    SET(FB_MODE STATIC)
endif()
add_library(QtFirebase ${FB_MODE})
set_target_properties(QtFirebase PROPERTIES FIREBASE_IOS_SDK_VERSIONED ${FIREBASE_IOS_SDK_VERSIONED})
if (IOS)
#    set_target_properties(${PROJECT_NAME} PROPERTIES
#            XCODE_ATTRIBUTE_SWIFT_OBJC_BRIDGING_HEADER "${CMAKE_CURRENT_SOURCE_DIR}/QtFirebase-Bridging-Header.h"
#    #        XCODE_ATTRIBUTE_SWIFT_OBJC_INTERFACE_HEADER_NAME "${CMAKE_CURRENT_SOURCE_DIR}/Helper.swift"
#    #        XCODE_ATTRIBUTE_SWIFT_OBJC_BRIDGING_HEADER "${A_DIR_MODULE_ROOT}/aswiftbridging.h"
#            XCODE_ATTRIBUTE_ENABLE_BITCODE "NO"
#            XCODE_ATTRIBUTE_ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES "YES"
#            XCODE_ATTRIBUTE_SWIFT_VERSION "5.0"
#            SOURCES
#                ${CMAKE_CURRENT_SOURCE_DIR}/Helper.swift
#    )

    message("QtFirebase iOS base. If you did not complete the framework download remove ${FIREBASE_IOS_SDK_VERSIONED} to redeownload")
    if (NOT EXISTS "${FIREBASE_IOS_SDK_VERSIONED}")
        FetchContent_Declare(
            IOSFirebaseFramework
            URL https://github.com/firebase/firebase-ios-sdk/releases/download/${FIREBASE_VERSION}/Firebase.zip
            DOWNLOAD_EXTRACT_TIMESTAMP OLD
            SOURCE_DIR ${FIREBASE_IOS_SDK_VERSIONED}
        )
        FetchContent_MakeAvailable(IOSFirebaseFramework)
        file(CREATE_LINK ${FIREBASE_IOS_SDK_VERSIONED} ${FIREBASE_IOS_SDK} SYMBOLIC)

    endif()
    target_link_options(QtFirebase PRIVATE -ObjC)
    LIST(APPEND
        HEADER_FILES
            ${CMAKE_CURRENT_SOURCE_DIR}/src/ios/AppDelegate.h
    )
    LIST(APPEND
        SOURCE_FILES
            ${CMAKE_CURRENT_SOURCE_DIR}/src/ios/platformutils.mm
            ${CMAKE_CURRENT_SOURCE_DIR}/src/ios/AppDelegate.mm
    )
    LIST(APPEND
        EXTRA_LIBS
            ObjC
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

)

target_link_libraries(QtFirebase PRIVATE
    firebase_app
    firebase_functions
#    firebase_performance
    ${EXTRA_LIBS}
)
#set_target_properties(QtFirebase PROPERTIES
#    XCODE_ATTRIBUTE_MACH_O_TYPE "dynamiclib"
#)
if (IOS)
#add_xcframework_to_target(QtFirebase FirebaseAnalytics FirebaseAnalytics)
#add_xcframework_to_target(QtFirebase FirebaseAnalytics FirebaseCore)

#Messages
#add_xcframework_to_target(QtFirebase FirebaseMessaging FirebaseInstanceID)
#add_xcframework_to_target(QtFirebase FirebasePerformance Protobuf)
add_xcframework_to_target(QtFirebase FirebaseMessaging GoogleDataTransport)
add_xcframework_to_target(QtFirebase FirebaseMessaging FirebaseMessaging)

#Analityrcs
add_xcframework_to_target(QtFirebase FirebaseAnalytics FirebaseCoreInternal)
add_xcframework_to_target(QtFirebase FirebaseAnalytics FirebaseAnalytics)
add_xcframework_to_target(QtFirebase FirebaseAnalytics FirebaseCore)
add_xcframework_to_target(QtFirebase FirebaseAnalytics FBLPromises)
add_xcframework_to_target(QtFirebase FirebaseAnalytics GoogleUtilities)
add_xcframework_to_target(QtFirebase FirebaseAnalytics nanopb)
##add_xcframework_to_target(QtFirebase FirebaseAnalytics PromisesObjC)
add_xcframework_to_target(QtFirebase FirebaseAnalytics FirebaseInstallations)
#add_xcframework_to_target(QtFirebase FirebaseAnalytics GoogleAppMeasurement)

#add_xcframework_to_target(QtFirebase FirebaseFunctions FirebaseCoreExtension)
#add_xcframework_to_target(QtFirebase FirebaseMessaging GoogleDataTransport)

target_link_libraries(QtFirebase PRIVATE
    "-framework MediaPlayer"
    "-framework UIKit"
    "-framework CoreMotion"
    "-framework CoreTelephony"
    "-framework MessageUI"
    "-framework GLKit"
    "-framework AddressBook"
    "-framework SystemConfiguration"
)
endif()
message("EXTRAAAAAAA ${${EXTRA_LIBS}}")
#add_dependencies(QtFirebase FirebaseSDKFromGoogle)



add_subdirectory(example)
