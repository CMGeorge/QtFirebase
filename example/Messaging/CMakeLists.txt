#In the firebase_messaging_cpp.aar archive there is an AndroidManifest.xml file which declares FCM's default ListenerService. This manifest is normally merged with the project specific manifest which is how the ListenerService is able to run. This ListenerService needs to replaced with the cusom listener service. That is accomplished by removing the default ListenerService and adding the custom Service, which can be done with the following lines your projects AndroidManifest.xml file:

cmake_minimum_required(VERSION 3.24)
SET(PROJECT_NAME "MessagingDemo")
SET(CMAKE_AUTOMOC ON)

project(${PROJECT_NAME} VERSION 1.0.0  LANGUAGES CXX)

find_package(Qt6
    REQUIRED COMPONENTS
    Core
    Gui
    Qml
    Quick
)

if (IOS)
SET(GOOGLE_PLIST ios/GoogleService-Info.plist)
set_source_files_properties(${GOOGLE_PLIST} PROPERTIES MACOSX_PACKAGE_LOCATION Resources)
SET(SWIFT_FILE ${CMAKE_CURRENT_SOURCE_DIR}/../../Helper.swift)
#TODO This will assign the file to the current target
set_source_files_properties(${SWIFT_FILE} PROPERTIES LANGUAGE Swift)
else()
endif()
qt6_add_executable(${PROJECT_NAME}
    main.cpp
    ${SWIFT_FILE}
)
target_sources(${PROJECT_NAME} PRIVATE ${GOOGLE_PLIST})

qt6_add_qml_module(${PROJECT_NAME}QML STATIC
    URI "/"
    VERSION 1.0
    QML_FILES
    main.qml
)
IF (IOS)
set_target_properties(${PROJECT_NAME} PROPERTIES
    XCODE_ATTRIBUTE_ENABLE_BITCODE "NO"
    #        XCODE_ATTRIBUTE_ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES "YES"
    XCODE_ATTRIBUTE_SWIFT_VERSION "5.0"
    ##            SOURCES
    ##                ${CMAKE_CURRENT_SOURCE_DIR}/Helper.swift
)
endif()
target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::Qml
    Qt${QT_VERSION_MAJOR}::Quick
    QtFirebaseLib
    QtFirebaseLibplugin
    ${PROJECT_NAME}QML
    ${PROJECT_NAME}QMLplugin
    firebase_app
    firebase_functions
    firebase_messaging

)
set_target_properties(${PROJECT_NAME}
    PROPERTIES
    XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER "ro.wesell.QtMessagingDemo"

    QT_ANDROID_PACKAGE_NAME "ro.wesell"
    QT_ANDROID_VERSION_CODE "31"
    QT_ANDROID_VERSION_NAME ${PROJECT_NAME}
    QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android/
    #    QT_ANDROID_EXTRA_LIBS "${ANDROID_EXTRA_LIBS}"
)

qt6_import_qml_plugins(${PROJECT_NAME}QML)

add_dependencies(${PROJECT_NAME} QtFirebaseLib)
