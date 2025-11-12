import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


Rectangle {
    id: root
    property string title: ""
    property var projects: []
    property var themeColors: ThemeManager.currentThemeColors
    property bool isEditMode: false  // <-- ДОБАВЛЕНО

    color: themeColors.backgroundColor
    radius: 8
    border.color: themeColors.primaryColor
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 10

        Text {
            text: title
            font.bold: true
            font.pointSize: 14
            color: themeColors.textColor
            Layout.fillWidth: true
            wrapMode: Text.Wrap
        }

        ScrollView {
            id: scrollViewId
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                id: projectsContainer
                width: scrollViewId.availableWidth
                spacing: 8

                Repeater {
                    model: root.projects

                    delegate: ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 3

                        RowLayout {
                            Layout.fillWidth: true

                            Text {
                                text: modelData.name
                                font.pointSize: 10
                                color: themeColors.textColor
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }

                            Text {
                                text: modelData.status
                                font.pointSize: 10
                                color: themeColors.secondaryTextColor
                            }
                        }

                        ProgressBar {
                            value: modelData.status / 100
                            Layout.fillWidth: true
                            Layout.preferredHeight: 6
                            background: Rectangle {
                                color: themeColors.textColor
                                radius: 3
                            }
                            contentItem: Rectangle {
                                color: themeColors.primaryColor
                                radius: 3
                            }
                        }
                    }
                }
            }
        }

        Item { Layout.fillHeight: true }
    }
}
