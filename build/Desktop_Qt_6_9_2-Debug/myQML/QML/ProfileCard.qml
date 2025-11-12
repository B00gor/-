import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    property var themeColors
    property string userName
    property string userRole
    property string userAvatar
    property int coursesCount
    property int createdCount

    width: parent.width
    height: 120
    radius: 12
    color: themeColors.surfaceColor
    border.color: themeColors.primaryColor
    border.width: 1

    RowLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        // Аватар
        Rectangle {
            Layout.preferredWidth: 80
            Layout.preferredHeight: 80
            radius: 40
            color: "transparent"
            clip: true

            Image {
                id: avatarImage
                anchors.fill: parent
                source: root.userAvatar || "qrc:/icons/icon_standard.webp"
                fillMode: Image.PreserveAspectCrop

                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        width: avatarImage.width
                        height: avatarImage.height
                        radius: 40
                    }
                }
            }

            Rectangle {
                anchors.fill: parent
                radius: 40
                color: "transparent"
                border.color: themeColors.primaryColor
                border.width: 2
            }
        }

        // Информация
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 5

            Text {
                text: root.userName
                font.pixelSize: 20
                font.bold: true
                color: themeColors.textColor
                Layout.fillWidth: true
                elide: Text.ElideRight
            }

            Text {
                text: root.userRole
                font.pixelSize: 14
                color: themeColors.secondaryTextColor
                Layout.fillWidth: true
                elide: Text.ElideRight
            }

            Item { Layout.fillHeight: true }

            // Статистика
            RowLayout {
                Layout.fillWidth: true
                spacing: 15

                StatItem {
                    label: "Курсов пройдено"
                    value: root.coursesCount
                    themeColors: root.themeColors
                }

                StatItem {
                    label: "Курсов создано"
                    value: root.createdCount
                    themeColors: root.themeColors
                }
            }
        }
    }
}
