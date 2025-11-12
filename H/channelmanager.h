#ifndef CHANNELMANAGER_H
#define CHANNELMANAGER_H

#include <QObject>
#include <QVariantMap>
#include <QString>

class ChannelManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantMap channelData READ channelData NOTIFY channelDataChanged)
    Q_PROPERTY(QVariantMap loadedChannelData READ loadedChannelData NOTIFY loadedChannelDataChanged)
    Q_PROPERTY(bool isChannel READ isChannel NOTIFY isChannelChanged)

public:
    static ChannelManager& instance();

    // Основные методы
    Q_INVOKABLE void loadChannel(const QString &userId);
    Q_INVOKABLE QVariantMap getChannelData(const QString &userId);
    Q_INVOKABLE QVariantList getChannelCourses(const QString &userId);
    Q_INVOKABLE QVariantMap getPublicProfile(const QString &userId);
    Q_INVOKABLE QString getAuthorIdByChannelId(const QString &channelId) const;
    Q_INVOKABLE QVariantMap getChannelByAuthorId(const QString &authorId) const;
    Q_INVOKABLE QVariantList getCoursesByAuthorId(const QString &authorId) const;

    // ДОБАВЛЕНО: метод для получения channelId по имени пользователя
    Q_INVOKABLE QString getChannelIdByUserName(const QString &userName);

    // Существующие методы
    QVariantMap channelData() const;
    QVariantMap loadedChannelData() const;
    bool isChannel() const;
    void createChannel(const QString &name, const QString &description);
    void deleteChannel();
    void updateChannelInfo(const QVariantMap &channelInfo);

signals:
    void channelDataChanged();
    void loadedChannelDataChanged();
    void isChannelChanged();
    void channelInfoUpdated();
    void publicCoursesChanged();

private:
    explicit ChannelManager(QObject *parent = nullptr);
    void loadFromFile();
    void saveToFile();
    QVariantMap createDefaultChannelData();
    QVariantMap filterPublicProfile() const;
    QVariantList filterPublicCourses() const;

    // Новые методы для фейкового API
    QVariantMap loadChannelFromFile(const QString &userId);
    void initializeFakeChannels();

    QString m_dataPath;
    QVariantMap m_channelData;
    QVariantMap m_loadedChannelData;
};

#endif // CHANNELMANAGER_H
