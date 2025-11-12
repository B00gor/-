// RegisterPage.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Page {
    id: registerPage
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
        width: Math.min(parent.width * 0.9, 400)
        anchors.centerIn: parent

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
                text: "Создать аккаунт"
                font.pointSize: 24
                font.bold: true
                color: themeColors.textColor
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "Заполните данные для регистрации"
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

                TextField {
                    id: passwordField
                    Layout.fillWidth: true
                    height: 52
                    echoMode: TextField.Password
                    placeholderText: "Создайте надежный пароль"
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

                // Password strength indicator
                Rectangle {
                    Layout.fillWidth: true
                    height: 4
                    radius: 2
                    color: themeColors.borderColor

                    Rectangle {
                        width: parent.width * (passwordField.text.length > 8 ? 0.8 : passwordField.text.length > 5 ? 0.5 : 0.2)
                        height: parent.height
                        radius: 2
                        color: passwordField.text.length > 8 ? "#4CAF50" : passwordField.text.length > 5 ? "#FF9800" : "#F44336"
                        Behavior on width { NumberAnimation { duration: 200 } }
                    }
                }
            }

            // Repeat Password Field
            ColumnLayout {
                spacing: 6
                Layout.fillWidth: true

                Text {
                    text: "Повторите пароль"
                    font.pointSize: 12
                    font.bold: true
                    color: themeColors.textColor
                }

                TextField {
                    id: repeatPasswordField
                    Layout.fillWidth: true
                    height: 52
                    echoMode: TextField.Password
                    placeholderText: "Повторите ваш пароль"
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
            }

            // Terms agreement
            RowLayout {
                spacing: 8
                Layout.fillWidth: true

                Rectangle {
                    width: 20
                    height: 20
                    radius: 4
                    color: themeColors.cardColor
                    border.color: themeColors.borderColor
                    border.width: 2

                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/assets/check.svg"
                        sourceSize: Qt.size(12, 12)
                        visible: true
                        ColorOverlay {
                            anchors.fill: parent
                            source: parent
                            color: themeColors.primaryColor
                        }
                    }
                }

                Text {
                    text: "Я согласен с условиями использования"
                    font.pointSize: 12
                    color: themeColors.textColor
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                }
            }
        }

        // Buttons
        ColumnLayout {
            spacing: 12
            Layout.fillWidth: true

            // Register Button
            Button {
                id: buttonRegister
                text: "Создать аккаунт"
                Layout.fillWidth: true
                height: 56
                font.pointSize: 16
                font.bold: true
                opacity: emailField.text && passwordField.text && repeatPasswordField.text && passwordField.text === repeatPasswordField.text ? 1.0 : 0.6

                contentItem: Text {
                    text: buttonRegister.text
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font: buttonRegister.font
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
                    if(emailField.text && passwordField.text && repeatPasswordField.text && passwordField.text === repeatPasswordField.text) {
                        pagePanel.push("MainPage.qml")
                    }
                }
            }

            // Login redirect
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 4

                Text {
                    text: "Уже есть аккаунт?"
                    color: themeColors.secondaryTextColor
                    font.pointSize: 14
                }

                Text {
                    text: "Войти"
                    color: themeColors.primaryColor
                    font.pointSize: 14
                    font.bold: true

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: pagePanel.pop()
                    }
                }
            }
        }
    }
}
