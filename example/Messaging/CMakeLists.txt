cmake_minimum_required(VERSION 3.24)
SET(PROJECT_NAME "MessagingDemo")

project(${PROJECT_NAME} VERSION 1.0.0  LANGUAGES CXX)

find_package(Qt6
    REQUIRED COMPONENTS
        Core
        Gui
        Qml
        Quick
)
qt6_add_executable(${PROJECT_NAME}
    main.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/../../Helper.swift
)

#DO NOT FORGET TO OPEN PROJECT IN XCODE AND ACTIVATE THE SWIFT FILE IN TARGET MEMBERSHIP
set_target_properties(${PROJECT_NAME} PROPERTIES
#        XCODE_ATTRIBUTE_SWIFT_OBJC_BRIDGING_HEADER "${CMAKE_CURRENT_SOURCE_DIR}/../../QtFirebase-Bridging-Header.h"
#        XCODE_ATTRIBUTE_SWIFT_OBJC_INTERFACE_HEADER_NAME "${CMAKE_CURRENT_SOURCE_DIR}/Helper.swift"
        XCODE_ATTRIBUTE_ENABLE_BITCODE "NO"
        XCODE_ATTRIBUTE_ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES "YES"
        XCODE_ATTRIBUTE_SWIFT_VERSION "5.0"
#        SOURCES
#            ${CMAKE_CURRENT_SOURCE_DIR}/../../Helper.swift
)
#set_target_properties(${PROJECT_NAME} PROPERTIES
##    XCODE_ATTRIBUTE_SWIFT_OBJC_BRIDGING_HEADER "${CMAKE_CURRENT_SOURCE_DIR}/../../${PROJECT_NAME}-Bridging-Header.h"
#    SOURCES
#        ${CMAKE_CURRENT_SOURCE_DIR}/../../Helper.swift
#)
qt6_add_qml_module(${PROJECT_NAME}QML
    URI "/"
    VERSION 1.0
    QML_FILES
        main.qml
)
target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::Qml
    Qt${QT_VERSION_MAJOR}::Quick
    QtFirebase
    QtFirebaseplugin
    ${PROJECT_NAME}QML
    ${PROJECT_NAME}QMLplugin
)
qt6_import_qml_plugins(${PROJECT_NAME}QML)
add_dependencies(${PROJECT_NAME} QtFirebase)
