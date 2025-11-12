import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects


Rectangle {
    id: root
    property var themeColors: ThemeManager.currentThemeColors

    radius: 12
    width: parent.width
    height: contentColumn.implicitHeight + 10
    border.color: themeColors.primaryColor
    border.width: 1
    color: themeColors.backgroundColor
    clip: true

    property var videoData: ({})

    // Защита от undefined данных
    property var safeData: videoData && videoData.data ? videoData.data : {}
    property string safeTitle: safeData.title || "Без названия"
    property int safeDuration: safeData.duration_seconds || 0
    property bool hasSubtitles: safeData.has_subtitles || false
    property bool hasNotes: safeData.has_notes || false
    property string safeimages: safeData.images || "qrc:/images/preview_standard.webp"
    property int likes: safeData.likes
    property int views: safeData.views

    Column {
        anchors.fill: parent
        anchors.margins: 1
        spacing: 5

        Rectangle {
            id: imagesContainer
            width: parent.width
            height: parent.height * 0.7
            color: "transparent"
            clip: true
            radius: 12

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: imagesContainer.width
                    height: imagesContainer.height
                    topLeftRadius: 12
                    topRightRadius: 12
                    bottomLeftRadius: 0
                    bottomRightRadius: 0
                }
            }

            Image {
                anchors.fill: parent
                source: safeimages
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                cache: true

                // Запасное изображение при ошибке загрузки
                onStatusChanged: {
                    if (status === Image.Error) {
                        source = "qrc:/images/preview_standard.webp"
                    }
                }

                Rectangle {
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.margins: 6
                    width: durationText.implicitWidth + 8
                    height: durationText.implicitHeight + 4
                    radius: 4
                    color: Qt.rgba(0, 0, 0, 0.7)

                    Text {
                        id: durationText
                        anchors.centerIn: parent
                        text: formatDuration(safeDuration)
                        font.pixelSize: 12
                        color: "white"
                    }
                }
            }
        }
        Column {
            id: contentColumn
            width: parent.width - 8
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 3

            // Верхняя строка с заголовком и кнопкой добавления
            RowLayout {
                width: parent.width
                spacing: 5

                Text {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop

                    text: safeTitle
                    font.pixelSize: 14
                    font.bold: true
                    wrapMode: Text.Wrap
                    maximumLineCount: 2
                    elide: Text.ElideRight
                    color: themeColors.textColor
                }

                Button {
                    Layout.preferredWidth: 30
                    Layout.preferredHeight: 30
                    Layout.alignment: Qt.AlignTop

                    background: Rectangle {
                        color: "transparent"
                        radius: 5
                        border.color: "transparent"
                    }

                    contentItem: Image {
                        source: "qrc:/icons/add_mark_icon.webp"
                        layer.enabled: true
                        layer.effect: ColorOverlay {
                            color: themeColors.textColor
                        }
                    }

                    // onClicked: addToBookmarks()
                }
            }

            // Нижняя строка с метками и статистикой
            RowLayout {
                width: parent.width
                spacing: 5

                // Левая часть - метки
                Row {
                    Layout.fillWidth: true
                    spacing: 5

                    // Метка субтитров
                    Rectangle {
                        id: subtitleLabel
                        visible: hasSubtitles
                        height: 18
                        width: subtitleText.implicitWidth + 8 // Фиксируем ширину без binding loop
                        radius: 9
                        color: themeColors.backgroundColor
                        border.color: themeColors.borderColor
                        border.width: 1

                        Text {
                            id: subtitleText
                            anchors.centerIn: parent
                            text: "Субтитры"
                            font.pixelSize: 10
                            color: themeColors.secondaryTextColor
                        }
                    }

                    // Метка заметок
                    Rectangle {
                        id: notesLabel
                        visible: hasNotes
                        height: 18
                        width: notesText.implicitWidth + 8 // Фиксируем ширину без binding loop
                        radius: 9
                        color: themeColors.backgroundColor
                        border.color: themeColors.borderColor
                        border.width: 1

                        Text {
                            id: notesText
                            anchors.centerIn: parent
                            text: "Заметки"
                            font.pixelSize: 10
                            color: themeColors.secondaryTextColor
                        }
                    }
                }

                // Правая часть - кнопки статистики
                Row {
                    spacing: 5

                    // Кнопка просмотров
                    Button {
                        width: 45
                        height: 35

                        background: Rectangle {
                            color: "transparent"
                            radius: 5
                            border.color: "transparent"
                        }

                        contentItem: Column {
                            spacing: 1
                            anchors.centerIn: parent

                            Image {
                                source: "qrc:/icons/release_overview_icon.webp"
                                fillMode: Image.PreserveAspectFit
                                width: 18
                                height: 18
                                anchors.horizontalCenter: parent.horizontalCenter
                                layer.enabled: true
                                layer.effect: ColorOverlay {
                                    color: themeColors.textColor
                                }
                            }

                            Text {
                                text: views
                                font.pixelSize: 9
                                color: themeColors.textColor
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                        // onClicked: showViewsDetails()
                    }

                    // Кнопка лайков
                    Button {
                        width: 45
                        height: 35

                        background: Rectangle {
                            color: "transparent"
                            radius: 5
                            border.color: "transparent"
                        }

                        contentItem: Column {
                            spacing: 1
                            anchors.centerIn: parent

                            Image {
                                source: "qrc:/icons/like_icon.webp"
                                fillMode: Image.PreserveAspectFit
                                width: 18
                                height: 18
                                anchors.horizontalCenter: parent.horizontalCenter
                                layer.enabled: true
                                layer.effect: ColorOverlay {
                                    color: themeColors.textColor
                                }
                            }

                            Text {
                                text: likes
                                font.pixelSize: 9
                                color: themeColors.textColor
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                        // onClicked: showLikesDetails()
                    }
                }
            }
        }
    }

    function formatDuration(seconds) {
        if (!seconds || seconds <= 0) return "0:00";
        var minutes = Math.floor(seconds / 60);
        var remainingSeconds = seconds % 60;
        return minutes + ":" + (remainingSeconds < 10 ? "0" : "") + remainingSeconds;
    }
}
