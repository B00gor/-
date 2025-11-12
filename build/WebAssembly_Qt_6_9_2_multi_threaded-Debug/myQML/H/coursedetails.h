#ifndef COURSEDETAILS_H
#define COURSEDETAILS_H

#include <QObject>
#include <QString>
#include <QList>
#include <QVariantMap>
#include "H/lesson.h"

class CourseDetails : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString courseId READ courseId CONSTANT)
    Q_PROPERTY(QString title READ title CONSTANT)
    Q_PROPERTY(QString author READ author CONSTANT)
    Q_PROPERTY(QString level READ level CONSTANT)
    Q_PROPERTY(int lessonCount READ lessonCount CONSTANT)
    Q_PROPERTY(QVariantList items READ items CONSTANT)

public:
    explicit CourseDetails(QObject *parent = nullptr);
    CourseDetails(const QVariantMap &data, QObject *parent = nullptr);

    QString courseId() const { return m_courseId; }
    QString title() const { return m_title; }
    QString author() const { return m_author; }
    QString level() const { return m_level; }
    int lessonCount() const { return m_lessonCount; }
    QVariantList items() const { return m_items; }

    void addLesson(Lesson *lesson);
    QVariantMap toVariantMap() const;

private:
    QString m_courseId;
    QString m_title;
    QString m_author;
    QString m_level;
    int m_lessonCount;
    QVariantList m_items;
};

#endif // COURSEDETAILS_H
