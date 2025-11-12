#ifndef LESSON_H
#define LESSON_H

#include <QObject>
#include <QString>
#include <QVariantMap>

class Lesson : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int order READ order CONSTANT)
    Q_PROPERTY(QString type READ type CONSTANT)
    Q_PROPERTY(QVariantMap data READ data CONSTANT)

public:
    explicit Lesson(QObject *parent = nullptr);
    Lesson(const QVariantMap &data, QObject *parent = nullptr);

    int order() const { return m_order; }
    QString type() const { return m_type; }
    QVariantMap data() const { return m_data; }

    QVariantMap toVariantMap() const;

private:
    int m_order;
    QString m_type;
    QVariantMap m_data;
};

#endif // LESSON_H
