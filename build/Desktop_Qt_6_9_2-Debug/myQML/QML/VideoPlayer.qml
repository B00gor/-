import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    property string currentPlatform: {
        if (Qt.platform.os === "wasm") return "wasm";
        if (Qt.platform.os === "android") return "android";
        if (Qt.platform.os === "ios") return "ios";
        if (Qt.platform.os === "linux") return "desktop";
        if (Qt.platform.os === "windows") return "desktop";
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        RowLayout {
            Text {
                text: "Видео"
                font.pointSize: 24
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                Layout.leftMargin: 10
                horizontalAlignment: Text.AlignLeft
            }

            Button {
                background: Item { }
                contentItem: Row {
                    spacing: 10
                    Image {
                        width: 20
                        height: 20
                        source: "qrc:/Icon/back_icon.webp"
                    }
                }
                onClicked: contentStackView.pop()
            }
        }

        Canvas {
            id: backgroundCanvas
            Layout.fillWidth: true
            Layout.fillHeight: true

            onPaint: {
                var ctx = getContext("2d");
                var w = width, h = height;
                var r = 8;

                ctx.clearRect(0, 0, w, h);
                ctx.beginPath();
                ctx.moveTo(0, r);
                ctx.arcTo(0, 0, r, 0, r);
                ctx.lineTo(w - r, 0);
                ctx.arcTo(w, 0, w, r, r);
                ctx.lineTo(w, h);
                ctx.lineTo(0, h);
                ctx.closePath();

                ctx.fillStyle = "#ffffff";
                ctx.fill();

                ctx.strokeStyle = "#ddd";
                ctx.lineWidth = 2;
                ctx.stroke();
            }

            Loader {
                id: pageLoader
                anchors.fill: parent
                source: {
                    switch(currentPlatform) {
                        case "wasm": return "VideoMainWasm.qml";
                        case "android": return "VideoMainAndroid.qml";
                        case "desktop": return "VideoMainDesktop.qml";
                    }
                }
            }
        }
    }
}
