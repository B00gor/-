import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    property var themeColors
    property string title
    property var courses
    property string emptyText
    signal courseClicked(var course)

    width: parent.width
    implicitHeight: contentColumn.height
    color: "transparent"

    ColumnLayout {
        id: contentColumn
        width: parent.width
        spacing: 15

        // Заголовок
        Text {
            text: root.title
            font.pixelSize: 18
            font.bold: true
            color: themeColors.textColor
            Layout.fillWidth: true
        }

        // Сетка курсов
        Flow {
            id: coursesFlow
            Layout.fillWidth: true
            spacing: 15

            Repeater {
                model: root.courses

                delegate: CardCourse {
                    width: Math.min(300, (parent.width - 30) / 2)
                    themeColors: root.themeColors
                    courseData: modelData
                    onCourseClicked: root.courseClicked(modelData)
                }
            }

            // Сообщение если нет курсов
            Rectangle {
                width: parent.width
                height: 100
                color: "transparent"
                visible: root.courses.length === 0

                Text {
                    anchors.centerIn: parent
                    text: root.emptyText
                    color: themeColors.secondaryTextColor
                    font.pixelSize: 14
                }
            }
        }
    }
}
