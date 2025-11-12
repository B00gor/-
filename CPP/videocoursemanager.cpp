#include "H/videocoursemanager.h"
#include "H/profilemanager.h"
#include <QStandardPaths>
#include <QDir>
#include <QFile>
#include <QJsonDocument>
#include <QDateTime>
#include <QDebug>
#include <QUuid>
#include <qjsonobject.h>
#include <qnetworkaccessmanager.h>

VideoCourseManager& VideoCourseManager::instance()
{
    static VideoCourseManager instance;
    return instance;
}

VideoCourseManager::VideoCourseManager(QObject *parent) : QObject(parent)
{
#ifdef Q_OS_WASM
    m_dataPath = "/courses.json";
#else
    QString dataDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(dataDir);
    if (!dir.exists()) dir.mkpath(".");
    m_dataPath = dir.filePath("courses.json");
#endif

    m_networkManager = new QNetworkAccessManager(this);
    loadFromFile();

    // Если нет курсов, инициализируем фейковые данные
    if (m_allCourses.isEmpty()) {
        initializeFakeCourses();
        saveToFile();
    }
}

QVariantList VideoCourseManager::getCoursesByAuthor(const QString &authorId) const
{
    QVariantList result;
    qDebug() << "🔍 Searching courses by author:" << authorId;

    for (const auto &course : m_allCourses) {
        QVariantMap courseMap = course.toMap();
        QString courseAuthorId = courseMap["authorId"].toString();

        if (courseAuthorId == authorId) {
            qDebug() << "✅ Found course:" << courseMap["title"].toString();

            // Добавляем полную информацию о курсе
            QVariantMap fullCourse = courseMap;
            fullCourse["cover"] = courseMap["thumbnail_path"];
            fullCourse["lessonCount"] = courseMap["lessonCount"];
            fullCourse["studentsCount"] = courseMap["studentsCount"];
            fullCourse["rating"] = courseMap["rating"];

            result.append(fullCourse);
        }
    }

    qDebug() << "📊 Total courses found for author" << authorId << ":" << result.size();
    return result;
}

QVariantList VideoCourseManager::getAllAuthors() const
{
    QSet<QString> authorIds;
    QVariantList authors;

    for (const auto &course : m_allCourses) {
        QVariantMap courseMap = course.toMap();
        QString authorId = courseMap["authorId"].toString();
        QString authorName = courseMap["author"].toString();

        if (!authorIds.contains(authorId) && !authorId.isEmpty()) {
            authorIds.insert(authorId);
            authors.append(QVariantMap{
                {"id", authorId},
                {"name", authorName},
                {"courseCount", getCoursesByAuthor(authorId).size()}
            });
        }
    }

    return authors;
}

// Обновляем метод поиска курсов по channelId
QVariantList VideoCourseManager::getCoursesByChannelId(const QString &channelId) const
{
    QVariantList result;
    qDebug() << "🔍 Searching courses by channelId:" << channelId;

    for (const auto &course : m_allCourses) {
        QVariantMap courseMap = course.toMap();
        QString courseChannelId = courseMap["channelId"].toString();

        if (courseChannelId == channelId) {
            qDebug() << "✅ Found course:" << courseMap["title"].toString();
            result.append(courseMap);
        }
    }

    qDebug() << "📊 Total courses found for channelId" << channelId << ":" << result.size();
    return result;
}

void VideoCourseManager::loadFromFile()
{
    QFile file(m_dataPath);
    if (file.open(QIODevice::ReadOnly)) {
        QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
        QVariantMap data = doc.object().toVariantMap();
        m_allCourses = data["allCourses"].toList();
        file.close();
        qDebug() << "📁 Courses loaded from file. Count:" << m_allCourses.size();
    } else {
        qDebug() << "📁 No courses file found, will use fake data";
    }
}

void VideoCourseManager::saveToFile()
{
    QFile file(m_dataPath);
    if (file.open(QIODevice::WriteOnly)) {
        QVariantMap data;
        data["allCourses"] = m_allCourses;
        data["version"] = "1.0";
        data["last_updated"] = QDateTime::currentDateTime().toString(Qt::ISODate);

        QJsonDocument doc(QJsonObject::fromVariantMap(data));
        file.write(doc.toJson());
        file.close();
        qDebug() << "💾 Courses saved to file. Count:" << m_allCourses.size();
    }
}

