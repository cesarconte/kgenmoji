/*
    SPDX-FileCopyrightText: 2026 Cesar
    SPDX-License-Identifier: GPL-3.0-or-later

    Golden Gate layout audit for KGenmoji.

    The real QML scene is mounted offscreen and the resulting QQuickItem tree
    is audited for the classic design defects: protruding items, items
    sticking out of the window, texts cut without elision and the window title
    overlapping the header clusters.

    The auditor itself lives in the design system (CachyOS.UI), so every
    application of the ecosystem verifies the very same invariants.
*/

#include <QDir>
#include <QGuiApplication>
#include <QLoggingCategory>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QTest>
#include <QUrl>

#include "LayoutAuditor.h"
#include "genmojicontroller.h"

namespace {

void addImportPaths(QQmlApplicationEngine &engine)
{
    const QStringList candidates = {
        qEnvironmentVariable("CACHYOS_UI_IMPORT_PATH"),
        qEnvironmentVariable("QML2_IMPORT_PATH"),
        QDir::homePath() + QStringLiteral("/.local/lib/qt6/qml"),
        QStringLiteral("/usr/lib/qt6/qml"),
    };

    for (const QString &entry : candidates) {
        const QStringList parts = entry.split(QLatin1Char(':'), Qt::SkipEmptyParts);
        for (const QString &part : parts) {
            if (!engine.importPathList().contains(part)) {
                engine.addImportPath(part);
            }
        }
    }
}

} // namespace

class TestLayoutAudit : public QObject
{
    Q_OBJECT

private Q_SLOTS:
    void initTestCase();
    void cleanupTestCase();
    void auditWindowStates_data();
    void auditWindowStates();
    void auditHeaderTitleSweep();

private:
    GenmojiController m_controller;
    QQmlApplicationEngine m_qmlEngine;
    QQuickWindow *m_window = nullptr;
    QObject *m_root = nullptr;
};

void TestLayoutAudit::initTestCase()
{
    addImportPaths(m_qmlEngine);

    m_qmlEngine.rootContext()->setContextProperty(QStringLiteral("Genmoji"), &m_controller);
    m_qmlEngine.load(QUrl(QStringLiteral("qrc:/qt/qml/org/cesar/kgenmoji/main.qml")));

    if (m_qmlEngine.rootObjects().isEmpty()) {
        QFAIL("The QML scene could not be loaded");
    }

    m_root = m_qmlEngine.rootObjects().constFirst();
    m_window = qobject_cast<QQuickWindow *>(m_root);
    if (!m_window) {
        QFAIL("The root object is not a window");
    }
    m_window->show();
    QTest::qWait(100);
}

void TestLayoutAudit::cleanupTestCase()
{
    m_window->hide();
}

void TestLayoutAudit::auditWindowStates_data()
{
    QTest::addColumn<int>("width");
    QTest::addColumn<int>("height");

    QTest::newRow("minimum") << 640 << 520;
    QTest::newRow("default") << 880 << 640;
    QTest::newRow("wide") << 1440 << 900;
    QTest::newRow("tall") << 700 << 1000;
}

void TestLayoutAudit::auditWindowStates()
{
    QFETCH(int, width);
    QFETCH(int, height);

    m_window->resize(width, height);
    QTest::qWait(50);

    // Every page of the application must be free of defects.
    for (int page = 0; page < 3; ++page) {
        m_root->setProperty("currentPage", page);
        QTest::qWait(30);

        const QList<LayoutAuditor::Violation> violations =
            LayoutAuditor::audit(m_window->contentItem());
        for (const LayoutAuditor::Violation &violation : violations) {
            QFAIL(qPrintable(QStringLiteral("page=%1 (%2x%3): %4")
                                 .arg(page)
                                 .arg(width)
                                 .arg(height)
                                 .arg(violation.toString())));
        }
    }
}

void TestLayoutAudit::auditHeaderTitleSweep()
{
    // The title must never collide with the header clusters, whatever the
    // window width is.
    for (int width = 640; width <= 1440; width += 3) {
        m_window->resize(width, 640);
        QTest::qWait(1);

        const QList<LayoutAuditor::Violation> violations =
            LayoutAuditor::audit(m_window->contentItem());
        for (const LayoutAuditor::Violation &violation : violations) {
            if (violation.rule != LayoutAuditor::Rule::HeaderOverlap) {
                continue;
            }
            QFAIL(qPrintable(QStringLiteral("width=%1: %2").arg(width).arg(violation.toString())));
        }
    }
}

int main(int argc, char *argv[])
{
    qputenv("QT_QPA_PLATFORM", "offscreen");
    qputenv("QT_QUICK_CONTROLS_STYLE", "Basic");

    // The KWin blur cannot be applied on the offscreen platform.
    QLoggingCategory::setFilterRules(QStringLiteral("kf.windowsystem.warning=false\n"));

    QGuiApplication app(argc, argv);
    app.setApplicationName(QStringLiteral("kgenmoji"));

    TestLayoutAudit testCase;
    return QTest::qExec(&testCase, argc, argv);
}

#include "test_layout_audit.moc"
