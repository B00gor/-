import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    property var themeColors
    property var courseData
    property bool isSelected
    signal selected()
    signal editRequested()
    signal deleteRequested()

    width: parent.width
    height: 100
    radius: 12
    color: isSelected ? themeColors.primaryColor : themeColors.surfaceColor
    border.color: isSelected ? themeColors.accentColor : themeColors.borderColor
    border.width: isSelected ? 2 : 1

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.selected()
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 15

        // Превью
        Rectangle {
            Layout.preferredWidth: 70
            Layout.preferredHeight: 70
            radius: 8
            color: "transparent"
            clip: true

            Image {
                anchors.fill: parent
                source: courseData.thumbnail_path || "qrc:/images/preview_standard.webp"
                fillMode: Image.PreserveAspectCrop
            }
        }

        // Информация
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 5

            Text {
                text: courseData.title || "Без названия"
                font.pixelSize: 16
                font.bold: true
                color: isSelected ? "white" : themeColors.textColor
                Layout.fillWidth: true
                elide: Text.ElideRight
            }

            Text {
                text: courseData.description || "Описание отсутствует"
                font.pixelSize: 12
                color: isSelected ? Qt.rgba(1,1,1,0.8) : themeColors.secondaryTextColor
                Layout.fillWidth: true
                elide: Text.ElideRight
                maximumLineCount: 2
                wrapMode: Text.Wrap
            }

            Item { Layout.fillHeight: true }

            // Статистика
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Text {
                    text: "Уроков: " + (courseData.lessons ? courseData.lessons.length : 0)
                    font.pixelSize: 11
                    color: isSelected ? Qt.rgba(1,1,1,0.8) : themeColors.secondaryTextColor
                }

                Text {
                    text: "Студентов: " + (courseData.studentsCount || 0)
                    font.pixelSize: 11
                    color: isSelected ? Qt.rgba(1,1,1,0.8) : themeColors.secondaryTextColor
                }
            }
        }

        // Кнопки управления
        Column {
            Layout.alignment: Qt.AlignTop
            spacing: 5
            visible: root.isSelected

            Button {
                text: "✏️"
                ToolTip.text: "Редактировать"
                onClicked: root.editRequested()

                background: Rectangle {
                    color: themeColors.accentColor
                    radius: 4
                }
            }

            Button {
                text: "🗑️"
                ToolTip.text: "Удалить"
                onClicked: root.deleteRequested()

                background: Rectangle {
                    color: "#ff4757"
                    radius: 4
                }

                contentItem: Text {
                    text: parent.text
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }
}
