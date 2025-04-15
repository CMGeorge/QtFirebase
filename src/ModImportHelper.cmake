SET(FIREBASE_IOS_SDK "${CMAKE_SOURCE_DIR}/external/ios/firebase")
SET(FIREBASE_IOS_SDK_VERSIONED "${CMAKE_SOURCE_DIR}/external/ios/firebase-${FIREBASE_IOS_VERSION}")
function(add_xcframework_to_target TARGET_NAME CATALOG_NAME FRAMEWORK_NAME)
    set(XCFRAMEWORK_PATH "${FIREBASE_IOS_SDK}/${CATALOG_NAME}/${FRAMEWORK_NAME}.xcframework")

    if(CMAKE_OSX_SYSROOT MATCHES "iphonesimulator")
        set(ARCH_LIST "ios-arm64_x86_64-simulator" "ios-arm64_i386_x86_64-simulator")
    else()
        set(ARCH_LIST "ios-arm64")
    endif()

    set(IMPORTED_TARGET_NAME Firebase_${FRAMEWORK_NAME})

    if(NOT TARGET ${IMPORTED_TARGET_NAME})
        foreach(ARCH IN LISTS ARCH_LIST)
            set(FRAMEWORK_DIR "${XCFRAMEWORK_PATH}/${ARCH}/${FRAMEWORK_NAME}.framework")
            set(FRAMEWORK_BINARY "${FRAMEWORK_DIR}/${FRAMEWORK_NAME}")

            if(EXISTS "${FRAMEWORK_BINARY}")
                add_library(${IMPORTED_TARGET_NAME} STATIC IMPORTED GLOBAL)
                set_target_properties(${IMPORTED_TARGET_NAME} PROPERTIES
                    IMPORTED_LOCATION "${FRAMEWORK_BINARY}"
                    INTERFACE_INCLUDE_DIRECTORIES "${FRAMEWORK_DIR}/Headers"
                    FRAMEWORK TRUE
                )

                # Carefully force load only this framework
                target_link_libraries(${TARGET_NAME} PRIVATE
                    "-force_load" "${FRAMEWORK_BINARY}"
                )

                target_include_directories(${TARGET_NAME} SYSTEM PRIVATE "${FRAMEWORK_DIR}")
                break()
            endif()
        endforeach()

        if(NOT TARGET ${IMPORTED_TARGET_NAME})
            message(WARNING "No valid slice found for ${FRAMEWORK_NAME}")
            return()
        endif()
    endif()

    target_link_libraries(${TARGET_NAME} PRIVATE ${IMPORTED_TARGET_NAME})
endfunction()

# function(add_xcframework_to_target TARGET_NAME CATALOG_NAME FRAMEWORK_NAME)
#     set(XCFRAMEWORK_PATH "${FIREBASE_IOS_SDK}/${CATALOG_NAME}/${FRAMEWORK_NAME}.xcframework")

#     # Detect platform: device vs simulator
#     if(CMAKE_OSX_SYSROOT MATCHES "iphonesimulator")
#         set(ARCH_LIST "ios-arm64_x86_64-simulator" "ios-arm64_i386_x86_64-simulator")
#     else()
#         set(ARCH_LIST "ios-arm64")
#     endif()

#     # Create a unique imported target name per framework
#     set(IMPORTED_TARGET_NAME Firebase_${FRAMEWORK_NAME})

#     # Avoid redefining the target
#     if(NOT TARGET ${IMPORTED_TARGET_NAME})
#         foreach(ARCH IN LISTS ARCH_LIST)
#             set(FRAMEWORK_DIR "${XCFRAMEWORK_PATH}/${ARCH}/${FRAMEWORK_NAME}.framework")
#             set(FRAMEWORK_BINARY "${FRAMEWORK_DIR}/${FRAMEWORK_NAME}")

#             if(EXISTS "${FRAMEWORK_BINARY}")
#                 add_library(${IMPORTED_TARGET_NAME} STATIC IMPORTED GLOBAL)
#                 set_target_properties(${IMPORTED_TARGET_NAME} PROPERTIES
#                     IMPORTED_LOCATION "${FRAMEWORK_BINARY}"
#                     INTERFACE_INCLUDE_DIRECTORIES "${FRAMEWORK_DIR}/Headers"
#                     FRAMEWORK TRUE
#                 )

#                 # Optional: provide framework search path
#                 target_include_directories(${TARGET_NAME} SYSTEM PRIVATE "${FRAMEWORK_DIR}")
#                 break()  # Stop after first valid slice
#             endif()
#         endforeach()

#         if(NOT TARGET ${IMPORTED_TARGET_NAME})
#             message(WARNING "No valid slice found for ${FRAMEWORK_NAME}")
#             return()
#         endif()
#     endif()

#     target_link_libraries(${TARGET_NAME} PRIVATE
#         "-ObjC"
#         ${IMPORTED_TARGET_NAME})
# endfunction()

function (importForMessenging userTarget)
if (IOS)
    add_xcframework_to_target(${userTarget} FirebaseAnalytics GoogleAppMeasurement)


    #add_xcframework_to_target(${userTarget} FirebaseAnalytics FirebaseAnalytics)
    #add_xcframework_to_target(${userTarget} FirebaseAnalytics FirebaseCore)

    #Messages
    #add_xcframework_to_target(${userTarget} FirebaseMessaging FirebaseInstanceID)
    #add_xcframework_to_target(${userTarget} FirebasePerformance Protobuf)


    #Analityrcs
    add_xcframework_to_target(${userTarget} FirebaseAnalytics FirebaseCoreInternal)
    #    add_xcframework_to_target(${userTarget} FirebaseAnalytics FirebaseAnalytics)
    add_xcframework_to_target(${userTarget} FirebaseAnalytics FirebaseCore)
    add_xcframework_to_target(${userTarget} FirebaseAnalytics FBLPromises)
    add_xcframework_to_target(${userTarget} FirebaseAnalytics GoogleUtilities)
    add_xcframework_to_target(${userTarget} FirebaseAnalytics nanopb)
    ##add_xcframework_to_target(${userTarget} FirebaseAnalytics PromisesObjC)
    add_xcframework_to_target(${userTarget} FirebaseAnalytics FirebaseInstallations)

    add_xcframework_to_target(${userTarget} FirebaseMessaging GoogleDataTransport)
    add_xcframework_to_target(${userTarget} FirebaseMessaging FirebaseMessaging)

    #add_xcframework_to_target(${userTarget} FirebaseFunctions FirebaseCoreExtension)
    #add_xcframework_to_target(${userTarget} FirebaseMessaging GoogleDataTransport)


    #add_xcframework_to_target(${userTarget} FirebasePerformance FirebasePerformance)
    #add_xcframework_to_target(${userTarget} FirebasePerformance FirebasePerformance)
    #add_xcframework_to_target(${userTarget} FirebasePerformance FirebaseSessions)
    #add_xcframework_to_target(${userTarget} FirebaseRemoteConfig FirebaseRemoteConfig)
    #add_xcframework_to_target(${userTarget} FirebaseRemoteConfig FirebaseABTesting)

    #    add_xcframework_to_target(${userTarget} FirebaseFunctions FirebaseSharedSwift)

    #set_property(TARGET QtFirebaseLib PROPERTY XCODE_ATTRIBUTE_OTHER_FLAGS "-ObjC")
    target_link_libraries(${userTarget} PRIVATE
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
endfunction()
