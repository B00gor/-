#ifndef COURSEMANAGER_H
#define COURSEMANAGER_H

#include <QObject>
#include <QList>
#include <QVariantMap>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include "H/course.h"
#include "H/coursedetails.h"

class CourseManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList allCourses READ allCourses NOTIFY allCoursesChanged)
    Q_PROPERTY(QVariantList myCourses READ myCourses NOTIFY myCoursesChanged)
    Q_PROPERTY(QVariantList createdCourses READ createdCourses NOTIFY createdCoursesChanged)
    Q_PROPERTY(bool isLoading READ isLoading NOTIFY isLoadingChanged)

public:
    explicit CourseManager(QObject *parent = nullptr);
    static CourseManager& instance();

    // Основные методы для QML
    Q_INVOKABLE QVariantList allCourses() const;
    Q_INVOKABLE QVariantList myCourses() const;
    Q_INVOKABLE QVariantList createdCourses() const;
    Q_INVOKABLE QVariantMap getCourse(const QString &courseId) const;
    Q_INVOKABLE QVariantMap getCourseDetails(const QString &courseId) const;
    Q_INVOKABLE void loadCourses();
    Q_INVOKABLE void loadCourseDetails(const QString &courseId);

    // Методы для работы с API (будут использоваться с Drogon)
    Q_INVOKABLE void createCourse(const QVariantMap &courseData);
    Q_INVOKABLE void updateCourse(const QString &courseId, const QVariantMap &courseData);
    Q_INVOKABLE void deleteCourse(const QString &courseId);
    Q_INVOKABLE void enrollInCourse(const QString &courseId);

    bool isLoading() const { return m_loading; }

signals:
    void allCoursesChanged();
    void myCoursesChanged();
    void createdCoursesChanged();
    void isLoadingChanged();
    void courseDetailsLoaded(const QString &courseId);
    void courseCreated(const QString &courseId);
    void courseUpdated(const QString &courseId);
    void courseDeleted(const QString &courseId);
    void enrollmentStatusChanged(const QString &courseId, bool enrolled);

    // Сигналы ошибок для API
    void apiError(const QString &errorMessage);

private slots:
    void onApiReplyFinished(QNetworkReply *reply);

private:
    void setLoading(bool loading);
    void loadFromLocalStorage();
    void saveToLocalStorage();
    void initializeLocalData(); // Создает начальные данные если нет файлов

    QNetworkAccessManager *m_networkManager;
    QList<Course*> m_courses;
    QList<CourseDetails*> m_courseDetails;
    bool m_loading;

    // Для будущей интеграции с API
    QString m_apiBaseUrl;
    QString m_authToken;
};

#endif // COURSEMANAGER_H
