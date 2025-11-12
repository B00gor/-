#include "H/coursemanager.h"
#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QStandardPaths>
#include <QDir>
#include <QTimer>
#include <QDebug>

CourseManager::CourseManager(QObject *parent)
    : QObject(parent)
    , m_loading(false)
{
    m_networkManager = new QNetworkAccessManager(this);
    connect(m_networkManager, &QNetworkAccessManager::finished,
            this, &CourseManager::onApiReplyFinished);

    // Для тестирования - инициализируем локальные данные
    initializeLocalData();
}

CourseManager& CourseManager::instance()
{
    static CourseManager instance;
    return instance;
}

QVariantList CourseManager::allCourses() const
{
    QVariantList list;
    for (Course* course : m_courses) {
        list.append(course->toVariantMap());
    }
    return list;
}

QVariantList CourseManager::myCourses() const
{
    // Пока возвращаем все курсы как "мои"
    // В будущем можно добавить логику подписок
    return allCourses();
}

QVariantList CourseManager::createdCourses() const
{
    // Пока возвращаем пустой список созданных курсов
    // В будущем можно добавить логику создания курсов
    return QVariantList();
}

QVariantMap CourseManager::getCourse(const QString &courseId) const
{
    for (Course* course : m_courses) {
        if (course->id() == courseId) {
            return course->toVariantMap();
        }
    }
    return QVariantMap();
}

QVariantMap CourseManager::getCourseDetails(const QString &courseId) const
{
    for (CourseDetails* details : m_courseDetails) {
        if (details->courseId() == courseId) {
            return details->toVariantMap();
        }
    }
    return QVariantMap();
}

void CourseManager::loadCourses()
{
    setLoading(true);

    // В будущем здесь будет HTTP запрос к API
    // Пока используем локальные данные
    QTimer::singleShot(500, this, [this]() {
        emit allCoursesChanged();
        setLoading(false);
    });
}

void CourseManager::loadCourseDetails(const QString &courseId)
{
    setLoading(true);

    // В будущем здесь будет HTTP запрос к API
    // Пока используем локальные данные
    QTimer::singleShot(300, this, [this, courseId]() {
        // Ищем детали курса в локальных данных
        for (CourseDetails* details : m_courseDetails) {
            if (details->courseId() == courseId) {
                emit courseDetailsLoaded(courseId);
                break;
            }
        }
        setLoading(false);
    });
}

void CourseManager::createCourse(const QVariantMap &courseData)
{
    // В будущем здесь будет POST запрос к API
    Course* newCourse = new Course(courseData, this);
    m_courses.append(newCourse);

    emit courseCreated(newCourse->id());
    emit allCoursesChanged();
}

void CourseManager::updateCourse(const QString &courseId, const QVariantMap &courseData)
{
    // В будущем здесь будет PUT запрос к API
    for (int i = 0; i < m_courses.size(); ++i) {
        if (m_courses[i]->id() == courseId) {
            // Обновляем курс (в реальности нужно пересоздать)
            Course* updatedCourse = new Course(courseData, this);
            delete m_courses[i];
            m_courses[i] = updatedCourse;

            emit courseUpdated(courseId);
            emit allCoursesChanged();
            break;
        }
    }
}

void CourseManager::deleteCourse(const QString &courseId)
{
    // В будущем здесь будет DELETE запрос к API
    for (int i = 0; i < m_courses.size(); ++i) {
        if (m_courses[i]->id() == courseId) {
            delete m_courses[i];
            m_courses.removeAt(i);

            emit courseDeleted(courseId);
            emit allCoursesChanged();
            break;
        }
    }
}

void CourseManager::enrollInCourse(const QString &courseId)
{
    // В будущем здесь будет POST запрос к API для записи на курс
    qDebug() << "Enrolling in course:" << courseId;
    emit enrollmentStatusChanged(courseId, true);
}

void CourseManager::onApiReplyFinished(QNetworkReply *reply)
{
    // Обработка HTTP ответов от API
    if (reply->error() == QNetworkReply::NoError) {
        QByteArray response = reply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson(response);

        // Здесь будет парсинг ответа и обновление данных
        qDebug() << "API Response:" << doc.toJson();
    } else {
        emit apiError(reply->errorString());
    }

    reply->deleteLater();
    setLoading(false);
}

void CourseManager::loadFromLocalStorage()
{
    // Загрузка из локальных JSON файлов
    QString dataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(dataPath);
    if (!dir.exists()) {
        dir.mkpath(".");
    }

    // Загрузка списка курсов
    QFile coursesFile(dir.filePath("courses.json"));
    if (coursesFile.open(QIODevice::ReadOnly)) {
        QJsonDocument doc = QJsonDocument::fromJson(coursesFile.readAll());
        QVariantMap data = doc.object().toVariantMap();
        QVariantList coursesList = data["courses"].toList();

        for (const QVariant &courseData : coursesList) {
            Course* course = new Course(courseData.toMap(), this);
            m_courses.append(course);
        }
        coursesFile.close();
    }

    // Загрузка деталей курсов
    QFile pythonCourseFile(dir.filePath("course_python.json"));
    if (pythonCourseFile.open(QIODevice::ReadOnly)) {
        QJsonDocument doc = QJsonDocument::fromJson(pythonCourseFile.readAll());
        CourseDetails* details = new CourseDetails(doc.object().toVariantMap(), this);
        m_courseDetails.append(details);
        pythonCourseFile.close();
    }
}

