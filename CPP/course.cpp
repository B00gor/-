#include "H/course.h"

Course::Course(QObject *parent)
    : QObject(parent)
    , m_thumbnailHeight(0)
    , m_isPublished(false)
    , m_isPaid(false)
    , m_lessonCount(0)
{
}

Course::Course(const QVariantMap &data, QObject *parent)
    : QObject(parent)
{
    m_id = data["id"].toString();
    m_title = data["title"].toString();
    m_description = data["description"].toString();
    m_author = data["author"].toString();
    m_level = data["level"].toString();
    m_language = data["language"].toString();
    m_thumbnailPath = data["thumbnail_path"].toString();
    m_iconPath = data["icon_path"].toString();
    m_thumbnailHeight = data["thumbnail_height"].toInt();

    QVariantList tagsList = data["tags"].toList();
    for (const QVariant &tag : tagsList) {
        m_tags.append(tag.toString());
    }

    m_isPublished = data["is_published"].toBool();
    m_isPaid = data["is_paid"].toBool();
    m_lessonCount = data["lessonCount"].toInt();
}

QVariantMap Course::toVariantMap() const
{
    QVariantMap map;
    map["id"] = m_id;
    map["title"] = m_title;
    map["description"] = m_description;
    map["author"] = m_author;
    map["level"] = m_level;
    map["language"] = m_language;
    map["thumbnail_path"] = m_thumbnailPath;
    map["icon_path"] = m_iconPath;
    map["thumbnail_height"] = m_thumbnailHeight;
    map["tags"] = m_tags;
    map["is_published"] = m_isPublished;
    map["is_paid"] = m_isPaid;
    map["lessonCount"] = m_lessonCount;

    return map;
}
