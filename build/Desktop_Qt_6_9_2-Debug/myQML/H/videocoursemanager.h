#ifndef VIDEOMANAGER_H
#define VIDEOMANAGER_H

#include <QObject>
#include <QVariantMap>
#include <QVariantList>
#include <qnetworkaccessmanager.h>

class VideoCourseManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList allCourses READ allCourses NOTIFY allCoursesChanged)
    Q_PROPERTY(QVariantList myCourses READ myCourses NOTIFY myCoursesChanged)
    Q_PROPERTY(QVariantList createdCourses READ createdCourses NOTIFY createdCoursesChanged)

public:
    static VideoCourseManager& instance();

    // Основные методы для работы с курсами
    Q_INVOKABLE void createCourse(const QVariantMap &courseData);
    Q_INVOKABLE void enrollInCourse(const QString &courseId);
    Q_INVOKABLE void leaveCourse(const QString &courseId);
    Q_INVOKABLE void updateCourseProgress(const QString &courseId, int progress);
    Q_INVOKABLE void deleteCourse(const QString &courseId);
    Q_INVOKABLE void updateCourse(const QString &courseId, const QVariantMap &courseData);

    Q_INVOKABLE QVariantMap getCourse(const QString &courseId) const;
    Q_INVOKABLE void addLesson(const QString &courseId, const QVariantMap &lessonData);
    Q_INVOKABLE void removeLesson(const QString &courseId, const QString &lessonId);
    Q_INVOKABLE QVariantList getCoursesByAuthor(const QString &authorId) const;
    Q_INVOKABLE QVariantList getAllAuthors() const;

    // ДОБАВЬТЕ ЭТОТ МЕТОД
    Q_INVOKABLE QVariantMap getCourseProgress(const QString &courseId) const;

    // Геттеры
    QVariantList allCourses() const;
    QVariantList myCourses() const;
    QVariantList createdCourses() const;

    // Поиск и фильтрация
    Q_INVOKABLE QVariantList searchCourses(const QString &query) const;
    Q_INVOKABLE QVariantList getCoursesByChannelId(const QString &authorId) const;
    Q_INVOKABLE QVariantList getCoursesByCategory(const QString &category) const;
    Q_INVOKABLE QVariantList getRecommendedCourses() const;

signals:
    void allCoursesChanged();
    void myCoursesChanged();
    void createdCoursesChanged();
    void courseCreated(const QString &courseId);
    void courseUpdated(const QString &courseId);
    void courseDeleted(const QString &courseId);
    void courseEnrolled(const QString &courseId);
    void courseProgressUpdated(const QString &courseId, int progress);

private:
    void initializeFakeCourses();
    explicit VideoCourseManager(QObject *parent = nullptr);
    void loadFromFile();
    void saveToFile();
    QString generateCourseId() const;
    QString generateLessonId() const;

    QVariantList m_allCourses;
    QString m_dataPath;
    QNetworkAccessManager *m_networkManager;
};

#endif // VIDEOMANAGER_H
