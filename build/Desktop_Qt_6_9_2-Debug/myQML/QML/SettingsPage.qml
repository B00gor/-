import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects


Page {
    id: container
    property var courseData: null
    property var themeColors: ThemeManager.currentThemeColors

    // Свойства для данных из настроек
    property string lightThemeName: ThemeManager.getThemeName("light")
    property string darkThemeName: ThemeManager.getThemeName("dark")
    property string lightThemeDescription: ThemeManager.getThemeDescription("light")
    property string darkThemeDescription: ThemeManager.getThemeDescription("dark")
    property var colorPalette: ThemeManager.getColorPalette()

    // Определяем состояние на основе ширины
    property bool isWide: width > 700

    function toggleTheme() {
        ThemeManager.theme = ThemeManager.theme === "light" ? "dark" : "light";
    }

    function updatePrimaryColor(newColor) {
        ThemeManager.primaryColor = newColor;
    }

    // Обновляем данные при изменении темы
    Connections {
        target: ThemeManager
        function onThemeChanged() {
            themeColors = ThemeManager.currentThemeColors;
            lightThemeName = ThemeManager.getThemeName("light");
            darkThemeName = ThemeManager.getThemeName("dark");
            lightThemeDescription = ThemeManager.getThemeDescription("light");
            darkThemeDescription = ThemeManager.getThemeDescription("dark");
        }
        function onPrimaryColorChanged() {
            themeColors = ThemeManager.currentThemeColors;
            colorPalette = ThemeManager.getColorPalette();
        }
        function onThemeColorsChanged() {
            themeColors = ThemeManager.currentThemeColors;
        }
        function onProfileDataChanged() {
            themeColors = ThemeManager.currentThemeColors;
            colorPalette = ThemeManager.getColorPalette();
            lightThemeName = ThemeManager.getThemeName("light");
            darkThemeName = ThemeManager.getThemeName("dark");
            lightThemeDescription = ThemeManager.getThemeDescription("light");
            darkThemeDescription = ThemeManager.getThemeDescription("dark");
        }
    }

    // Фон страницы - ПРОЗРАЧНЫЙ как и нужно
    background: Rectangle {
        color: "transparent"
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        // Основной контент - ОДИН ScrollView для ВСЕХ блоков
        ScrollView {
            id: mainScrollView
            Layout.fillWidth: true
            Layout.fillHeight: true

            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            ScrollBar.horizontal.policy: ScrollBar.AsNeeded

            // Содержимое скролла
            Column {
                id: contentColumn
                width: mainScrollView.availableWidth
                spacing: 15

                // Блок темы оформления
                Rectangle {
                    width: parent.width
                    height: themeContent.height + 30
                    radius: 8
                    border.color: themeColors.primaryColor
                    border.width: 1
                    color: themeColors.backgroundColor

                    Column {
                        id: themeContent
                        width: parent.width - 30
                        anchors.centerIn: parent
                        spacing: 15

                        Text {
                            text: "Тема оформления"
                            font.pointSize: 16
                            font.bold: true
                            color: themeColors.textColor
                            width: parent.width
                        }

                        // Адаптивный контейнер для выбора темы
                        Item {
                            width: parent.width
                            height: container.isWide ? 100 : 200

                            Row {
                                anchors.fill: parent
                                spacing: 20
                                visible: container.isWide

                                // Светлая тема
                                Rectangle {
                                    width: 80
                                    height: 80
                                    radius: 8
                                    color: "#f5f5f5"
                                    border.color: ThemeManager.theme === "light" ?
                                        themeColors.primaryColor :
                                        themeColors.borderColor
                                    border.width: ThemeManager.theme === "light" ? 3 : 1

                                    Column {
                                        anchors.centerIn: parent
                                        spacing: 5
                                        Rectangle {
                                            width: 40; height: 20; radius: 3
                                            color: "#ffffff"; border.color: themeColors.primaryColor
                                        }
                                        Rectangle {
                                            width: 40; height: 30; radius: 3
                                            color: themeColors.primaryColor
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: toggleTheme()
                                    }
                                }

                                // Темная тема
                                Rectangle {
                                    width: 80
                                    height: 80
                                    radius: 8
                                    color: "#2b2b2b"
                                    border.color: ThemeManager.theme === "dark" ?
                                        themeColors.primaryColor :
                                        themeColors.borderColor
                                    border.width: ThemeManager.theme === "dark" ? 3 : 1

                                    Column {
                                        anchors.centerIn: parent
                                        spacing: 5
                                        Rectangle {
                                            width: 40; height: 20; radius: 3
                                            color: "#3c3c3c"; border.color: themeColors.primaryColor
                                        }
                                        Rectangle {
                                            width: 40; height: 30; radius: 3
                                            color: themeColors.primaryColor
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: toggleTheme()
                                    }
                                }

                                // Описание темы
                                Column {
                                    width: parent.width - 180
                                    height: parent.height
                                    spacing: 5

                                    Text {
                                        text: ThemeManager.theme === "dark" ?
                                            container.darkThemeName :
                                            container.lightThemeName
                                        font.pointSize: 14
                                        color: themeColors.textColor
                                        width: parent.width
                                        wrapMode: Text.Wrap
                                    }

                                    Text {
                                        text: ThemeManager.theme === "dark" ?
                                            container.darkThemeDescription :
                                            container.lightThemeDescription
                                        font.pointSize: 10
                                        color: themeColors.secondaryTextColor
                                        wrapMode: Text.WordWrap
                                        width: parent.width
                                    }
                                }
                            }

                            Column {
                                anchors.fill: parent
                                spacing: 15
                                visible: !container.isWide

                                Row {
                                    width: parent.width
                                    height: 80
                                    spacing: 20

                                    // Светлая тема
                                    Rectangle {
                                        width: 80
                                        height: 80
                                        radius: 8
                                        color: "#f5f5f5"
                                        border.color: ThemeManager.theme === "light" ?
                                            themeColors.primaryColor :
                                            themeColors.borderColor
                                        border.width: ThemeManager.theme === "light" ? 3 : 1

                                        Column {
                                            anchors.centerIn: parent
                                            spacing: 5
                                            Rectangle {
                                                width: 40; height: 20; radius: 3
                                                color: "#ffffff"; border.color: themeColors.primaryColor
                                            }
                                            Rectangle {
                                                width: 40; height: 30; radius: 3
                                                color: themeColors.primaryColor
                                            }
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: toggleTheme()
                                        }
                                    }

                                    // Темная тема
                                    Rectangle {
                                        width: 80
                                        height: 80
                                        radius: 8
                                        color: "#2b2b2b"
                                        border.color: ThemeManager.theme === "dark" ?
                                            themeColors.primaryColor :
                                            themeColors.borderColor
                                        border.width: ThemeManager.theme === "dark" ? 3 : 1

                                        Column {
                                            anchors.centerIn: parent
                                            spacing: 5
                                            Rectangle {
                                                width: 40; height: 20; radius: 3
                                                color: "#3c3c3c"; border.color: themeColors.primaryColor
                                            }
                                            Rectangle {
                                                width: 40; height: 30; radius: 3
                                                color: themeColors.primaryColor
                                            }
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: toggleTheme()
                                        }
                                    }
                                }

                                // Описание темы для узкого экрана
                                Column {
                                    width: parent.width
                                    spacing: 5

                                    Text {
                                        text: ThemeManager.theme === "dark" ?
                                            container.darkThemeName :
                                            container.lightThemeName
                                        font.pointSize: 14
                                        color: themeColors.textColor
                                        width: parent.width
                                        wrapMode: Text.Wrap
                                    }

                                    Text {
                                        text: ThemeManager.theme === "dark" ?
                                            container.darkThemeDescription :
                                            container.lightThemeDescription
                                        font.pointSize: 10
                                        color: themeColors.secondaryTextColor
                                        wrapMode: Text.WordWrap
                                        width: parent.width
                                    }
                                }
                            }
                        }
                    }
                }

                // Блок основного цвета
                Rectangle {
                    width: parent.width
                    height: colorContent.height + 30
                    radius: 8
                    border.color: themeColors.primaryColor
                    border.width: 1
                    color: themeColors.backgroundColor

                    Column {
                        id: colorContent
                        width: parent.width - 30
                        anchors.centerIn: parent
                        spacing: 15

                        Text {
                            text: "Основной цвет"
                            font.pointSize: 16
                            font.bold: true
                            color: themeColors.textColor
                            width: parent.width
                        }

                        // Текущий цвет
                        Row {
                            width: parent.width
                            height: 40
                            spacing: 15

                            Text {
                                text: "Текущий цвет:"
                                color: themeColors.textColor
                                height: parent.height
                                verticalAlignment: Text.AlignVCenter
                            }

                            Rectangle {
                                width: 40
                                height: 40
                                radius: 8
                                color: themeColors.primaryColor
                                border.color: themeColors.borderColor
                                border.width: 2
                            }

                            Text {
                                text: themeColors.primaryColor
                                color: themeColors.secondaryTextColor
                                font.family: "Monospace"
                                height: parent.height
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                width: parent.width - 200
                            }
                        }

                        // Палитра цветов
                        Flow {
                            width: parent.width
                            spacing: 10

                            Repeater {
                                model: ThemeManager.getColorPalette()

                                Rectangle {
                                    width: 40
                                    height: 40
                                    radius: 6
                                    color: modelData
                                    border.color: ThemeManager.primaryColor === modelData ?
                                        modelData : themeColors.borderColor
                                    border.width: ThemeManager.primaryColor === modelData ? 3 : 1

                                    MouseArea {
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onClicked: {
                                            console.log("Selected color:", modelData);
                                            ThemeManager.primaryColor = modelData;
                                        }
                                    }

                                    Rectangle {
                                        anchors.fill: parent
                                        radius: parent.radius
                                        color: "transparent"
                                        border.color: Qt.lighter(modelData, 1.4)
                                        border.width: 2
                                        opacity: parent.MouseArea.containsMouse ? 1 : 0
                                    }
                                }
                            }
                        }

                        // HEX ввод
                        Row {
                            width: parent.width
                            height: 40
                            spacing: 10

                            Text {
                                text: "HEX код:"
                                color: themeColors.textColor
                                height: parent.height
                                verticalAlignment: Text.AlignVCenter
                                width: 70
                            }

                            TextField {
                                id: hexInput
                                width: parent.width - 80
                                height: 40
                                placeholderText: "#0078d4"
                                validator: RegularExpressionValidator {
                                    regularExpression: /^#[0-9A-Fa-f]{6}$/
                                }

                                background: Rectangle {
                                    radius: 4
                                    border.color: themeColors.borderColor
                                    border.width: 1
                                    color: themeColors.cardColor
                                }

                                color: themeColors.textColor
                                placeholderTextColor: themeColors.secondaryTextColor

                                // Убираем прямую привязку text: themeColors.primaryColor чтобы избежать цикла
                                // Вместо этого используем Connections для обновления текста при изменении цвета
                                Component.onCompleted: {
                                    hexInput.text = themeColors.primaryColor
                                }

                                Connections {
                                    target: ThemeManager
                                    function onPrimaryColorChanged() {
                                        // Обновляем текст только если он отличается от текущего цвета
                                        if (hexInput.text !== themeColors.primaryColor) {
                                            hexInput.text = themeColors.primaryColor
                                        }
                                    }
                                }

                                onAccepted: {
                                    if (text.match(/^#[0-9a-fA-F]{6}$/)) {
                                        updatePrimaryColor(text);
                                    }
                                }

                                onTextChanged: {
                                    // Добавляем проверку чтобы избежать цикла
                                    if (text.match(/^#[0-9a-fA-F]{6}$/) && text !== themeColors.primaryColor) {
                                        updatePrimaryColor(text);
                                    }
                                }
                            }
                        }
                    }
                }

                // Блок дополнительных настроек
                Rectangle {
                    width: parent.width
                    height: additionalContent.height + 30
                    radius: 8
                    border.color: themeColors.primaryColor
                    border.width: 1
                    color: themeColors.backgroundColor

                    Column {
                        id: additionalContent
                        width: parent.width - 30
                        anchors.centerIn: parent
                        spacing: 15

                        Text {
                            text: "Дополнительные настройки"
                            font.pointSize: 16
                            font.bold: true
                            color: themeColors.textColor
                            width: parent.width
                        }

                        Button {
                            width: parent.width
                            height: 40
                            text: "Сбросить к стандартным настройкам"
                            background: Rectangle {
                                radius: 4
                                color: themeColors.cardColor
                                border.color: themeColors.borderColor
                                border.width: 1
                            }
                            contentItem: Text {
                                text: parent.text
                                color: themeColors.textColor
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.Wrap
                            }
                            onClicked: {
                                updatePrimaryColor("#2196F3");
                                if (ThemeManager.theme !== "light") {
                                    toggleTheme();
                                }
                            }
                        }
                    }
                }

                // Добавляем отступ внизу для удобства скролла
                Item {
                    width: parent.width
                    height: 20
                }
            }
        }
    }
}
