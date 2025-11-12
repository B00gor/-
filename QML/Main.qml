import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

ApplicationWindow {
    id: window
    visible: true
    property var themeColors: ThemeManager.currentThemeColors

    background: Rectangle {
        color: themeColors.backgroundColor

        LinearGradient {
            anchors.fill: parent
            start: Qt.point(0, 0)
            end: Qt.point(parent.width, parent.height) // вертикальный градиент (сверху вниз)

            gradient: Gradient {
                GradientStop { position: 0.0; color: themeColors.backgroundColor }
                GradientStop { position: 0.3; color: Qt.lighter(themeColors.backgroundColor, 1.05) }
                GradientStop { position: 0.7; color: Qt.lighter(themeColors.backgroundColor, 1.15) }
                GradientStop { position: 1.0; color: Qt.lighter(themeColors.backgroundColor, 1.3) }
            }
        }
    }
    StackView {
        id: pagePanel
        anchors.fill: parent
        initialItem: AuthPage {}
    }
}
