import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt5Compat.GraphicalEffects

Rectangle {
    id: root
    property var themeColors: ThemeManager.currentThemeColors
    property bool isEditMode: false
    property var information: []  // ДОБАВЛЕНО: свойство для получения информации извне

    color: themeColors.backgroundColor
    radius: 8
    border.color: themeColors.primaryColor
    border.width: 1

    function updateInformationModel() {
        informationModel.clear()
        // ИСПРАВЛЕНИЕ: Используем переданное свойство information или данные из ProfileManager
        var informationList = information.length > 0 ? information : (ProfileManager.fullProfile.information || [])
        console.log("🔄 Updating information model. Data:", JSON.stringify(informationList));

        for (var i = 0; i < informationList.length; i++) {
            var item = informationList[i]
            // Поддержка разных форматов данных
            if (item && typeof item === 'object') {
                informationModel.append({
                    label: item.label || item.title || "",
                    value: item.value || item.content || "",
                    isPublic: item.isPublic !== undefined ? item.isPublic : true,
                    id: item.id || i
                })
            }
        }
        console.log("✅ Information model updated. Items:", informationModel.count);
    }

    ListModel {
        id: informationModel
    }

    Component.onCompleted: {
        console.log("🏁 InformationBlock created. isEditMode:", isEditMode);
        updateInformationModel()
    }

    // ДОБАВЛЕНО: обновление при изменении свойства information
    onInformationChanged: {
        console.log("📬 Information property changed:", JSON.stringify(information));
        updateInformationModel()
    }

    // ИСПРАВЛЕНИЕ: Обновляем всегда, но в режиме просмотра используем переданные данные
    Connections {
        target: ProfileManager
        function onFullProfileChanged() {
            console.log("👤 Profile changed, updating information");
            updateInformationModel()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 10

        Text {
            text: "Личная информация"
            font.bold: true
            font.pointSize: 16
            color: themeColors.textColor
            Layout.fillWidth: true
        }

        Text {
            id: noInformationText
            text: "Информация отсутствует"
            font.pointSize: 14
            color: themeColors.secondaryTextColor
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter
            visible: informationModel.count === 0 && !isEditMode
        }

        ScrollView {
            id: scrollView
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: informationModel.count > 0 || isEditMode
            clip: true

            ColumnLayout {
                id: informationColumn
                width: scrollView.availableWidth
                spacing: 8

                Repeater {
                    model: informationModel

                    delegate: Rectangle {
                        id: infoDelegate
                        Layout.fillWidth: true
                        height: 60
                        color: "transparent"
                        radius: 4

                        RowLayout {
                            anchors.fill: parent
                            spacing: 10

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                Text {
                                    text: model.label || "Без названия"
                                    font.pointSize: 12
                                    color: themeColors.secondaryTextColor
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }

                                Text {
                                    text: model.value || "Не указано"
                                    font.pointSize: 14
                                    font.bold: true
                                    color: themeColors.textColor
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                    wrapMode: Text.Wrap
                                    maximumLineCount: 2
                                }
                            }

                            Button {
                                Layout.preferredWidth: 30
                                Layout.preferredHeight: 30
                                ToolTip.text: "Редактировать информацию"
                                visible: isEditMode
                                onClicked: {
                                    editDialog.infoIndex = index
                                    editLabelField.text = model.label || ""
                                    editValueField.text = model.value || ""
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
                                ToolTip.text: "Удалить информацию"
                                visible: isEditMode
                                onClicked: {
                                    deleteConfirmation.infoIndex = index
                                    deleteConfirmation.infoLabel = model.label || "эту запись"
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
                            visible: index < informationModel.count - 1
                        }
                    }
                }
            }
        }

        Button {
            Layout.alignment: Qt.AlignHCenter
            text: "+ Добавить информацию"
            visible: isEditMode
            onClicked: {
                addLabelField.text = ""
                addValueField.text = ""
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

        // Диалог добавления информации
        Dialog {
            id: addDialog
            title: "Добавить информацию"
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
                    text: "Название:"
                    color: themeColors.textColor
                }

                TextField {
                    id: addLabelField
                    placeholderText: "Введите название (например: Должность)"
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
                    id: addValueField
                    placeholderText: "Введите значение"
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
                        enabled: addLabelField.text.trim() !== "" && addValueField.text.trim() !== ""
                        onClicked: {
                            console.log("➕ Adding information:", addLabelField.text.trim(), addValueField.text.trim())
                            ProfileManager.addInformation(addLabelField.text.trim(), addValueField.text.trim(), true)
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

        // Диалог редактирования информации
        Dialog {
            id: editDialog
            title: "Редактировать информацию"
            anchors.centerIn: Overlay.overlay
            width: 400
            height: 200
            modal: true
            property int infoIndex: -1

            background: Rectangle {
                color: themeColors.backgroundColor
                radius: 8
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 10

                Text {
                    text: "Название:"
                    color: themeColors.textColor
                }

                TextField {
                    id: editLabelField
                    placeholderText: "Введите название"
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
                    id: editValueField
                    placeholderText: "Введите значение"
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
                        enabled: editLabelField.text.trim() !== "" && editValueField.text.trim() !== ""
                        onClicked: {
                            console.log("💾 Saving edited information at index:", editDialog.infoIndex)
                            if (editDialog.infoIndex >= 0) {
                                // Получаем текущий список информации
                                var currentInfo = ProfileManager.fullProfile.information || []
                                if (editDialog.infoIndex < currentInfo.length) {
                                    var oldInfo = currentInfo[editDialog.infoIndex]
                                    // Удаляем старую запись и добавляем новую
                                    ProfileManager.removeInformation(editDialog.infoIndex)
                                    ProfileManager.addInformation(
                                        editLabelField.text.trim(),
                                        editValueField.text.trim(),
                                        oldInfo.isPublic !== undefined ? oldInfo.isPublic : true
                                    )
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
            property int infoIndex: -1
            property string infoLabel: ""

            background: Rectangle {
                color: themeColors.backgroundColor
                radius: 8
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 10

                Text {
                    text: `Вы уверены, что хотите удалить "${deleteConfirmation.infoLabel}"?`
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
                            console.log("🗑️ Deleting information at index:", deleteConfirmation.infoIndex)
                            if (deleteConfirmation.infoIndex >= 0) {
                                ProfileManager.removeInformation(deleteConfirmation.infoIndex)
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
