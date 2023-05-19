SET(FIREBASE_IOS_SDK "${CMAKE_SOURCE_DIR}/external/ios/firebase")
SET(FIREBASE_IOS_SDK_VERSIONED "${CMAKE_SOURCE_DIR}/external/ios/firebase-${FIREBASE_IOS_VERSION}")
function(add_xcframework_to_target TARGET_NAME CATALOG_NAME FRAMEWORK_NAME)
    # Set the path to the XCFramework
    set(XCFRAMEWORK_PATH "${FIREBASE_IOS_SDK}/${CATALOG_NAME}/${FRAMEWORK_NAME}.xcframework")
    # Add the XCFramework to the link directories for all architectures
    if (CMAKE_OSX_SYSROOT MATCHES ".*iphonesimulator.*")
        foreach(arch IN ITEMS "ios-arm64_i386_x86_64-simulator" "ios-arm64_x86_64-simulator")
            link_directories(${XCFRAMEWORK_PATH}/${arch})
            # Add the header search path for all architectures
            target_include_directories(${TARGET_NAME} SYSTEM PRIVATE
                "${XCFRAMEWORK_PATH}/${arch}/${FRAMEWORK_NAME}.framework/Headers"
            )
        # Add the framework directory to the include path
        target_include_directories(${TARGET_NAME} SYSTEM PRIVATE
            "${XCFRAMEWORK_PATH}/${arch}"
        )
        # Link against the XCFramework for all architectures
        target_link_libraries(${TARGET_NAME} PRIVATE
            -framework ${FRAMEWORK_NAME}
            -F${XCFRAMEWORK_PATH}/${arch}
            #      "-arch" "${arch}"
        )

        add_library(${TARGET_NAME} STATIC IMPORTED)
        set_target_properties(${TARGET_NAME} PROPERTIES IMPORTED_LOCATION "${XCFRAMEWORK_PATH}/${arch}/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}")

    endforeach()
    else()
        foreach(arch IN ITEMS "ios-arm64" "ios-arm64_armv7")
            if (IS_DIRECTORY ${XCFRAMEWORK_PATH}/${arch})
                link_directories(${XCFRAMEWORK_PATH}/${arch}/${FRAMEWORK_NAME}.framework )
                # Add the header search path for all architectures
                target_include_directories(${TARGET_NAME} SYSTEM PRIVATE
                    "${XCFRAMEWORK_PATH}/${arch}/${FRAMEWORK_NAME}.framework/Headers"
                )
                # Add the framework directory to the include path
                target_include_directories(${TARGET_NAME} SYSTEM PUBLIC
                    "${XCFRAMEWORK_PATH}/${arch}"
                )
                # Link against the XCFramework for all architectures
                message("Link frameword ${FRAMEWORK_NAME} from ${XCFRAMEWORK_PATH}/${arch}")

                #    target_link_libraries(${TARGET_NAME} PUBLIC
                #        "-F${XCFRAMEWORK_PATH}/${arch}"
                #        "-framework ${FRAMEWORK_NAME}"
                #        #      "-arch" "${arch}"
                #    )
                target_link_libraries(${TARGET_NAME} PRIVATE
                    "-ObjC ${XCFRAMEWORK_PATH}/${arch}/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}"
                )
        #    message(FATAL_ERROR "Force Load: ${XCFRAMEWORK_PATH}/${arch}/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}")
            endif()
        endforeach()
    endif()
    #  # Add the header search path for all architectures
    #  foreach(arch IN ITEMS "ios-arm64" "ios-arm64_armv7")
    #    target_include_directories(${TARGET_NAME} SYSTEM PRIVATE
    #      "${XCFRAMEWORK_PATH}/${arch}/${FRAMEWORK_NAME}.framework/Headers"
    #    )
    #    # Add the framework directory to the include path
    #    target_include_directories(${TARGET_NAME} SYSTEM PRIVATE
    #      "${XCFRAMEWORK_PATH}/${arch}"
    #    )
    #  endforeach()

    #  # Link against the XCFramework for all architectures
    #  foreach(arch IN ITEMS "ios-arm64" "ios-arm64_armv7")
    #    target_link_libraries(${TARGET_NAME} PRIVATE
    #      "-framework ${FRAMEWORK_NAME}"
    #      "-F${XCFRAMEWORK_PATH}/${arch}"
    ##      "-arch" "${arch}"
    #    )
    #  endforeach()


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
