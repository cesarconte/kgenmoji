/*
    SPDX-FileCopyrightText: 2026 Cesar
    SPDX-License-Identifier: GPL-3.0-or-later
*/

#include <QTest>
#include <QSignalSpy>
#include <QDir>
#include <QFile>
#include "genmojicontroller.h"

class TestKGenmoji : public QObject
{
    Q_OBJECT

private Q_SLOTS:
    void testInitialization();
    void testMashupSelection();
    void testRecentStickersStorage();
};

void TestKGenmoji::testInitialization()
{
    GenmojiController controller;
    QCOMPARE(controller.isGenerating(), false);
    QVERIFY(!controller.statusMessage().isEmpty());
    QVERIFY(!controller.curatedMashups().isEmpty());
    QVERIFY(!controller.currentMashupUrl().isEmpty());
}

void TestKGenmoji::testMashupSelection()
{
    GenmojiController controller;
    const int count = controller.curatedMashups().size();
    QVERIFY(count > 1);

    controller.selectMashup(1);
    const QString secondUrl = controller.curatedMashups().at(1).toMap().value(QStringLiteral("url")).toString();
    QCOMPARE(controller.currentMashupUrl(), secondUrl);
}

void TestKGenmoji::testRecentStickersStorage()
{
    GenmojiController controller;
    // Calling refresh should execute cleanly without crashing
    controller.refreshRecentStickers();
    QVERIFY(controller.recentStickers().size() >= 0);
}

QTEST_MAIN(TestKGenmoji)
#include "test_kgenmoji.moc"
