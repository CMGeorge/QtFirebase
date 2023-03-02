#include "platformutils.h"

#if defined(Q_OS_ANDROID)
jobject PlatformUtils::nativeWindow = nullptr;
#endif

/*
 * Google Play Services (only available under Android)
 */
#if defined(Q_OS_ANDROID)
GooglePlayServices::Availability GooglePlayServices::getAvailability()
{
    QJniEnvironment env;
    QJniObject  activity = QNativeInterface::QAndroidApplication::context();

    auto availablity = ::google_play_services::CheckAvailability(env.jniEnv(), activity.object());
    qDebug() << "GooglePlayServices::getAvailability result :" << availablity << " (0 is kAvailabilityAvailable)";
    return Availability(availablity);
}

bool GooglePlayServices::available()
{
    QJniEnvironment env;
    QJniObject  activity = QNativeInterface::QAndroidApplication::context();

    auto availablity = ::google_play_services::CheckAvailability(env.jniEnv(), activity.object());
    qDebug() << "GooglePlayServices::available() result :" << availablity << " (0 is kAvailabilityAvailable)";
    return ::google_play_services::kAvailabilityAvailable == availablity;
}
#endif

/*
 * PlatformUtils
 */
#if defined(Q_OS_ANDROID)
jobject PlatformUtils::getNativeWindow()
{
    QJniEnvironment env;

    QJniObject  activity = QNativeInterface::QAndroidApplication::context();

    if (!nativeWindow) {
        nativeWindow = env->NewGlobalRef(activity.object());
    }

    return nativeWindow;
}
#else
bool PlatformUtils::getNativeWindow()
{
    qDebug() << Q_FUNC_INFO << "not implemented";
    return false;
}
#endif
