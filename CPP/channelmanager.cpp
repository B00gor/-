#include "H/channelmanager.h"
#include "H/profilemanager.h"
#include "H/videocoursemanager.h"
#include <QStandardPaths>
#include <QDir>
#include <QFile>
#include <QJsonDocument>
#include <QDateTime>
#include <QJsonObject>
#include <QDebug>
#include <QUuid>

ChannelManager& ChannelManager::instance()
{
    static ChannelManager instance;
    return instance;
}

ChannelManager::ChannelManager(QObject *parent) : QObject(parent)
{
#ifdef Q_OS_WASM
    m_dataPath = "/channel.json";
#else
    QString dataDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(dataDir);
    if (!dir.exists()) dir.mkpath(".");
    m_dataPath = dir.filePath("channel.json");
#endif
    loadFromFile();
    //initializeFakeChannels();
}

void ChannelManager::initializeFakeChannels()
{

}

QVariantMap ChannelManager::loadChannelFromFile(const QString &channelId)
{
    QString userChannelPath;

#ifdef Q_OS_WASM
    userChannelPath = "/channel_" + channelId + ".json";
#else
    QString dataDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(dataDir);
    userChannelPath = dir.filePath("channel_" + channelId + ".json");
#endif

    qDebug() << "Loading channel from:" << userChannelPath;

    QFile file(userChannelPath);
    if (file.open(QIODevice::ReadOnly)) {
        QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
        QVariantMap channelData = doc.object().toVariantMap();
        file.close();

        // Добавляем публичные курсы канала
        auto &courseManager = VideoCourseManager::instance();
        QVariantList authorCourses = courseManager.getCoursesByChannelId(channelId);
        QVariantList publicCourses;

        for (const auto &course : authorCourses) {
            QVariantMap courseMap = course.toMap();
            if (courseMap["isPublic"].toBool()) {
                publicCourses.append(QVariantMap{
                    {"id", courseMap["id"]},
                    {"title", courseMap["title"]},
                    {"description", courseMap["description"]},
                    {"rating", courseMap["rating"]},
                    {"studentsCount", courseMap["studentsCount"]},
                    {"duration", courseMap["duration"]},
                    {"level", courseMap["level"]},
                    {"category", courseMap["category"]},
                    {"thumbnail_path", courseMap["thumbnail_path"]},
                    {"icon_path", courseMap["icon_path"]},
                    {"thumbnail_height", courseMap["thumbnail_height"]},
                    {"lessonCount", courseMap["lessonCount"]}
                });
            }
        }

        channelData["publicCourses"] = publicCourses;
        return channelData;
    }

    return QVariantMap();
}

void ChannelManager::loadChannel(const QString &channelId)
{
    m_loadedChannelData = loadChannelFromFile(channelId);
    emit loadedChannelDataChanged();

    qDebug() << "Channel loaded for channelId:" << channelId
             << "Has data:" << !m_loadedChannelData.isEmpty();
}

QVariantMap ChannelManager::getChannelData(const QString &channelId)
{
    return loadChannelFromFile(channelId);
}

QVariantList ChannelManager::getChannelCourses(const QString &channelId)
{
    auto &courseManager = VideoCourseManager::instance();
    QVariantList courses = courseManager.getCoursesByChannelId(channelId);

    qDebug() << "🔍 ChannelManager::getChannelCourses called for channelId:" << channelId;
    qDebug() << "📊 Found courses:" << courses.size();

    for (const auto &course : courses) {
        QVariantMap courseMap = course.toMap();
        qDebug() << "📚 Course:" << courseMap["title"].toString()
                 << "ID:" << courseMap["id"].toString()
                 << "Channel:" << courseMap["channelId"].toString();
    }

    return courses;
}

// В классе ChannelManager добавить:
QString ChannelManager::getChannelIdByUserName(const QString &userName)
{
    // В реальной системе здесь был бы поиск в базе данных
    // Пока используем хардкод для тестовых данных
    if (userName == "Python Boogor") {
        return "123e4567-e89b-12d3-a456-426614174000";
    } else if (userName == "Javascript Master") {
        return "123e4567-e89b-12d3-a456-426614174001";
    }
    return "";
}

// Добавить в класс ChannelManager
QVariantMap ChannelManager::getChannelByAuthorId(const QString &authorId) const
{
    // Создаем фейковый канал на основе authorId
    QVariantMap channelData;

    // Получаем курсы автора
    auto &courseManager = VideoCourseManager::instance();
    QVariantList authorCourses = courseManager.getCoursesByAuthor(authorId);

    // Создаем информацию о канале
    if (!authorCourses.isEmpty()) {
        QVariantMap firstCourse = authorCourses.first().toMap();
        QString authorName = firstCourse["author"].toString();

        channelData["id"] = authorId;
        channelData["channelInfo"] = QVariantMap{
            {"name", authorName},
            {"description", "Автор курсов по программированию"},
            {"subscribersCount", authorCourses.size() * 1000},
            {"createdAt", "2023-01-01T00:00:00Z"},
            {"avatar", firstCourse["icon_path"]},
            {"cover", firstCourse["thumbnail_path"]}
        };

        // Публичные данные
        channelData["publicCourses"] = authorCourses;
        channelData["contacts"] = QVariantList();
        channelData["information"] = QVariantList();
    }

    return channelData;
}

