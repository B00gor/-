import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt5Compat.GraphicalEffects

Rectangle {
    id: root
    property var themeColors: ThemeManager.currentThemeColors
    property bool isEditMode: false
    property string avatarSource: ProfileManager.avatar || ""
    property string coverSource: ProfileManager.cover || ""
    property real headerHeight: 200
    property real containerHeight: headerHeight

    color: themeColors.backgroundColor
    radius: 8
    border.color: themeColors.primaryColor
    border.width: 1

    Component.onCompleted: {
        updateProfileData()
    }

    function updateProfileData() {
        avatarSource = ProfileManager.avatar || "qrc:/icons/icon_standard.webp"
        coverSource = ProfileManager.cover || ""
    }

    Connections {
        target: ProfileManager
        function onAvatarChanged() {
            avatarSource = ProfileManager.avatar || "qrc:/icons/icon_standard.webp"
        }
        function onCoverChanged() {
            coverSource = ProfileManager.cover || ""
        }
        function onFullProfileChanged() {
            updateProfileData()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 1
        spacing: 0

        // БЛОК 1: Аватарка и фон
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: containerHeight

            // Cover image (фон)
            Rectangle {
                id: coverContainer
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }
                color: themeColors.secondaryColor
                clip: true
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        width: coverContainer.width
                        height: coverContainer.height
                        topLeftRadius: 8
                        topRightRadius: 8
                        bottomLeftRadius: 0
                        bottomRightRadius: 0
                    }
                }

                Image {
                    id: coverImage
                    anchors.fill: parent
                    source: coverSource
                    fillMode: Image.PreserveAspectCrop
                    visible: coverSource !== ""
                }

                // Градиент поверх фона для лучшей читаемости
                LinearGradient {
                    anchors.fill: parent
                    start: Qt.point(0, 0)
                    end: Qt.point(0, height)
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Qt.rgba(0,0,0,0.3) }
                        GradientStop { position: 0.7; color: "transparent" }
                        GradientStop { position: 1.0; color: Qt.rgba(0,0,0,0.1) }
                    }
                }

                // Иконка редактирования фона
                Rectangle {
                    visible: isEditMode
                    anchors.fill: parent
                    color: Qt.rgba(0,0,0,0.3)
                    radius: coverContainer.radius

                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/icons/edit_white.svg"
                        sourceSize: Qt.size(32, 32)
                        width: 32
                        height: 32
                    }
                }
            }

            MouseArea {
                anchors.fill: coverContainer
                enabled: isEditMode
                onClicked: coverDialog.open()
            }

            // Аватарка по центру
            Rectangle {
                id: avatarContainer
                width: Math.min(parent.width * 0.4, 140) // Ограничиваем максимальный размер
                height: width // Квадратная аватарка
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: -height * 0.3 // Плавное позиционирование
                radius: 1000
                color: "transparent"
                clip: true

                Image {
                    id: avatarimages
                    anchors.fill: parent
                    source: avatarSource
                    fillMode: Image.PreserveAspectCrop
                    smooth: true
                    mipmap: true

                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Rectangle {
                            width: avatarimages.width
                            height: avatarimages.height
                            radius: 1000
                            color: "white"
                        }
                    }
                }

                // Рамка поверх изображения
                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: "transparent"
                    border.color: themeColors.primaryColor
                    border.width: 3
                }

                // Иконка редактирования в режиме isEditMode
                Rectangle {
                    visible: isEditMode
                    anchors.fill: parent
                    color: Qt.rgba(0,0,0,0.5)
                    radius: parent.radius

                    Image {
                        anchors.centerIn: parent
                        source: "qrc:/icons/edit_white.svg"
                        sourceSize: Qt.size(24, 24)
                        width: 24
                        height: 24
                    }
                }
            }

            MouseArea {
                anchors.fill: avatarContainer
                enabled: isEditMode
                onClicked: fileDialog.open()
            }
        }

        // БЛОК 2: Информация профиля
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 20
            Layout.topMargin: 40 // Уменьшен отступ
            spacing: 10

            // Основная информация профиля - по центру
            Column {
                Layout.fillWidth: true
                spacing: 6

                Text {
                    text: ProfileManager.userName || "Новый пользователь"
                    font.bold: true
                    font.pointSize: 18
                    color: themeColors.textColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width
                    wrapMode: Text.Wrap
                    maximumLineCount: 2
                    elide: Text.ElideRight
                }

                Text {
                    text: ProfileManager.userRole || "Студент"
                    font.pointSize: 14
                    color: themeColors.secondaryTextColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width
                    wrapMode: Text.Wrap
                }
            }

            Item { Layout.fillHeight: true }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Выберите изображение аватара"
        nameFilters: ["Изображения (*.png *.jpg *.jpeg *.gif *.bmp *.webp)"]
        onAccepted: {
            console.log("Выбран файл аватара:", selectedFile)
            ProfileManager.setAvatar(selectedFile.toString())
        }
        onRejected: {
            console.log("Диалог выбора аватара отменен")
        }
    }

    FileDialog {
        id: coverDialog
        title: "Выберите фоновое изображение"
        nameFilters: ["Изображения (*.png *.jpg *.jpeg *.gif *.bmp *.webp)"]
        onAccepted: {
            console.log("Выбран файл фона:", selectedFile)
            ProfileManager.setCover(selectedFile.toString())
        }
        onRejected: {
            console.log("Диалог выбора фона отменен")
        }
    }

    function getLocation() {
        var profile = ProfileManager.fullProfile
        if (profile && profile.profile && profile.profile.location) {
            return profile.profile.location
        }
        return ""
    }

    function hasAdditionalInfo() {
        var profile = ProfileManager.fullProfile
        return profile && profile.information && profile.information.length > 0
    }

    function getAdditionalInfo() {
        var profile = ProfileManager.fullProfile
        if (profile && profile.information) {
            return profile.information
        }
        return []
    }
}
