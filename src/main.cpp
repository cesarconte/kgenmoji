/*
    SPDX-FileCopyrightText: 2026 Cesar
    SPDX-License-Identifier: GPL-3.0-or-later
*/

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <KAboutData>
#include <KLocalizedString>

#include "genmojicontroller.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setOrganizationName(QStringLiteral("Cesar"));
    app.setOrganizationDomain(QStringLiteral("cesar.org"));
    app.setApplicationName(QStringLiteral("KGenmoji"));
    app.setWindowIcon(QIcon::fromTheme(QStringLiteral("face-smile")));

    KAboutData aboutData(
        QStringLiteral("kgenmoji"),
        i18n("KGenmoji"),
        QStringLiteral("0.1.0"),
        i18n("Generador expresivo de Genmojis y Stickers con IA para KDE Plasma"),
        KAboutLicense::GPL_V3,
        i18n("© 2026 Cesar")
    );
    KAboutData::setApplicationData(aboutData);

    GenmojiController controller;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty(QStringLiteral("Genmoji"), &controller);

    const QUrl url(QStringLiteral("qrc:/qt/qml/org/cesar/kgenmoji/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl) {
                QCoreApplication::exit(-1);
            }
        },
        Qt::QueuedConnection
    );

    engine.load(url);

    return app.exec();
}
