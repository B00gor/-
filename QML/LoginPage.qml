// LoginPage.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Page {
    id: loginPage
    property var themeColors: ThemeManager.currentThemeColors

    background: Rectangle {
        color: themeColors.backgroundColor
        LinearGradient {
            anchors.fill: parent
            start: Qt.point(0, 0)
            end: Qt.point(parent.width, parent.height)
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.lighter(themeColors.backgroundColor, 1.1) }
                GradientStop { position: 1.0; color: themeColors.backgroundColor }
            }
        }
    }

    ColumnLayout {
        spacing: 24
        anchors.centerIn: parent
        width: Math.min(parent.width * 0.9, 400)

        // Header
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
                text: "Добро пожаловать"
                font.pointSize: 24
                font.bold: true
                color: themeColors.textColor
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "Войдите в свой аккаунт"
                font.pointSize: 14
                color: themeColors.secondaryTextColor
                Layout.alignment: Qt.AlignHCenter
            }
        }

        // Form
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
                    id: loginField
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
                        border.color: loginField.activeFocus ? themeColors.primaryColor : themeColors.borderColor
                        border.width: loginField.activeFocus ? 2 : 1
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

                TextField {
                    id: passwordField
                    Layout.fillWidth: true
                    height: 52
                    echoMode: TextField.Password
                    placeholderText: "Введите ваш пароль"
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
            }

            // Forgot Password
            Text {
                text: "Забыли пароль?"
                color: themeColors.primaryColor
                font.pointSize: 12
                font.bold: true
                Layout.alignment: Qt.AlignRight

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: console.log("Forgot password clicked")
                }
            }
        }

        // Buttons
        ColumnLayout {
            spacing: 12
            Layout.fillWidth: true

            // Login Button
            Button {
                id: buttonLogin
                text: "Войти"
                Layout.fillWidth: true
                height: 56
                font.pointSize: 16
                font.bold: true
                opacity: loginField.text && passwordField.text ? 1.0 : 0.6

                contentItem: Text {
                    text: buttonLogin.text
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font: buttonLogin.font
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
                    if(loginField.text && passwordField.text) {
                        pagePanel.push("MainPage.qml")
                    }
                }
            }

            // Divider
            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: themeColors.borderColor
                }

                Text {
                    text: "или"
                    color: themeColors.secondaryTextColor
                    font.pointSize: 12
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: themeColors.borderColor
                }
            }

            // Register Button
            Button {
                id: buttonToRegister
                text: "Создать аккаунт"
                Layout.fillWidth: true
                height: 56
                font.pointSize: 16
                font.bold: true

                contentItem: Text {
                    text: buttonToRegister.text
                    color: themeColors.primaryColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font: buttonToRegister.font
                }

                background: Rectangle {
                    radius: 14
                    color: "transparent"
                    border.color: themeColors.primaryColor
                    border.width: 2
                }

                onClicked: pagePanel.push("RegisterPage.qml")
            }
        }
    }
}
