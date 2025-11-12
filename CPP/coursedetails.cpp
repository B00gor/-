#include "H/coursedetails.h"

CourseDetails::CourseDetails(QObject *parent)
    : QObject(parent)
    , m_lessonCount(0)
{
}

CourseDetails::CourseDetails(const QVariantMap &data, QObject *parent)
    : QObject(parent)
{
    m_courseId = data["course_id"].toString();
    m_title = data["title"].toString();
    m_author = data["author"].toString();
    m_level = data["level"].toString();
    m_lessonCount = data["lessonCount"].toInt();

    QVariantList itemsList = data["items"].toList();
    for (const QVariant &item : itemsList) {
        m_items.append(item.toMap());
    }
}

void CourseDetails::addLesson(Lesson *lesson)
{
    m_items.append(lesson->toVariantMap());
}

QVariantMap CourseDetails::toVariantMap() const
{
    QVariantMap map;
    map["course_id"] = m_courseId;
    map["title"] = m_title;
    map["author"] = m_author;
    map["level"] = m_level;
    map["lessonCount"] = m_lessonCount;
    map["items"] = m_items;

    return map;
}