// Остальные методы VideoCourseManager остаются без изменений...
QVariantList VideoCourseManager::allCourses() const
{
    return m_allCourses;
}

QVariantMap VideoCourseManager::getCourse(const QString &courseId) const
{
    for (const auto &course : m_allCourses) {
        QVariantMap courseMap = course.toMap();
        if (courseMap["id"].toString() == courseId) {
            return courseMap;
        }
    }
    return QVariantMap();
}

void VideoCourseManager::createCourse(const QVariantMap &courseData)
{
    QVariantMap course = courseData;
    course["id"] = generateCourseId();
    course["authorId"] = ProfileManager::instance().userName();
    course["createdAt"] = QDateTime::currentDateTime().toString(Qt::ISODate);
    course["updatedAt"] = QDateTime::currentDateTime().toString(Qt::ISODate);
    course["studentsCount"] = 0;
    course["rating"] = 0.0;
    course["enrolledStudents"] = QVariantList();
    course["lessons"] = QVariantList();
    course["isPublic"] = course.value("isPublic", true).toBool();

    if (!course.contains("price")) {
        course["price"] = 0;
    }

    m_allCourses.append(course);
    saveToFile();

    emit allCoursesChanged();
    emit createdCoursesChanged();
    emit courseCreated(course["id"].toString());
}

void VideoCourseManager::enrollInCourse(const QString &courseId)
{
    QString currentUser = ProfileManager::instance().userName();

    for (int i = 0; i < m_allCourses.size(); ++i) {
        QVariantMap course = m_allCourses[i].toMap();
        if (course["id"].toString() == courseId) {
            QVariantList enrolledStudents = course["enrolledStudents"].toList();
            if (!enrolledStudents.contains(currentUser)) {
                enrolledStudents.append(currentUser);
                course["enrolledStudents"] = enrolledStudents;
                course["studentsCount"] = enrolledStudents.size();
                m_allCourses[i] = course;
                saveToFile();

                emit allCoursesChanged();
                emit myCoursesChanged();
                emit courseEnrolled(courseId);
            }
            break;
        }
    }
}

void VideoCourseManager::leaveCourse(const QString &courseId)
{
    QString currentUser = ProfileManager::instance().userName();

    for (int i = 0; i < m_allCourses.size(); ++i) {
        QVariantMap course = m_allCourses[i].toMap();
        if (course["id"].toString() == courseId) {
            QVariantList enrolledStudents = course["enrolledStudents"].toList();
            if (enrolledStudents.contains(currentUser)) {
                enrolledStudents.removeAll(currentUser);
                course["enrolledStudents"] = enrolledStudents;
                course["studentsCount"] = enrolledStudents.size();
                m_allCourses[i] = course;
                saveToFile();

                emit allCoursesChanged();
                emit myCoursesChanged();
            }
            break;
        }
    }
}

void VideoCourseManager::updateCourseProgress(const QString &courseId, int progress)
{
    // Создаем временное решение, пока ProfileManager не будет обновлен
    // Временное решение: сохраняем прогресс в самом курсе
    for (int i = 0; i < m_allCourses.size(); ++i) {
        QVariantMap course = m_allCourses[i].toMap();
        if (course["id"].toString() == courseId) {
            course["userProgress"] = progress;
            m_allCourses[i] = course;
            saveToFile();
            emit allCoursesChanged();
            break;
        }
    }
    emit courseProgressUpdated(courseId, progress);
}

void VideoCourseManager::deleteCourse(const QString &courseId)
{
    for (int i = 0; i < m_allCourses.size(); ++i) {
        if (m_allCourses[i].toMap()["id"].toString() == courseId) {
            m_allCourses.removeAt(i);
            saveToFile();
            emit allCoursesChanged();
            emit createdCoursesChanged();
            emit myCoursesChanged();
            break;
        }
    }
}

void VideoCourseManager::updateCourse(const QString &courseId, const QVariantMap &courseData)
{
    for (int i = 0; i < m_allCourses.size(); ++i) {
        QVariantMap course = m_allCourses[i].toMap();
        if (course["id"].toString() == courseId) {
            QVariantMap updatedCourse = course;
            for (auto it = courseData.constBegin(); it != courseData.constEnd(); ++it) {
                if (it.key() != "id") {
                    updatedCourse[it.key()] = it.value();
                }
            }
            updatedCourse["updatedAt"] = QDateTime::currentDateTime().toString(Qt::ISODate);
            m_allCourses[i] = updatedCourse;
            saveToFile();
            emit allCoursesChanged();
            emit createdCoursesChanged();
            break;
        }
    }
}

