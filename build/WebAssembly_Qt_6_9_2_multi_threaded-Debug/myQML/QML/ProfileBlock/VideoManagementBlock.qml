import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt5Compat.GraphicalEffects

Rectangle {
    id: videoManagementBlock
    property var currentCourse: null
    property var themeColors: ThemeManager.themeColors
    property var selectedVideo: null
    property bool isEditMode: false

    signal videoAdded(var videoData)
    signal videoUpdated(var videoData)
    signal videoDeleted(var videoId)
    signal courseUnselected()

    function addVideo(videoData) {
        if (currentCourse && currentCourse.id) {
            console.log("Добавление урока в курс через VideoCourseManager:", currentCourse.id, videoData)
            VideoCourseManager.addLesson(currentCourse.id, videoData)
            updateCurrentCourse()
            videoAdded(videoData)
        } else {
            console.log("Ошибка: currentCourse не установлен или нет id")
        }
    }

    function updateVideo(videoData) {
        if (currentCourse && currentCourse.id) {
            console.log("Обновление урока в курсе через VideoCourseManager:", currentCourse.id, videoData)

            // Получаем текущий курс
            var course = VideoCourseManager.getCourse(currentCourse.id)
            if (course) {
                // Находим и обновляем урок
                var lessons = course.lessons || []
                for (var i = 0; i < lessons.length; i++) {
                    if (lessons[i].id === videoData.id) {
                        lessons[i] = videoData
                        break
                    }
                }

                // Обновляем курс
                course.lessons = lessons
                VideoCourseManager.updateCourse(currentCourse.id, course)
                updateCurrentCourse()
                videoUpdated(videoData)
            }
        }
    }

    function deleteVideo(videoId) {
        if (currentCourse && currentCourse.id) {
            console.log("Удаление урока из курса через VideoCourseManager:", currentCourse.id, videoId)
            VideoCourseManager.removeLesson(currentCourse.id, videoId)
            updateCurrentCourse()
            videoDeleted(videoId)
        }
    }

    function updateCurrentCourse() {
        if (currentCourse && currentCourse.id) {
            let updatedCourse = VideoCourseManager.getCourse(currentCourse.id)
            if (updatedCourse && updatedCourse.id) {
                currentCourse = updatedCourse
                console.log("Курс обновлен, уроков:", currentCourse.lessons ? currentCourse.lessons.length : 0)
            } else {
                console.log("Курс не найден, сбрасываем currentCourse")
                currentCourse = null
                courseUnselected()
            }
        }
    }

    function resetCourse() {
        console.log("Сброс текущего курса в VideoManagementBlock")
        currentCourse = null
        selectedVideo = null
    }

    color: themeColors.backgroundColor
    radius: 8
    border.color: themeColors.primaryColor
    border.width: 1

    Connections {
        target: VideoCourseManager
        function onAllCoursesChanged() {
            console.log("Данные курсов изменились, обновляем текущий курс")
            if (currentCourse) {
                updateCurrentCourse()
            }
        }
    }

    Connections {
        target: ThemeManager
        function onThemeColorsChanged() {
            themeColors = ThemeManager.themeColors
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 10

        // Заголовок
        RowLayout {
            Layout.fillWidth: true

            Text {
                text: currentCourse ? "Уроки курса: " + currentCourse.title : "Управление уроками"
                font.bold: true
                font.pointSize: 14
                color: themeColors.textColor
                Layout.fillWidth: true
                wrapMode: Text.Wrap
            }

            Button {
                text: "+ Урок"
                enabled: currentCourse && currentCourse.id && isEditMode
                visible: isEditMode
                onClicked: {
                    videoTitle.text = ""
                    videoDescription.text = ""
                    videoUrl.text = ""
                    videoDialog.open()
                }
                background: Rectangle {
                    color: themeColors.primaryColor
                    radius: 8
                }
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 12
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                Layout.preferredHeight: 36
                Layout.preferredWidth: 100
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: currentCourse && currentCourse.lessons && currentCourse.lessons.length > 0
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

            ListView {
                id: videoListView
                model: currentCourse ? currentCourse.lessons : []
                spacing: 8
                width: parent.width
                delegate: Rectangle {
                    id: videoDelegate
                    property var videoData: modelData
                    width: ListView.view.width
                    height: 80
                    radius: 6
                    color: themeColors.cardColor
                    border.color: themeColors.primaryColor
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 10

                        // Миниатюра видео
                        Rectangle {
                            id: imageContainer
                            Layout.preferredWidth: 100
                            Layout.preferredHeight: 60
                            radius: 4
                            color: themeColors.surfaceColor
                            clip: true

                            Image {
                                anchors.centerIn: parent
                                width: Math.min(parent.width, parent.height * (16/9))
                                height: Math.min(parent.height, parent.width * (9/16))
                                source: videoData.thumbnail || "qrc:/images/preview_standard.webp"
                                fillMode: Image.PreserveAspectCrop
                                asynchronous: true
                                cache: true
                                smooth: true
                            }

                            layer.enabled: true
                            layer.effect: OpacityMask {
                                maskSource: Rectangle {
                                    width: imageContainer.width
                                    height: imageContainer.height
                                    radius: 8
                                }
                            }


                            Button {
                                anchors.bottom: parent.bottom
                                anchors.right: parent.right
                                anchors.margins: 2
                                ToolTip.text: "Сменить миниатюру"
                                width: 24
                                height: 24
                                opacity: 0.9
                                visible: isEditMode
                                onClicked: {
                                    selectedVideo = videoData
                                    thumbnailDialog.open()
                                }
                                background: Rectangle {
                                    color: themeColors.primaryColor
                                    radius: 3
                                }
                                contentItem: Image {
                                    anchors.centerIn: parent
                                    source: "qrc:/icons/photocamera_icon.webp"
                                    width: 16
                                    height: 16
                                    layer.enabled: true
                                    layer.effect: ColorOverlay {
                                        color: themeColors.textColor
                                    }
                                }
                            }
                        }

                        // Информация о видео
                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 4

                            Text {
                                text: videoData.title || "Без названия"
                                font.bold: true
                                font.pixelSize: 14
                                color: themeColors.textColor
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                                wrapMode: Text.Wrap
                                maximumLineCount: 1
                            }

                            Text {
                                text: videoData.description || "Описание отсутствует"
                                font.pixelSize: 12
                                color: themeColors.secondaryTextColor
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                                maximumLineCount: 2
                                wrapMode: Text.Wrap
                            }

                            Text {
                                text: videoData.url || "URL не указан"
                                font.pixelSize: 10
                                color: themeColors.secondaryTextColor
                                Layout.fillWidth: true
                                elide: Text.ElideMiddle
                            }
                        }

                        // Кнопки управления
                        ColumnLayout {
                            Layout.alignment: Qt.AlignTop
                            spacing: 4
                            visible: isEditMode

                            Button {
                                implicitWidth: 30
                                implicitHeight: 30
                                ToolTip.text: "Редактировать"
                                onClicked: {
                                    selectedVideo = videoData
                                    editVideoTitle.text = videoData.title || ""
                                    editVideoDescription.text = videoData.description || ""
                                    editVideoUrl.text = videoData.url || ""
                                    editVideoDialog.open()
                                }
                                background: Rectangle {
                                    color: themeColors.primaryColor
                                    radius: 4
                                }
                                contentItem: Image {
                                    anchors.centerIn: parent
                                    source: "qrc:/icons/edit_pen_icon.webp"
                                    width: 16
                                    height: 16
                                    layer.enabled: true
                                    layer.effect: ColorOverlay {
                                        color: themeColors.textColor
                                    }
                                }
                            }

                            Button {
                                implicitWidth: 30
                                implicitHeight: 30
                                ToolTip.text: "Удалить"
                                onClicked: {
                                    selectedVideo = videoData
                                    deleteVideo(videoData.id)
                                }
                                background: Rectangle {
                                    color: "#ff4757"
                                    radius: 4
                                }
                                contentItem: Image {
                                    anchors.centerIn: parent
                                    source: "qrc:/icons/delete-icon.webp"
                                    width: 16
                                    height: 16
                                    layer.enabled: true
                                    layer.effect: ColorOverlay {
                                        color: themeColors.textColor
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // Сообщение если нет видео
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
            visible: !currentCourse || !currentCourse.lessons || currentCourse.lessons.length === 0

            Column {
                anchors.centerIn: parent
                spacing: 20
                width: Math.min(parent.width * 0.8, 400)

                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: Math.min(200, parent.width - 40)
                    height: width
                    source: "qrc:/images/shows-thumbs.webp"
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }

                Text {
                    width: parent.width
                    text: currentCourse ? "В этом курсе пока нет уроков" : "Выберите курс для управления уроками"
                    color: themeColors.secondaryTextColor
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.Wrap
                }
            }
        }
    }

    // Диалог добавления урока
    Dialog {
        id: videoDialog
        title: "Добавить урок"
        anchors.centerIn: Overlay.overlay
        width: Math.min(500, parent.width * 0.9)
        height: Math.min(350, parent.height * 0.8)
        modal: true

        background: Rectangle {
            color: themeColors.backgroundColor
            radius: 8
            border.color: themeColors.primaryColor
            border.width: 1
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 10

            Text {
                text: "Название урока:"
                color: themeColors.textColor
                font.bold: true
            }

            TextField {
                id: videoTitle
                placeholderText: "Введите название урока"
                Layout.fillWidth: true

                background: Rectangle {
                    color: themeColors.surfaceColor
                    radius: 4
                    border.color: themeColors.borderColor
                    border.width: 1
                }
            }

            Text {
                text: "Описание урока:"
                color: themeColors.textColor
                font.bold: true
            }

            TextArea {
                id: videoDescription
                placeholderText: "Введите описание урока"
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                wrapMode: TextArea.Wrap

                background: Rectangle {
                    color: themeColors.surfaceColor
                    radius: 4
                    border.color: themeColors.borderColor
                    border.width: 1
                }
            }

            Text {
                text: "URL видео:"
                color: themeColors.textColor
                font.bold: true
            }

            TextField {
                id: videoUrl
                placeholderText: "Введите URL видео"
                Layout.fillWidth: true

                background: Rectangle {
                    color: themeColors.surfaceColor
                    radius: 4
                    border.color: themeColors.borderColor
                    border.width: 1
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Button {
                    text: "Отмена"
                    Layout.fillWidth: true
                    onClicked: videoDialog.close()

                    background: Rectangle {
                        color: themeColors.surfaceColor
                        radius: 4
                    }
                }

                Button {
                    id: addVideoButton
                    text: "Добавить"
                    Layout.fillWidth: true
                    enabled: videoTitle.text.trim() !== "" && videoUrl.text.trim() !== ""
                    onClicked: {
                        const newVideo = {
                            id: Date.now(),
                            title: videoTitle.text.trim(),
                            description: videoDescription.text.trim(),
                            url: videoUrl.text.trim(),
                            thumbnail: ""
                        }
                        console.log("Создание нового урока:", newVideo)
                        addVideo(newVideo)
                        videoDialog.close()
                    }
                    background: Rectangle {
                        color: addVideoButton.enabled ? themeColors.primaryColor : "#cccccc"
                        radius: 4
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        font.bold: true
                    }
                }
            }
        }
    }

    // Диалог редактирования урока
    Dialog {
        id: editVideoDialog
        title: "Редактировать урок"
        anchors.centerIn: Overlay.overlay
        width: Math.min(500, parent.width * 0.9)
        height: Math.min(350, parent.height * 0.8)
        modal: true

        background: Rectangle {
            color: themeColors.backgroundColor
            radius: 8
            border.color: themeColors.primaryColor
            border.width: 1
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 10

            Text {
                text: "Название урока:"
                color: themeColors.textColor
                font.bold: true
            }

            TextField {
                id: editVideoTitle
                placeholderText: "Введите название урока"
                Layout.fillWidth: true

                background: Rectangle {
                    color: themeColors.surfaceColor
                    radius: 4
                    border.color: themeColors.borderColor
                    border.width: 1
                }
            }

            Text {
                text: "Описание урока:"
                color: themeColors.textColor
                font.bold: true
            }

            TextArea {
                id: editVideoDescription
                placeholderText: "Введите описание урока"
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                wrapMode: TextArea.Wrap

                background: Rectangle {
                    color: themeColors.surfaceColor
                    radius: 4
                    border.color: themeColors.borderColor
                    border.width: 1
                }
            }

            Text {
                text: "URL видео:"
                color: themeColors.textColor
                font.bold: true
            }

            TextField {
                id: editVideoUrl
                placeholderText: "Введите URL видео"
                Layout.fillWidth: true

                background: Rectangle {
                    color: themeColors.surfaceColor
                    radius: 4
                    border.color: themeColors.borderColor
                    border.width: 1
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Button {
                    text: "Удалить урок"
                    Layout.fillWidth: true
                    onClicked: {
                        if (selectedVideo && selectedVideo.id) {
                            console.log("Удаление урока:", selectedVideo.id)
                            deleteVideo(selectedVideo.id)
                            editVideoDialog.close()
                        }
                    }
                    background: Rectangle {
                        color: "#ff4757"
                        radius: 4
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        font.bold: true
                    }
                }

                Button {
                    id: saveVideoButton
                    text: "Сохранить"
                    Layout.fillWidth: true
                    enabled: editVideoTitle.text.trim() !== "" && editVideoUrl.text.trim() !== ""
                    onClicked: {
                        if (selectedVideo) {
                            const updatedVideo = {
                                id: selectedVideo.id,
                                title: editVideoTitle.text.trim(),
                                description: editVideoDescription.text.trim(),
                                url: editVideoUrl.text.trim(),
                                thumbnail: selectedVideo.thumbnail || ""
                            }
                            console.log("Сохранение изменений урока:", updatedVideo)
                            updateVideo(updatedVideo)
                            editVideoDialog.close()
                        }
                    }
                    background: Rectangle {
                        color: saveVideoButton.enabled ? themeColors.primaryColor : "#cccccc"
                        radius: 4
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        font.bold: true
                    }
                }
            }
        }
    }

    // Диалог выбора миниатюры
    FileDialog {
        id: thumbnailDialog
        title: "Выберите миниатюру урока"
        nameFilters: ["Изображения (*.png *.jpg *.jpeg *.gif *.bmp *.webp)"]
        onAccepted: {
            if (selectedVideo) {
                console.log("Выбрана новая миниатюра:", selectedFile)
                var updatedVideo = {
                    id: selectedVideo.id,
                    title: selectedVideo.title || "",
                    description: selectedVideo.description || "",
                    url: selectedVideo.url || "",
                    thumbnail: selectedFile.toString()
                }
                console.log("Обновление урока с новой миниатюрой:", updatedVideo)
                updateVideo(updatedVideo)
            } else {
                console.log("Ошибка: selectedVideo не установлен")
            }
        }
        onRejected: {
            console.log("Выбор миниатюры отменен")
        }
    }
}
