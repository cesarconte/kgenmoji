/*
    SPDX-FileCopyrightText: 2026 Cesar
    SPDX-License-Identifier: GPL-3.0-or-later
*/

#pragma once

#include <QObject>
#include <QString>
#include <QVariantList>
#include <QNetworkAccessManager>
#include <QNetworkReply>

class GenmojiController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isGenerating READ isGenerating NOTIFY generatingChanged)
    Q_PROPERTY(QString statusMessage READ statusMessage NOTIFY statusMessageChanged)
    Q_PROPERTY(QString currentStickerPath READ currentStickerPath NOTIFY currentStickerPathChanged)
    Q_PROPERTY(QVariantList recentStickers READ recentStickers NOTIFY recentStickersChanged)
    Q_PROPERTY(QVariantList curatedMashups READ curatedMashups NOTIFY curatedMashupsChanged)
    Q_PROPERTY(QString currentMashupUrl READ currentMashupUrl NOTIFY currentMashupUrlChanged)

public:
    explicit GenmojiController(QObject *parent = nullptr);
    ~GenmojiController() override = default;

    bool isGenerating() const;
    QString statusMessage() const;
    QString currentStickerPath() const;
    QVariantList recentStickers() const;
    QVariantList curatedMashups() const;
    QString currentMashupUrl() const;

    Q_INVOKABLE void generateAiSticker(const QString &prompt, const QString &style = QStringLiteral("3D Emoji"));
    Q_INVOKABLE void selectMashup(int index);
    Q_INVOKABLE void copyToClipboard(const QString &imagePath);
    Q_INVOKABLE void copyMashupToClipboard(const QString &imageUrl);
    Q_INVOKABLE void deleteSticker(const QString &imagePath);
    Q_INVOKABLE void openStickersFolder();
    Q_INVOKABLE void refreshRecentStickers();

Q_SIGNALS:
    void generatingChanged();
    void statusMessageChanged();
    void currentStickerPathChanged();
    void recentStickersChanged();
    void curatedMashupsChanged();
    void currentMashupUrlChanged();
    void stickerReady(const QString &filePath);

private Q_SLOTS:
    void onDownloadFinished(QNetworkReply *reply);

private:
    void initStorage();
    void loadCuratedMashups();
    void processStickerWithLiftSubject(const QString &tempPath, const QString &finalPath);

    bool m_isGenerating = false;
    QString m_statusMessage;
    QString m_currentStickerPath;
    QString m_currentMashupUrl;
    QVariantList m_recentStickers;
    QVariantList m_curatedMashups;

    QNetworkAccessManager *m_nam = nullptr;
    QString m_storageDir;
    QString m_cacheDir;
};
