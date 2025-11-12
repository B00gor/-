#ifndef PROFILEMANAGER_H
#define PROFILEMANAGER_H

#include <QObject>
#include <QVariantMap>
#include <QVariantList>

class ProfileManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString userName READ userName WRITE setUserName NOTIFY userNameChanged)
    Q_PROPERTY(QString userRole READ userRole WRITE setUserRole NOTIFY userRoleChanged)
    Q_PROPERTY(QString avatar READ avatar WRITE setAvatar NOTIFY avatarChanged)
    Q_PROPERTY(QString cover READ cover WRITE setCover NOTIFY coverChanged) // Добавлено свойство cover
    Q_PROPERTY(QVariantMap fullProfile READ fullProfile NOTIFY fullProfileChanged)

public:
    static ProfileManager& instance();

    // Геттеры
    QString userName() const;
    QString userRole() const;
    QString avatar() const;
    QString cover() const; // Добавлен геттер для cover
    QVariantMap fullProfile() const;
    QVariantMap getStatistics() const;

    // Сеттеры
    Q_INVOKABLE void setUserName(const QString &userName);
    Q_INVOKABLE void setUserRole(const QString &userRole);
    Q_INVOKABLE void setAvatar(const QString &avatar);
    Q_INVOKABLE void setCover(const QString &cover); // Добавлен сеттер для cover

    // Методы для работы с контактами и информацией
    Q_INVOKABLE void addContact(const QString &type, const QString &value, bool isPublic, const QString &icon = "");
    Q_INVOKABLE void removeContact(int index);
    Q_INVOKABLE void addInformation(const QString &label, const QString &value, bool isPublic);
    Q_INVOKABLE void removeInformation(int index);

    // Методы для работы с прогрессом курсов
    Q_INVOKABLE void updateCourseProgress(const QString &courseId, int progress);
    Q_INVOKABLE QVariantMap getCourseProgress(const QString &courseId) const;

signals:
    void userNameChanged();
    void userRoleChanged();
    void avatarChanged();
    void coverChanged(); // Добавлен сигнал для cover
    void fullProfileChanged();

private:
    explicit ProfileManager(QObject *parent = nullptr);
    void loadFromFile();
    void saveToFile();
    QVariantMap createDefaultProfile();

    QVariantMap m_profileData;
    QString m_dataPath;
};

#endif // PROFILEMANAGER_H
