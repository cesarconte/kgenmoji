/*
    SPDX-FileCopyrightText: 2026 Cesar
    SPDX-License-Identifier: GPL-3.0-or-later
*/

#include "genmojicontroller.h"

#include <QClipboard>
#include <QDateTime>
#include <QDesktopServices>
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QGuiApplication>
#include <QImage>
#include <QProcess>
#include <QRandomGenerator>
#include <QStandardPaths>
#include <QUrl>
#include <QUrlQuery>

GenmojiController::GenmojiController(QObject *parent)
    : QObject(parent)
    , m_nam(new QNetworkAccessManager(this))
{
    initStorage();
    loadCuratedMashups();
    refreshRecentStickers();
    m_statusMessage = QStringLiteral("Genmoji listo. Elige un mashup o escribe un prompt para crear un sticker IA.");
}

bool GenmojiController::isGenerating() const
{
    return m_isGenerating;
}

QString GenmojiController::statusMessage() const
{
    return m_statusMessage;
}

QString GenmojiController::currentStickerPath() const
{
    return m_currentStickerPath;
}

QVariantList GenmojiController::recentStickers() const
{
    return m_recentStickers;
}

QVariantList GenmojiController::curatedMashups() const
{
    return m_curatedMashups;
}

QString GenmojiController::currentMashupUrl() const
{
    return m_currentMashupUrl;
}

void GenmojiController::initStorage()
{
    const QString dataPath = QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation);
    m_storageDir = dataPath + QStringLiteral("/kgenmoji/stickers");
    m_cacheDir = dataPath + QStringLiteral("/kgenmoji/cache");

    QDir().mkpath(m_storageDir);
    QDir().mkpath(m_cacheDir);
}

void GenmojiController::loadCuratedMashups()
{
    // Curated high-resolution Google Emoji Kitchen combinations with verified gstatic CDN endpoints
    m_curatedMashups = QVariantList{
        QVariantMap{
            {QStringLiteral("name"), QStringLiteral("Gato Vaquero")},
            {QStringLiteral("emojis"), QStringLiteral("🐱 + 🤠")},
            {QStringLiteral("url"), QStringLiteral("https://www.gstatic.com/android/keyboard/emojikitchen/20230301/u1f920/u1f920_u1f431.png")}
        },
        QVariantMap{
            {QStringLiteral("name"), QStringLiteral("Café con Amor")},
            {QStringLiteral("emojis"), QStringLiteral("☕ + ❤️")},
            {QStringLiteral("url"), QStringLiteral("https://www.gstatic.com/android/keyboard/emojikitchen/20240610/u2764-ufe0f-u200d-u1fa79/u2764-ufe0f-u200d-u1fa79_u2615.png")}
        },
        QVariantMap{
            {QStringLiteral("name"), QStringLiteral("Pizza Picante")},
            {QStringLiteral("emojis"), QStringLiteral("🍕 + 🔥")},
            {QStringLiteral("url"), QStringLiteral("https://www.gstatic.com/android/keyboard/emojikitchen/20241021/u1f355/u1f355_u1f525.png")}
        },
        QVariantMap{
            {QStringLiteral("name"), QStringLiteral("Príncipe Rana")},
            {QStringLiteral("emojis"), QStringLiteral("🐸 + 👑")},
            {QStringLiteral("url"), QStringLiteral("https://www.gstatic.com/android/keyboard/emojikitchen/20230803/u1f438/u1f438_u1f451.png")}
        },
        QVariantMap{
            {QStringLiteral("name"), QStringLiteral("Robot Enamorado")},
            {QStringLiteral("emojis"), QStringLiteral("🤖 + ❤️")},
            {QStringLiteral("url"), QStringLiteral("https://www.gstatic.com/android/keyboard/emojikitchen/20240206/u1f916/u1f916_u2764-ufe0f.png")}
        },
        QVariantMap{
            {QStringLiteral("name"), QStringLiteral("Aguacate Sonriente")},
            {QStringLiteral("emojis"), QStringLiteral("🥑 + 🥰")},
            {QStringLiteral("url"), QStringLiteral("https://www.gstatic.com/android/keyboard/emojikitchen/20201001/u1f970/u1f970_u1f951.png")}
        },
        QVariantMap{
            {QStringLiteral("name"), QStringLiteral("Fantasma Cool")},
            {QStringLiteral("emojis"), QStringLiteral("👻 + 😎")},
            {QStringLiteral("url"), QStringLiteral("https://www.gstatic.com/android/keyboard/emojikitchen/20230301/u1f60e/u1f60e_u1f47b.png")}
        }
    };

    if (!m_curatedMashups.isEmpty()) {
        m_currentMashupUrl = m_curatedMashups.first().toMap().value(QStringLiteral("url")).toString();
    }
}

