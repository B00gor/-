import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "./ProfileBlock"
import Qt5Compat.GraphicalEffects

Page {
    id: container
    property var themeColors: ThemeManager.currentThemeColors
    property bool isWide: width > 600
    property bool isEditMode: true

    // ИСПРАВЛЕНО: используем Binding для автоматического обновления
    property var videoCourses: VideoCourseManager.createdCourses || []

    Component.onCompleted: {
        console.log("VideoCourseManager доступен:", typeof VideoCourseManager !== "undefined")
        console.log("Мои созданные курсы:", videoCourses.length)
        console.log("Текущий пользователь:", ProfileManager.userName)
        updateCourses()
    }

    Connections {
        target: ThemeManager
        function onThemeColorsChanged() {
            themeColors = ThemeManager.currentThemeColors;
        }
    }

    // Обработчик изменений в VideoCourseManager
    Connections {
        target: VideoCourseManager

        function onAllCoursesChanged() {
            console.log("Курсы обновлены в VideoCourseManager")
            updateCourses()
        }

        function onCreatedCoursesChanged() {
            console.log("Созданные курсы обновлены")
            updateCourses()
        }

        function onCourseCreated(courseId) {
            console.log("Создан новый курс:", courseId)
            updateCourses()
        }
    }

    // Обработчик изменений в ProfileManager
    Connections {
        target: ProfileManager
        function onUserNameChanged() {
            console.log("Имя пользователя изменено")
            updateCourses()
        }
    }

    // Функция для обновления списка курсов
    function updateCourses() {
        console.log("🔄 Обновление списка курсов...")

        var createdCourses = VideoCourseManager.createdCourses || []
        console.log("📊 Получено созданных курсов:", createdCourses.length)

        // Логируем каждый созданный курс для отладки
        for (var i = 0; i < createdCourses.length; i++) {
            console.log("📝 Мой созданный курс:", createdCourses[i].title,
                       "Автор:", createdCourses[i].author,
                       "AuthorId:", createdCourses[i].authorId)
        }

        // ИСПРАВЛЕНО: принудительное обновление свойства
        container.videoCourses = createdCourses

        // Принудительно обновляем связанные компоненты
        if (videoCourseBlockWide.item) {
            videoCourseBlockWide.item.courses = createdCourses
        }
        if (videoCourseBlockNarrow.item) {
            videoCourseBlockNarrow.item.courses = createdCourses
        }

        console.log("✅ Список курсов обновлен")
    }

    // Для широкого режима - растягивание на всю страницу
    // Для узкого режима - прокрутка
    Loader {
        id: contentLoader
        anchors {
            fill: parent
            bottomMargin: 10
        }
        sourceComponent: container.isWide ? wideContent : narrowContent
    }

    Component {
        id: wideContent
        ColumnLayout {
            anchors.fill: parent
            spacing: 10

            // Первый ряд - 30% высоты
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: parent.height * 0.3

                Row {
                    anchors.fill: parent
                    spacing: 10

                    ProfileBlock {
                        width: parent.width * 0.5 - 5
                        height: parent.height
                        themeColors: container.themeColors
                        isEditMode: container.isEditMode
                    }

                    InformationBlock {
                        id: infoBlockWide
                        width: parent.width * 0.5 - 5
                        height: parent.height
                        themeColors: container.themeColors
                        isEditMode: container.isEditMode
                    }
                }
            }

            // Второй ряд - 30% высоты
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: parent.height * 0.3

                Row {
                    anchors.fill: parent
                    spacing: 10

                    ContactBlock {
                        width: (parent.width - 20) / 3
                        height: parent.height
                        themeColors: container.themeColors
                        isEditMode: container.isEditMode
                    }

                    StatusBlock {
                        width: (parent.width - 20) / 3
                        height: parent.height
                        title: "Прогресс обучения"
                        projects: getProgressProjects()
                        themeColors: container.themeColors
                        isEditMode: container.isEditMode
                    }

                    ProjectBlock {
                        width: (parent.width - 20) / 3
                        height: parent.height
                        title: "Статистика"
                        projects: getStatisticsProjects()
                        themeColors: container.themeColors
                        isEditMode: container.isEditMode
                    }
                }
            }

            // Третий ряд - 40% высоты
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 10

                Loader {
                    id: videoCourseBlockWide
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width * 0.4
                    sourceComponent: VideoCourseBlock {
                        width: parent.width
                        height: parent.height
                        courses: container.videoCourses
                        themeColors: container.themeColors
                        isEditMode: container.isEditMode
                        onCourseSelected: (course) => {
                            console.log("Курс выбран в широком режиме:", course.title)
                            videoManagementBlockWide.item.currentCourse = course
                        }
                    }
                }

                Loader {
                    id: videoManagementBlockWide
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width * 0.6
                    sourceComponent: VideoManagementBlock {
                        width: parent.width
                        height: parent.height
                        themeColors: container.themeColors
                        isEditMode: container.isEditMode
                    }
                }
            }
        }
    }

    Component {
        id: narrowContent
        ScrollView {
            anchors.fill: parent
            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            clip: true
            contentWidth: width
            contentHeight: contentColumn.height

            Column {
                id: contentColumn
                width: parent.width
                spacing: 10

                // Первый ряд
                Column {
                    width: parent.width
                    spacing: 10

                    ProfileBlock {
                        width: parent.width
                        height: 330
                        themeColors: container.themeColors
                        isEditMode: container.isEditMode
                    }

                    InformationBlock {
                        width: parent.width
                        height: parent.height * 0.58
                        themeColors: container.themeColors
                        isEditMode: container.isEditMode
                    }
                }

                // Второй ряд
                Column {
                    width: parent.width
                    spacing: 10

                    ContactBlock {
                        width: parent.width
                        height: 250
                        themeColors: container.themeColors
                        isEditMode: container.isEditMode
                    }

                    StatusBlock {
                        width: parent.width
                        height: 250
                        title: "Прогресс обучения"
                        projects: getProgressProjects()
                        themeColors: container.themeColors
                        isEditMode: container.isEditMode
                    }

                    ProjectBlock {
                        width: parent.width
                        height: 250
                        title: "Статистика"
                        projects: getStatisticsProjects()
                        themeColors: container.themeColors
                        isEditMode: container.isEditMode
                    }
                }

                // Третий ряд
                Column {
                    width: parent.width
                    spacing: 10

                    Loader {
                        id: videoCourseBlockNarrow
                        width: parent.width
                        height: 400
                        sourceComponent: VideoCourseBlock {
                            width: parent.width
                            height: parent.height
                            courses: container.videoCourses
                            themeColors: container.themeColors
                            isEditMode: container.isEditMode
                            onCourseSelected: (course) => {
                                console.log("Курс выбран в узком режиме:", course.title)
                                videoManagementBlockNarrow.item.currentCourse = course
                            }
                        }
                    }

                    Loader {
                        id: videoManagementBlockNarrow
                        width: parent.width
                        height: 400
                        sourceComponent: VideoManagementBlock {
                            width: parent.width
                            height: parent.height
                            themeColors: container.themeColors
                            isEditMode: container.isEditMode
                        }
                    }
                }
            }
        }
    }

    // Функции для получения данных прогресса и статистики
    function getProgressProjects() {
        var myCourses = VideoCourseManager.myCourses || [];
        var projects = [];

        console.log("Прогресс - мои курсы:", myCourses.length)

        for (var i = 0; i < myCourses.length; i++) {
            var course = myCourses[i];
            var progress = ProfileManager.getCourseProgress(course.id).progress || 0;

            projects.push({
                name: course.title,
                status: progress
            });
        }

        if (projects.length === 0) {
            projects.push({
                name: "Нет активных курсов",
                status: 0
            });
        }

        return projects;
    }

    function getStatisticsProjects() {
        var statistics = ProfileManager.getStatistics() || {};
        var projects = [];

        projects.push({
            name: "Всего курсов",
            status: statistics.totalCourses || 0
        });

        projects.push({
            name: "Завершено курсов",
            status: statistics.completedCourses || 0
        });

        projects.push({
            name: "Часов обучения",
            status: statistics.totalStudyHours || 0
        });

        var createdCourses = VideoCourseManager.createdCourses || [];
        projects.push({
            name: "Создано курсов",
            status: createdCourses.length
        });

        console.log("Статистика - создано курсов:", createdCourses.length)

        return projects;
    }

    background: Rectangle {
        color: "transparent"
    }
}
