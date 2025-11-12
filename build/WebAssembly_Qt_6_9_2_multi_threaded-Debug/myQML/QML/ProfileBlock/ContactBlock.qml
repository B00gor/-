import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt5Compat.GraphicalEffects

Rectangle {
    id: root
    property var themeColors: ThemeManager.currentThemeColors
    property bool isEditMode: false
    property var contacts: []  // ДОБАВЛЕНО: свойство для получения контактов извне

    color: themeColors.backgroundColor
    radius: 8
    border.color: themeColors.primaryColor
    border.width: 1

    function updateContactsModel() {
        contactsModel.clear()
        var contactsList = contacts.length > 0 ? contacts : (ProfileManager.fullProfile.contacts || [])
        for (var i = 0; i < contactsList.length; i++) {
            contactsModel.append({
                label: contactsList[i].type || "",
                url: contactsList[i].value || "",
                icon: contactsList[i].icon || "",
                isPublic: contactsList[i].isPublic || true
            })
        }
    }

    ListModel {
        id: contactsModel
    }

    Component.onCompleted: {
        updateContactsModel()
    }

    // ДОБАВЛЕНО: обновление при изменении свойства contacts
    onContactsChanged: {
        updateContactsModel()
    }

    Connections {
        target: ProfileManager
        function onFullProfileChanged() {
            if (!isEditMode) return; // Обновляем только в режиме редактирования
            updateContactsModel()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 10

        Text {
            text: "Контакты"
            font.bold: true
            font.pointSize: 16
            color: themeColors.textColor
            Layout.fillWidth: true
        }

        ScrollView {
            id: scrollView
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                id: contactsColumn
                width: scrollView.availableWidth
                spacing: 8

                Repeater {
                    model: contactsModel

                    delegate: Rectangle {
                        id: contactDelegate
                        Layout.fillWidth: true
                        height: 50
                        color: "transparent"
                        radius: 4

                        RowLayout {
                            anchors.fill: parent
                            spacing: 10

                            Image {
                                id: contactImage
                                Layout.preferredWidth: 30
                                Layout.preferredHeight: 30
                                source: icon === "" ? "qrc:/icons/fail_icon.webp" : icon
                                fillMode: Image.PreserveAspectCrop
                                asynchronous: true
                                cache: true

                                layer.enabled: true
                                layer.effect: OpacityMask {
                                    maskSource: Rectangle {
                                        width: contactImage.width
                                        height: contactImage.height
                                        radius: width / 2
                                        color: "white"
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    enabled: isEditMode
                                    onClicked: {
                                        fileDialog.contactIndex = index
                                        fileDialog.open()
                                    }
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                Text {
                                    text: label
                                    font.pointSize: 12
                                    color: themeColors.primaryColor
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: Qt.openUrlExternally(url)
                                    }
                                }

                                Text {
                                    text: url
                                    font.pointSize: 10
                                    color: themeColors.secondaryTextColor
                                    Layout.fillWidth: true
                                    elide: Text.ElideMiddle
                                }
                            }

                            Button {
                                Layout.preferredWidth: 30
                                Layout.preferredHeight: 30
                                ToolTip.text: "Редактировать контакт"
                                visible: isEditMode
                                onClicked: {
                                    editDialog.contactIndex = index
                                    editLabelField.text = label
                                    editUrlField.text = url
                                    editDialog.open()
                                }
                                background: Rectangle {
                                    color: themeColors.primaryColor
                                    radius: 4
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
                            }

                            Button {
                                Layout.preferredWidth: 30
                                Layout.preferredHeight: 30
                                ToolTip.text: "Удалить контакт"
                                visible: isEditMode
                                onClicked: {
                                    deleteConfirmation.contactIndex = index
                                    deleteConfirmation.open()
                                }
                                background: Rectangle {
                                    color: "#ff4757"
                                    radius: 4
                                }
                                contentItem: Image {
                                    anchors.centerIn: parent
                                    source: "qrc:/icons/delete-icon.webp"
                                    width: 30
                                    height: 30
                                    layer.enabled: true
                                    layer.effect: ColorOverlay {
                                        color: themeColors.textColor
                                    }
                                }
                            }
                        }

                        Rectangle {
                            anchors.bottom: parent.bottom
                            width: parent.width
                            height: 1
                            color: themeColors.borderColor
                            visible: index < contactsModel.count - 1
                        }
                    }
                }
            }
        }

        Button {
            Layout.alignment: Qt.AlignHCenter
            text: "+ Добавить контакт"
            visible: isEditMode
            onClicked: {
                addLabelField.text = ""
                addUrlField.text = ""
                addDialog.open()
            }
            background: Rectangle {
                color: themeColors.primaryColor
                radius: 4
            }
            contentItem: Text {
                text: parent.text
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        // ... остальные диалоги остаются без изменений
        FileDialog {
            id: fileDialog
            property int contactIndex: -1
            title: "Выберите значок"
            nameFilters: ["Изображения (*.png *.jpg *.jpeg *.gif *.bmp *.webp)"]
            onAccepted: {
                if (contactIndex >= 0) {
                    var selectedFile = fileDialog.selectedFile
                    console.log("Selected file:", selectedFile)

                    var contacts = ProfileManager.fullProfile.contacts || []
                    if (contactIndex < contacts.length) {
                        var contact = contacts[contactIndex]
                        ProfileManager.removeContact(contactIndex)
                        ProfileManager.addContact(contact.type, contact.value, contact.isPublic || true, selectedFile)
                    }
                }
            }
        }

        // Диалог добавления контакта
        Dialog {
            id: addDialog
            title: "Добавить контакт"
            anchors.centerIn: Overlay.overlay
            width: 400
            height: 200
            modal: true

            background: Rectangle {
                color: themeColors.backgroundColor
                radius: 8
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 10

                Text {
                    text: "Тип контакта:"
                    color: themeColors.textColor
                }

                TextField {
                    id: addLabelField
                    placeholderText: "Например: Telegram, Email"
                    Layout.fillWidth: true
                    background: Rectangle {
                        color: themeColors.surfaceColor
                        radius: 4
                        border.color: themeColors.borderColor
                        border.width: 1
                    }
                }

                Text {
                    text: "Значение:"
                    color: themeColors.textColor
                }

                TextField {
                    id: addUrlField
                    placeholderText: "Введите контактные данные"
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
                        onClicked: addDialog.close()
                        background: Rectangle {
                            color: themeColors.surfaceColor
                            radius: 4
                        }
                    }

                    Button {
                        text: "Добавить"
                        Layout.fillWidth: true
                        enabled: addLabelField.text.trim() !== "" && addUrlField.text.trim() !== ""
                        onClicked: {
                            ProfileManager.addContact(addLabelField.text.trim(), addUrlField.text.trim(), true)
                            addDialog.close()
                        }
                        background: Rectangle {
                            color: enabled ? themeColors.primaryColor : "#cccccc"
                            radius: 4
                        }
                        contentItem: Text {
                            text: parent.text
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }
            }
        }

        // Диалог редактирования контакта
        Dialog {
            id: editDialog
            title: "Редактировать контакт"
            anchors.centerIn: Overlay.overlay
            width: 400
            height: 200
            modal: true
            property int contactIndex: -1

            background: Rectangle {
                color: themeColors.backgroundColor
                radius: 8
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 10

                Text {
                    text: "Тип контакта:"
                    color: themeColors.textColor
                }

                TextField {
                    id: editLabelField
                    placeholderText: "Например: Telegram, Email"
                    Layout.fillWidth: true
                    background: Rectangle {
                        color: themeColors.surfaceColor
                        radius: 4
                        border.color: themeColors.borderColor
                        border.width: 1
                    }
                }

                Text {
                    text: "Значение:"
                    color: themeColors.textColor
                }

                TextField {
                    id: editUrlField
                    placeholderText: "Введите контактные данные"
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
                        onClicked: editDialog.close()
                        background: Rectangle {
                            color: themeColors.surfaceColor
                            radius: 4
                        }
                    }

                    Button {
                        text: "Сохранить"
                        Layout.fillWidth: true
                        enabled: editLabelField.text.trim() !== "" && editUrlField.text.trim() !== ""
                        onClicked: {
                            if (editDialog.contactIndex >= 0) {
                                var contacts = ProfileManager.fullProfile.contacts || []
                                if (editDialog.contactIndex < contacts.length) {
                                    var contact = contacts[editDialog.contactIndex]
                                    ProfileManager.removeContact(editDialog.contactIndex)
                                    ProfileManager.addContact(editLabelField.text.trim(), editUrlField.text.trim(), contact.isPublic || true)
                                }
                                editDialog.close()
                            }
                        }
                        background: Rectangle {
                            color: enabled ? themeColors.primaryColor : "#cccccc"
                            radius: 4
                        }
                        contentItem: Text {
                            text: parent.text
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }
            }
        }

        // Диалог подтверждения удаления
        Dialog {
            id: deleteConfirmation
            title: "Подтверждение удаления"
            anchors.centerIn: Overlay.overlay
            width: 300
            height: 150
            modal: true
            property int contactIndex: -1

            background: Rectangle {
                color: themeColors.backgroundColor
                radius: 8
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 10

                Text {
                    text: "Вы уверены, что хотите удалить этот контакт?"
                    color: themeColors.textColor
                    Layout.fillWidth: true
                    wrapMode: Text.Wrap
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Button {
                        text: "Отмена"
                        Layout.fillWidth: true
                        onClicked: deleteConfirmation.close()
                        background: Rectangle {
                            color: themeColors.surfaceColor
                            radius: 4
                        }
                    }

                    Button {
                        text: "Удалить"
                        Layout.fillWidth: true
                        onClicked: {
                            if (deleteConfirmation.contactIndex >= 0) {
                                ProfileManager.removeContact(deleteConfirmation.contactIndex)
                                deleteConfirmation.close()
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
                        }
                    }
                }
            }
        }
    }
}