void GenmojiController::selectMashup(int index)
{
    if (index >= 0 && index < m_curatedMashups.size()) {
        const auto map = m_curatedMashups.at(index).toMap();
        m_currentMashupUrl = map.value(QStringLiteral("url")).toString();
        Q_EMIT currentMashupUrlChanged();
        m_statusMessage = QStringLiteral("Mashup seleccionado: ") + map.value(QStringLiteral("name")).toString();
        Q_EMIT statusMessageChanged();
    }
}

void GenmojiController::generateAiSticker(const QString &prompt, const QString &style)
{
    if (prompt.trimmed().isEmpty() || m_isGenerating) {
        return;
    }

    m_isGenerating = true;
    Q_EMIT generatingChanged();
    m_statusMessage = QStringLiteral("Generando sticker IA para: «") + prompt.trimmed() + QStringLiteral("»...");
    Q_EMIT statusMessageChanged();

    // Construct enhanced prompt targeting clean stickers with white border contour
    QString styleKeywords;
    if (style == QLatin1String("3D Emoji")) {
        styleKeywords = QStringLiteral("apple 3d emoji style, cute 3d clay render, smooth, vibrant, glossy");
    } else if (style == QLatin1String("Pixel Art")) {
        styleKeywords = QStringLiteral("retro pixel art style, 16-bit, vibrant colors, clear silhouette");
    } else if (style == QLatin1String("Caricatura")) {
        styleKeywords = QStringLiteral("cartoon mascot vector art style, playful, expressive, bold outlines");
    } else {
        styleKeywords = QStringLiteral("die-cut sticker style, vector graphic, vibrant, clean design");
    }

    const QString fullPrompt = QStringLiteral("%1, %2, sticker with white contour border, isolated centered, clean plain transparent background, high quality")
                                   .arg(prompt.trimmed(), styleKeywords);

    const quint32 seed = QRandomGenerator::global()->generate();
    const QString encodedPrompt = QString::fromUtf8(QUrl::toPercentEncoding(fullPrompt));
    QUrl url(QStringLiteral("https://image.pollinations.ai/prompt/") + encodedPrompt);
    QUrlQuery query;
    query.addQueryItem(QStringLiteral("width"), QStringLiteral("512"));
    query.addQueryItem(QStringLiteral("height"), QStringLiteral("512"));
    query.addQueryItem(QStringLiteral("nologo"), QStringLiteral("true"));
    query.addQueryItem(QStringLiteral("seed"), QString::number(seed));
    url.setQuery(query);

    QNetworkRequest request(url);
    request.setAttribute(QNetworkRequest::User, prompt.trimmed());
    QNetworkReply *reply = m_nam->get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        onDownloadFinished(reply);
    });
}

void GenmojiController::onDownloadFinished(QNetworkReply *reply)
{
    m_isGenerating = false;
    Q_EMIT generatingChanged();

    if (reply->error() != QNetworkReply::NoError) {
        m_statusMessage = QStringLiteral("Error de conexión al generar sticker: ") + reply->errorString();
        Q_EMIT statusMessageChanged();
        reply->deleteLater();
        return;
    }

    const QByteArray data = reply->readAll();
    const QString prompt = reply->request().attribute(QNetworkRequest::User).toString();
    reply->deleteLater();

    if (data.isEmpty()) {
        m_statusMessage = QStringLiteral("Respuesta vacía del servidor.");
        Q_EMIT statusMessageChanged();
        return;
    }

    const QString timeTag = QDateTime::currentDateTime().toString(QStringLiteral("yyyyMMdd_hhmmss"));
    const QString tempPath = m_cacheDir + QStringLiteral("/raw_%1.png").arg(timeTag);
    const QString finalPath = m_storageDir + QStringLiteral("/genmoji_%1.png").arg(timeTag);

    QFile tempFile(tempPath);
    if (!tempFile.open(QIODevice::WriteOnly)) {
        m_statusMessage = QStringLiteral("No se pudo guardar la imagen temporal.");
        Q_EMIT statusMessageChanged();
        return;
    }
    tempFile.write(data);
    tempFile.close();

    // Process with KLiftSubject to automatically remove background and add sticker outline
    processStickerWithLiftSubject(tempPath, finalPath);

    m_currentStickerPath = finalPath;
    Q_EMIT currentStickerPathChanged();

    // Automatically copy generated sticker to clipboard
    copyToClipboard(finalPath);

    refreshRecentStickers();

    m_statusMessage = QStringLiteral("¡Sticker «%1» creado y copiado al portapapeles!").arg(prompt);
    Q_EMIT statusMessageChanged();
    Q_EMIT stickerReady(finalPath);
}