QVariantMap ChannelManager::loadedChannelData() const // Исправлено: правильное имя метода
{
    return m_loadedChannelData;
}

void ChannelManager::loadFromFile()
{
    QFile file(m_dataPath);
    if (file.open(QIODevice::ReadOnly)) {
        QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
        m_channelData = doc.object().toVariantMap();
        file.close();
    }
    // Если файла нет, канал не создан
}

void ChannelManager::saveToFile()
{
    if (isChannel()) {
        QFile file(m_dataPath);
        if (file.open(QIODevice::WriteOnly)) {
            QJsonDocument doc((QJsonObject::fromVariantMap(m_channelData)));
            file.write(doc.toJson());
            file.close();
        }
    } else {
        // Удаляем файл если канал удален
        QFile::remove(m_dataPath);
    }
}

// Остальные методы без изменений...
QVariantMap ChannelManager::createDefaultChannelData()
{
    return QVariantMap{
        {"isChannel", true},
        {"channelInfo", QVariantMap{
                            {"name", ""},
                            {"description", ""},
                            {"createdAt", QDateTime::currentDateTime().toString(Qt::ISODate)},
                            {"subscribersCount", 0},
                            {"isActive", true}
                        }},
        {"visibilitySettings", QVariantMap{
                                   {"profileIsPublic", true},
                                   {"contactsIsPublic", true},
                                   {"informationIsPublic", true},
                                   {"coursesIsPublic", true}
                               }}
    };
}

void ChannelManager::createChannel(const QString &name, const QString &description)
{
    m_channelData = createDefaultChannelData();

    QVariantMap channelInfo = m_channelData["channelInfo"].toMap();
    channelInfo["name"] = name;
    channelInfo["description"] = description;
    m_channelData["channelInfo"] = channelInfo;

    // Обновляем профиль пользователя
    auto &profileManager = ProfileManager::instance();
    profileManager.setUserName(name);
    profileManager.setUserRole(description);

    saveToFile();
    emit channelDataChanged();
    emit isChannelChanged();
    emit channelInfoUpdated();
}

void ChannelManager::deleteChannel()
{
    m_channelData.clear();
    saveToFile();
    emit channelDataChanged();
    emit isChannelChanged();
}

void ChannelManager::updateChannelInfo(const QVariantMap &channelInfo)
{
    if (isChannel()) {
        m_channelData["channelInfo"] = channelInfo;
        saveToFile();
        emit channelDataChanged();
        emit channelInfoUpdated();
    }
}

QVariantMap ChannelManager::channelData() const
{
    if (!isChannel()) {
        return QVariantMap();
    }

    QVariantMap data = m_channelData;
    data["publicProfile"] = filterPublicProfile();
    data["publicCourses"] = filterPublicCourses();

    return data;
}

bool ChannelManager::isChannel() const
{
    return m_channelData["isChannel"].toBool();
}

QVariantMap ChannelManager::filterPublicProfile() const
{
    QVariantMap result;
    QVariantMap visibility = m_channelData["visibilitySettings"].toMap();

    auto &profileManager = ProfileManager::instance();
    QVariantMap fullProfile = profileManager.fullProfile();

    // Публичный профиль
    if (visibility["profileIsPublic"].toBool()) {
        QVariantMap profile = fullProfile["profile"].toMap();
        profile["userName"] = fullProfile["userName"];
        profile["userRole"] = fullProfile["userRole"];
        profile["avatar"] = fullProfile["avatar"];
        result["profile"] = profile;
    } else {
        result["profile"] = QVariantMap{
            {"userName", fullProfile["userName"]},
            {"userRole", fullProfile["userRole"]},
            {"avatar", fullProfile["avatar"]}
        };
    }

    // Публичные контакты
    QVariantList publicContacts;
    if (visibility["contactsIsPublic"].toBool()) {
        QVariantList contacts = fullProfile["contacts"].toList();
        for (const auto &contact : contacts) {
            QVariantMap contactMap = contact.toMap();
            if (contactMap["isPublic"].toBool()) {
                publicContacts.append(contactMap);
            }
        }
    }
    result["contacts"] = publicContacts;

    // Публичная информация
    QVariantList publicInformation;
    if (visibility["informationIsPublic"].toBool()) {
        QVariantList information = fullProfile["information"].toList();
        for (const auto &info : information) {
            QVariantMap infoMap = info.toMap();
            if (infoMap["isPublic"].toBool()) {
                // ИСПРАВЛЕНО: правильная структура для QML
                publicInformation.append(QVariantMap{
                    {"label", infoMap["label"]},
                    {"value", infoMap["value"]},
                    {"isPublic", infoMap["isPublic"]}
                });
            }
        }
    }
    result["information"] = publicInformation;

    // Публичные курсы
    result["courses"] = filterPublicCourses();

    return result;
}

