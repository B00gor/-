import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt5Compat.GraphicalEffects
import "./ProfileBlock"

Item {
    id: profileChannel

    property var themeColors: ThemeManager.currentThemeColors
    property real headerHeight: 300
    property real containerHeight: headerHeight + 200

    // Параметры для чужого канала
    property string userId: ""
    property string userName: ""
    property bool isOtherUserChannel: userId !== ""

    // Данные канала
    property var channelData: ({})
    property var channelCourses: ([])

    // Макет для сетки курсов
    property int columnCount: Math.max(1, Math.floor((width - 40) / 300))
    property real columnWidth: (width - (columnCount - 1) * 15) / columnCount
    property var columns: []

    Component.onCompleted: {
        console.log("🔄 ProfileChannel component completed");
        console.log("📱 isOtherUserChannel:", isOtherUserChannel);
        console.log("👤 userId:", userId);
        console.log("👤 userName:", userName);

        loadChannelData();
    }

    function loadChannelData() {
        if (isOtherUserChannel) {
            console.log("🔄 Loading OTHER USER channel data for channelId:", userId);

            // Загружаем публичный профиль автора
            var publicProfile = ChannelManager.getPublicProfile(userId);
            console.log("📊 Public profile data:", JSON.stringify(publicProfile));

            profileChannel.channelData = publicProfile || {};

            // Загружаем курсы канала
            var channelCourses = ChannelManager.getChannelCourses(userId);
            console.log("📚 Channel courses count:", channelCourses ? channelCourses.length : 0);

            profileChannel.channelCourses = channelCourses || [];

        } else {
            console.log("🔄 Loading MY channel data");
            profileChannel.channelData = ChannelManager.channelData || {};

            // Используем правильный метод для получения созданных курсов
            var currentUserName = ProfileManager.userName;
            console.log("👤 Current user name:", currentUserName);

            // Если есть метод getCoursesByAuthorName, используем его
            // Или используем исправленный createdCourses
            profileChannel.channelCourses = VideoCourseManager.createdCourses || [];

            console.log("📚 My created courses count:", profileChannel.channelCourses.length);
        }

        console.log("📊 Final channel courses count:", channelCourses.length);
        updateColumns();
    }

    function updateColumns() {
        if (!channelCourses || channelCourses.length === 0) {
            columns = [];
            return;
        }

        var cols = [];
        for (var c = 0; c < columnCount; c++) {
            cols.push([]);
        }

        for (var i = 0; i < channelCourses.length; i++) {
            var colIndex = i % columnCount;
            cols[colIndex].push(channelCourses[i]);
        }
        columns = cols;
    }

    onWidthChanged: {
        columnCount = Math.max(1, Math.floor((width - 40) / 300));
        updateColumns();
    }

    onChannelCoursesChanged: updateColumns()

    // Обработчики изменений данных
    Connections {
        target: ChannelManager
        function onChannelDataChanged() {
            if (!isOtherUserChannel) {
                console.log("🔄 My channel data changed, reloading...");
                loadChannelData();
            }
        }

        function onLoadedChannelDataChanged() {
            if (isOtherUserChannel) {
                console.log("🔄 Other user channel data changed, reloading...");
                loadChannelData();
            }
        }
    }

    Connections {
        target: VideoCourseManager
        function onAllCoursesChanged() {
            console.log("🔄 Courses data updated, reloading channel data...");
            loadChannelData();
        }

        function onCreatedCoursesChanged() {
            if (!isOtherUserChannel) {
                console.log("🔄 My created courses changed, reloading...");
                loadChannelData();
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10
        anchors.bottomMargin: 10

        // Хедер канала
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: containerHeight
            color: themeColors.backgroundColor
            radius: 8
            border.color: themeColors.primaryColor
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 1
                spacing: 10

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Rectangle {
                        id: coverContainer
                        anchors {
                            left: parent.left
                            right: parent.right
                            top: parent.top
                            bottom: parent.bottom
                        }
                        color: "#f0f0f0"
                        clip: true
                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: Rectangle {
                                width: coverContainer.width
                                height: coverContainer.height
                                radius: 8
                            }
                        }

                        Image {
                            id: coverImage
                            anchors.fill: parent
                            source: channelData.cover || "qrc:/images/preview_standard.webp"
                            fillMode: Image.PreserveAspectCrop
                            onStatusChanged: {
                                if (status === Image.Error) {
                                    console.log("❌ Cover image failed to load:", source);
                                }
                            }
                        }
                    }

                    // Аватарка
                    Rectangle {
                        id: avatarContainer
                        width: 120
                        height: 120
                        anchors {
                            left: parent.left
                            leftMargin: 20
                            bottom: parent.bottom
                            bottomMargin: -40
                        }
                        radius: 1000
                        color: "transparent"
                        clip: true

                        Image {
                            id: avatarImage
                            anchors.fill: parent
                            source: isOtherUserChannel ?
                                (channelData.avatar || "qrc:/icons/icon_standard.webp") :
                                (ProfileManager.avatar || "qrc:/icons/icon_standard.webp")
                            fillMode: Image.PreserveAspectCrop
                            onStatusChanged: {
                                if (status === Image.Error) {
                                    console.log("❌ Avatar image failed to load:", source);
                                }
                            }

                            layer.enabled: true
                            layer.effect: OpacityMask {
                                maskSource: Rectangle {
                                    width: avatarImage.width
                                    height: avatarImage.height
                                    radius: 1000
                                }
                            }
                        }

                        Rectangle {
                            anchors.fill: parent
                            radius: parent.radius
                            color: "transparent"
                            border.color: themeColors.primaryColor
                            border.width: 2
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 200
                    Layout.leftMargin: 10
                    Layout.rightMargin: 10
                    spacing: 10

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.topMargin: 10

                        Text {
                            id: channelNameText
                            Layout.fillWidth: true
                            text: isOtherUserChannel ?
                                (channelData.channelName || userName || "Название канала") :
                                (channelData.channelInfo ? channelData.channelInfo.name : "Мой канал")
                            font.pixelSize: 20
                            font.bold: true
                            color: themeColors.textColor
                            elide: Text.ElideRight
                        }

                        Column {
                            Text {
                                text: channelData.subscribersCount || "0"
                                font.pixelSize: 18
                                font.bold: true
                                color: themeColors.textColor
                            }
                            Text {
                                text: "подписчиков"
                                font.pixelSize: 14
                                color: themeColors.secondaryTextColor
                            }
                        }

                        Column {
                            Text {
                                text: channelCourses ? channelCourses.length : "0"
                                font.pixelSize: 18
                                font.bold: true
                                color: themeColors.textColor
                            }
                            Text {
                                text: "курсов"
                                font.pixelSize: 14
                                color: themeColors.secondaryTextColor
                            }
                        }
                    }

                    Text {
                        id: channelDescriptionText
                        Layout.fillWidth: true
                        text: isOtherUserChannel ?
                            (channelData.description || "Описание канала") :
                            (channelData.channelInfo ? channelData.channelInfo.description : "Описание вашего канала")
                        font.pixelSize: 14
                        wrapMode: Text.Wrap
                        color: themeColors.secondaryTextColor
                    }

                    Rectangle {
                        id: tabBarContainer
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                        color: "transparent"

                        TabBar {
                            id: tabBar
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            currentIndex: swipeView.currentIndex

                            background: Rectangle {
                                color: "transparent"
                            }

                            TabButton {
                                text: "Курсы"
                                width: tabBar.width / 2

                                background: Rectangle {
                                    color: "transparent"
                                    radius: 8

                                    Rectangle {
                                        anchors.top: parent.top
                                        width: parent.width
                                        height: 3
                                        color: tabBar.currentIndex === 0 ? themeColors.primaryColor : "transparent"
                                    }
                                }

                                contentItem: Text {
                                    text: parent.text
                                    font.pixelSize: 16
                                    font.bold: tabBar.currentIndex === 0
                                    color: tabBar.currentIndex === 0 ? themeColors.primaryColor : themeColors.secondaryTextColor
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            TabButton {
                                text: "Информация"
                                width: tabBar.width / 2

                                background: Rectangle {
                                    color: "transparent"
                                    radius: 8

                                    Rectangle {
                                        anchors.top: parent.top
                                        width: parent.width
                                        height: 3
                                        color: tabBar.currentIndex === 1 ? themeColors.primaryColor : "transparent"
                                    }
                                }

                                contentItem: Text {
                                    text: parent.text
                                    font.pixelSize: 16
                                    font.bold: tabBar.currentIndex === 1
                                    color: tabBar.currentIndex === 1 ? themeColors.primaryColor : themeColors.secondaryTextColor
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                        }
                    }
                }
            }
        }

        SwipeView {
            id: swipeView
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: tabBar.currentIndex
            clip: true

            // Вкладка с курсами
            Item {
                width: swipeView.width
                height: swipeView.height

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 10

                    Text {
                        Layout.fillWidth: true
                        Layout.leftMargin: 10
                        text: "Курсы (" + (channelCourses ? channelCourses.length : 0) + ")"
                        font.pixelSize: 18
                        font.bold: true
                        color: themeColors.textColor
                        visible: channelCourses && channelCourses.length > 0
                    }

                    Loader {
                        id: coursesContentLoader
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        sourceComponent: channelCourses && channelCourses.length > 0 ? coursesGridComponent : emptyCoursesComponent
                    }
                }
            }

            // Вкладка с информацией
            Item {
                width: swipeView.width
                height: swipeView.height

                Column {
                    anchors.fill: parent
                    spacing: 10

                    ContactBlock {
                        width: parent.width
                        height: parent.height * 0.4
                        themeColors: profileChannel.themeColors
                        isEditMode: false
                        contacts: channelData.contacts || []
                    }

                    InformationBlock {
                        width: parent.width
                        height: parent.height * 0.58
                        themeColors: profileChannel.themeColors
                        isEditMode: false
                        information: channelData.information || []
                    }
                }
            }
        }
    }

    // Компонент сетки курсов
    Component {
        id: coursesGridComponent

        ScrollView {
            contentWidth: width
            contentHeight: columnsContainer.height
            clip: true

            Row {
                id: columnsContainer
                width: parent.width
                spacing: 15

                Repeater {
                    model: profileChannel.columns

                    delegate: Column {
                        width: profileChannel.columnWidth
                        spacing: 15

                        Repeater {
                            model: profileChannel.columns[index]

                            delegate: CardCourseProfile {
                                width: parent.width
                                themeColors: profileChannel.themeColors
                                courseData: modelData
                                onCourseClicked: {
                                    console.log("🎯 Opening course from channel:", modelData.title);
                                    console.log("🆔 Course ID:", modelData.id);
                                    navHistory.push("CardVideoListView.qml", {
                                        courseId: modelData.id
                                    });
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Компонент пустого состояния для курсов
    Component {
        id: emptyCoursesComponent

        Item {
            width: parent.width
            height: parent.height

            Column {
                anchors.centerIn: parent
                spacing: 20
                width: Math.min(parent.width * 0.8, 400)

                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: Math.min(150, parent.width - 40)
                    height: width
                    source: "qrc:/images/shows-thumbs.webp"
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }

                Column {
                    width: parent.width
                    spacing: 8

                    Text {
                        width: parent.width
                        text: "Пока нет доступных курсов"
                        color: themeColors.textColor
                        font.pixelSize: 16
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.Wrap
                    }

                    Text {
                        width: parent.width
                        text: "Курсы появятся здесь, когда автор их добавит"
                        color: themeColors.secondaryTextColor
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.Wrap
                    }
                }
            }
        }
    }
}
