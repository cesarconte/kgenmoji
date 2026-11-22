/*
    SPDX-FileCopyrightText: 2026 Cesar
    SPDX-License-Identifier: GPL-3.0-or-later

    KGenmoji — Creador de Genmojis y Stickers con IA local (Apple Intelligence).
    Diseño Golden Gate / Liquid Glass (CachyOS.UI).
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import CachyOS.UI

CachyWindow {
    id: rootWindow

    title: CachyI18n.i18n("Genmoji")

    width: 880
    height: 640
    minimumWidth: 640
    minimumHeight: 520
    visible: true

    showTrafficLights: true
    showTitle: false                   // Golden Gate: centrado libre sin colisión con titleLabel
    showTitleBarDivider: false         // Golden Gate: cabecera translúcida sin divisor duro
    showWindowFrame: true              // Liquid Glass: blur KWin + rim especular
    resizable: true
    cornerRadius: CachyTheme.radiusWindow
    contentPadded: true                // margen perimetral de 18 px

    // Página activa: 0 = mezclador, 1 = creador, 2 = galería
    property int currentPage: 1

    // Índice de variante activa para el carrusel de Genmoji
    property int activeVariantIndex: 0

    // =========================================================================
    // CABECERA — IZQUIERDA: marca Apple Intelligence
    // =========================================================================
    headerLeading: [
        RowLayout {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            CachyIcon {
                name: "sparkles"
                size: 16
                color: Genmoji && Genmoji.isGenerating ? "#AF52DE" : CachyTheme.accentColor
            }

            CachyLabel {
                text: CachyI18n.i18n("Genmoji")
                font.pixelSize: 13
                font.weight: Font.DemiBold
                color: CachyPalette.text
            }
        }
    ]

    // =========================================================================
    // CABECERA — CENTRO: Selector de vista en cápsula Golden Gate
    // =========================================================================
    headerCenter: [
        CachySegmentedControl {
            anchors.centerIn: parent
            model: [
                CachyI18n.i18n("Creador IA"),
                CachyI18n.i18n("Mezclador"),
                CachyI18n.i18n("Mis Stickers (%1)", (Genmoji && Genmoji.recentStickers) ? Genmoji.recentStickers.length : 0)
            ]
            // Map: 0 -> Creador (page 1), 1 -> Mezclador (page 0), 2 -> Stickers (page 2)
            currentIndex: rootWindow.currentPage === 1 ? 0 : (rootWindow.currentPage === 0 ? 1 : 2)
            onCurrentIndexChanged: {
                if (currentIndex === 0) rootWindow.currentPage = 1;
                else if (currentIndex === 1) rootWindow.currentPage = 0;
                else rootWindow.currentPage = 2;
            }
        }
    ]

    // =========================================================================
    // CABECERA — DERECHA: acciones
    // =========================================================================
    headerActions: [
        RowLayout {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 6

            CachyToolbarButton {
                iconName: "folder"
                tooltipText: CachyI18n.i18n("Abrir la carpeta de stickers")
                onClicked: Genmoji.openStickersFolder()
            }

            CachyToolbarButton {
                iconName: "refresh"
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

                // =============================================================
                // PÁGINA 0: MEZCLADOR DE EMOJIS (Google Emoji Kitchen)
                // =============================================================
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

                        contentItem: Item {
                            ListView {
                                id: mashupsListView
                                anchors.fill: parent
                                clip: true
                                model: Genmoji.curatedMashups
                                spacing: 4

                                delegate: Rectangle {
                                    id: mashupDelegate
                                    required property var modelData
                                    required property int index

                                    readonly property bool isSelected: Genmoji.currentMashupUrl === mashupDelegate.modelData.url

                                    width: mashupsListView.width
                                    height: 44
                                    radius: CachyTheme.radiusSmall
                                    color: isSelected
                                        ? CachyPalette.cardBackgroundHover
                                        : (mashupMouse.containsMouse ? CachyPalette.hoverOverlay : "transparent")
                                    border.width: isSelected ? 1 : 0
                                    border.color: isSelected ? CachyTheme.accentColor : "transparent"

                                    Behavior on color {
                                        ColorAnimation { duration: CachyTheme.animFast }
                                    }

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.leftMargin: 10
                                        anchors.rightMargin: 10
                                        spacing: 8

                                        Text {
                                            text: mashupDelegate.modelData.emojis
                                            font.pixelSize: 18
                                            verticalAlignment: Text.AlignVCenter
                                        }

                                        CachyLabel {
                                            Layout.fillWidth: true
                                            Layout.minimumWidth: 0
                                            text: mashupDelegate.modelData.name
                                            font.pixelSize: 12
                                            font.bold: mashupDelegate.isSelected
                                            color: CachyPalette.text
                                            elide: Text.ElideRight
                                        }

                                        CachyIcon {
                                            name: "chevron-right"
                                            size: 10
                                            color: CachyPalette.textMuted
                                            visible: mashupDelegate.isSelected
                                        }
                                    }

                                    HoverHandler {
                                        id: mashupMouse
                                        cursorShape: Qt.PointingHandCursor
                                    }

                                    TapHandler {
                                        onTapped: Genmoji.selectMashup(mashupDelegate.index)
                                    }
                                }
                            }
                        }
                    }

                    // --- Previsualización del mashup ---
                    CachyCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumWidth: 0
                        Layout.preferredWidth: 4

                        contentItem: ColumnLayout {
                            spacing: CachyTheme.spacingMedium

                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                Item {
                                    anchors.centerIn: parent
                                    width: Math.min(parent.width - 32, parent.height - 32, 260)
                                    height: width

                                    Rectangle {
                                        anchors.fill: parent
                                        radius: CachyTheme.radiusLarge
                                        color: "transparent"
                                        border.width: 1
                                        border.color: CachyPalette.specularBorder
                                    }

                                    Image {
                                        id: mashupPreviewImage
                                        anchors.fill: parent
                                        anchors.margins: 10
                                        source: Genmoji.currentMashupUrl
                                        fillMode: Image.PreserveAspectFit
                                        smooth: true
                                    }
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.minimumWidth: 0
                                spacing: 8

                                CachyButton {
                                    Layout.fillWidth: true
                                    pillStyle: true
                                    primary: true
                                    iconName: "copy"
                                    text: CachyI18n.i18n("Copiar al portapapeles")
                                    onClicked: Genmoji.copyMashupToClipboard(Genmoji.currentMashupUrl)
                                }
                            }
                        }
                    }
                }

                // =============================================================
                // PÁGINA 1: CREADOR GENMOJI (APPLE INTELLIGENCE PROTAGONISTA)
                // =============================================================
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumWidth: 0
                    spacing: CachyTheme.spacingMedium

                    // --- Escenario Central Protagonista (macOS Golden Gate) ---
                    CachyCard {
                        id: canvasCard
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumWidth: 0

                        // Efecto luminoso iridiscente de Apple Intelligence durante la generación
                        Rectangle {
                            id: genGlow
                            anchors.fill: parent
                            radius: CachyTheme.radiusMedium
                            color: "transparent"
                            border.width: 2
                            border.color: "#AF52DE"
                            visible: Genmoji && Genmoji.isGenerating
                            opacity: 0.75

                            SequentialAnimation {
                                running: genGlow.visible
                                loops: Animation.Infinite
                                NumberAnimation { target: genGlow; property: "opacity"; from: 0.35; to: 0.85; duration: 900; easing.type: Easing.InOutQuad }
                                NumberAnimation { target: genGlow; property: "opacity"; from: 0.85; to: 0.35; duration: 900; easing.type: Easing.InOutQuad }
                            }
                        }

                        contentItem: ColumnLayout {
                            spacing: CachyTheme.spacingSmall

                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                // Estado de generación activa
                                ColumnLayout {
                                    anchors.centerIn: parent
                                    visible: Genmoji && Genmoji.isGenerating
                                    spacing: CachyTheme.spacingMedium

                                    CachyBusyIndicator {
                                        Layout.alignment: Qt.AlignHCenter
                                        running: Genmoji ? Genmoji.isGenerating : false
                                        size: 32
                                    }

                                    CachyLabel {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: CachyI18n.i18n("Creando y perfilando tu Genmoji con IA local…")
                                        color: CachyPalette.text
                                        font.pixelSize: 13
                                        font.weight: Font.DemiBold
                                    }
                                }

                                // Genmoji generado (Vista Principal)
                                Item {
                                    anchors.centerIn: parent
                                    visible: !Genmoji.isGenerating && Genmoji.currentStickerPath.length > 0
                                    width: Math.min(parent.width - 40, parent.height - 40, 260)
                                    height: width

                                    Image {
                                        anchors.fill: parent
                                        source: Genmoji.currentStickerPath.length > 0 ? ("file://" + Genmoji.currentStickerPath) : ""
                                        fillMode: Image.PreserveAspectFit
                                        smooth: true
                                    }
                                }

                                // Estado vacío inicial
                                ColumnLayout {
                                    anchors.centerIn: parent
                                    visible: !Genmoji.isGenerating && Genmoji.currentStickerPath.length === 0
                                    spacing: CachyTheme.spacingSmall

                                    CachyIcon {
                                        Layout.alignment: Qt.AlignHCenter
                                        name: "sparkles"
                                        size: 44
                                        color: CachyPalette.textMuted
                                    }

                                    CachyLabel {
                                        Layout.alignment: Qt.AlignHCenter
                                        text: CachyI18n.i18n("Describe una idea abajo y pulsa «Crear Genmoji»")
                                        color: CachyPalette.textMuted
                                        font.pixelSize: 13
                                    }
                                }
                            }

                            // --- Carrusel de Variantes e Indicadores de Página (macOS Genmoji) ---
                            RowLayout {
                                Layout.alignment: Qt.AlignHCenter
                                visible: !Genmoji.isGenerating && Genmoji.recentStickers.length > 1
                                spacing: 10

                                CachyToolbarButton {
                                    iconName: "chevron-left"
                                    tooltipText: CachyI18n.i18n("Variante anterior")
                                    enabled: rootWindow.activeVariantIndex > 0
                                    onClicked: {
                                        if (rootWindow.activeVariantIndex > 0) {
                                            rootWindow.activeVariantIndex--;
                                            const item = Genmoji.recentStickers[rootWindow.activeVariantIndex];
                                            if (item) Genmoji.currentStickerPath = item.path;
                                        }
                                    }
                                }

                                // Puntos de página (Dots de variantes)
                                Row {
                                    spacing: 6
                                    Repeater {
                                        model: Math.min(5, Genmoji.recentStickers.length)
                                        delegate: Rectangle {
                                            required property int index
                                            width: 7
                                            height: 7
                                            radius: 3.5
                                            color: index === rootWindow.activeVariantIndex
                                                ? CachyTheme.accentColor
                                                : CachyPalette.surfacePill
                                            border.width: 1
                                            border.color: CachyPalette.specularBorder

                                            MouseArea {
                                                anchors.fill: parent
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    rootWindow.activeVariantIndex = index;
                                                    const item = Genmoji.recentStickers[index];
                                                    if (item) Genmoji.currentStickerPath = item.path;
                                                }
                                            }
                                        }
                                    }
                                }

                                CachyToolbarButton {
                                    iconName: "chevron-right"
                                    tooltipText: CachyI18n.i18n("Siguiente variante")
                                    enabled: rootWindow.activeVariantIndex < Math.min(4, Genmoji.recentStickers.length - 1)
                                    onClicked: {
                                        if (rootWindow.activeVariantIndex < Math.min(4, Genmoji.recentStickers.length - 1)) {
                                            rootWindow.activeVariantIndex++;
                                            const item = Genmoji.recentStickers[rootWindow.activeVariantIndex];
                                            if (item) Genmoji.currentStickerPath = item.path;
                                        }
                                    }
                                }
                            }

                            // --- Acciones Cápsula del Genmoji Actual (Copiar, Guardar, Insertar, Historial) ---
                            RowLayout {
                                Layout.fillWidth: true
                                Layout.minimumWidth: 0
                                visible: !Genmoji.isGenerating && Genmoji.currentStickerPath.length > 0
                                spacing: 8

                                Item { Layout.fillWidth: true }

                                CachyButton {
                                    pillStyle: true
                                    iconName: "copy"
                                    text: CachyI18n.i18n("Copiar")
                                    onClicked: Genmoji.copyToClipboard(Genmoji.currentStickerPath)
                                }

                                CachyButton {
                                    pillStyle: true
                                    iconName: "download"
                                    text: CachyI18n.i18n("Guardar")
                                    onClicked: Genmoji.openStickersFolder()
                                }

                                CachyButton {
                                    pillStyle: true
                                    primary: true
                                    iconName: "check"
                                    text: CachyI18n.i18n("Insertar")
                                    onClicked: Genmoji.copyToClipboard(Genmoji.currentStickerPath)
                                }

                                CachyButton {
                                    pillStyle: true
                                    iconName: "grid"
                                    text: CachyI18n.i18n("Historial")
                                    onClicked: rootWindow.currentPage = 2
                                }

                                Item { Layout.fillWidth: true }
                            }
                        }
                    }

                    // --- Barra Inferior Cápsula: "Describe un Genmoji…" con Estilo y Botón Crear ---
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.minimumWidth: 0
                        spacing: 8

                        CachyTextField {
                            id: promptInput
                            Layout.fillWidth: true
                            Layout.minimumWidth: 0
                            pillStyle: true
                            leadingIcon: "sparkles"
                            showClearButton: true
                            placeholderText: CachyI18n.i18n("Describe un Genmoji… (ej: «Gato astronauta con guitarra», «Pizza con gafas de sol»)")
                            font.pixelSize: 13
                            onAccepted: {
                                if (text.trim().length > 0 && !Genmoji.isGenerating) {
                                    Genmoji.generateAiSticker(text.trim(), styleSelector.currentText);
                                }
                            }
                        }

                        CachyComboBox {
                            id: styleSelector
                            Layout.preferredWidth: 140
                            Layout.preferredHeight: 32
                            font.pixelSize: 12
                            model: ["3D Emoji", "Caricatura", "Pixel Art", "Pegatina Vector"]
                        }

                        CachyButton {
                            pillStyle: true
                            primary: true
                            iconName: "sparkles"
                            text: CachyI18n.i18n("Crear Genmoji")
                            enabled: promptInput.text.trim().length > 0 && !Genmoji.isGenerating
                            onClicked: {
                                Genmoji.generateAiSticker(promptInput.text.trim(), styleSelector.currentText);
                            }
                        }
                    }
                }

                // =============================================================
                // PÁGINA 2: MIS STICKERS (HISTORIAL)
                // =============================================================
                CachyCard {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumWidth: 0

                    contentItem: Item {
                        GridView {
                            id: galleryGrid
                            anchors.fill: parent
                            clip: true
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
                                    ? CachyPalette.cardBackgroundHover
                                    : "transparent"
                                border.width: 1
                                border.color: cardMouse.containsMouse
                                    ? CachyTheme.accentColor
                                    : CachyPalette.specularBorder

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

                                        CachyLabel {
                                            Layout.fillWidth: true
                                            Layout.minimumWidth: 0
                                            text: stickerCard.modelData.fileSizeText
                                            font.pixelSize: 10
                                            color: CachyPalette.textMuted
                                            elide: Text.ElideRight
                                        }

                                        CachyToolbarButton {
                                            iconName: "copy"
                                            tooltipText: CachyI18n.i18n("Copiar al portapapeles")
                                            onClicked: Genmoji.copyToClipboard(stickerCard.modelData.path)
                                        }

                                        CachyToolbarButton {
                                            iconName: "trash"
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

            CachyLabel {
                Layout.fillWidth: true
                Layout.minimumWidth: 0
                text: Genmoji.statusMessage
                color: CachyPalette.textMuted
                font.pixelSize: 11
                elide: Text.ElideRight
            }
        }
    ]
}
