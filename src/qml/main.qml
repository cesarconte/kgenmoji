/*
    SPDX-FileCopyrightText: 2026 Cesar
    SPDX-License-Identifier: GPL-3.0-or-later

    KGenmoji — Creador de Genmojis y Stickers con IA local.

    Diseño Golden Gate / Liquid Glass (CachyOS.UI):
      * ventana `CachyWindow` con marco translúcido, cabecera de 44 px con el
        divisor duro de 1 px y radio de 20 px;
      * la navegación por pestañas son píldoras de cristal en la cabecera y las
        acciones de carpeta y actualización a su derecha;
      * cada superficie (mezclador, creador y galería) se presenta sobre
        `CachyCard`;
      * toda la paleta, los radios y los espaciados salen de `CachyTheme`.
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import CachyOS.UI

CachyWindow {
    id: rootWindow

    title: CachyI18n.i18n("KGenmoji — Creador de Genmojis y Stickers")

    // Canonical window metrics of the design system: the three views need a
    // landscape shape to breathe.
    width: CachyTheme.windowWidthSettings
    height: CachyTheme.windowHeightSettings
    minimumWidth: 640
    minimumHeight: 520
    visible: true

    showTrafficLights: true
    showTitleBarDivider: true          // divisor duro de 1 px
    showWindowFrame: true              // Liquid Glass: blur KWin + rim especular
    resizable: true
    cornerRadius: CachyTheme.radiusWindow
    contentPadded: true                // margen perimetral de 18 px

    // Página activa: 0 = mezclador, 1 = creador, 2 = galería
    property int currentPage: 0

    // =========================================================================
    // CABECERA — IZQUIERDA: marca
    // =========================================================================
    headerLeading: [
        Kirigami.Icon {
            anchors.verticalCenter: parent.verticalCenter
            source: "face-smile-symbolic"
            width: 18
            height: 18
            color: CachyTheme.accentColor
        }
    ]

    // =========================================================================
    // CABECERA — DERECHA: navegación y acciones
    // =========================================================================
    headerActions: [
        RowLayout {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 6

            // --- Navegación por pestañas ---
            CachyToolbarButton {
                checkable: true
                checked: rootWindow.currentPage === 0
                text: CachyI18n.i18n("Mezclador")
                tooltipText: CachyI18n.i18n("Mezclar emojis prediseñados")
                onToggled: (nextState) => {
                    if (nextState) {
                        rootWindow.currentPage = 0;
                    }
                }
            }

            CachyToolbarButton {
                checkable: true
                checked: rootWindow.currentPage === 1
                text: CachyI18n.i18n("Creador IA")
                tooltipText: CachyI18n.i18n("Generar un sticker con IA local")
                onToggled: (nextState) => {
                    if (nextState) {
                        rootWindow.currentPage = 1;
                    }
                }
            }

            CachyToolbarButton {
                checkable: true
                checked: rootWindow.currentPage === 2
                text: CachyI18n.i18n("Mis Stickers (%1)").arg(Genmoji.recentStickers.length)
                tooltipText: CachyI18n.i18n("Galería de stickers guardados")
                onToggled: (nextState) => {
                    if (nextState) {
                        rootWindow.currentPage = 2;
                    }
                }
            }

            // Separador duro antes de las acciones de archivo
            Rectangle {
                Layout.preferredWidth: 1
                Layout.preferredHeight: 18
                Layout.alignment: Qt.AlignVCenter
                color: CachyTheme.hardDividerColor
            }

            CachyToolbarButton {
                iconName: "folder-pictures-symbolic"
                tooltipText: CachyI18n.i18n("Abrir la carpeta de stickers (~/.local/share/kgenmoji/stickers)")
                onClicked: Genmoji.openStickersFolder()
            }

            CachyToolbarButton {
                iconName: "view-refresh-symbolic"
                tooltipText: CachyI18n.i18n("Actualizar los stickers")
                onClicked: Genmoji.refreshRecentStickers()
            }
        }
    ]

    // =========================================================================
    // CONTENIDO
    // =========================================================================
    contentData: [
        ColumnLayout {
            anchors.fill: parent
            spacing: CachyTheme.spacingMedium

            StackLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumWidth: 0
                currentIndex: rootWindow.currentPage

                // ==================== PÁGINA 0: MEZCLADOR DE EMOJIS ============
                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumWidth: 0
                    spacing: CachyTheme.spacingMedium

                    // --- Lista de combinaciones ---
                    CachyCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumWidth: 0
                        Layout.preferredWidth: 3

                        contentItem: QQC2.ScrollView {
                            id: mashupScroll
                            clip: true
                            QQC2.ScrollBar.vertical.policy: QQC2.ScrollBar.AsNeeded

                            ListView {
                                id: mashupList
                                spacing: 4
                                model: Genmoji.curatedMashups

                                delegate: Rectangle {
                                    id: mashupDelegate
                                    required property var modelData
                                    required property int index

                                    width: ListView.view ? ListView.view.width : 0
                                    height: 44
                                    radius: CachyTheme.radiusSmall
                                    color: ListView.isCurrentItem
                                        ? CachyTheme.withAlpha(CachyTheme.accentColor, 0.18)
                                        : (mashupMouse.containsMouse
                                            ? CachyTheme.cardBackgroundHover
                                            : "transparent")
                                    border.width: 1
                                    border.color: ListView.isCurrentItem
                                        ? CachyTheme.accentColor
                                        : CachyTheme.specularBorder

                                    Behavior on color {
                                        ColorAnimation { duration: 120 }
                                    }

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.leftMargin: 8
                                        anchors.rightMargin: 8
                                        spacing: 8

                                        Text {
                                            text: mashupDelegate.modelData.emojis
                                            font.pixelSize: 18
                                        }

                                        Text {
                                            Layout.fillWidth: true
                                            Layout.minimumWidth: 0
                                            text: mashupDelegate.modelData.name
                                            font.pixelSize: 12
                                            font.weight: mashupList.currentIndex === mashupDelegate.index
                                                ? Font.Bold
                                                : Font.Normal
                                            color: CachyTheme.textPrimary
                                            elide: Text.ElideRight
                                        }
                                    }

                                    HoverHandler {
                                        id: mashupMouse
                                        cursorShape: Qt.PointingHandCursor
                                    }

                                    TapHandler {
                                        onTapped: {
                                            mashupList.currentIndex = mashupDelegate.index;
                                            Genmoji.selectMashup(mashupDelegate.index);
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // --- Vista previa grande ---
                    CachyCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumWidth: 0
                        Layout.preferredWidth: 2

                        contentItem: ColumnLayout {
                            spacing: CachyTheme.spacingSmall

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

                            CachyToolbarButton {
                                Layout.fillWidth: true
                                iconName: "edit-copy-symbolic"
                                text: CachyI18n.i18n("Copiar al portapapeles")
                                primary: true
                                onClicked: Genmoji.copyMashupToClipboard(Genmoji.currentMashupUrl)
                            }
                        }
                    }
                }

                // ==================== PÁGINA 1: CREADOR DE STICKERS ============
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumWidth: 0
                    spacing: CachyTheme.spacingMedium

                    // --- Descripción y estilo ---
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.minimumWidth: 0
                        spacing: 8

                        CachyTextField {
                            id: promptInput
                            Layout.fillWidth: true
                            Layout.minimumWidth: 0
                            placeholderText: CachyI18n.i18n("Describe tu Genmoji o sticker (ej: «Gato astronauta con guitarra»)…")
                            font.pixelSize: 13
                            onAccepted: {
                                if (text.trim().length > 0 && !Genmoji.isGenerating) {
                                    Genmoji.generateAiSticker(text.trim(), styleSelector.currentText);
                                }
                            }
                        }

                        QQC2.ComboBox {
                            id: styleSelector
                            Layout.preferredWidth: 140
                            Layout.preferredHeight: 32
                            font.pixelSize: 12
                            model: ["3D Emoji", "Caricatura", "Pixel Art", "Pegatina Vector"]
                        }

                        CachyToolbarButton {
                            iconName: "sparkles-symbolic"
                            text: CachyI18n.i18n("Crear Sticker")
                            primary: true
                            enabled: promptInput.text.trim().length > 0 && !Genmoji.isGenerating
                            onClicked: {
                                Genmoji.generateAiSticker(promptInput.text.trim(), styleSelector.currentText);
                            }
                        }
                    }

                    // --- Escenario de previsualización ---
                    CachyCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumWidth: 0

                        contentItem: ColumnLayout {
                            spacing: CachyTheme.spacingSmall

                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                // Generando
                                ColumnLayout {
                                    anchors.centerIn: parent
                                    visible: Genmoji.isGenerating
                                    spacing: CachyTheme.spacingSmall

                                    QQC2.BusyIndicator {
                                        Layout.alignment: Qt.AlignHCenter
                                        running: Genmoji.isGenerating
                                    }

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: CachyI18n.i18n("Generando y perfilando el sticker…")
                                        color: CachyTheme.textPrimary
                                        font.pixelSize: 13
                                        font.weight: Font.DemiBold
                                    }
                                }

                                // Sticker generado
                                Image {
                                    anchors.centerIn: parent
                                    visible: !Genmoji.isGenerating && Genmoji.currentStickerPath.length > 0
                                    width: Math.min(parent.width - 24, parent.height - 24, 280)
                                    height: width
                                    source: Genmoji.currentStickerPath.length > 0 ? ("file://" + Genmoji.currentStickerPath) : ""
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                }

                                // Estado vacío
                                ColumnLayout {
                                    anchors.centerIn: parent
                                    visible: !Genmoji.isGenerating && Genmoji.currentStickerPath.length === 0
                                    spacing: CachyTheme.spacingSmall

                                    Kirigami.Icon {
                                        Layout.alignment: Qt.AlignHCenter
                                        source: "insert-image"
                                        Layout.preferredWidth: 48
                                        Layout.preferredHeight: 48
                                        color: CachyTheme.textMuted
                                    }

                                    Text {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: CachyI18n.i18n("Escribe una idea arriba y pulsa «Crear Sticker»")
                                        color: CachyTheme.textMuted
                                        font.pixelSize: 12
                                    }
                                }
                            }

                            // Acciones del sticker actual
                            RowLayout {
                                Layout.fillWidth: true
                                Layout.minimumWidth: 0
                                visible: !Genmoji.isGenerating && Genmoji.currentStickerPath.length > 0
                                spacing: 6

                                CachyToolbarButton {
                                    Layout.fillWidth: true
                                    iconName: "edit-copy-symbolic"
                                    text: CachyI18n.i18n("Copiar al portapapeles")
                                    onClicked: Genmoji.copyToClipboard(Genmoji.currentStickerPath)
                                }

                                CachyToolbarButton {
                                    iconName: "folder-symbolic"
                                    text: CachyI18n.i18n("Ver archivo")
                                    onClicked: Genmoji.openStickersFolder()
                                }
                            }
                        }
                    }
                }

                // ==================== PÁGINA 2: GALERÍA DE STICKERS ============
                CachyCard {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumWidth: 0

                    contentItem: QQC2.ScrollView {
                        id: galleryScroll
                        clip: true
                        QQC2.ScrollBar.vertical.policy: QQC2.ScrollBar.AsNeeded

                        GridView {
                            id: galleryGrid
                            cellWidth: 130
                            cellHeight: 145
                            model: Genmoji.recentStickers

                            delegate: Rectangle {
                                id: stickerCard
                                required property var modelData

                                width: 120
                                height: 135
                                radius: CachyTheme.radiusSmall
                                color: cardMouse.containsMouse
                                    ? CachyTheme.cardBackgroundHover
                                    : "transparent"
                                border.width: 1
                                border.color: cardMouse.containsMouse
                                    ? CachyTheme.accentColor
                                    : CachyTheme.specularBorder

                                Behavior on color {
                                    ColorAnimation { duration: 120 }
                                }

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
                                        Layout.minimumWidth: 0
                                        spacing: 2

                                        Text {
                                            Layout.fillWidth: true
                                            Layout.minimumWidth: 0
                                            text: stickerCard.modelData.fileSizeText
                                            font.pixelSize: 10
                                            color: CachyTheme.textMuted
                                            elide: Text.ElideRight
                                        }

                                        CachyToolbarButton {
                                            iconName: "edit-copy-symbolic"
                                            tooltipText: CachyI18n.i18n("Copiar al portapapeles")
                                            onClicked: Genmoji.copyToClipboard(stickerCard.modelData.path)
                                        }

                                        CachyToolbarButton {
                                            iconName: "edit-delete-symbolic"
                                            tooltipText: CachyI18n.i18n("Eliminar el sticker")
                                            onClicked: Genmoji.deleteSticker(stickerCard.modelData.path)
                                        }
                                    }
                                }

                                HoverHandler {
                                    id: cardMouse
                                    cursorShape: Qt.PointingHandCursor
                                }

                                TapHandler {
                                    onTapped: Genmoji.copyToClipboard(stickerCard.modelData.path)
                                }
                            }
                        }
                    }
                }
            }

            // -----------------------------------------------------------------
            // Barra de estado
            // -----------------------------------------------------------------
            CachyDivider {}

            Text {
                Layout.fillWidth: true
                Layout.minimumWidth: 0
                text: Genmoji.statusMessage
                color: CachyTheme.textMuted
                font.pixelSize: 11
                elide: Text.ElideRight
            }
        }
    ]
}
