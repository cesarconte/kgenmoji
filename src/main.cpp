/*
    SPDX-FileCopyrightText: 2026 Cesar
    SPDX-License-Identifier: GPL-3.0-or-later
*/

#include <QApplication>
#include <QQuickStyle>
#include <QQuickWindow>
#include <QTimer>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QCommandLineParser>
#include <QIcon>
#include <KAboutData>
#include <KLocalizedString>

#include "genmojicontroller.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QCommandLineParser parser;
    parser.setApplicationDescription(QStringLiteral("Generador expresivo de Genmojis y Stickers con IA para KDE Plasma"));
    parser.addHelpOption();
    parser.addVersionOption();
    QCommandLineOption screenshotOpt(QStringLiteral("screenshot"),
                                     QStringLiteral("Capture window screenshot and exit"),
                                     QStringLiteral("path"));
    parser.addOption(screenshotOpt);
    parser.process(app);

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

    // Golden Gate parity: the application inherits the Plasma desktop style so
    // menus, tooltips and scroll bars match the rest of the CachyOS.UI
    // ecosystem instead of the raw Basic style.
    if (qEnvironmentVariableIsEmpty("QT_QUICK_CONTROLS_STYLE")) {
        QQuickStyle::setStyle(QStringLiteral("org.kde.desktop"));
    }

    QQmlApplicationEngine engine;
    // The CachyOS.UI design system (Liquid Glass) is installed system wide or
    // in the user prefix.
    engine.addImportPath(QStringLiteral("/home/cesar/.local/lib/qt6/qml"));
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

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    if (parser.isSet(screenshotOpt)) {
        if (auto *win = qobject_cast<QQuickWindow *>(engine.rootObjects().constFirst())) {
            const QString outPath = parser.value(screenshotOpt);
            QTimer::singleShot(500, win, [win, outPath, &app]() {
                const QImage img = win->grabWindow();
                img.save(outPath);
                app.quit();
            });
        }
    }

    return app.exec();
}