QVariantList ChannelManager::filterPublicCourses() const
{
    QVariantList publicCourses;
    auto &courseManager = VideoCourseManager::instance();
    QVariantList createdCourses = courseManager.createdCourses();

    for (const auto &course : createdCourses) {
        QVariantMap courseMap = course.toMap();
        if (courseMap["isPublic"].toBool()) {
            // Оставляем только публичную информацию о курсе
            publicCourses.append(QVariantMap{
                {"id", courseMap["id"]},
                {"title", courseMap["title"]},
                {"description", courseMap["description"]},
                {"rating", courseMap["rating"]},
                {"studentsCount", courseMap["studentsCount"]},
                {"duration", courseMap["duration"]},
                {"level", courseMap["level"]},
                {"category", courseMap["category"]}
            });
        }
    }

    return publicCourses;
}

// В класс ChannelManager добавить метод для получения authorId по channelId
QString ChannelManager::getAuthorIdByChannelId(const QString &channelId) const
{
    // Сопоставление channelId из JSON с authorId из курсов
    if (channelId == "123e4567-e89b-12d3-a456-426614174000") {
        return "user_alexey_petrov";
    } else if (channelId == "123e4567-e89b-12d3-a456-426614174001") {
        return "user_maria_ivanova";
    }
    return channelId; // Если нет соответствия, используем channelId как authorId
}

// Обновить метод getPublicProfile
QVariantMap ChannelManager::getPublicProfile(const QString &channelId)
{
    qDebug() << "🔍 Getting public profile for channelId:" << channelId;

    // Получаем соответствующий authorId
    QString authorId = getAuthorIdByChannelId(channelId);
    qDebug() << "🔍 Mapped authorId:" << authorId;

    // Используем новый метод для получения канала по authorId
    QVariantMap channelData = getChannelByAuthorId(authorId);
    if (channelData.isEmpty()) {
        qDebug() << "❌ No channel data found for authorId:" << authorId;
        return QVariantMap();
    }

    // Загружаем реальные данные канала из файла
    QVariantMap realChannelData = loadChannelFromFile(channelId);
    qDebug() << "📁 Real channel data loaded:" << !realChannelData.isEmpty();

    QVariantMap publicData;
    QVariantMap channelInfo = channelData["channelInfo"].toMap();

    // Объединяем данные: берем реальные данные канала, если есть, иначе используем сгенерированные
    if (!realChannelData.isEmpty()) {
        QVariantMap realChannelInfo = realChannelData["channelInfo"].toMap();
        publicData["channelName"] = realChannelInfo["name"].toString();
        publicData["description"] = realChannelInfo["description"].toString();
        publicData["subscribersCount"] = realChannelInfo["subscribersCount"].toInt();
        publicData["createdAt"] = realChannelInfo["createdAt"].toString();
        publicData["avatar"] = realChannelInfo["avatar"].toString();
        publicData["cover"] = realChannelInfo["cover"].toString();

        // Берем реальные контакты и информацию из файла канала
        publicData["contacts"] = realChannelData["contacts"].toList();
        publicData["information"] = realChannelData["information"].toList();
    } else {
        publicData["channelName"] = channelInfo["name"];
        publicData["description"] = channelInfo["description"];
        publicData["subscribersCount"] = channelInfo["subscribersCount"];
        publicData["createdAt"] = channelInfo["createdAt"];
        publicData["avatar"] = channelInfo["avatar"];
        publicData["cover"] = channelInfo["cover"];

        // Добавляем тестовые контакты и информацию
        publicData["contacts"] = QVariantList{
            QVariantMap{
                {"type", "Email"},
                {"value", "author@example.com"},
                {"isPublic", true}
            },
            QVariantMap{
                {"type", "Telegram"},
                {"value", "@author_channel"},
                {"isPublic", true}
            }
        };

        publicData["information"] = QVariantList{
            QVariantMap{
                {"label", "Специализация"},
                {"value", "Программирование и разработка"},
                {"isPublic", true}
            },
            QVariantMap{
                {"label", "Опыт"},
                {"value", "5+ лет преподавания"},
                {"isPublic", true}
            }
        };
    }

    publicData["channelId"] = channelId;

    // Добавляем публичные курсы
    publicData["courses"] = channelData["publicCourses"].toList();

    qDebug() << "✅ Public profile created for channelId:" << channelId;
    qDebug() << "📊 Channel name:" << publicData["channelName"].toString();
    qDebug() << "📝 Description:" << publicData["description"].toString();
    qDebug() << "👥 Subscribers:" << publicData["subscribersCount"].toInt();
    qDebug() << "📚 Courses count:" << publicData["courses"].toList().size();

    return publicData;
}

// Обновить метод getCoursesByAuthorId
QVariantList ChannelManager::getCoursesByAuthorId(const QString &authorId) const
{
    qDebug() << "🔍 Getting courses by authorId:" << authorId;
    auto &courseManager = VideoCourseManager::instance();
    QVariantList courses = courseManager.getCoursesByAuthor(authorId);
    qDebug() << "📚 Found courses:" << courses.size();
    return courses;
}
