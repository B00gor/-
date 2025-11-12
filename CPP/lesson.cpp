#include "H/lesson.h"

Lesson::Lesson(QObject *parent)
    : QObject(parent)
    , m_order(0)
{
}

Lesson::Lesson(const QVariantMap &data, QObject *parent)
    : QObject(parent)
{
    m_order = data["order"].toInt();
    m_type = data["type"].toString();
    m_data = data["data"].toMap();
}

QVariantMap Lesson::toVariantMap() const
{
    QVariantMap map;
    map["order"] = m_order;
    map["type"] = m_type;
    map["data"] = m_data;

    return map;
}
