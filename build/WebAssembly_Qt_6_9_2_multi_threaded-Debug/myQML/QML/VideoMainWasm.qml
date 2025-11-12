// MainWasm.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtWebView

Item {
    property string currentVideoUrl: ""
    function loadVideo(videoUrl) {
        if (!videoUrl) return;

        var htmlContent = `
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <style>
                body { margin: 0; background: #000; height: 100vh; display: flex; justify-content: center; align-items: center; }
                video { max-width: 100%; max-height: 100%; }
            </style>
        </head>
        <body>
            <video id="videoPlayer" controls autoplay>
                <source src="${videoUrl}" type="video/mp4">
                Ваш браузер не поддерживает HTML5 видео.
            </video>
        </body>
        </html>`;
        webView.loadHtml(htmlContent, "");
    }

    ColumnLayout {
        anchors.fill: parent
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
                    text: "https://192.168.1.62:8000/video/balerina.mp4" // HTTPS может работать в браузере
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

            WebView {
                id: webView
                anchors.fill: parent
            }
        }
    }
}