void GenmojiController::processStickerWithLiftSubject(const QString &tempPath, const QString &finalPath)
{
    const QString homeDir = QDir::homePath();
    const QString liftSubjectBin = homeDir + QStringLiteral("/.local/bin/kliftsubject");

    if (QFile::exists(liftSubjectBin)) {
        QProcess proc;
        proc.start(liftSubjectBin, {QStringLiteral("--sticker"), tempPath});
        if (proc.waitForFinished(15000)) {
            const QString stickerVariant = tempPath.left(tempPath.lastIndexOf(QLatin1Char('.'))) + QStringLiteral("-sticker.png");
            if (QFile::exists(stickerVariant)) {
                QFile::remove(finalPath);
                QFile::rename(stickerVariant, finalPath);
                QFile::remove(tempPath);
                return;
            }
        }
    }

    // Fallback: If kliftsubject isn't called or failed, load with QImage and save
    QImage img(tempPath);
    if (!img.isNull()) {
        img.save(finalPath, "PNG");
    } else {
        QFile::copy(tempPath, finalPath);
    }
    QFile::remove(tempPath);
}

void GenmojiController::copyToClipboard(const QString &imagePath)
{
    if (!QFile::exists(imagePath)) {
        return;
    }

    // 1. Copy via Qt GUI Application Clipboard
    QImage img(imagePath);
    if (!img.isNull()) {
        QGuiApplication::clipboard()->setImage(img);
    }

    // 2. Also copy via wl-copy for native Wayland apps
    QProcess::startDetached(QStringLiteral("wl-copy"), {QStringLiteral("--type"), QStringLiteral("image/png")}, {}, nullptr);
    QProcess wlProc;
    wlProc.setStandardInputFile(imagePath);
    wlProc.start(QStringLiteral("wl-copy"), {QStringLiteral("--type"), QStringLiteral("image/png")});
    wlProc.waitForFinished(1000);

    m_statusMessage = QStringLiteral("Sticker copiado al portapapeles de Wayland.");
    Q_EMIT statusMessageChanged();
}

void GenmojiController::copyMashupToClipboard(const QString &imageUrl)
{
    if (imageUrl.isEmpty()) {
        return;
    }

    m_statusMessage = QStringLiteral("Descargando mashup para portapapeles...");
    Q_EMIT statusMessageChanged();

    QNetworkRequest req{QUrl(imageUrl)};
    QNetworkReply *reply = m_nam->get(req);
    connect(reply, &QNetworkReply::finished, this, [this, reply, imageUrl]() {
        if (reply->error() == QNetworkReply::NoError) {
            const QByteArray data = reply->readAll();
            const QString timeTag = QDateTime::currentDateTime().toString(QStringLiteral("yyyyMMdd_hhmmss"));
            const QString savedPath = m_storageDir + QStringLiteral("/mashup_%1.png").arg(timeTag);
            QFile f(savedPath);
            if (f.open(QIODevice::WriteOnly)) {
                f.write(data);
                f.close();
                copyToClipboard(savedPath);
                refreshRecentStickers();
                m_currentStickerPath = savedPath;
                Q_EMIT currentStickerPathChanged();
                m_statusMessage = QStringLiteral("Mashup copiado al portapapeles y guardado en Mis Stickers.");
                Q_EMIT statusMessageChanged();
            }
        } else {
            m_statusMessage = QStringLiteral("Error al descargar mashup.");
            Q_EMIT statusMessageChanged();
        }
        reply->deleteLater();
    });
}

void GenmojiController::deleteSticker(const QString &imagePath)
{
    if (QFile::exists(imagePath)) {
        QFile::remove(imagePath);
        refreshRecentStickers();
        if (m_currentStickerPath == imagePath) {
            m_currentStickerPath.clear();
            Q_EMIT currentStickerPathChanged();
        }
        m_statusMessage = QStringLiteral("Sticker eliminado.");
        Q_EMIT statusMessageChanged();
    }
}

void GenmojiController::openStickersFolder()
{
    QDesktopServices::openUrl(QUrl::fromLocalFile(m_storageDir));
}

void GenmojiController::refreshRecentStickers()
{
    m_recentStickers.clear();
    QDir dir(m_storageDir, QStringLiteral("*.png"), QDir::Time | QDir::Reversed, QDir::Files);
    const QFileInfoList files = dir.entryInfoList();
    for (int i = 0; i < files.size() && i < 30; ++i) {
        const QFileInfo &fi = files.at(i);
        QVariantMap item;
        item[QStringLiteral("path")] = fi.absoluteFilePath();
        item[QStringLiteral("fileName")] = fi.fileName();
        item[QStringLiteral("fileSizeText")] = QString(QString::number(fi.size() / 1024) + QStringLiteral(" KB"));
        m_recentStickers.append(item);
    }
    Q_EMIT recentStickersChanged();
}
