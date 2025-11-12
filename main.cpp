#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSurfaceFormat>
#include <qsqldatabase.h>
#include <H/database.h>
#include <H/navigationhistory.h>
#include <QQuickWindow>
#include <H/profilemanager.h>
#include <H/thememanager.h>
#include <H/videocoursemanager.h>
#include <H/googleauth.h>
#include <H/channelmanager.h>
#include "H/coursemanager.h"
#include "H/course.h"
#include "H/coursedetails.h"
#include "H/lesson.h"

int main(int argc, char *argv[])
{
    qputenv("QML_XHR_ALLOW_FILE_READ", "1");
    qputenv("QML_DISABLE_DISK_CACHE", "0");
    qputenv("QSG_RENDER_LOOP", "basic");
    qputenv("QT_LOGGING_RULES", "*.debug=false");

    QGuiApplication app(argc, argv);


    QQmlApplicationEngine engine;
    NavigationHistory navHistory;
    GoogleAuth google;
    CourseManager CourseManager;
    Course Course;
    CourseDetails CourseDetails;


    // Регистрируем как контекстные свойства
    engine.rootContext()->setContextProperty("VideoCourseManager", &VideoCourseManager::instance());
    engine.rootContext()->setContextProperty("ProfileManager", &ProfileManager::instance());
    engine.rootContext()->setContextProperty("ThemeManager", &ThemeManager::instance());
    engine.rootContext()->setContextProperty("navHistory", &navHistory);
    engine.rootContext()->setContextProperty("googleAuth", &google);
    engine.rootContext()->setContextProperty("ChannelManager", &ChannelManager::instance());
    engine.rootContext()->setContextProperty("CourseManager", &CourseManager);
    engine.rootContext()->setContextProperty("Course", &Course);
    engine.rootContext()->setContextProperty("CourseDetails", &CourseDetails);

    QSqlDatabase db = Database::instance().get();
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
                     &app,[]() { QCoreApplication::exit(-1);}, Qt::QueuedConnection);
    engine.loadFromModule("myQML", "Main");
    return app.exec();
}