void VideoCourseManager::addLesson(const QString &courseId, const QVariantMap &lessonData)
{
    for (int i = 0; i < m_allCourses.size(); ++i) {
        QVariantMap course = m_allCourses[i].toMap();
        if (course["id"].toString() == courseId) {
            QVariantList lessons = course["lessons"].toList();
            QVariantMap lesson = lessonData;
            lesson["id"] = generateLessonId();
            lessons.append(lesson);
            course["lessons"] = lessons;
            course["updatedAt"] = QDateTime::currentDateTime().toString(Qt::ISODate);
            m_allCourses[i] = course;
            saveToFile();
            emit allCoursesChanged();
            break;
        }
    }
}

void VideoCourseManager::removeLesson(const QString &courseId, const QString &lessonId)
{
    for (int i = 0; i < m_allCourses.size(); ++i) {
        QVariantMap course = m_allCourses[i].toMap();
        if (course["id"].toString() == courseId) {
            QVariantList lessons = course["lessons"].toList();
            for (int j = 0; j < lessons.size(); ++j) {
                if (lessons[j].toMap()["id"].toString() == lessonId) {
                    lessons.removeAt(j);
                    course["lessons"] = lessons;
                    course["updatedAt"] = QDateTime::currentDateTime().toString(Qt::ISODate);
                    m_allCourses[i] = course;
                    saveToFile();
                    emit allCoursesChanged();
                    break;
                }
            }
            break;
        }
    }
}

// В методе myCourses() замените:
QVariantList VideoCourseManager::myCourses() const
{
    QVariantList result;
    QString currentUser = ProfileManager::instance().userName();

    for (const auto &course : m_allCourses) {
        QVariantMap courseMap = course.toMap();
        QVariantList enrolledStudents = courseMap["enrolledStudents"].toList();

        if (enrolledStudents.contains(currentUser)) {
            QString courseId = courseMap["id"].toString();

            // Используем обновленный ProfileManager с QString
            QVariantMap progress = ProfileManager::instance().getCourseProgress(courseId);
            courseMap["progress"] = progress["progress"];
            courseMap["isCompleted"] = progress["isCompleted"];
            result.append(courseMap);
        }
    }

    return result;
}

QVariantList VideoCourseManager::searchCourses(const QString &query) const
{
    QVariantList result;
    QString lowerQuery = query.toLower();

    for (const auto &course : m_allCourses) {
        QVariantMap courseMap = course.toMap();
        QString title = courseMap["title"].toString().toLower();
        QString description = courseMap["description"].toString().toLower();
        QString category = courseMap["category"].toString().toLower();

        if (title.contains(lowerQuery) ||
            description.contains(lowerQuery) ||
            category.contains(lowerQuery)) {
            result.append(courseMap);
        }
    }

    return result;
}


QVariantList VideoCourseManager::getCoursesByCategory(const QString &category) const
{
    QVariantList result;

    for (const auto &course : m_allCourses) {
        QVariantMap courseMap = course.toMap();
        if (courseMap["category"].toString() == category) {
            result.append(courseMap);
        }
    }

    return result;
}

QVariantList VideoCourseManager::getRecommendedCourses() const
{
    QVariantList result;
    QString currentUser = ProfileManager::instance().userName();

    QVariantList myCoursesList = myCourses();
    QSet<QString> enrolledCategories;

    for (const auto &course : myCoursesList) {
        enrolledCategories.insert(course.toMap()["category"].toString());
    }

    for (const auto &course : m_allCourses) {
        QVariantMap courseMap = course.toMap();
        QString category = courseMap["category"].toString();
        QVariantList enrolledStudents = courseMap["enrolledStudents"].toList();

        if (!enrolledStudents.contains(currentUser) &&
            enrolledCategories.contains(category)) {
            result.append(courseMap);
        }

        if (result.size() >= 5) break;
    }

    return result;
}
QVariantMap VideoCourseManager::getCourseProgress(const QString &courseId) const
{
    // Временная реализация - возвращаем прогресс из самого курса
    // Или делегируем вызов ProfileManager, если он уже обновлен для работы с QString

    // Вариант 1: Возвращаем прогресс из данных курса
    QVariantMap course = getCourse(courseId);
    if (!course.isEmpty()) {
        int progress = course.contains("userProgress") ? course["userProgress"].toInt() : 0;
        bool isCompleted = progress >= 100;

        return QVariantMap{
            {"progress", progress},
            {"isCompleted", isCompleted},
            {"lastUpdated", course.contains("progressUpdated") ? course["progressUpdated"] : ""}
        };
    }

    // Вариант 2: Если ProfileManager поддерживает QString, используем его
    // return ProfileManager::instance().getCourseProgress(courseId);

    // Если курс не найден, возвращаем значения по умолчанию
    return QVariantMap{
        {"progress", 0},
        {"isCompleted", false}
    };
}

