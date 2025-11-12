// ColorButton.qml
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    // Входное свойство — НЕ "color", а своё
    property color buttonColor: "#0078d4"

    // Визуальный цвет — берём из buttonColor
    color: buttonColor

    implicitWidth: 40
    implicitHeight: 40
    radius: 6
    border.color: container.primaryColor === buttonColor ? buttonColor : borderColor
    border.width: container.primaryColor === buttonColor ? 3 : 1

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            container.primaryColor = buttonColor
            container.hexInput.text = buttonColor
        }
    }
}
