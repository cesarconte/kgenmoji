/*
    SPDX-FileCopyrightText: 2026 Cesar
    SPDX-License-Identifier: GPL-3.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Window {
    id: rootWindow
    width: 580
    height: 640
    visible: true
    color: "transparent"
    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    title: "KGenmoji"

    Rectangle {
        id: mainSurface
        anchors.fill: parent
        anchors.margins: Kirigami.Units.smallSpacing
        radius: Kirigami.Units.largeSpacing
        color: Kirigami.Theme.backgroundColor
        border.width: 1
        border.color: Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.18)

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Kirigami.Units.largeSpacing
            spacing: Kirigami.Units.mediumSpacing

            // Top Header: Title + Actions
            RowLayout {
                Layout.fillWidth: true
                spacing: Kirigami.Units.smallSpacing

                Kirigami.Icon {
                    source: "face-smile"
                    implicitWidth: Kirigami.Units.iconSizes.medium
                    implicitHeight: Kirigami.Units.iconSizes.medium
                    color: Kirigami.Theme.highlightColor
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    QQC2.Label {
                        text: "KGenmoji"
                        font.pixelSize: 16
                        font.bold: true
                        color: Kirigami.Theme.textColor
                    }

                    QQC2.Label {
                        text: "Genmojis y Stickers con IA · Wayland"
                        font.pixelSize: Kirigami.Theme.smallFont.pixelSize
                        color: Kirigami.Theme.disabledTextColor
                    }
                }

                QQC2.ToolButton {
                    icon.name: "folder-pictures-symbolic"
                    QQC2.ToolTip.visible: hovered
                    QQC2.ToolTip.text: "Abrir carpeta de stickers (~/.local/share/kgenmoji/stickers)"
                    onClicked: Genmoji.openStickersFolder()
                }

                QQC2.ToolButton {
                    icon.name: "view-refresh-symbolic"
                    QQC2.ToolTip.visible: hovered
                    QQC2.ToolTip.text: "Actualizar stickers"
                    onClicked: Genmoji.refreshRecentStickers()
                }

                QQC2.ToolButton {
                    icon.name: "window-close-symbolic"
                    QQC2.ToolTip.visible: hovered
                    QQC2.ToolTip.text: "Cerrar"
                    onClicked: Qt.quit()
                }
            }

            // Navigation Tabs
            QQC2.TabBar {
                id: tabNav
                Layout.fillWidth: true
                currentIndex: 0

                QQC2.TabButton {
                    text: "✨ Mezclador Emoji"
                    width: implicitWidth
                }
                QQC2.TabButton {
                    text: "🎨 Creador IA"
                    width: implicitWidth
                }
                QQC2.TabButton {
                    text: "📁 Mis Stickers (" + Genmoji.recentStickers.length + ")"
                    width: implicitWidth
                }
            }

            // Tab Content Stack
            StackLayout {
                id: stackContent
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: tabNav.currentIndex

                // ==================== TAB 0: EMOJI KITCHEN MASHUPS ====================
                ColumnLayout {
                    spacing: Kirigami.Units.mediumSpacing

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: Kirigami.Units.mediumSpacing

                        // Left: Curated Mashup Grid
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.preferredWidth: 3
                            radius: Kirigami.Units.mediumSpacing
                            color: Kirigami.Theme.alternateBackgroundColor
                            border.width: 1
                            border.color: Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.12)

                            QQC2.ScrollView {
                                anchors.fill: parent
                                anchors.margins: Kirigami.Units.smallSpacing
                                clip: true

                                ListView {
                                    id: mashupList
                                    anchors.fill: parent
                                    spacing: 4
                                    model: Genmoji.curatedMashups

                                    delegate: Rectangle {
                                        id: mashupDelegate
                                        required property var modelData
                                        required property int index
                                        width: ListView.view.width
                                        height: 44
                                        radius: 6
                                        color: ListView.isCurrentItem
                                            ? Qt.rgba(Kirigami.Theme.highlightColor.r, Kirigami.Theme.highlightColor.g, Kirigami.Theme.highlightColor.b, 0.18)
                                            : (mashupMouse.containsMouse
                                                ? Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.alternateBackgroundColor, Kirigami.Theme.textColor, 0.08)
                                                : Kirigami.Theme.backgroundColor)
                                        border.width: 1
                                        border.color: ListView.isCurrentItem
                                            ? Kirigami.Theme.highlightColor
                                            : Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.10)

                                        RowLayout {
                                            anchors.fill: parent
                                            anchors.leftMargin: 8
                                            anchors.rightMargin: 8
                                            spacing: 8

                                            QQC2.Label {
                                                text: mashupDelegate.modelData.emojis
                                                font.pixelSize: 18
                                            }

                                            QQC2.Label {
                                                Layout.fillWidth: true
                                                text: mashupDelegate.modelData.name
                                                font.bold: mashupList.currentIndex === mashupDelegate.index
                                                color: Kirigami.Theme.textColor
                                                elide: Text.ElideRight
                                            }
                                        }

                                        MouseArea {
                                            id: mashupMouse
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                mashupList.currentIndex = mashupDelegate.index
                                                Genmoji.selectMashup(mashupDelegate.index)
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // Right: Live Big Preview & Copy
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.preferredWidth: 2
                            radius: Kirigami.Units.mediumSpacing
                            color: Kirigami.Theme.alternateBackgroundColor
                            border.width: 1
                            border.color: Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.12)

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: Kirigami.Units.mediumSpacing
                                spacing: Kirigami.Units.smallSpacing

                                Item {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true

                                    Image {
                                        anchors.centerIn: parent
                                        width: Math.min(parent.width - 16, parent.height - 16)
                                        height: width
                                        source: Genmoji.currentMashupUrl
                                        fillMode: Image.PreserveAspectFit
                                        smooth: true
                                    }
                                }

                                QQC2.Button {
                                    Layout.fillWidth: true
                                    icon.name: "edit-copy-symbolic"
                                    text: "Copiar al portapapeles"
                                    highlighted: true
                                    onClicked: Genmoji.copyMashupToClipboard(Genmoji.currentMashupUrl)
                                }
                            }
                        }
                    }
                }

                // ==================== TAB 1: AI STICKER CREATOR ====================
                ColumnLayout {
                    spacing: Kirigami.Units.mediumSpacing

                    // Prompt Box
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Kirigami.Units.smallSpacing

                        QQC2.TextField {
                            id: promptInput
                            Layout.fillWidth: true
                            placeholderText: "Describe tu Genmoji o sticker (ej: «Gato astronauta con guitarra»)..."
                            color: Kirigami.Theme.textColor
                            font.pixelSize: 13
                            onAccepted: {
                                if (text.trim().length > 0 && !Genmoji.isGenerating) {
                                    Genmoji.generateAiSticker(text.trim(), styleSelector.currentText)
                                }
                            }
                        }

                        QQC2.ComboBox {
                            id: styleSelector
                            implicitWidth: 130
                            model: ["3D Emoji", "Caricatura", "Pixel Art", "Pegatina Vector"]
                        }

                        QQC2.Button {
                            icon.name: "sparkles-symbolic"
                            text: "Crear Sticker"
                            highlighted: true
                            enabled: promptInput.text.trim().length > 0 && !Genmoji.isGenerating
                            onClicked: {
                                Genmoji.generateAiSticker(promptInput.text.trim(), styleSelector.currentText)
                            }
                        }
                    }

                    // Preview Stage
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: Kirigami.Units.mediumSpacing
                        color: Kirigami.Theme.alternateBackgroundColor
                        border.width: 1
                        border.color: Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.12)
                        clip: true

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Kirigami.Units.largeSpacing
                            spacing: Kirigami.Units.mediumSpacing

                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                // Busy Indicator while generating
                                ColumnLayout {
                                    anchors.centerIn: parent
                                    visible: Genmoji.isGenerating
                                    spacing: Kirigami.Units.mediumSpacing

                                    QQC2.BusyIndicator {
                                        Layout.alignment: Qt.AlignHCenter
                                        running: Genmoji.isGenerating
                                    }

                                    QQC2.Label {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Generando y perfilando sticker con KLiftSubject…"
                                        color: Kirigami.Theme.textColor
                                        font.bold: true
                                    }
                                }

                                // Finished Sticker Preview
                                Image {
                                    anchors.centerIn: parent
                                    visible: !Genmoji.isGenerating && Genmoji.currentStickerPath.length > 0
                                    width: Math.min(parent.width - 24, parent.height - 24, 280)
                                    height: width
                                    source: Genmoji.currentStickerPath.length > 0 ? ("file://" + Genmoji.currentStickerPath) : ""
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                }

                                // Placeholder when empty
                                ColumnLayout {
                                    anchors.centerIn: parent
                                    visible: !Genmoji.isGenerating && Genmoji.currentStickerPath.length === 0
                                    spacing: Kirigami.Units.smallSpacing

                                    Kirigami.Icon {
                                        Layout.alignment: Qt.AlignHCenter
                                        source: "insert-image"
                                        implicitWidth: 48
                                        implicitHeight: 48
                                        color: Kirigami.Theme.disabledTextColor
                                    }

                                    QQC2.Label {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: "Escribe una idea arriba y pulsa «Crear Sticker»"
                                        color: Kirigami.Theme.disabledTextColor
                                    }
                                }
                            }

                            // Action Toolbar for current sticker
                            RowLayout {
                                Layout.fillWidth: true
                                visible: !Genmoji.isGenerating && Genmoji.currentStickerPath.length > 0
                                spacing: Kirigami.Units.smallSpacing

                                QQC2.Button {
                                    Layout.fillWidth: true
                                    icon.name: "edit-copy-symbolic"
                                    text: "Copiar al portapapeles"
                                    onClicked: Genmoji.copyToClipboard(Genmoji.currentStickerPath)
                                }

                                QQC2.Button {
                                    icon.name: "folder-symbolic"
                                    text: "Ver archivo"
                                    onClicked: Genmoji.openStickersFolder()
                                }
                            }
                        }
                    }
                }

                // ==================== TAB 2: MY STICKERS GALLERY ====================
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: Kirigami.Units.mediumSpacing
                    color: Kirigami.Theme.alternateBackgroundColor
                    border.width: 1
                    border.color: Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.12)

                    QQC2.ScrollView {
                        anchors.fill: parent
                        anchors.margins: Kirigami.Units.smallSpacing
                        clip: true

                        GridView {
                            id: galleryGrid
                            anchors.fill: parent
                            cellWidth: 130
                            cellHeight: 145
                            model: Genmoji.recentStickers

                            delegate: Rectangle {
                                id: stickerCard
                                required property var modelData
                                width: 120
                                height: 135
                                radius: 8
                                color: Kirigami.Theme.backgroundColor
                                border.width: 1
                                border.color: cardMouse.containsMouse
                                    ? Kirigami.Theme.highlightColor
                                    : Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.12)

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 6
                                    spacing: 4

                                    Image {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        source: "file://" + stickerCard.modelData.path
                                        fillMode: Image.PreserveAspectFit
                                        smooth: true
                                    }

                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: 2

                                        QQC2.Label {
                                            Layout.fillWidth: true
                                            text: stickerCard.modelData.fileSizeText
                                            font.pixelSize: Kirigami.Theme.smallFont.pixelSize - 1
                                            color: Kirigami.Theme.disabledTextColor
                                            elide: Text.ElideRight
                                        }

                                        QQC2.ToolButton {
                                            icon.name: "edit-copy-symbolic"
                                            implicitWidth: 24
                                            implicitHeight: 24
                                            QQC2.ToolTip.visible: hovered
                                            QQC2.ToolTip.text: "Copiar al portapapeles"
                                            onClicked: Genmoji.copyToClipboard(stickerCard.modelData.path)
                                        }

                                        QQC2.ToolButton {
                                            icon.name: "edit-delete-symbolic"
                                            implicitWidth: 24
                                            implicitHeight: 24
                                            QQC2.ToolTip.visible: hovered
                                            QQC2.ToolTip.text: "Eliminar sticker"
                                            onClicked: Genmoji.deleteSticker(stickerCard.modelData.path)
                                        }
                                    }
                                }

                                MouseArea {
                                    id: cardMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: Genmoji.copyToClipboard(stickerCard.modelData.path)
                                }
                            }
                        }
                    }
                }
            }

            // Bottom Status Bar
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Kirigami.ColorUtils.linearInterpolation(Kirigami.Theme.backgroundColor, Kirigami.Theme.textColor, 0.12)
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Kirigami.Units.smallSpacing

                QQC2.Label {
                    Layout.fillWidth: true
                    text: Genmoji.statusMessage
                    color: Kirigami.Theme.disabledTextColor
                    font.pixelSize: Kirigami.Theme.smallFont.pixelSize
                    elide: Text.ElideRight
                }
            }
        }
    }
}
