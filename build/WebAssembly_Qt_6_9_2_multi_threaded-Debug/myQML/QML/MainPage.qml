import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Page {
    id: root
    property bool sidebarVisible: true
    property bool popupVisible: false

    property var navigationHistory: []
    property int currentHistoryIndex: -1

    // Используем привязку к текущим цветам темы
    property var themeColors: ThemeManager.currentThemeColors

    // Общее свойство для активного индекса меню
    property int currentMenuIndex: 0

    // Единый StackView для всего контента
    property string currentPage: "MainSearchPage.qml"
    property var currentProperties: ({})

    // Функция для установки активного элемента в боковой панели
    function setActiveMenuItem(page) {
        for (var i = 0; i < sideMenuModel.count; i++) {
            if (sideMenuModel.get(i).page === page) {
                currentMenuIndex = i;
                console.log("Active menu item set to:", page, "index:", i);
                break;
            }
        }
    }
    background: Rectangle {
        color: "transparent"// Добавьте эту строку
    }

    // Функция для навигации
    function navigateTo(page, properties) {
        currentPage = page;
        currentProperties = properties || {};
        setActiveMenuItem(page);
    }

    ListModel {
        id: sideMenuModel
        ListElement {
            title: "Главная"
            icon: "qrc:/icons/home-house.webp"
            page: "MainSearchPage.qml"
            category: "main"
        }
        ListElement {
            title: "Профиль"
            icon: "qrc:/icons/profile-icon.webp"
            page: "ProfilePage.qml"
            category: "user"
        }
        ListElement {
            title: "Настройки"
            icon: "qrc:/icons/settings_panel_icon.webp"
            page: "SettingsPage.qml"
            category: "setting"
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Верхняя панель (остается без изменений)
               Rectangle {
                   id: header
                   Layout.fillWidth: true
                   height: 60
                   color: themeColors.backgroundColor
                   z: 10

                   Rectangle {
                       anchors.bottom: parent.bottom
                       width: parent.width
                       height: 2
                       color: themeColors.primaryColor
                   }

                   RowLayout {
                       anchors.fill: parent
                       anchors.leftMargin: 10
                       anchors.rightMargin: 10
                       spacing: 15

                       // Кнопка переключения боковой панели
                       Button {
                           id: sidebarToggleButton
                           Layout.alignment: Qt.AlignVCenter
                           Layout.preferredWidth: 40
                           Layout.preferredHeight: 40
                           background: Rectangle {
                               color: "transparent"
                           }
                           contentItem: Image {
                               anchors.centerIn: parent
                               source: sidebarVisible ? "qrc:/icons/left_icon.webp" : "qrc:/icons/right_icon.webp"
                               width: 20
                               height: 20
                               layer.enabled: true
                               layer.effect: ColorOverlay {
                                   color: themeColors.textColor
                               }
                           }
                           onClicked: {
                               sidebarVisible = !sidebarVisible
                               console.log("Sidebar toggled:", sidebarVisible)
                           }
                       }

                       // Распорка для центрирования поиска
                       Item {
                           Layout.fillWidth: true
                       }

                       RowLayout {
                           Layout.alignment: Qt.AlignVCenter
                           Layout.maximumWidth: 500
                           Layout.preferredWidth: 400
                           spacing: -2

                           TextField {
                               id: searchField
                               Layout.fillWidth: true
                               Layout.preferredHeight: 32
                               font.pointSize: 14
                               placeholderText: "Поиск..."
                               placeholderTextColor: "#808080"
                               color: themeColors.textColor
                               background: Rectangle {
                                   topLeftRadius: 8
                                   bottomLeftRadius: 8
                                   topRightRadius: 0
                                   bottomRightRadius: 0
                                   border.color: themeColors.primaryColor
                                   border.width: 2
                                   color: themeColors.backgroundColor
                               }
                           }

                           Button {
                               Layout.preferredHeight: 32
                               Layout.preferredWidth: 32
                               background: Rectangle {
                                   topLeftRadius: 0
                                   bottomLeftRadius: 0
                                   topRightRadius: 8
                                   bottomRightRadius: 8
                                   border.color: themeColors.primaryColor
                                   border.width: 2
                                   color: themeColors.backgroundColor
                               }
                               contentItem: Image {
                                   anchors.centerIn: parent
                                   source: "qrc:/icons/search-icon.webp"
                                   width: 16
                                   height: 16
                                   layer.enabled: true
                                   layer.effect: ColorOverlay {
                                       color: themeColors.textColor
                                   }
                               }
                               onClicked: {
                                   console.log("Search clicked:", searchField.text)
                               }
                           }
                       }

                       // Распорка для выравнивания правой части
                       Item {
                           Layout.fillWidth: true
                       }

                       // Правая часть с кнопками навигации и профиля
                       RowLayout {
                           Layout.alignment: Qt.AlignVCenter
                           spacing: 10

                           // Кнопки навигации
                           Button {
                               id: backButton
                               Layout.preferredWidth: 32
                               Layout.preferredHeight: 32
                               background: Rectangle {
                                   color: "transparent"
                               }
                               contentItem: Image {
                                   anchors.centerIn: parent
                                   source: "qrc:/icons/back_icon.webp"
                                   width: 16
                                   height: 16
                                   layer.enabled: true
                                   layer.effect: ColorOverlay {
                                       color: themeColors.textColor
                                   }
                               }
                               enabled: navHistory.canGoBack
                               onClicked: {
                                   console.log("Back button clicked")
                                   navHistory.goBack()
                               }
                           }

                           Button {
                               id: forwardButton
                               Layout.preferredWidth: 32
                               Layout.preferredHeight: 32
                               background: Rectangle {
                                   color: "transparent"
                               }
                               contentItem: Image {
                                   anchors.centerIn: parent
                                   source: "qrc:/icons/forward.webp"
                                   width: 16
                                   height: 16
                                   layer.enabled: true
                                   layer.effect: ColorOverlay {
                                       color: themeColors.textColor
                                   }
                               }
                               enabled: navHistory.canGoForward
                               onClicked: {
                                   console.log("Forward button clicked")
                                   navHistory.goForward()
                               }
                           }

                           // Кнопка профиля
                           Button {
                               id: profileButton
                               Layout.preferredWidth: 40
                               Layout.preferredHeight: 40
                               background: Rectangle {
                                   color: "transparent"
                               }
                               contentItem: Image {
                                   anchors.centerIn: parent
                                   source: "qrc:/icons/profile-icon.webp"
                                   width: 20
                                   height: 20
                                   layer.enabled: true
                                   layer.effect: ColorOverlay {
                                       color: themeColors.textColor
                                   }
                               }
                               onClicked: {
                                   console.log("Profile button clicked")
                                   popupVisible = !popupVisible
                               }
                           }
                       }
                   }

                   // Выпадающее меню профиля
                   Rectangle {
                       id: dropdownPopup
                       visible: popupVisible
                       width: 150
                       height: contentColumn.height + 20
                       x: root.width - 160
                       y: 70
                       z: 1000
                       radius: 8
                       border.color: themeColors.primaryColor
                       border.width: 1
                       color: themeColors.cardColor

                       layer.enabled: true
                       layer.effect: DropShadow {
                           transparentBorder: true
                           color: "#80000000"
                           radius: 10
                           samples: 16
                           verticalOffset: 2
                       }

                       Column {
                           id: contentColumn
                           anchors {
                               top: parent.top
                               left: parent.left
                               right: parent.right
                               margins: 10
                           }
                           spacing: 8

                           Button {
                               width: parent.width
                               background: Rectangle {
                                   color: "transparent"
                                   radius: 4
                               }
                               contentItem: Text {
                                   text: "Профиль"
                                   font.pixelSize: 14
                                   color: themeColors.textColor
                                   horizontalAlignment: Text.AlignLeft
                               }
                               onClicked: {
                                   console.log("Profile menu clicked")
                                   popupVisible = false
                                   setActiveMenuItem("ProfilePage.qml")
                                   navHistory.push("ProfilePage.qml")
                               }
                           }

                           Rectangle {
                               width: parent.width
                               height: 1
                               color: themeColors.borderColor
                           }

                           Button {
                               width: parent.width
                               background: Rectangle {
                                   color: "transparent"
                                   radius: 4
                               }
                               contentItem: Text {
                                   text: "Настройки"
                                   font.pixelSize: 14
                                   color: themeColors.textColor
                                   horizontalAlignment: Text.AlignLeft
                               }
                               onClicked: {
                                   console.log("Settings menu clicked")
                                   popupVisible = false
                                   setActiveMenuItem("SettingsPage.qml")
                                   navHistory.push("SettingsPage.qml")
                               }
                           }

                           Rectangle {
                               width: parent.width
                               height: 1
                               color: themeColors.borderColor
                           }

                           Button {
                               width: parent.width
                               background: Rectangle {
                                   color: "transparent"
                                   radius: 4
                               }
                               contentItem: Text {
                                   text: "Выйти"
                                   font.pixelSize: 14
                                   color: "#e74c3c"
                                   horizontalAlignment: Text.AlignLeft
                               }
                               onClicked: {
                                   console.log("Logout clicked")
                                   popupVisible = false
                                   // Убедитесь, что pagePanel существует
                                   if (typeof pagePanel !== "undefined") {
                                       pagePanel.push("AuthPage.qml")
                                   }
                               }
                           }
                       }
                   }

                   // Оверлей для закрытия попапа
                   MouseArea {
                       id: overlay
                       visible: popupVisible
                       anchors.fill: parent
                       z: 999
                       onClicked: {
                           console.log("Overlay clicked")
                           popupVisible = false
                       }
                   }
               }


        // Основной контент - используем ColumnLayout при ширине меньше 600, иначе RowLayout
        Loader {
            id: contentLayoutLoader
            Layout.fillWidth: true
            Layout.fillHeight: true
            sourceComponent: root.width < 600 ? columnLayoutComponent : rowLayoutComponent

            onLoaded: {
                // При загрузке нового layout обновляем страницу
                if (item && item.stackView) {
                    item.stackView.replace(currentPage, currentProperties);
                }
            }
        }
    }

    // Компонент для ColumnLayout (мобильная версия)
    Component {
        id: columnLayoutComponent
        ColumnLayout {
            spacing: 0
            property alias stackView: contentStackViewMobile

            // Основной контент
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "transparent"
                Layout.rightMargin: 10
                Layout.leftMargin: 10
                Layout.topMargin: 10
                clip: true

                StackView {
                    id: contentStackViewMobile
                    anchors.fill: parent

                    replaceEnter: Transition {
                        PropertyAnimation {
                            property: "x"
                            from: (ViewTransition.index % 2 === 0) ? contentStackViewMobile.width : -contentStackViewMobile.width
                            to: 0
                            duration: 300
                            easing.type: Easing.OutCubic
                        }
                    }

                    replaceExit: Transition {
                        PropertyAnimation {
                            property: "x"
                            from: 0
                            to: (ViewTransition.index % 2 === 0) ? -contentStackViewMobile.width : contentStackViewMobile.width
                            duration: 300
                            easing.type: Easing.OutCubic
                        }
                    }

                    Connections {
                        target: navHistory
                        function onCurrentPageChanged(page, direction, properties) {
                            console.log("Mobile Navigation to:", page, "with properties:", properties);
                            if (page !== "") {
                                root.navigateTo(page, properties);
                                contentStackViewMobile.replace(page, properties,
                                    direction === 1 ? StackView.PushTransition : StackView.PopTransition);
                            }
                        }
                    }

                    Component.onCompleted: {
                        navHistory.initialize("MainSearchPage.qml")
                        if (contentStackViewMobile.depth === 0) {
                            contentStackViewMobile.replace(root.currentPage, root.currentProperties);
                        }
                    }
                }
            }

            // Боковая панель в виде горизонтальной панели (внизу)
            Rectangle {
                id: mobileSidebar
                Layout.fillWidth: true
                height: sidebarVisible ? 60 : 0
                visible: sidebarVisible
                color: "transparent"
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                Layout.bottomMargin: 10
                clip: true

                Rectangle {
                    anchors.fill: parent
                    radius: 12
                    border.color: themeColors.primaryColor
                    border.width: 2
                    color: themeColors.backgroundColor

                    ListView {
                        id: mobileMenuListView
                        anchors.fill: parent
                        orientation: ListView.Horizontal
                        model: sideMenuModel
                        currentIndex: root.currentMenuIndex

                        delegate: Rectangle {
                            width: mobileMenuListView.width / sideMenuModel.count
                            height: mobileMenuListView.height
                            color: mobileMenuListView.currentIndex === index ? themeColors.primaryColor : "transparent"
                            radius: 8
                            clip: true

                            Column {
                                anchors.centerIn: parent
                                spacing: 2

                                Image {
                                    width: 25
                                    height: 25
                                    source: model.icon
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    layer.enabled: true
                                    layer.effect: ColorOverlay {
                                        color: mobileMenuListView.currentIndex === index ? "white" : themeColors.textColor
                                    }
                                }

                                Text {
                                    text: model.title
                                    color: mobileMenuListView.currentIndex === index ? "white" : themeColors.textColor
                                    font.pixelSize: 10
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    console.log("Mobile menu item clicked:", model.page)
                                    root.currentMenuIndex = index
                                    navHistory.push(model.page)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Компонент для RowLayout (десктопная версия)
    Component {
        id: rowLayoutComponent
        RowLayout {
            spacing: 0
            property alias stackView: contentStackViewDesktop

            // Боковая панель
            Rectangle {
                id: desktopSidebar
                Layout.preferredWidth: sidebarVisible
                    ? (parent.width * 0.15 >= 140 ? parent.width * 0.15 : 65)
                    : 0
                Layout.fillHeight: true
                visible: sidebarVisible
                color: "transparent"
                Layout.topMargin: 10
                Layout.leftMargin: 10
                Layout.bottomMargin: 10
                clip: true

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 10

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 12
                        border.color: themeColors.primaryColor
                        border.width: 2
                        color: themeColors.backgroundColor

                        ListView {
                            id: desktopMenuListView
                            anchors.fill: parent
                            model: sideMenuModel
                            currentIndex: root.currentMenuIndex

                            delegate: Rectangle {
                                width: desktopMenuListView.width
                                height: 55
                                color: desktopMenuListView.currentIndex === index ? themeColors.primaryColor : "transparent"
                                radius: 8
                                clip: true

                                Row {
                                    anchors.fill: parent
                                    anchors.leftMargin: 15
                                    spacing: 12

                                    Image {
                                        width: 35
                                        height: 35
                                        source: model.icon
                                        anchors.verticalCenter: parent.verticalCenter
                                        layer.enabled: true
                                        layer.effect: ColorOverlay {
                                            color: desktopMenuListView.currentIndex === index ? "white" : themeColors.textColor
                                        }
                                    }

                                    Text {
                                        text: desktopSidebar.width >= 120 ? model.title : ""
                                        color: desktopMenuListView.currentIndex === index ? "white" : themeColors.textColor
                                        font.pixelSize: 14
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        console.log("Desktop menu item clicked:", model.page)
                                        root.currentMenuIndex = index
                                        navHistory.push(model.page)
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Основной контент
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "transparent"
                Layout.rightMargin: 10
                Layout.topMargin: 10
                Layout.leftMargin: 10
                clip: true

                StackView {
                    id: contentStackViewDesktop
                    anchors.fill: parent

                    replaceEnter: Transition {
                        PropertyAnimation {
                            property: "x"
                            from: root.isMobile ? -contentStackViewDesktop.width : contentStackViewDesktop.width
                            to: 0
                            duration: 300
                            easing.type: Easing.OutCubic
                        }
                    }
                    replaceExit: Transition {
                        PropertyAnimation {
                            property: "x"
                            from: 0
                            to: root.isMobile ? contentStackViewDesktop.width : -contentStackViewDesktop.width
                            duration: 300
                            easing.type: Easing.OutCubic
                        }
                    }


                    Connections {
                        target: navHistory
                        function onCurrentPageChanged(page, direction, properties) {
                            console.log("Desktop Navigation to:", page, "with properties:", properties);
                            if (page !== "") {
                                root.navigateTo(page, properties);
                                contentStackViewDesktop.replace(page, properties,
                                    direction === 1 ? StackView.PushTransition : StackView.PopTransition);
                            }
                        }
                    }

                    Component.onCompleted: {
                        navHistory.initialize("MainSearchPage.qml")
                        if (contentStackViewDesktop.depth === 0) {
                            contentStackViewDesktop.replace(root.currentPage, root.currentProperties);
                        }
                    }
                }
            }
        }
    }

    // Обработчик изменения ширины - сохраняем состояние
    onWidthChanged: {
        console.log("Width changed to:", width, "current page:", currentPage, "properties:", currentProperties);
    }

    // Инициализация при создании компонента
    Component.onCompleted: {
        console.log("Main page component created")
        // Убедитесь, что navHistory инициализирован
        if (typeof navHistory !== "undefined") {
            navHistory.initialize("MainSearchPage.qml")
            setActiveMenuItem("MainSearchPage.qml")
        }
    }
}