void CourseManager::saveToLocalStorage()
{
    // Сохранение в локальные JSON файлы
    QString dataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(dataPath);

    // Сохранение списка курсов
    QFile coursesFile(dir.filePath("courses.json"));
    if (coursesFile.open(QIODevice::WriteOnly)) {
        QVariantMap data;
        QVariantList coursesList;

        for (Course* course : m_courses) {
            coursesList.append(course->toVariantMap());
        }

        data["courses"] = coursesList;
        data["version"] = "1.0";
        data["last_updated"] = QDateTime::currentDateTime().toString(Qt::ISODate);

        QJsonDocument doc = QJsonDocument::fromVariant(data);
        coursesFile.write(doc.toJson());
        coursesFile.close();
    }
}

void CourseManager::initializeLocalData()
{
    // Создание тестовых данных если локальные файлы отсутствуют

    // Курс Python
    QVariantMap pythonCourse;
    pythonCourse["id"] = "e4b2faac-525a-4790-9b98-467ea8cdf447";
    pythonCourse["title"] = "Python для начинающих";
    pythonCourse["description"] = "Полный курс по основам Python";
    pythonCourse["author"] = "Python Boogor";
    pythonCourse["level"] = "средний";
    pythonCourse["language"] = "ru";
    pythonCourse["thumbnail_path"] = "qrc:/images/pythonLogo.webp";
    pythonCourse["icon_path"] = "qrc:/images/python.webp";
    pythonCourse["thumbnail_height"] = 200;
    pythonCourse["tags"] = QVariantList{"python", "django", "flask", "pandas"};
    pythonCourse["is_published"] = true;
    pythonCourse["is_paid"] = false;
    pythonCourse["lessonCount"] = 6;

    Course* pythonCourseObj = new Course(pythonCourse, this);
    m_courses.append(pythonCourseObj);

    // Курс JavaScript
    QVariantMap jsCourse;
    jsCourse["id"] = "a1c3f8d2-9e4b-4f1a-8c7d-2b5e6a9f0c3d";
    jsCourse["title"] = "JavaScript современный";
    jsCourse["description"] = "Освойте JavaScript от синтаксиса до асинхронного программирования";
    jsCourse["author"] = "Javascript Master";
    jsCourse["level"] = "начинающий";
    jsCourse["language"] = "ru";
    jsCourse["thumbnail_path"] = "qrc:/images/javascriptLogo.webp";
    jsCourse["icon_path"] = "qrc:/images/javascript.webp";
    jsCourse["thumbnail_height"] = 120;
    jsCourse["tags"] = QVariantList{"javascript", "react", "node.js", "vue.js"};
    jsCourse["is_published"] = true;
    jsCourse["is_paid"] = false;
    jsCourse["lessonCount"] = 5;

    Course* jsCourseObj = new Course(jsCourse, this);
    m_courses.append(jsCourseObj);

    // Детали курса Python
    QVariantMap pythonDetails;
    pythonDetails["course_id"] = "e4b2faac-525a-4790-9b98-467ea8cdf447";
    pythonDetails["title"] = "Python для начинающих";
    pythonDetails["author"] = "Python Boogor";
    pythonDetails["level"] = "средний";
    pythonDetails["lessonCount"] = 6;

    QVariantList pythonItems;

    QVariantMap lesson1;
    lesson1["order"] = 1;
    lesson1["type"] = "video";
    lesson1["data"] = QVariantMap{
        {"id", "f3a1b9c8-2d4e-4f6a-9b8c-1d2e3f4a5b6c"},
        {"title", "Установка Python и настройка окружения"},
        {"filename", "01/python_env.mp4"},
        {"duration_seconds", 1515},
        {"has_subtitles", true},
        {"has_notes", true},
        {"likes", 245},
        {"views", 1520},
        {"completed_seconds", 1180},
        {"is_favorite", false}
    };
    pythonItems.append(lesson1);

    // Добавляем остальные уроки...

    pythonDetails["items"] = pythonItems;

    CourseDetails* pythonDetailsObj = new CourseDetails(pythonDetails, this);
    m_courseDetails.append(pythonDetailsObj);

    // Сохраняем в локальные файлы
    saveToLocalStorage();
}

void CourseManager::setLoading(bool loading)
{
    if (m_loading != loading) {
        m_loading = loading;
        emit isLoadingChanged();
    }
}
