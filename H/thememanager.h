#ifndef THEMEMANAGER_H
#define THEMEMANAGER_H

#include <QObject>
#include <QString>
#include <QVariantMap>
#include <QVariantList>
#include <QDateTime>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QStandardPaths>
#include <QDir>
#include <QRandomGenerator>
#include <QColor>

class ThemeManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString theme READ theme WRITE setTheme NOTIFY themeChanged)
    Q_PROPERTY(QString primaryColor READ primaryColor WRITE setPrimaryColor NOTIFY primaryColorChanged)
    Q_PROPERTY(QVariantMap currentThemeColors READ currentThemeColors NOTIFY themeColorsChanged)

public:
    static ThemeManager& instance();

    // Геттеры
    QString theme() const;
    QString primaryColor() const;
    QVariantMap currentThemeColors() const;

    Q_INVOKABLE QString getThemeColor(const QString& colorName);
    Q_INVOKABLE QString getThemeName(const QString& theme);
    Q_INVOKABLE QString getThemeDescription(const QString& theme);
    Q_INVOKABLE QVariantList getColorPalette();
    Q_INVOKABLE QVariantMap getAppSettings();
    Q_INVOKABLE QVariantList getRecentColors();

    // Сеттеры
    Q_INVOKABLE void setTheme(const QString &theme);
    Q_INVOKABLE void setPrimaryColor(const QString &primaryColor);
    Q_INVOKABLE void updateAppSettings(const QVariantMap& settings);

signals:
    void themeChanged();
    void primaryColorChanged();
    void themeColorsChanged();

private:
    ThemeManager();
    void saveToFile();
    void loadFromFile();
    void updateThemeColors();
    void addColorToRecent(const QString& color);
    QString generateColor();
    QVariantList generateColorPalette();
    QVariantMap createDefaultSettings();

    QVariantMap m_settingsData;
    QVariantMap m_currentThemeColors;
    QString m_dataPath;
};

#endif // THEMEMANAGER_H
