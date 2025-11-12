// JSONListModel.qml
import QtQuick 2.15

ListModel {
    id: listModel

    property string source: ""
    property string jsonArrayField: "data"
    property bool _loading: false

    signal loaded()        // ← ДОБАВЬ ЭТО
    signal loadError(string message)  // ← ОПЦИОНАЛЬНО, но полезно

    onSourceChanged: {
        if (source && !_loading) {
            _loading = true;
            var xhr = new XMLHttpRequest();
            xhr.open("GET", source);

            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    _loading = false;
                    if (xhr.status === 200) {
                        try {
                            var jsonData = JSON.parse(xhr.responseText);
                            var list = jsonData[jsonArrayField];

                            if (list && Array.isArray(list)) {
                                listModel.clear();
                                for (var i = 0; i < list.length; i++) {
                                    listModel.append(list[i]);
                                }
                                console.log("JSONListModel: Загружено", list.length, "элементов из", jsonArrayField);
                                listModel.loaded();  // ← ВЫЗОВ СИГНАЛА
                            } else {
                                var msg = "Поле '" + jsonArrayField + "' не найдено или не массив";
                                console.warn("JSONListModel:", msg);
                                listModel.loadError(msg);
                            }
                        } catch (e) {
                            var msg = "Ошибка парсинга JSON: " + e.message;
                            console.error(msg);
                            listModel.loadError(msg);
                        }
                    } else {
                        var msg = "Ошибка загрузки: " + xhr.status + " " + xhr.statusText;
                        console.error("JSONListModel:", msg);
                        listModel.loadError(msg);
                    }
                }
            };
            xhr.send();
        }
    }
}
