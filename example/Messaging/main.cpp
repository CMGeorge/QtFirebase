// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0

#include <QGuiApplication>
#include <QDir>
#include <QQmlApplicationEngine>
//#include <QNetworkAccessManager>
#include <QQmlContext>
#include <QCoreApplication>

int main(int argc, char *argv[])
{
//    qputenv("QML_IMPORT_TRACE", "1");
//    set_qt_environment();
    QGuiApplication app(argc, argv);

//    QNetworkAccessManager _nam;
    app.setApplicationName("FirebaseMessagingTestApp");
    app.setOrganizationName("REEA");
    app.setOrganizationDomain("ro.wesell");
    QQmlApplicationEngine engine;
    const QUrl url("qrc:/main.qml");

    QObject::connect(
                &engine, &QQmlApplicationEngine::objectCreated, &app,
                [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
        else{
            #ifdef Q_OS_ANDROID
                QNativeInterface::QAndroidApplication::hideSplashScreen(500);
            #endif
        }
    },
    Qt::QueuedConnection);

//    engine.addImportPath(QCoreApplication::applicationDirPath() + "/qml");
//    engine.addImportPath(":/");
//    engine.addImportPath("../../qml");

    engine.load(url);

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    return app.exec();
}
