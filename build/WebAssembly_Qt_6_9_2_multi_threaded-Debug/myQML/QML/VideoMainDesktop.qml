// MainDesktop.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

Item {
    property string currentVideoUrl: ""

    function loadVideo(videoUrl) {
        if (!videoUrl) return;
        videoPlayer.source = Qt.resolvedUrl(videoUrl);
        videoPlayer.play();
    }

    ColumnLayout {
        anchors.fill: parent // Этот ColumnLayout заполняет Item (MainDesktop.qml)
        spacing: 5

        Rectangle {
            Layout.fillWidth: true
            height: 60
            color: "#f0f0f0"
            border.color: "#ccc"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 5

                TextField {
                    id: urlInput
                    Layout.fillWidth: true
                    placeholderText: "Введите URL видео API..."
                    text: "http://192.168.1.62:5555/video/balerina.mp4" // Используйте HTTP
                }

                Button {
                    text: "Загрузить"
                    onClicked: {
                        currentVideoUrl = urlInput.text;
                        loadVideo(currentVideoUrl);
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "black"

            Video {
                id: videoPlayer
                anchors.fill: parent
                fillMode: VideoOutput.PreserveAspectFit
                autoPlay: false
            }
        }
    }
}
