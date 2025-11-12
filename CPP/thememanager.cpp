#include "H/thememanager.h"

ThemeManager& ThemeManager::instance()
{
    static ThemeManager instance;
    return instance;
}

ThemeManager::ThemeManager()
{
#ifdef Q_OS_WASM
    m_dataPath = "/settings.json";
#else
    QString dataDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(dataDir);
    if (!dir.exists()) dir.mkpath(".");
    m_dataPath = dir.filePath("settings.json");
#endif
    loadFromFile();
}

// Геттеры
QString ThemeManager::theme() const {
    return m_settingsData["theme"].toString();
}

QString ThemeManager::primaryColor() const {
    return m_settingsData["primaryColor"].toString();
}

QVariantMap ThemeManager::currentThemeColors() const {
    return m_currentThemeColors;
}

QString ThemeManager::getThemeColor(const QString& colorName) {
    return m_currentThemeColors.value(colorName).toString();
}

QString ThemeManager::getThemeName(const QString& theme) {
    QVariantMap themeNames = m_settingsData["themeNames"].toMap();
    return themeNames[theme].toString();
}

QString ThemeManager::getThemeDescription(const QString& theme) {
    QVariantMap themeDescriptions = m_settingsData["themeDescriptions"].toMap();
    return themeDescriptions[theme].toString();
}

QVariantList ThemeManager::getColorPalette() {
    return generateColorPalette();
}

QVariantMap ThemeManager::getAppSettings() {
    return m_settingsData["appSettings"].toMap();
}

QVariantList ThemeManager::getRecentColors() {
    return m_settingsData["recentColors"].toList();
}

// Сеттеры
void ThemeManager::setTheme(const QString &theme) {
    m_settingsData["theme"] = theme;
    updateThemeColors();
    saveToFile();
    emit themeChanged();
    emit themeColorsChanged();
}

void ThemeManager::setPrimaryColor(const QString &primaryColor) {
    m_settingsData["primaryColor"] = primaryColor;
    addColorToRecent(primaryColor);
    updateThemeColors();
    saveToFile();
    emit primaryColorChanged();
    emit themeColorsChanged();
}

void ThemeManager::updateAppSettings(const QVariantMap& settings) {
    QVariantMap appSettings = m_settingsData["appSettings"].toMap();

    // Обновляем настройки
    for (auto it = settings.begin(); it != settings.end(); ++it) {
        appSettings[it.key()] = it.value();
    }

    m_settingsData["appSettings"] = appSettings;
    saveToFile();
}

// Приватные методы
void ThemeManager::saveToFile() {
    m_settingsData["lastUpdated"] = QDateTime::currentDateTime().toString(Qt::ISODate);

    QJsonDocument doc(QJsonObject::fromVariantMap(m_settingsData));
    QFile file(m_dataPath);

    if (file.open(QIODevice::WriteOnly)) {
        file.write(doc.toJson());
        file.close();
    }
}

void ThemeManager::loadFromFile() {
    QFile file(m_dataPath);
    if (!file.exists()) {
        m_settingsData = createDefaultSettings();
        saveToFile();
        return;
    }

    if (file.open(QIODevice::ReadOnly)) {
        QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
        file.close();
        m_settingsData = doc.object().toVariantMap();
        updateThemeColors();
    }
}

QVariantMap ThemeManager::createDefaultSettings() {
    return QVariantMap({
        {"theme", "light"},
        {"primaryColor", "#2196F3"},
        {"recentColors", QVariantList({
                             "#2196F3", "#0078d4", "#107c10", "#d13438", "#ffb900"
                         })},
        {"themeNames", QVariantMap({
                           {"light", "Светлая тема"},
                           {"dark", "Темная тема"}
                       })},
        {"themeDescriptions", QVariantMap({
                                  {"light", "Классический светлый интерфейс"},
                                  {"dark", "Удобно для использования в условиях слабого освещения"}
                              })},
        {"appSettings", QVariantMap({
                            {"language", "ru"},
                            {"fontSize", "medium"},
                            {"animationsEnabled", true},
                            {"notificationsEnabled", true}
                        })},
        {"lastUpdated", "2024-01-15T10:30:00Z"}
    });
}

void ThemeManager::updateThemeColors() {
    QString currentTheme = theme();
    QString currentPrimaryColor = primaryColor();

    if (currentTheme == "light") {
        m_currentThemeColors = {
            {"backgroundColor", "#f5f5f5"},
            {"cardColor", "#ffffff"},
            {"textColor", "#333333"},
            {"secondaryTextColor", "#666666"},
            {"borderColor", "#e0e0e0"},
            {"headerColor", "lightblue"},
            {"primaryColor", currentPrimaryColor},
            {"surfaceColor", "#f8f9fa"}, // ДОБАВЛЕНО: для фона элементов
            {"accentColor", "#1976d2"}    // ДОБАВЛЕНО: для акцентного текста
        };
    } else if (currentTheme == "dark") {
        m_currentThemeColors = {
            {"backgroundColor", "#1e1e1e"},
            {"cardColor", "#1a1919"},
            {"textColor", "#ffffff"},
            {"secondaryTextColor", "#b0b0b0"},
            {"borderColor", "#444444"},
            {"headerColor", "#252525"},
            {"primaryColor", currentPrimaryColor},
            {"surfaceColor", "#2d2d2d"}, // ДОБАВЛЕНО: для фона элементов
            {"accentColor", "#64b5f6"}    // ДОБАВЛЕНО: для акцентного текста
        };
    }
}

void ThemeManager::addColorToRecent(const QString& color) {
    QVariantList recentColors = m_settingsData["recentColors"].toList();

    // Удаляем цвет если он уже есть
    recentColors.removeAll(color);

    // Добавляем цвет в начало
    recentColors.prepend(color);

    // Ограничиваем до 7 последних цветов
    while (recentColors.size() > 7) {
        recentColors.removeLast();
    }

    m_settingsData["recentColors"] = recentColors;
}

QString ThemeManager::generateColor() {
    int hue = QRandomGenerator::global()->bounded(360);
    int saturation = QRandomGenerator::global()->bounded(30, 100);
    int lightness = QRandomGenerator::global()->bounded(30, 80);

    QColor color;
    color.setHsl(hue, saturation, lightness);
    return color.name();
}

QVariantList ThemeManager::generateColorPalette() {
    QVariantList palette;

    // Добавляем последние использованные цвета
    QVariantList recentColors = getRecentColors();
    for (const QVariant& color : recentColors) {
        palette.append(color);
    }

    // Добавляем стандартные цвета
    QVariantList standardColors = {
        "#0078d4", "#107c10", "#d13438", "#ffb900", "#5c2d91",
        "#697689", "#00bc70", "#ef476f", "#118ab2", "#f48c06"
    };

    for (const QVariant& color : standardColors) {
        if (!palette.contains(color)) {
            palette.append(color);
        }
    }

    // Генерируем случайные цвета чтобы заполнить палитру
    int colorsNeeded = 100 - palette.size();
    for (int i = 0; i < colorsNeeded; ++i) {
        QString newColor = generateColor();
        if (!palette.contains(newColor)) {
            palette.append(newColor);
        }
    }

    return palette;
}
