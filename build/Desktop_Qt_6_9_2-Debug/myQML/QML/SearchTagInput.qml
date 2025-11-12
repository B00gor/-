// SearchTagInput.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects


Rectangle {
    id: tagInputArea
    Layout.fillWidth: true
    implicitHeight: contentColumn.implicitHeight + 20
    radius: 8
    border.color: ThemeManager.primaryColor
    border.width: 2
    color: ThemeManager.getThemeColor("backgroundColor")
    clip: true

    // Свойства цветов темы
    property color backgroundColor: ThemeManager.getThemeColor("backgroundColor")
    property color cardColor: ThemeManager.getThemeColor("cardColor")
    property color textColor: ThemeManager.getThemeColor("textColor")
    property color secondaryTextColor: ThemeManager.getThemeColor("secondaryTextColor")
    property color borderColor: ThemeManager.getThemeColor("borderColor")
    property color primaryColor: ThemeManager.primaryColor

    JSONListModel {
        id: tagsModel
        source: "tags.json"
        jsonArrayField: "tags"
    }

    property var selectedTags: []
    property int maxTags: 15
    property var availableTags: []
    property bool tagsLoaded: true
    property var filteredTags: []

    Connections {
        target: tagsModel
        function onCountChanged() {
            console.log("tagsModel.count =", tagsModel.count);
            var tags = [];
            for (var i = 0; i < tagsModel.count; i++) {
                tags.push(tagsModel.get(i));
            }
            availableTags = tags;
            tagsLoaded = true;
            console.log("availableTags =", availableTags);
        }
    }

    signal loadError(string message)

    // === ОСНОВНОЙ КОНТЕНТ ===
    Column {
        id: contentColumn
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        // Верхняя строка с полем ввода и кнопкой поиска
        RowLayout {
            width: parent.width
            spacing: 10

            // Основной контент
            Column {
                Layout.fillWidth: true
                spacing: 10

                // Индикатор загрузки
                BusyIndicator {
                    width: 20
                    height: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: !tagInputArea.tagsLoaded && tagInputArea.availableTags.length === 0
                }

                Text {
                    id: errorText
                    width: parent.width
                    color: "red"
                    font.pixelSize: 11
                    wrapMode: Text.WordWrap
                    visible: text !== ""
                }

                // Горизонтальный скролл для выбранных тегов (1 строка)
                ScrollView {
                    id: selectedTagsScroll
                    width: parent.width
                    height: 35 // 1 строка
                    clip: true

                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                    Row {
                        id: selectedTagsRow
                        spacing: 5
                        height: parent.height

                        Repeater {
                            model: tagInputArea.selectedTags
                            delegate: Rectangle {
                                height: 30
                                radius: 15
                                color: ThemeManager.theme === "dark" ? Qt.darker(primaryColor, 2) : "#e3f2fd"
                                width: tagText.implicitWidth + closeBtn.width + 20
                                border.color: primaryColor
                                border.width: 1
                                RowLayout {
                                    anchors.fill: parent
                                    spacing: 5

                                    Text {
                                        id: tagText
                                        text: modelData
                                        font.pixelSize: 12
                                        font.bold: true
                                        color: ThemeManager.theme === "dark" ? "white" : "#1976d2"
                                        elide: Text.ElideRight
                                        maximumLineCount: 1
                                        Layout.leftMargin: 8
                                        Layout.alignment: Qt.AlignVCenter
                                        Layout.fillWidth: true
                                    }

                                    Button {
                                        id: closeBtn
                                        width: 16
                                        height: 16
                                        text: "×"
                                        font.pixelSize: 10
                                        font.bold: true
                                        background: Rectangle {
                                            color: "transparent"
                                        }
                                        contentItem: Text {
                                            text: parent.text
                                            color: primaryColor
                                            font: parent.font
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                        }
                                        Layout.rightMargin: 5
                                        onClicked: {
                                            const idx = tagInputArea.selectedTags.indexOf(modelData);

                                            if (idx !== -1) {
                                                tagInputArea.selectedTags.splice(idx, 1);
                                                tagInputArea.selectedTagsChanged();
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // Поле ввода нового тега
                        TextField {
                            id: tagInput
                            width: 100
                            height: 30
                            placeholderText: tagInputArea.selectedTags.length < tagInputArea.maxTags ? "Enter tag" : ""
                            font.pixelSize: 12
                            visible: tagInputArea.tagsLoaded && tagInputArea.selectedTags.length < tagInputArea.maxTags
                            enabled: tagInputArea.tagsLoaded
                            color: textColor
                            placeholderTextColor: secondaryTextColor

                            // Обработчик изменения текста
                            onTextChanged: {
                                tagInputArea.filterTags(text);
                            }

                            onAccepted: {
                                const tag = text.trim();
                                if (tag) {
                                    tagInputArea.addTag(tag);
                                    text = "";
                                    tagInputArea.filteredTags = []; // Очищаем фильтр после добавления
                                }
                            }

                            background: Rectangle {
                                color: "transparent"
                            }
                        }
                    }
                }

                // Сообщение о лимите тегов
                Text {
                    text: "Лимит Тегов!"
                    color: "red"
                    font.pixelSize: 11
                    visible: tagInputArea.selectedTags.length >= tagInputArea.maxTags
                }

                // Вертикальный скролл для доступных тегов (3 строки)
                ScrollView {
                    id: availableTagsScroll
                    width: parent.width
                    height: 85 // Ограничиваем высоту до 3 строк
                    clip: true
                    visible: tagInputArea.tagsLoaded && tagInputArea.selectedTags.length < tagInputArea.maxTags &&
                             (tagInput.text.length === 0 || tagInputArea.filteredTags.length > 0)

                    ScrollBar.vertical.policy: ScrollBar.AlwaysOff

                    Flow {
                        id: availableTagsFlow
                        width: availableTagsScroll.width
                        spacing: 5

                        Repeater {
                            model: tagInput.text.length === 0 ?
                                   tagInputArea.availableTags.filter(tag => !tagInputArea.selectedTags.includes(tag)) :
                                   tagInputArea.filteredTags

                            delegate: Button {
                                height: 25
                                padding: 5
                                text: modelData
                                font.pixelSize: 11
                                background: Rectangle {
                                    color: "transparent"
                                    border.color: ThemeManager.getThemeColor("borderColor")

                                    border.width: 1
                                    radius: 12
                                }
                                contentItem: Text {
                                    text: parent.text
                                    color: secondaryTextColor
                                    font: parent.font
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                                onClicked: {
                                    tagInputArea.addTag(modelData);
                                    tagInput.text = ""; // Очищаем поле ввода
                                    tagInputArea.filteredTags = []; // Очищаем фильтр
                                }
                            }
                        }
                    }
                }

                // Сообщение, если не найдено тегов
                Text {
                    text: "Теги не найдены"
                    color: secondaryTextColor
                    font.pixelSize: 11
                    visible: tagInputArea.tagsLoaded && tagInput.text.length > 0 && tagInputArea.filteredTags.length === 0
                }
            }

            // Кнопка поиска - теперь внутри основного контента
            Button {
                id: searchButton
                Layout.preferredWidth: 50
                Layout.preferredHeight: 50
                Layout.alignment: Qt.AlignTop

                background: Rectangle {
                    color: "transparent"
                }

                contentItem: Image {
                    anchors.centerIn: parent
                    width: 30
                    height: 30
                    source: "qrc:/icons/search-icon.webp"
                    layer.enabled: true
                    layer.effect: ColorOverlay {
                        color: primaryColor
                    }
                }

                onClicked: {
                    console.log("Поиск по тегам:", tagInputArea.selectedTags);
                }
            }
        }
    }

    // === МЕТОДЫ ===
    function addTag(tag) {
        if (tagInputArea.selectedTags.length < tagInputArea.maxTags && !tagInputArea.selectedTags.includes(tag)) {
            tagInputArea.selectedTags.push(tag);
            tagInputArea.selectedTagsChanged();
        }
    }

    function removeTag(index) {
        tagInputArea.selectedTags.splice(index, 1);
        tagInputArea.selectedTagsChanged();
    }

    // Новая функция для фильтрации тегов
    function filterTags(searchText) {
        if (searchText.trim().length === 0) {
            tagInputArea.filteredTags = [];
            return;
        }

        const searchLower = searchText.toLowerCase();
        tagInputArea.filteredTags = tagInputArea.availableTags.filter(tag => {
            // Исключаем уже выбранные теги
            if (tagInputArea.selectedTags.includes(tag)) {
                return false;
            }
            // Ищем совпадения (без учета регистра)
            return tag.toLowerCase().includes(searchLower);
        });
    }

    function handleLoadError(message) {
        console.error("SearchTagInput Error:", message);
        tagInputArea.loadError(message);
        tagInputArea.tagsLoaded = true;
    }

    Component.onCompleted: {
        // Инициализация availableTags из статического списка
        if (availableTags.length === 0) {
            availableTags = [
                "QML", "Qt", "C++", "Python", "JavaScript", "HTML", "CSS", "Java", "Ruby", "PHP",
                "Swift", "Kotlin", "Go", "Rust", "TypeScript", "C#", "C", "R", "MATLAB", "Scala",
                "Perl", "Haskell", "Lua", "Julia", "Dart", "Elixir", "Clojure", "F#", "OCaml", "Scheme",
                "Assembly", "Shell", "PowerShell", "Objective-C", "Visual Basic", "Delphi", "Pascal",
                "Fortran", "COBOL", "Lisp", "Prolog", "Erlang", "Groovy", "VBScript", "ActionScript",
                "SQL", "PL/SQL", "TSQL", "NoSQL", "MongoDB", "PostgreSQL", "MySQL", "SQLite", "Redis",
                "Elasticsearch", "Cassandra", "Oracle", "SQL Server", "MariaDB", "Firebase", "DynamoDB",
                "Neo4j", "Couchbase", "Redis", "Memcached", "InfluxDB", "ClickHouse",
                "React", "Vue", "Angular", "Svelte", "jQuery", "Bootstrap", "Tailwind", "SASS", "LESS",
                "Webpack", "Vite", "Babel", "ES6", "Web Components", "PWA", "Responsive Design",
                "Material UI", "Ant Design", "Chakra UI", "Three.js", "D3.js",
                "Node.js", "Express", "Django", "Flask", "Spring", "Laravel", "Ruby on Rails", "ASP.NET",
                "FastAPI", "NestJS", "Koa", "Phoenix", "Gin", "Actix", "Rocket",
                "React Native", "Flutter", "Ionic", "Xamarin", "Cordova", "PhoneGap", "Android SDK",
                "iOS SDK", "SwiftUI", "Jetpack Compose",
                "Docker", "Kubernetes", "AWS", "Azure", "GCP", "Heroku", "DigitalOcean", "Linode",
                "Terraform", "Ansible", "Puppet", "Chef", "Jenkins", "GitLab CI", "GitHub Actions",
                "Travis CI", "CircleCI", "Prometheus", "Grafana", "Kibana", "Splunk",
                "Git", "GitHub", "GitLab", "Bitbucket", "JIRA", "Confluence", "Trello", "Asana",
                "Slack", "Discord", "Zoom", "Teams", "Figma", "Sketch", "Adobe XD", "InVision",
                "Unity", "Unreal Engine", "Godot", "Blender", "Maya", "3ds Max", "Photoshop",
                "Illustrator", "InDesign", "After Effects", "Premiere Pro", "DaVinci Resolve",
                "Excel", "Word", "PowerPoint", "Outlook", "Google Docs", "Sheets", "Slides",
                "Notion", "Evernote", "OneNote", "Obsidian", "Roam Research",
                "WordPress", "Joomla", "Drupal", "Magento", "Shopify", "WooCommerce", "BigCommerce",
                "Squarespace", "Wix", "Webflow", "Ghost", "Strapi", "Contentful",
                "Agile", "Scrum", "Kanban", "Waterfall", "DevOps", "CI/CD", "TDD", "BDD", "DDD",
                "Microservices", "Monolith", "REST API", "GraphQL", "gRPC", "SOAP",
                "Cybersecurity", "Penetration Testing", "Cryptography", "SSL/TLS", "OAuth", "JWT",
                "Firewall", "VPN", "Zero Trust", "SOC", "SIEM",
                "Machine Learning", "Deep Learning", "Neural Networks", "TensorFlow", "PyTorch",
                "Keras", "Scikit-learn", "Pandas", "NumPy", "Data Analysis", "Data Visualization",
                "Tableau", "Power BI", "Big Data", "Hadoop", "Spark", "Kafka",
                "Arduino", "Raspberry Pi", "ESP32", "MicroPython", "Embedded C", "RTOS", "FreeRTOS",
                "Blockchain", "Bitcoin", "Ethereum", "Smart Contracts", "Web3", "Solidity", "DeFi",
                "NFT", "Cryptocurrency",
                "WebAssembly", "WebRTC", "WebSockets", "GraphQL", "Apache", "Nginx", "Linux", "Windows Server",
                "macOS", "Ubuntu", "CentOS", "Debian", "VMware", "VirtualBox", "Hyper-V",
                "Unit Testing", "Integration Testing", "E2E Testing", "Selenium", "Cypress", "Jest",
                "Mocha", "Chai", "JUnit", "TestNG", "Postman", "SoapUI",
                "Technical Writing", "Documentation", "Code Review", "Refactoring", "Design Patterns",
                "Algorithms", "Data Structures", "Competitive Programming", "Open Source", "Mentoring"
            ];
            tagsLoaded = true;
        }
    }
}