QString VideoCourseManager::generateCourseId() const
{
    return QUuid::createUuid().toString(QUuid::WithoutBraces);
}

QString VideoCourseManager::generateLessonId() const
{
    return QUuid::createUuid().toString(QUuid::WithoutBraces);
}

QVariantList VideoCourseManager::createdCourses() const
{
    QVariantList result;
    QString currentUser = ProfileManager::instance().userName();

    qDebug() << "🔍 VideoCourseManager::createdCourses - current user:" << currentUser;

    for (const auto &course : m_allCourses) {
        QVariantMap courseMap = course.toMap();
        QString authorId = courseMap["authorId"].toString();
        QString authorName = courseMap["author"].toString();

        qDebug() << "📝 Course:" << courseMap["title"].toString()
                 << "authorId:" << authorId
                 << "authorName:" << authorName;

        // Сравниваем с authorName, а не с authorId
        if (authorName == currentUser) {
            qDebug() << "✅ Course belongs to current user";
            result.append(courseMap);
        }
    }

    qDebug() << "📊 Total created courses for current user:" << result.size();
    return result;
}

// В метод initializeFakeCourses добавить channelId для каждого курса
void VideoCourseManager::initializeFakeCourses()
{
    qDebug() << "🔄 Initializing independent courses data...";
    m_allCourses.clear();

    // 1. Python курс от независимого автора
    QVariantMap pythonCourse;
    pythonCourse["id"] = "e4b2faac-525a-4790-9b98-467ea8cdf447";
    pythonCourse["title"] = "Python для начинающих";
    pythonCourse["description"] = "Полный курс по основам Python. Изучите синтаксис, структуры данных, ООП и создание реальных приложений.";
    pythonCourse["author"] = "Алексей Петров";
    pythonCourse["authorId"] = "user_alexey_petrov";
    pythonCourse["channelId"] = "123e4567-e89b-12d3-a456-426614174000"; // Добавляем channelId
    pythonCourse["level"] = "средний";
    pythonCourse["language"] = "ru";
    pythonCourse["category"] = "Программирование";
    pythonCourse["thumbnail_path"] = "qrc:/images/pythonLogo.webp";
    pythonCourse["icon_path"] = "qrc:/images/python.webp";
    pythonCourse["thumbnail_height"] = 200;
    pythonCourse["price"] = 0;
    pythonCourse["rating"] = 4.8;
    pythonCourse["studentsCount"] = 12450;
    pythonCourse["duration"] = "18 часов";
    pythonCourse["lessonCount"] = 4;
    pythonCourse["tags"] = QVariantList{"python", "django", "flask", "pandas", "numpy", "automation"};
    pythonCourse["is_published"] = true;
    pythonCourse["is_paid"] = false;
    pythonCourse["isPublic"] = true;
    pythonCourse["createdAt"] = "2022-05-15T10:00:00Z";
    pythonCourse["updatedAt"] = "2024-01-15T10:00:00Z";
    pythonCourse["enrolledStudents"] = QVariantList{};
    pythonCourse["lessons"] = QVariantList{
        QVariantMap{
            {"id", "f3a1b9c8-2d4e-4f6a-9b8c-1d2e3f4a5b6c"},
            {"title", "Установка Python и настройка окружения"},
            {"description", "Научимся устанавливать Python и настраивать рабочее окружение"},
            {"duration", "25:15"},
            {"url", "https://example.com/videos/python_env.mp4"},
            {"thumbnail", "qrc:/images/python_lesson1.webp"},
            {"type", "video"},
            {"isCompleted", false}
        },
        QVariantMap{
            {"id", "b2c3d4e5-f6a7-4b8c-9d0e-f1a2b3c4d5e6"},
            {"title", "Переменные и основные типы данных"},
            {"description", "Изучим основные типы данных в Python"},
            {"duration", "32:40"},
            {"url", "https://example.com/variables.mp4"},
            {"thumbnail", "qrc:/images/python_lesson2.webp"},
            {"type", "video"},
            {"isCompleted", false}
        },
        QVariantMap{
            {"id", "c3d4e5f6-a7b8-4c9d-0e1f-a2b3c4d5e6f7"},
            {"title", "Функции и модули"},
            {"description", "Учимся создавать функции и работать с модулями"},
            {"duration", "28:10"},
            {"url", "https://example.com/functions.mp4"},
            {"thumbnail", "qrc:/images/python_lesson3.webp"},
            {"type", "video"},
            {"isCompleted", false}
        },
        QVariantMap{
            {"id", "d4e5f6a7-b8c9-4d0e-1f2a-3b4c5d6e7f8a"},
            {"title", "Работа с файлами"},
            {"description", "Научимся читать и записывать файлы в Python"},
            {"duration", "35:20"},
            {"url", "https://example.com/files.mp4"},
            {"thumbnail", "qrc:/images/python_lesson4.webp"},
            {"type", "video"},
            {"isCompleted", false}
        }
    };

    // 2. JavaScript курс от другого автора
    QVariantMap jsCourse;
    jsCourse["id"] = "a1c3f8d2-9e4b-4f1a-8c7d-2b5e6a9f0c3d";
    jsCourse["title"] = "JavaScript современный";
    jsCourse["description"] = "Освойте JavaScript от синтаксиса до асинхронного программирования. React, Node.js и современные фреймворки.";
    jsCourse["author"] = "Мария Иванова";
    jsCourse["authorId"] = "user_maria_ivanova";
    jsCourse["channelId"] = "123e4567-e89b-12d3-a456-426614174001"; // Добавляем channelId
    jsCourse["level"] = "начинающий";
    jsCourse["language"] = "ru";
    jsCourse["category"] = "Веб-разработка";
    jsCourse["thumbnail_path"] = "qrc:/images/javascriptLogo.webp";
    jsCourse["icon_path"] = "qrc:/images/javascript.webp";
    jsCourse["thumbnail_height"] = 120;
    jsCourse["price"] = 0;
    jsCourse["rating"] = 4.7;
    jsCourse["studentsCount"] = 8670;
    jsCourse["duration"] = "15 часов";
    jsCourse["lessonCount"] = 3;
    jsCourse["tags"] = QVariantList{"javascript", "react", "node.js", "vue.js", "typescript", "frontend"};
    jsCourse["is_published"] = true;
    jsCourse["is_paid"] = false;
    jsCourse["isPublic"] = true;
    jsCourse["createdAt"] = "2023-01-20T14:30:00Z";
    jsCourse["updatedAt"] = "2024-01-15T10:00:00Z";
    jsCourse["enrolledStudents"] = QVariantList{};
    jsCourse["lessons"] = QVariantList{
        QVariantMap{
            {"id", "c3d4e5f6-a7b8-4c9d-0e1f-a2b3c4d5e6f7"},
            {"title", "Основы JavaScript и синтаксис"},
            {"description", "Изучим базовый синтаксис JavaScript"},
            {"duration", "28:10"},
            {"url", "https://example.com/js_basics.mp4"},
            {"thumbnail", "qrc:/images/js_lesson1.webp"},
            {"type", "video"},
            {"isCompleted", false}
        },
        QVariantMap{
            {"id", "e4f5a6b7-c8d9-4e0f-1a2b-3c4d5e6f7a8b"},
            {"title", "DOM манипуляции"},
            {"description", "Работа с Document Object Model"},
            {"duration", "45:30"},
            {"url", "https://example.com/dom.mp4"},
            {"thumbnail", "qrc:/images/js_lesson2.webp"},
            {"type", "video"},
            {"isCompleted", false}
        },
        QVariantMap{
            {"id", "f5a6b7c8-d9e0-4f1a-2b3c-4d5e6f7a8b9c"},
            {"title", "Асинхронный JavaScript"},
            {"description", "Промисы, async/await и работа с API"},
            {"duration", "38:15"},
            {"url", "https://example.com/async_js.mp4"},
            {"thumbnail", "qrc:/images/js_lesson3.webp"},
            {"type", "video"},
            {"isCompleted", false}
        }
    };

    // 3. React курс от третьего автора
    QVariantMap reactCourse;
    reactCourse["id"] = "b3c4d5e6-f7a8-4b9c-8d0e-9f1a2b3c4d5e";
    reactCourse["title"] = "React с нуля до профессионала";
    reactCourse["description"] = "Полное руководство по React. Хуки, контекст, роутинг и создание реальных приложений.";
    reactCourse["author"] = "Дмитрий Сидоров";
    reactCourse["authorId"] = "user_dmitry_sidorov";
    reactCourse["channelId"] = ""; // У этого автора пока нет канала
    reactCourse["level"] = "средний";
    reactCourse["language"] = "ru";
    reactCourse["category"] = "Веб-разработка";
    reactCourse["thumbnail_path"] = "qrc:/images/reactLogo.webp";
    reactCourse["icon_path"] = "qrc:/images/javascript.webp";
    reactCourse["thumbnail_height"] = 180;
    reactCourse["price"] = 2990;
    reactCourse["rating"] = 4.9;
    reactCourse["studentsCount"] = 5430;
    reactCourse["duration"] = "24 часа";
    reactCourse["lessonCount"] = 4;
    reactCourse["tags"] = QVariantList{"react", "javascript", "frontend", "hooks", "redux", "webpack"};
    reactCourse["is_published"] = true;
    reactCourse["is_paid"] = true;
    reactCourse["isPublic"] = true;
    reactCourse["createdAt"] = "2023-08-10T09:15:00Z";
    reactCourse["updatedAt"] = "2024-01-10T16:45:00Z";
    reactCourse["enrolledStudents"] = QVariantList{};
    reactCourse["lessons"] = QVariantList{
        QVariantMap{
            {"id", "a6b7c8d9-e0f1-4a2b-3c4d-5e6f7a8b9c0d"},
            {"title", "Введение в React"},
            {"description", "Основные концепции React"},
            {"duration", "30:25"},
            {"url", "https://example.com/react_intro.mp4"},
            {"thumbnail", "qrc:/images/react_lesson1.webp"},
            {"type", "video"},
            {"isCompleted", false}
        },
        QVariantMap{
            {"id", "b7c8d9e0-f1a2-4b3c-4d5e-6f7a8b9c0d1e"},
            {"title", "Компоненты и Props"},
            {"description", "Создание и использование компонентов"},
            {"duration", "42:10"},
            {"url", "https://example.com/components.mp4"},
            {"thumbnail", "qrc:/images/react_lesson2.webp"},
            {"type", "video"},
            {"isCompleted", false}
        },
        QVariantMap{
            {"id", "c8d9e0f1-a2b3-4c4d-5e6f-7a8b9c0d1e2f"},
            {"title", "Хуки в React"},
            {"description", "Использование useState и useEffect"},
            {"duration", "35:45"},
            {"url", "https://example.com/hooks.mp4"},
            {"thumbnail", "qrc:/images/react_lesson3.webp"},
            {"type", "video"},
            {"isCompleted", false}
        },
        QVariantMap{
            {"id", "d9e0f1a2-b3c4-4d5e-6f7a-8b9c0d1e2f3a"},
            {"title", "Роутинг в React"},
            {"description", "Настройка маршрутов в приложении"},
            {"duration", "28:30"},
            {"url", "https://example.com/routing.mp4"},
            {"thumbnail", "qrc:/images/react_lesson4.webp"},
            {"type", "video"},
            {"isCompleted", false}
        }
    };

    m_allCourses.append(pythonCourse);
    m_allCourses.append(jsCourse);
    m_allCourses.append(reactCourse);

    qDebug() << "✅ Independent courses initialized. Total courses:" << m_allCourses.size();
    qDebug() << "🔗 Python course channelId:" << pythonCourse["channelId"].toString();
    qDebug() << "🔗 JavaScript course channelId:" << jsCourse["channelId"].toString();
    qDebug() << "🔗 React course channelId:" << reactCourse["channelId"].toString();
}
