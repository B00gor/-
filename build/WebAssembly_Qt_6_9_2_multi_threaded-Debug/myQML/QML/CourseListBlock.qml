import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Rectangle {
    id: root
    property var courses: []
    property var themeColors: ThemeManager.currentThemeColors
    property bool isEditMode: false
    property real minCardWidth: 300
    property real cardSpacing: 15

    signal courseSelected(var course)

    color: "transparent"

    Component.onCompleted: {
        console.log("📚 CourseListBlock initialized for channel");
        console.log("📊 Courses count:", courses ? courses.length : 0);
    }

    onCoursesChanged: {
        console.log("🔄 CourseListBlock courses changed");
        console.log("📊 New courses count:", courses ? courses.length : 0);
        updateColumns();
    }

    // Макет для сетки
    property int columnCount: Math.max(1, Math.floor((width - 40) / minCardWidth))
    property real columnWidth: (width - (columnCount - 1) * cardSpacing) / columnCount
    property var columns: []

    function updateColumns() {
        if (!courses || courses.length === 0) {
            columns = [];
            return;
        }

        var cols = [];
        for (var c = 0; c < columnCount; c++) {
            cols.push([]);
        }

        for (var i = 0; i < courses.length; i++) {
            var colIndex = i % columnCount;
            cols[colIndex].push(courses[i]);
        }
        columns = cols;
    }

    onWidthChanged: {
        columnCount = Math.max(1, Math.floor((width - 40) / minCardWidth));
        updateColumns();
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        // Заголовок с количеством курсов
        Text {
            Layout.fillWidth: true
            text: "Курсы (" + (courses ? courses.length : 0) + ")"
            font.pixelSize: 18
            font.bold: true
            color: themeColors.textColor
            visible: courses && courses.length > 0
        }

        // Содержимое - курсы или сообщение об отсутствии
        Loader {
            id: contentLoader
            Layout.fillWidth: true
            Layout.fillHeight: true
            sourceComponent: courses && courses.length > 0 ? coursesGridComponent : emptyStateComponent
        }
    }

    // Компонент сетки курсов
    Component {
        id: coursesGridComponent

        ScrollView {
            contentWidth: width
            contentHeight: columnsContainer.height
            clip: true

            Row {
                id: columnsContainer
                width: parent.width
                spacing: cardSpacing

                Repeater {
                    model: root.columns

                    delegate: Column {
                        width: root.columnWidth
                        spacing: cardSpacing

                        Repeater {
                            model: root.columns[index]

                            delegate: CardCourseProfile {
                                width: parent.width
                                themeColors: root.themeColors
                                courseData: modelData
                                onCourseClicked: {
                                    console.log("🎯 Opening course from channel:", modelData.title);
                                    console.log("🆔 Course ID:", modelData.id);
                                    root.courseSelected(modelData);
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Компонент пустого состояния
    Component {
        id: emptyStateComponent

        Item {
            width: parent.width
            height: parent.height

            Column {
                anchors.centerIn: parent
                spacing: 20
                width: Math.min(parent.width * 0.8, 400)

                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: Math.min(150, parent.width - 40)
                    height: width
                    source: "qrc:/images/shows-thumbs.webp"
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }

                Column {
                    width: parent.width
                    spacing: 8

                    Text {
                        width: parent.width
                        text: "Пока нет доступных курсов"
                        color: themeColors.textColor
                        font.pixelSize: 16
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.Wrap
                    }

                    Text {
                        width: parent.width
                        text: "Курсы появятся здесь, когда автор их добавит"
                        color: themeColors.secondaryTextColor
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.Wrap
                    }
                }
            }
        }
    }
}
