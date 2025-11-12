#include "H/database.h"
#include <QSqlDatabase>
#include <QStandardPaths>
#include <QSqlError>
#include <QDir>
#include <QDebug>

Database::Database()
{
    QString dbPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation)
    + QDir::separator() + "ApplicationSettings.db";


    QDir().mkpath(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));

    m_db = QSqlDatabase::addDatabase("QSQLITE");
    m_db.setDatabaseName(dbPath);

    if (!m_db.open()) {
        qWarning() << "Не удалось открыть базу данных:" << m_db.lastError().text();
    } else {
        qDebug() << "Подключение к БД установлено.";
        qDebug() << "Путь к базе данных:" << dbPath;
    }
}

Database::~Database()
{
    if (m_db.isOpen()) {
        m_db.close();
    }
    QSqlDatabase::removeDatabase(QSqlDatabase::defaultConnection);
}

Database& Database::instance()
{
    static Database instance;
    return instance;
}

QSqlDatabase& Database::get()
{
    return m_db;
}
