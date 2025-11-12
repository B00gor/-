#ifndef COURSE_H
#define COURSE_H

#include <QObject>
#include <QString>
#include <QList>
#include <QVariantMap>

class Course : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString id READ id CONSTANT)
    Q_PROPERTY(QString title READ title CONSTANT)
    Q_PROPERTY(QString description READ description CONSTANT)
    Q_PROPERTY(QString author READ author CONSTANT)
    Q_PROPERTY(QString level READ level CONSTANT)
    Q_PROPERTY(QString language READ language CONSTANT)
    Q_PROPERTY(QString thumbnailPath READ thumbnailPath CONSTANT)
    Q_PROPERTY(QString iconPath READ iconPath CONSTANT)
    Q_PROPERTY(int thumbnailHeight READ thumbnailHeight CONSTANT)
    Q_PROPERTY(QStringList tags READ tags CONSTANT)
    Q_PROPERTY(bool isPublished READ isPublished CONSTANT)
    Q_PROPERTY(bool isPaid READ isPaid CONSTANT)
    Q_PROPERTY(int lessonCount READ lessonCount CONSTANT)

public:
    explicit Course(QObject *parent = nullptr);
    Course(const QVariantMap &data, QObject *parent = nullptr);

    QString id() const { return m_id; }
    QString title() const { return m_title; }
    QString description() const { return m_description; }
    QString author() const { return m_author; }
    QString level() const { return m_level; }
    QString language() const { return m_language; }
    QString thumbnailPath() const { return m_thumbnailPath; }
    QString iconPath() const { return m_iconPath; }
    int thumbnailHeight() const { return m_thumbnailHeight; }
    QStringList tags() const { return m_tags; }
    bool isPublished() const { return m_isPublished; }
    bool isPaid() const { return m_isPaid; }
    int lessonCount() const { return m_lessonCount; }

    QVariantMap toVariantMap() const;

private:
    QString m_id;
    QString m_title;
    QString m_description;
    QString m_author;
    QString m_level;
    QString m_language;
    QString m_thumbnailPath;
    QString m_iconPath;
    int m_thumbnailHeight;
    QStringList m_tags;
    bool m_isPublished;
    bool m_isPaid;
    int m_lessonCount;
};

#endif // COURSE_H
