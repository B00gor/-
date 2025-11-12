import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    id: mainPage

    property int columnCount: Math.max(1, Math.floor((width - 40) / 350))
    property real columnWidth: (width - (columnCount - 1) * 10) / columnCount
    property var columns: []

    // Используем CourseManager вместо JS файлов
    property var courseArray: CourseManager.allCourses

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        SearchTagInput {
            id: tagSearch
            Layout.fillWidth: true
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            contentWidth: width
            contentHeight: columnsContainer.height

            Row {
                id: columnsContainer
                width: parent.width - 20
                spacing: 10

                Repeater {
                    model: mainPage.columns

                    delegate: Column {
                        width: mainPage.columnWidth
                        spacing: 15
                        Repeater {
                            model: mainPage.columns[index]
                            delegate: CardCourse {
                                width: parent.width
                                courseData: modelData
                            }
                        }
                    }
                }
            }
        }
    }

    background: Rectangle {
        color: "transparent"
    }

    function updateColumns() {
        if (!courseArray || courseArray.length === 0) {
            columns = [];
            return;
        }

        var cols = [];
        for (var c = 0; c < columnCount; c++) {
            cols.push([]);
        }

        for (var i = 0; i < courseArray.length; i++) {
            var colIndex = i % columnCount;
            cols[colIndex].push(courseArray[i]);
        }
        columns = cols;
    }

    onWidthChanged: {
        columnCount = Math.max(1, Math.floor((width - 40) / 350));
        updateColumns();
    }

    Component.onCompleted: {
        console.log("=== COURSES DEBUG INFO ===");
        console.log("Courses loaded:", courseArray ? courseArray.length : 0);

        // Загружаем курсы если еще не загружены
        if (courseArray.length === 0) {
            CourseManager.loadCourses();
        }

        updateColumns();
    }

    // Обновляем при изменении данных
    Connections {
        target: CourseManager
        function onAllCoursesChanged() {
            console.log("Courses updated, count:", CourseManager.allCourses.length);
            updateColumns();
        }
    }
}


