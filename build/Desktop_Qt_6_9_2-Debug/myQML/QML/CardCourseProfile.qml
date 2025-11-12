import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Rectangle {
    id: courseCard
    property var themeColors: ThemeManager.currentThemeColors

    width: parent.width
    height: contentColumn.implicitHeight + 10
    radius: 12
    border.color: themeColors.primaryColor
    border.width: 1
    color: themeColors.backgroundColor
    clip: true

    // ДОБАВЛЕНО: недостающее свойство courseId
    property string courseId: courseData ? courseData.id : ""
    property var courseData: ({})
    property string channelId: courseData ? courseData.channelId || "" : ""
    property string authorName: courseData ? courseData.author || "" : ""
    property var lessons: courseData ? (courseData.lessons || []) : []

    signal courseClicked()

    Column {
        id: contentColumn
        anchors.fill: parent
        anchors.margins: 1
        spacing: 0

        // Превью курса
        Rectangle {
            id: imageContainer
            width: parent.width
            height: courseData ? (courseData.thumbnail_height || 160) : 160
            color: "transparent"
            clip: true

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: imageContainer.width
                    height: imageContainer.height
                    radius: 12
                }
            }

            Image {
                id: previewImage
                anchors.fill: parent
                source: courseData ? (courseData.thumbnail_path || courseData.cover || "qrc:/images/preview_standard.webp") : "qrc:/images/preview_standard.webp"
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                cache: true
                smooth: true

                onStatusChanged: {
                    if (status === Image.Error) {
                        source = "qrc:/images/preview_standard.webp";
                    }
                }
            }

            // Затемнение для лучшей читаемости текста
            Rectangle {
                anchors.fill: parent
                color: "#80000000"
            }

            // Название курса поверх изображения
            Text {
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                    margins: 10
                }
                text: courseData ? (courseData.title || "Без названия") : "Без названия"
                font.pixelSize: 16
                font.bold: true
                color: "white"
                wrapMode: Text.Wrap
                maximumLineCount: 2
                elide: Text.ElideRight
            }
        }

        // Информация о курсе
        Column {
            width: parent.width
            padding: 12
            spacing: 8

            // Количество уроков и уровень
            Row {
                width: parent.width
                spacing: 10

                Text {
                    text: {
                        if (!courseData) return "0 уроков";
                        var count = courseData.lessonCount || (courseData.lessons ? courseData.lessons.length : 0);
                        return getLessonCount(count);
                    }
                    font.pixelSize: 12
                    color: themeColors.secondaryTextColor
                }

                Rectangle {
                    width: levelText.implicitWidth + 10
                    height: 20
                    radius: 10
                    color: getLevelColor(courseData ? courseData.level || "" : "").background
                    border.color: getLevelColor(courseData ? courseData.level || "" : "").border

                    Text {
                        id: levelText
                        anchors.centerIn: parent
                        text: courseData ? (courseData.level || "—") : "—"
                        font.pixelSize: 10
                        font.weight: Font.Medium
                        color: getLevelColor(courseData ? courseData.level || "" : "").text
                    }
                }
            }

            // Описание курса
            Text {
                width: parent.width
                text: courseData ? (courseData.description || "Описание отсутствует") : "Описание отсутствует"
                font.pixelSize: 12
                color: themeColors.textColor
                wrapMode: Text.Wrap
                maximumLineCount: 2
                elide: Text.ElideRight
                lineHeight: 1.2
            }

            // Теги курса
            Flow {
                width: parent.width
                spacing: 4
                visible: courseData && courseData.tags && courseData.tags.length > 0

                Repeater {
                    model: courseData ? (courseData.tags || []) : []

                    delegate: Rectangle {
                        height: 20
                        width: Math.min(tagText.implicitWidth + 8, parent.width - 20)
                        color: "transparent"
                        border.color: themeColors.borderColor
                        border.width: 1
                        radius: 4

                        Text {
                            id: tagText
                            anchors.centerIn: parent
                            text: modelData ? modelData.toString() : "?"
                            color: themeColors.secondaryTextColor
                            font.pixelSize: 9
                            elide: Text.ElideRight
                        }
                    }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            console.log("🎯 Course selected:", courseData ? courseData.title : "No data");
            console.log("🆔 Course ID:", courseId);
            console.log("🎬 Lessons count:", lessons.length);
            courseCard.courseClicked();
        }
    }


    function getLevelColor(level) {
        switch(level) {
            case "начинающий": return {
                background: Qt.lighter(themeColors.primaryColor, 2.5),
                border: themeColors.primaryColor,
                text: Qt.darker(themeColors.primaryColor, 1.5)
            };
            case "средний": return {
                background: "#fff3e0",
                border: "#ff9800",
                text: "#e65100"
            };
            case "продвинутый": return {
                background: "#ffebee",
                border: "#f44336",
                text: "#c62828"
            };
            default: return {
                background: themeColors.backgroundColor,
                border: themeColors.borderColor,
                text: themeColors.secondaryTextColor
            };
        }
    }

    function getLessonCount(count) {
        if (!count || count <= 0) return "0 уроков";
        if (count === 1) return count + " урок";
        else if (count >= 2 && count <= 4) return count + " урока";
        else if (count >= 5 && count <= 20) return count + " уроков";
        else {
            var lastDigit = count % 10;
            var lastTwoDigits = count % 100;
            if (lastTwoDigits >= 11 && lastTwoDigits <= 14) return count + " уроков";
            if (lastDigit === 1) return count + " урок";
            else if (lastDigit >= 2 && lastDigit <= 4) return count + " урока";
            else return count + " уроков";
        }
    }

    Component.onCompleted: {
        console.log("🔄 CourseCardProfile created for:", courseData ? courseData.title : "No data");
        console.log("📐 Thumbnail height:", courseData ? (courseData.thumbnail_height || 160) : 160);
        console.log("🆔 Course ID:", courseId);
    }
}
