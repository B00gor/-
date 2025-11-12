import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Page {
    id: authPage
    property var themeColors: ThemeManager.currentThemeColors
    property bool isRegisterMode: false
    property bool showPassword: false
    property bool showRepeatPassword: false
    property bool isTermsAccepted: false

    background: Rectangle {
        color: "transparent"
    }

    ColumnLayout {
        spacing: 12
        width: Math.min(parent.width * 0.9, 400)
        anchors.centerIn: parent

        // Header с анимацией
        ColumnLayout {
            spacing: 8
            Layout.alignment: Qt.AlignHCenter

            Image {
                source: "qrc:/assets/logo.svg"
                sourceSize: Qt.size(64, 64)
                Layout.alignment: Qt.AlignHCenter
                ColorOverlay {
                    anchors.fill: parent
                    source: parent
                    color: themeColors.primaryColor
                }
            }

            Text {
                id: titleText
                text: isRegisterMode ? "Создать аккаунт" : "Добро пожаловать"
                font.pointSize: 24
                font.bold: true
                color: themeColors.textColor
                Layout.alignment: Qt.AlignHCenter
                Behavior on text { PropertyAnimation { duration: 300 } }
            }

            Text {
                id: subtitleText
                text: isRegisterMode ? "Заполните данные для регистрации" : "Войдите в свой аккаунт"
                font.pointSize: 14
                color: themeColors.secondaryTextColor
                Layout.alignment: Qt.AlignHCenter
                Behavior on text { PropertyAnimation { duration: 300 } }
            }
        }

        // Кнопка Google
        Button {
            id: googleButton
            Layout.fillWidth: true
            height: 52
            text: googleAuth.authenticated ? "Выйти из Google" : "Войти через Google"
            font.pointSize: 14
            font.bold: true

            contentItem: Row {
                spacing: 8
                anchors.centerIn: parent

                Image {
                    source: "qrc:/icons/google-icon.webp"
                    height: 50
                    width: 50
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: googleButton.text
                    color: themeColors.textColor
                    font: googleButton.font
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            background: Rectangle {
                radius: 12
                color: "transparent"
                border.color: themeColors.borderColor
                border.width: 2
            }

            onClicked: {
                if (googleAuth.authenticated)
                    googleAuth.logout()
                else
                    googleAuth.startAuth()
            }
            Connections {
                target: googleAuth
                onOpenAuthUrl: Qt.openUrlExternally(url)
            }
        }

        // Разделитель "ИЛИ"
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: themeColors.borderColor
            }

            Text {
                text: "ИЛИ"
                color: themeColors.secondaryTextColor
                font.pointSize: 12
                font.bold: true
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: themeColors.borderColor
            }
        }

        // Форма с анимируемыми полями
        ColumnLayout {
            spacing: 16
            Layout.fillWidth: true

            // Email Field
            ColumnLayout {
                spacing: 6
                Layout.fillWidth: true

                Text {
                    text: "Email"
                    font.pointSize: 12
                    font.bold: true
                    color: themeColors.textColor
                }

                TextField {
                    id: emailField
                    Layout.fillWidth: true
                    height: 52
                    placeholderText: "your@email.com"
                    color: themeColors.textColor
                    placeholderTextColor: themeColors.secondaryTextColor
                    selectionColor: themeColors.accentColor
                    selectedTextColor: "white"
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 16
                    rightPadding: 16
                    font.pointSize: 14

                    background: Rectangle {
                        radius: 12
                        color: themeColors.cardColor
                        border.color: emailField.activeFocus ? themeColors.primaryColor : themeColors.borderColor
                        border.width: emailField.activeFocus ? 2 : 1
                        layer.enabled: true
                        layer.effect: DropShadow {
                            transparentBorder: true
                            horizontalOffset: 0
                            verticalOffset: 2
                            radius: 8
                            samples: 17
                            color: "#20000000"
                        }
                    }
                }
            }

            // Password Field
            ColumnLayout {
                spacing: 6
                Layout.fillWidth: true

                Text {
                    text: "Пароль"
                    font.pointSize: 12
                    font.bold: true
                    color: themeColors.textColor
                }

                Item {
                    Layout.fillWidth: true
                    height: 52

                    TextField {
                        id: passwordField
                        anchors.fill: parent
                        echoMode: showPassword ? TextField.Normal : TextField.Password
                        placeholderText: isRegisterMode ? "Создайте надежный пароль" : "Введите ваш пароль"
                        color: themeColors.textColor
                        placeholderTextColor: themeColors.secondaryTextColor
                        selectionColor: themeColors.accentColor
                        selectedTextColor: "white"
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 16
                        rightPadding: 50
                        font.pointSize: 14

                        background: Rectangle {
                            radius: 12
                            color: themeColors.cardColor
                            border.color: passwordField.activeFocus ? themeColors.primaryColor : themeColors.borderColor
                            border.width: passwordField.activeFocus ? 2 : 1
                            layer.enabled: true
                            layer.effect: DropShadow {
                                transparentBorder: true
                                horizontalOffset: 0
                                verticalOffset: 2
                                radius: 8
                                samples: 17
                                color: "#20000000"
                            }
                        }
                    }

                    // Иконка показа пароля
                    Rectangle {
                        id: passwordEyeButton
                        width: 40
                        height: 40
                        radius: 20
                        anchors {
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                            rightMargin: 6
                        }
                        color: "transparent"

                        Image {
                            id: passwordEyeIcon
                            anchors.centerIn: parent
                            source: "qrc:/icons/eye-icon.svg" // Замените на вашу иконку
                            sourceSize: Qt.size(24, 24)
                            opacity: 0.7
                        }

                        ColorOverlay {
                            anchors.fill: passwordEyeIcon
                            source: passwordEyeIcon
                            color: showPassword ? themeColors.primaryColor : themeColors.secondaryTextColor
                            Behavior on color { ColorAnimation { duration: 200 } }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: showPassword = !showPassword
                        }
                    }
                }

                // Индикатор силы пароля (только для регистрации)
                Item {
                    Layout.fillWidth: true
                    implicitHeight: 4
                    clip: true

                    Rectangle {
                        id: passwordStrengthIndicator
                        width: parent.width
                        height: isRegisterMode ? 4 : 0
                        radius: 2
                        color: themeColors.borderColor

                        Rectangle {
                            width: parent.width * (passwordField.text.length > 8 ? 0.8 : passwordField.text.length > 5 ? 0.5 : 0.2)
                            height: parent.height
                            radius: 2
                            color: passwordField.text.length > 8 ? "#4CAF50" : passwordField.text.length > 5 ? "#FF9800" : "#F44336"
                            Behavior on width { NumberAnimation { duration: 200 } }
                        }

                        Behavior on height {
                            NumberAnimation {
                                duration: 300
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }
            }

            // Repeat Password Field (только для регистрации)
            ColumnLayout {
                id: repeatPasswordContainer
                spacing: 6
                Layout.fillWidth: true
                Layout.preferredHeight: isRegisterMode ? implicitHeight : 0
                opacity: isRegisterMode ? 1 : 0

                Behavior on Layout.preferredHeight {
                    NumberAnimation {
                        duration: 400
                        easing.type: Easing.OutCubic
                    }
                }
                Behavior on opacity {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutCubic
                    }
                }

                Text {
                    text: "Повторите пароль"
                    font.pointSize: 12
                    font.bold: true
                    color: themeColors.textColor
                }

                Item {
                    Layout.fillWidth: true
                    height: 52

                    TextField {
                        id: repeatPasswordField
                        anchors.fill: parent
                        echoMode: showRepeatPassword ? TextField.Normal : TextField.Password
                        placeholderText: "Повторите ваш пароль"
                        color: themeColors.textColor
                        placeholderTextColor: themeColors.secondaryTextColor
                        selectionColor: themeColors.accentColor
                        selectedTextColor: "white"
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 16
                        rightPadding: 50
                        font.pointSize: 14

                        background: Rectangle {
                            radius: 12
                            color: themeColors.cardColor
                            border.color: repeatPasswordField.activeFocus ? themeColors.primaryColor :
                                        (repeatPasswordField.text && repeatPasswordField.text !== passwordField.text ? "#F44336" : themeColors.borderColor)
                            border.width: repeatPasswordField.activeFocus ? 2 : 1
                            layer.enabled: true
                            layer.effect: DropShadow {
                                transparentBorder: true
                                horizontalOffset: 0
                                verticalOffset: 2
                                radius: 8
                                samples: 17
                                color: "#20000000"
                            }
                        }
                    }

                    // Иконка показа пароля для повторного ввода
                    Rectangle {
                        id: repeatPasswordEyeButton
                        width: 40
                        height: 40
                        radius: 20
                        anchors {
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                            rightMargin: 6
                        }
                        color: "transparent"

                        Image {
                            id: repeatPasswordEyeIcon
                            anchors.centerIn: parent
                            source: "qrc:/icons/eye-icon.svg" // Замените на вашу иконку
                            sourceSize: Qt.size(24, 24)
                            opacity: 0.7
                        }

                        ColorOverlay {
                            anchors.fill: repeatPasswordEyeIcon
                            source: repeatPasswordEyeIcon
                            color: showRepeatPassword ? themeColors.primaryColor : themeColors.secondaryTextColor
                            Behavior on color { ColorAnimation { duration: 200 } }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: showRepeatPassword = !showRepeatPassword
                        }
                    }
                }
            }

            // Terms agreement (только для регистрации)
            RowLayout {
                id: termsContainer
                spacing: 8
                Layout.fillWidth: true
                Layout.preferredHeight: isRegisterMode ? implicitHeight : 0
                opacity: isRegisterMode ? 1 : 0

                Behavior on Layout.preferredHeight {
                    NumberAnimation {
                        duration: 400
                        easing.type: Easing.OutCubic
                    }
                }
                Behavior on opacity {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutCubic
                    }
                }

                CheckBox {
                    id: termsCheckbox
                    checked: isTermsAccepted
                    onCheckedChanged: isTermsAccepted = checked
                }

                Text {
                    text: "Я принимаю условия использования"
                    color: themeColors.textColor
                    font.pointSize: 12
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: termsCheckbox.checked = !termsCheckbox.checked
                    }
                }
            }

            // Forgot Password (только для входа)
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: !isRegisterMode ? 20 : 0
                opacity: !isRegisterMode ? 1 : 0

                Behavior on Layout.preferredHeight {
                    NumberAnimation {
                        duration: 400
                        easing.type: Easing.OutCubic
                    }
                }
                Behavior on opacity {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutCubic
                    }
                }

                Text {
                    text: "Забыли пароль?"
                    color: themeColors.primaryColor
                    font.pointSize: 12
                    font.bold: true
                    anchors.right: parent.right

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: console.log("Forgot password clicked")
                    }
                }
            }
        }

        // Buttons
        ColumnLayout {
            spacing: 12
            Layout.fillWidth: true

            // Основная кнопка
            Button {
                id: mainButton
                text: isRegisterMode ? "Создать аккаунт" : "Войти"
                Layout.fillWidth: true
                height: 56
                font.pointSize: 16
                font.bold: true
                opacity: {
                    if (isRegisterMode) {
                        return emailField.text && passwordField.text && repeatPasswordField.text &&
                               passwordField.text === repeatPasswordField.text && isTermsAccepted ? 1.0 : 0.6
                    } else {
                        return emailField.text && passwordField.text ? 1.0 : 0.6
                    }
                }

                contentItem: Text {
                    text: mainButton.text
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font: mainButton.font
                }

                background: Rectangle {
                    radius: 14
                    color: themeColors.primaryColor
                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        horizontalOffset: 0
                        verticalOffset: 4
                        radius: 12
                        samples: 17
                        color: Qt.rgba(themeColors.primaryColor.r, themeColors.primaryColor.g, themeColors.primaryColor.b, 0.3)
                    }
                }

                onClicked: {
                    if (isRegisterMode) {
                        if(emailField.text && passwordField.text && repeatPasswordField.text &&
                           passwordField.text === repeatPasswordField.text && isTermsAccepted) {
                            pagePanel.push("MainPage.qml")
                        }
                    } else {
                        if(emailField.text && passwordField.text) {
                            pagePanel.push("MainPage.qml")
                        }
                        /*убери это потом нахуй*/pagePanel.push("MainPage.qml")
                    }
                }

                Behavior on opacity {
                    NumberAnimation { duration: 300 }
                }
            }

            // Переключение между режимами
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 4

                Text {
                    text: isRegisterMode ? "Уже есть аккаунт?" : "Нет аккаунта?"
                    color: themeColors.secondaryTextColor
                    font.pointSize: 14
                }

                Text {
                    text: isRegisterMode ? "Войти" : "Создать аккаунт"
                    color: themeColors.primaryColor
                    font.pointSize: 14
                    font.bold: true

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            isRegisterMode = !isRegisterMode
                            // Очищаем поля при переключении
                            if (!isRegisterMode) {
                                repeatPasswordField.text = ""
                                isTermsAccepted = false
                            }
                        }
                    }
                }
            }
        }
    }
}
