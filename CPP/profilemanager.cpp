#include "H/profilemanager.h"
#include <QStandardPaths>
#include <QDir>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDateTime>

ProfileManager& ProfileManager::instance()
{
    static ProfileManager instance;
    return instance;
}

ProfileManager::ProfileManager(QObject *parent) : QObject(parent)
{
#ifdef Q_OS_WASM
    m_dataPath = "/profile.json";
#else
    QString dataDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(dataDir);
    if (!dir.exists()) dir.mkpath(".");
    m_dataPath = dir.filePath("profile.json");
#endif
    loadFromFile();
}

void ProfileManager::loadFromFile()
{
    QFile file(m_dataPath);
    if (file.open(QIODevice::ReadOnly)) {
        QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
        m_profileData = doc.object().toVariantMap();
        file.close();
    } else {
        // Создаем профиль по умолчанию
        m_profileData = createDefaultProfile();
        saveToFile();
    }
}

void ProfileManager::saveToFile()
{
    QFile file(m_dataPath);
    if (file.open(QIODevice::WriteOnly)) {
        QJsonDocument doc(QJsonObject::fromVariantMap(m_profileData));
        file.write(doc.toJson());
        file.close();
    }
}

QVariantMap ProfileManager::createDefaultProfile()
{
    return QVariantMap{
        {"userName", "Новый пользователь"},
        {"userRole", "Студент"},
        {"avatar", ""},
        {"cover", ""}, // Добавлено свойство cover
        {"profile", QVariantMap{
                        {"location", ""},
                        {"email", ""},
                        {"bio", ""}
                    }},
        {"contacts", QVariantList()},
        {"information", QVariantList()},
        {"courseProgress", QVariantMap()},
        {"statistics", QVariantMap{
                           {"totalCourses", 0},
                           {"completedCourses", 0},
                           {"totalStudyHours", 0},
                           {"achievements", QVariantList()}
                       }}
    };
}

QString ProfileManager::userName() const
{
    return m_profileData["userName"].toString();
}

void ProfileManager::setUserName(const QString &userName)
{
    if (m_profileData["userName"].toString() != userName) {
        m_profileData["userName"] = userName;
        saveToFile();
        emit userNameChanged();
        emit fullProfileChanged();
    }
}

QString ProfileManager::userRole() const
{
    return m_profileData["userRole"].toString();
}

void ProfileManager::setUserRole(const QString &userRole)
{
    if (m_profileData["userRole"].toString() != userRole) {
        m_profileData["userRole"] = userRole;
        saveToFile();
        emit userRoleChanged();
        emit fullProfileChanged();
    }
}

QString ProfileManager::avatar() const
{
    return m_profileData["avatar"].toString();
}

void ProfileManager::setAvatar(const QString &avatar)
{
    qDebug() << "Setting avatar to:" << avatar;

    if (m_profileData["avatar"].toString() != avatar) {
        m_profileData["avatar"] = avatar;
        saveToFile();
        qDebug() << "Avatar saved, emitting signals";
        emit avatarChanged();
        emit fullProfileChanged();
    } else {
        qDebug() << "Avatar is the same, no changes";
    }
}

// Добавляем методы для работы с cover
QString ProfileManager::cover() const
{
    return m_profileData["cover"].toString();
}

void ProfileManager::setCover(const QString &cover)
{
    qDebug() << "Setting cover to:" << cover;

    if (m_profileData["cover"].toString() != cover) {
        m_profileData["cover"] = cover;
        saveToFile();
        qDebug() << "Cover saved, emitting signals";
        emit coverChanged();
        emit fullProfileChanged();
    } else {
        qDebug() << "Cover is the same, no changes";
    }
}

QVariantMap ProfileManager::fullProfile() const
{
    return m_profileData;
}

void ProfileManager::addContact(const QString &type, const QString &value, bool isPublic, const QString &icon)
{
    QVariantList contacts = m_profileData["contacts"].toList();
    contacts.append(QVariantMap{
        {"type", type},
        {"value", value},
        {"isPublic", isPublic},
        {"icon", icon},
        {"id", QDateTime::currentDateTime().toSecsSinceEpoch() + contacts.size()}
    });
    m_profileData["contacts"] = contacts;
    saveToFile();
    emit fullProfileChanged();
}

void ProfileManager::removeContact(int index)
{
    QVariantList contacts = m_profileData["contacts"].toList();
    if (index >= 0 && index < contacts.size()) {
        contacts.removeAt(index);
        m_profileData["contacts"] = contacts;
        saveToFile();
        emit fullProfileChanged();
    }
}

void ProfileManager::addInformation(const QString &label, const QString &value, bool isPublic)
{
    QVariantList information = m_profileData["information"].toList();
    information.append(QVariantMap{
        {"label", label},
        {"value", value},
        {"isPublic", isPublic},
        {"id", QDateTime::currentDateTime().toSecsSinceEpoch() + information.size()}
    });
    m_profileData["information"] = information;
    saveToFile();
    emit fullProfileChanged();
}

void ProfileManager::removeInformation(int index)
{
    QVariantList information = m_profileData["information"].toList();
    if (index >= 0 && index < information.size()) {
        information.removeAt(index);
        m_profileData["information"] = information;
        saveToFile();
        emit fullProfileChanged();
    }
}

void ProfileManager::updateCourseProgress(const QString &courseId, int progress)
{
    QVariantMap progressData = m_profileData["courseProgress"].toMap();
    progressData[courseId] = QVariantMap{
        {"progress", progress},
        {"lastUpdated", QDateTime::currentDateTime().toString(Qt::ISODate)},
        {"isCompleted", progress >= 100}
    };
    m_profileData["courseProgress"] = progressData;
    saveToFile();
    emit fullProfileChanged();
}

QVariantMap ProfileManager::getCourseProgress(const QString &courseId) const
{
    QVariantMap progressData = m_profileData["courseProgress"].toMap();
    if (progressData.contains(courseId)) {
        return progressData[courseId].toMap();
    }
    return QVariantMap{
        {"progress", 0},
        {"isCompleted", false}
    };
}

QVariantMap ProfileManager::getStatistics() const
{
    return m_profileData["statistics"].toMap();
}
