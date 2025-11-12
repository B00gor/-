import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

Item {
    property string currentVideoUrl: ""

    function getBaseUrl() {
        return "http://192.168.1.62:5555/video/test.mp4";
    }

    function loadVideo(videoUrl) {
        if (!videoUrl) return;

        console.log("=== НАЧАЛО ЗАГРУЗКИ ВИДЕО ===");
        console.log("URL:", videoUrl);

        // Сначала остановить текущее воспроизведение
        videoPlayer.stop();
        videoPlayer.source = "";

        // Установить новый источник
        videoPlayer.source = videoUrl;
        console.log("Источник установлен");

        // Попробовать воспроизвести
        videoPlayer.play();
        console.log("Команда play() отправлена");
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 5

        Rectangle {
            Layout.fillWidth: true
            height: 100  // Увеличим высоту для дополнительных кнопок
            color: "#f0f0f0"
            border.color: "#ccc"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 5

                RowLayout {
                    Layout.fillWidth: true

                    TextField {
                        id: urlInput
                        Layout.fillWidth: true
                        placeholderText: "Введите URL видео..."
                        text: getBaseUrl()
                    }

                    Button {
                        text: "Загрузить"
                        onClicked: {
                            currentVideoUrl = urlInput.text;
                            loadVideo(currentVideoUrl);
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true

                    Button {
                        text: "Тест сервера"
                        onClicked: {
                            var xhr = new XMLHttpRequest();
                            var testUrl = getBaseUrl() + "/video";
                            console.log("Тестируем URL:", testUrl);
                            xhr.open("GET", testUrl);
                            xhr.onreadystatechange = function() {
                                if (xhr.readyState === XMLHttpRequest.DONE) {
                                    console.log("Статус ответа:", xhr.status);
                                    if (xhr.status === 200) {
                                        console.log("✅ Сервер доступен!");
                                        var data = JSON.parse(xhr.responseText);
                                        console.log("Доступно видео:", data.videos);
                                    } else {
                                        console.error("❌ Ошибка подключения:", xhr.status, xhr.statusText);
                                    }
                                }
                            };
                            xhr.send();
                        }
                    }

                    Button {
                        text: "Проверить видео"
                        onClicked: {
                            var xhr = new XMLHttpRequest();
                            var videoUrl = urlInput.text;
                            console.log("Проверяем видео URL:", videoUrl);
                            xhr.open("HEAD", videoUrl);
                            xhr.onreadystatechange = function() {
                                if (xhr.readyState === XMLHttpRequest.DONE) {
                                    console.log("Статус видео:", xhr.status);
                                    if (xhr.status === 200) {
                                        console.log("✅ Видеофайл доступен!");
                                        console.log("Content-Type:", xhr.getResponseHeader("Content-Type"));
                                        console.log("Content-Length:", xhr.getResponseHeader("Content-Length"));
                                    } else {
                                        console.error("❌ Видеофайл недоступен:", xhr.status);
                                    }
                                }
                            };
                            xhr.send();
                        }
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

                onErrorOccurred: {
                    console.error("=== ОШИБКА ВИДЕО ===");
                    console.error("Код:", error);
                    console.error("Описание:", errorString);
                    errorText.text = "Ошибка: " + errorString;
                }

                onPlaybackStateChanged: {
                    console.log("=== СОСТОЯНИЕ ВОСПРОИЗВЕДЕНИЯ ===");
                    console.log("Состояние:", playbackState);
                    if (playbackState === MediaPlayer.PlayingState) {
                        console.log("✅ ВИДЕО ВОСПРОИЗВОДИТСЯ!");
                        errorText.text = "";
                    } else if (playbackState === MediaPlayer.PausedState) {
                        console.log("⏸️ Видео на паузе");
                    } else if (playbackState === MediaPlayer.StoppedState) {
                        console.log("⏹️ Видео остановлено");
                    }
                }

                // Отладка метаданных - может косвенно указать на прогресс загрузки
                onMetaDataChanged: {
                    console.log("=== МЕТАДАННЫЕ ПОЛУЧЕНЫ ===");
                    console.log("Длительность:", metaData.duration, "ms");
                    console.log("Разрешение:", metaData.resolution.width + "x" + metaData.resolution.height);
                    console.log("Частота кадров:", metaData.videoFrameRate);
                }

                onSourceChanged: {
                    console.log("=== ИСТОЧНИК ИЗМЕНЕН ===");
                    console.log("Новый источник:", source);
                }
            }

            // Индикатор загрузки
            BusyIndicator {
                id: loadingIndicator
                anchors.centerIn: parent
                running: videoPlayer.mediaStatus === MediaPlayer.Loading ||
                        videoPlayer.mediaStatus === MediaPlayer.Stalled ||
                        videoPlayer.mediaStatus === MediaPlayer.Buffering
                visible: running
            }

            // Сообщение об ошибке
            Text {
                id: errorText
                anchors.centerIn: parent
                color: "white"
                font.pixelSize: 16
                visible: text !== ""
            }

            // Информация о статусе
            Text {
                id: statusText
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 10
                color: "white"
                font.pixelSize: 12
                text: "Состояние: " + videoPlayer.playbackState + "\n" +
                      "Статус: " + videoPlayer.mediaStatus + "\n" +
                      "Ошибка: " + (videoPlayer.hasError ? "Да" : "Нет")
            }

            // Кнопки управления
            Row {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: 20
                spacing: 10

                Button {
                    text: "▶️"
                    onClicked: {
                        console.log("Ручной запуск воспроизведения");
                        videoPlayer.play();
                    }
                }

                Button {
                    text: "⏸️"
                    onClicked: videoPlayer.pause()
                }

                Button {
                    text: "⏹️"
                    onClicked: videoPlayer.stop()
                }
            }
        }
    }

    Component.onCompleted: {
        console.log("=== VideoMainAndroid ЗАГРУЖЕН ===");
        console.log("Платформа:", Qt.platform.os);
        console.log("Базовый URL:", getBaseUrl());
    }
}
