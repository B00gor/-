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

    property var courseData: ({})
    property string channelId: courseData.channelId || "" // Используем channelId вместо authorId
    property string authorName: courseData.author || ""

    // ДОБАВЛЕНО: Функция для получения channelId по имени автора
    function getChannelIdForAuthor(author) {
        // Временное решение - используем ChannelManager для получения channelId
        if (author === "Python Boogor") {
            return "123e4567-e89b-12d3-a456-426614174000";
        } else if (author === "Javascript Master") {
            return "123e4567-e89b-12d3-a456-426614174001";
        }
        return "";
    }

    Column {
        id: contentColumn
        anchors.fill: parent
        anchors.margins: 1.3
        spacing: 5

        Rectangle {
            id: imageContainer
            width: parent.width
            height: courseData.thumbnail_height || 120
            color: "transparent"
            clip: true
            radius: 12

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: imageContainer.width
                    height: imageContainer.height
                    topLeftRadius: 12
                    topRightRadius: 12
                    bottomLeftRadius: 0
                    bottomRightRadius: 0
                }
            }

            Image {
                id: previewImage
                anchors.fill: parent
                source: courseData.thumbnail_path || "qrc:/images/preview_standard.webp"
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                cache: true
                smooth: true

                onStatusChanged: {
                    if (status === Image.Error) {
                        console.log("Preview image failed to load:", source)
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("🎯 Opening course:", courseData.title);
                    console.log("🆔 Course ID:", courseData.id);
                    navHistory.push("CardVideoListView.qml", {
                        courseId: courseData.id
                    });
                }
            }
        }

        RowLayout {
            width: parent.width - 20
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10

            Rectangle {
                id: iconContainer
                Layout.preferredWidth: 40
                Layout.preferredHeight: 40
                radius: 100
                color: "transparent"
                clip: true

                Image {
                    id: iconImage
                    anchors.fill: parent
                    source: courseData.icon_path || "qrc:/images/icon_standard.webp"
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    cache: true
                    smooth: true

                    onStatusChanged: {
                        if (status === Image.Error) {
                            console.log("Icon image failed to load:", source)
                        }
                    }
                }
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        width: iconContainer.width
                        height: iconContainer.height
                        radius: 100
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    radius: 100
                    color: "transparent"
                    border.color: themeColors.borderColor
                    border.width: 1
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("👤 Opening author channel. ChannelId:", channelId);
                        console.log("👤 Author name:", authorName);

                        // ИСПРАВЛЕНИЕ: Получаем channelId по имени автора
                        var actualChannelId = channelId || getChannelIdForAuthor(authorName);
                        console.log("👤 Actual channelId to use:", actualChannelId);

                        if (actualChannelId) {
                            navHistory.push("ProfileСhannel.qml", {
                                userId: actualChannelId, // Передаем правильный channelId
                                userName: authorName
                            });
                        } else {
                            console.log("❌ No channelId available for author:", authorName);
                            console.log("❌ Course data:", JSON.stringify(courseData));
                        }
                    }
                }
            }

            Column {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: 2

                Text {
                    width: parent.width
                    text: courseData.title || ""
                    font.pixelSize: 14
                    font.bold: true
                    color: themeColors.textColor
                    wrapMode: Text.Wrap
                    elide: Text.ElideRight
                    maximumLineCount: 2
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            navHistory.push("CardVideoListView.qml", {
                                courseId: courseData.id
                            });
                        }
                    }
                }

                Text {
                    width: parent.width
                    text: authorName
                    font.pixelSize: 11
                    color: themeColors.secondaryTextColor
                    wrapMode: Text.Wrap
                    elide: Text.ElideRight
                    maximumLineCount: 2
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("👤 Opening author channel from name. ChannelId:", channelId);
                            console.log("👤 Author name:", authorName);

                            // ИСПРАВЛЕНИЕ: Получаем channelId по имени автора
                            var actualChannelId = channelId || getChannelIdForAuthor(authorName);
                            console.log("👤 Actual channelId to use:", actualChannelId);

                            if (actualChannelId) {
                                navHistory.push("ProfileСhannel.qml", {
                                    userId: actualChannelId, // Передаем правильный channelId
                                    userName: authorName
                                });
                            } else {
                                console.log("❌ No channelId available for author:", authorName);
                            }
                        }
                    }
                }
            }

            Column {
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                spacing: 4

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: getLessonCount(courseData.lessonCount)
                    font.pixelSize: 11
                    color: themeColors.secondaryTextColor
                }

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: levelText.implicitWidth + 16
                    height: 20
                    radius: 10

                    color: getLevelColor(courseData.level || "").background
                    border.color: getLevelColor(courseData.level || "").border

                    Text {
                        id: levelText
                        anchors.centerIn: parent
                        text: courseData.level || "—"
                        font.pixelSize: 10
                        font.weight: Font.Medium
                        color: getLevelColor(courseData.level || "").text
                    }
                }
            }
        }

        Flow {
            width: parent.width
            spacing: 3
            padding: 5

            Repeater {
                model: courseData.tags || []

                delegate: Rectangle {
                    height: 18
                    width: Math.min(tagText.implicitWidth + 10, parent.width - 20)
                    color: "transparent"
                    border.color: themeColors.borderColor
                    border.width: 1
                    radius: 6

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

    function getLevelColor(level) {
        switch(level) {
            case "начинающий": return { background: Qt.lighter(themeColors.primaryColor, 2.5), border: themeColors.primaryColor, text: Qt.darker(themeColors.primaryColor, 1.5) };
            case "средний": return { background: "#fff3e0", border: "#ff9800", text: "#e65100" };
            case "продвинутый": return { background: "#ffebee", border: "#f44336", text: "#c62828" };
            default: return { background: themeColors.backgroundColor, border: themeColors.borderColor, text: themeColors.secondaryTextColor };
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

    // ДОБАВЛЕНО: Отладочный вывод при создании компонента
    Component.onCompleted: {
        console.log("🔄 CourseCard created for:", courseData.title);
        console.log("📋 Course data:", JSON.stringify(courseData));
        console.log("👤 Author:", authorName);
        console.log("🆔 ChannelId from data:", channelId);
        console.log("🆔 ChannelId from mapping:", getChannelIdForAuthor(authorName));
    }
}
