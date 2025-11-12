import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt5Compat.GraphicalEffects

Rectangle {
    id: root
    property string title: "Управление видеокурсами"
    property var courses: VideoCourseManager.allCourses || []
    property var themeColors: ThemeManager.themeColors
    property var selectedCourse: null
    property bool isEditMode: false

    signal courseSelected(var course)

    color: themeColors.backgroundColor
    radius: 12
    border.color: themeColors.primaryColor
    border.width: 1

    Component.onCompleted: {
        console.log("VideoCourseBlock инициализирован, курсов:", courses.length)
    }

    Connections {
        target: ThemeManager
        function onThemeColorsChanged() {
            themeColors = ThemeManager.themeColors
        }
    }

    Connections {
        target: VideoCourseManager
        function onAllCoursesChanged() {
            console.log("Курсы обновлены, всего:", VideoCourseManager.allCourses.length)
            courses = VideoCourseManager.allCourses || []
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 15

        // Заголовок и кнопка добавления
        RowLayout {
            Layout.fillWidth: true

            Text {
                text: title
                font.bold: true
                font.pixelSize: 18
                color: themeColors.textColor
                Layout.fillWidth: true
                wrapMode: Text.Wrap
            }

            Button {
                text: "+ Новый курс"
                visible: isEditMode
                onClicked: {
                    courseTitle.text = ""
                    courseDescription.text = ""
                    courseDialog.open()
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
                Layout.preferredWidth: 120
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: root.courses.length > 0
            clip: true

            Column {
                width: parent.width
                spacing: 12

                Repeater {
                    model: root.courses

                    delegate: Rectangle {
                        id: courseCard
                        property var courseData: modelData
                        property bool isSelected: selectedCourse && selectedCourse.id === courseData.id

                        width: parent.width
                        height: contentColumn.implicitHeight + 20
                        radius: 12
                        border.color: isSelected ? themeColors.accentColor : themeColors.primaryColor
                        border.width: isSelected ? 2 : 1
                        color: themeColors.cardColor
                        clip: true

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                selectedCourse = courseData
                                root.courseSelected(courseData)
                            }
                        }

                        Column {
                            id: contentColumn
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 8

                            Rectangle {
                                id: imageContainer
                                width: parent.width
                                height: 140
                                radius: 8
                                color: "transparent"
                                clip: true

                                layer.enabled: true
                                layer.effect: OpacityMask {
                                    maskSource: Rectangle {
                                        width: imageContainer.width
                                        height: imageContainer.height
                                        radius: 8
                                    }
                                }

                                Image {
                                    id: previewImage
                                    anchors.fill: parent
                                    source: courseData.cover || "qrc:/images/preview_standard.webp"
                                    fillMode: Image.PreserveAspectCrop
                                    asynchronous: true
                                    cache: true
                                    smooth: true
                                }

                                Rectangle {
                                    anchors.fill: parent
                                    color: "#40000000"
                                    radius: 8
                                }

                                Row {
                                    id: managementButtons
                                    anchors.top: parent.top
                                    anchors.right: parent.right
                                    anchors.margins: 8
                                    spacing: 6
                                    z: 10
                                    visible: isEditMode

                                    Button {
                                        ToolTip.text: "Сменить обложку"
                                        onClicked: {
                                            selectedCourse = courseData
                                            coverDialog.open()
                                        }
                                        background: Rectangle {
                                            color: themeColors.backgroundColor
                                            radius: 4
                                            border.color: themeColors.borderColor
                                            border.width: 1
                                        }
                                        contentItem: Image {
                                            anchors.centerIn: parent
                                            source: "qrc:/icons/photocamera_icon.webp"
                                            width: 30
                                            height: 30
                                            layer.enabled: true
                                            layer.effect: ColorOverlay {
                                                color: themeColors.textColor
                                            }
                                        }
                                        width: 30; height: 30
                                    }
                                    Button {
                                        ToolTip.text: "Редактировать курс"
                                        onClicked: {
                                            selectedCourse = courseData
                                            editCourseDialog.open()
                                        }
                                        background: Rectangle {
                                            color: themeColors.backgroundColor
                                            radius: 4
                                            border.color: themeColors.borderColor
                                            border.width: 1
                                        }
                                        contentItem: Image {
                                            anchors.centerIn: parent
                                            source: "qrc:/icons/edit_pen_icon.webp"
                                            width: 30
                                            height: 30
                                            layer.enabled: true
                                            layer.effect: ColorOverlay {
                                                color: themeColors.textColor
                                            }
                                        }
                                        width: 30; height: 30
                                    }
                                }
                            }

                            RowLayout {
                                width: parent.width
                                spacing: 10

                                Column {
                                    Layout.fillWidth: true
                                    spacing: 4

                                    Text {
                                        width: parent.width
                                        text: courseData.title || "Без названия"
                                        font.pixelSize: 16
                                        font.bold: true
                                        color: themeColors.textColor
                                        wrapMode: Text.Wrap
                                        maximumLineCount: 2
                                    }

                                    Text {
                                        width: parent.width
                                        text: courseData.description || "Описание отсутствует"
                                        font.pixelSize: 12
                                        color: themeColors.secondaryTextColor
                                        wrapMode: Text.Wrap
                                        maximumLineCount: 2
                                    }
                                }

                                Text {
                                    text: getLessonCount(courseData.lessons ? courseData.lessons.length : 0)
                                    font.pixelSize: 11
                                    color: themeColors.secondaryTextColor
                                }
                            }
                        }

                        function getLessonCount(count) {
                            if (!count || count <= 0) return "0 уроков";
                            if (count === 1) return count + " урок";
                            else if (count >= 2 && count <= 4) return count + " урока";
                            else return count + " уроков";
                        }
                    }
                }
            }
        }

        // Сообщение "нет курсов"
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: root.courses.length === 0
            color: "transparent"

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
                    text: "Пока нет видеокурсов.\nСоздайте первый курс!"
                    color: themeColors.secondaryTextColor
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.Wrap
                }
            }
        }
    }

    // Диалог создания курса
    Dialog {
        id: courseDialog
        title: "Создать новый курс"
        anchors.centerIn: Overlay.overlay
        width: 400
        height: 300
        modal: true

        background: Rectangle {
            color: themeColors.backgroundColor
            radius: 8
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 12

            Text {
                text: "Название курса:"
                color: themeColors.textColor
                font.bold: true
            }

            TextField {
                id: courseTitle
                placeholderText: "Введите название курса"
                Layout.fillWidth: true

                background: Rectangle {
                    color: themeColors.surfaceColor
                    radius: 4
                    border.color: themeColors.borderColor
                    border.width: 1
                }
            }

            Text {
                text: "Описание курса:"
                color: themeColors.textColor
                font.bold: true
            }

            TextArea {
                id: courseDescription
                placeholderText: "Введите описание курса"
                Layout.fillWidth: true
                Layout.fillHeight: true
                wrapMode: TextArea.Wrap

                background: Rectangle {
                    color: themeColors.surfaceColor
                    radius: 4
                    border.color: themeColors.borderColor
                    border.width: 1
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Button {
                    text: "Отмена"
                    Layout.fillWidth: true
                    onClicked: courseDialog.close()
                    background: Rectangle {
                        color: themeColors.surfaceColor
                        radius: 4
                    }
                }

                Button {
                    id: createButton
                    text: "Создать"
                    Layout.fillWidth: true
                    enabled: courseTitle.text.trim() !== ""
                    onClicked: {
                        const newCourse = {
                            title: courseTitle.text.trim(),
                            description: courseDescription.text.trim(),
                            cover: "",
                            lessons: []
                        }
                        console.log("Создание нового курса через VideoCourseManager:", newCourse)
                        VideoCourseManager.createCourse(newCourse)
                        courseDialog.close()
                    }
                    background: Rectangle {
                        color: createButton.enabled ? themeColors.primaryColor : "#cccccc"
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

    // Диалог редактирования курса
    Dialog {
        id: editCourseDialog
        title: "Редактировать курс"
        anchors.centerIn: Overlay.overlay
        width: 400
        height: 350
        modal: true
        property var selectedCourseData: null

        onOpened: {
            if (selectedCourse) {
                selectedCourseData = selectedCourse
                editCourseTitle.text = selectedCourse.title || ""
                editCourseDescription.text = selectedCourse.description || ""
            }
        }

        background: Rectangle {
            color: themeColors.backgroundColor
            radius: 8
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 12

            Text {
                text: "Название курса:"
                color: themeColors.textColor
                font.bold: true
            }

            TextField {
                id: editCourseTitle
                placeholderText: "Введите название курса"
                Layout.fillWidth: true

                background: Rectangle {
                    color: themeColors.surfaceColor
                    radius: 4
                    border.color: themeColors.borderColor
                    border.width: 1
                }
            }

            Text {
                text: "Описание курса:"
                color: themeColors.textColor
                font.bold: true
            }

            TextArea {
                id: editCourseDescription
                placeholderText: "Введите описание курса"
                Layout.fillWidth: true
                Layout.fillHeight: true
                wrapMode: TextArea.Wrap

                background: Rectangle {
                    color: themeColors.surfaceColor
                    radius: 4
                    border.color: themeColors.borderColor
                    border.width: 1
                }
            }

            // Подтверждение удаления
            Dialog {
                id: confirmDeleteDialog
                title: "Подтверждение удаления"
                anchors.centerIn: Overlay.overlay
                width: 300
                height: 150
                modal: true

                background: Rectangle {
                    color: themeColors.backgroundColor
                    radius: 8
                }

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 10

                    Text {
                        text: "Вы уверены, что хотите удалить этот курс?"
                        color: themeColors.textColor
                        Layout.fillWidth: true
                        wrapMode: Text.Wrap
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Button {
                            text: "Отмена"
                            Layout.fillWidth: true
                            onClicked: confirmDeleteDialog.close()
                            background: Rectangle {
                                color: themeColors.surfaceColor
                                radius: 4
                            }
                        }

                        Button {
                            text: "Удалить"
                            Layout.fillWidth: true
                            onClicked: {
                                if (editCourseDialog.selectedCourseData && editCourseDialog.selectedCourseData.id) {
                                    console.log("Подтверждено удаление курса через VideoCourseManager:", editCourseDialog.selectedCourseData.id)
                                    VideoCourseManager.deleteCourse(editCourseDialog.selectedCourseData.id)
                                    confirmDeleteDialog.close()
                                    editCourseDialog.close()
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
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Button {
                    text: "Удалить курс"
                    Layout.fillWidth: true
                    onClicked: {
                        console.log("Запрос на удаление курса")
                        confirmDeleteDialog.open()
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
                    id: saveButton
                    text: "Сохранить"
                    Layout.fillWidth: true
                    enabled: editCourseTitle.text.trim() !== ""
                    onClicked: {
                        if (editCourseDialog.selectedCourseData) {
                            const updatedCourse = {
                                id: editCourseDialog.selectedCourseData.id,
                                title: editCourseTitle.text.trim(),
                                description: editCourseDescription.text.trim(),
                                cover: editCourseDialog.selectedCourseData.cover || "",
                                lessons: editCourseDialog.selectedCourseData.lessons || []
                            }
                            console.log("Сохранение изменений курса через VideoCourseManager:", updatedCourse)
                            VideoCourseManager.updateCourse(editCourseDialog.selectedCourseData.id, updatedCourse)
                            editCourseDialog.close()
                        }
                    }
                    background: Rectangle {
                        color: saveButton.enabled ? themeColors.primaryColor : "#cccccc"
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

    // Диалог выбора обложки
    FileDialog {
        id: coverDialog
        title: "Выберите обложку курса"
        nameFilters: ["Изображения (*.png *.jpg *.jpeg *.gif *.bmp *.webp)"]
        onAccepted: {
            if (selectedCourse) {
                console.log("Выбрана новая обложка:", selectedFile)
                var updatedCourse = {
                    id: selectedCourse.id,
                    title: selectedCourse.title || "",
                    description: selectedCourse.description || "",
                    cover: selectedFile.toString(),
                    lessons: selectedCourse.lessons || []
                }
                console.log("Обновление курса с новой обложкой через VideoCourseManager:", updatedCourse)
                VideoCourseManager.updateCourse(selectedCourse.id, updatedCourse)
            } else {
                console.log("Ошибка: selectedCourse не установлен")
            }
        }
        onRejected: {
            console.log("Выбор обложки отменен")
        }
    }
}
