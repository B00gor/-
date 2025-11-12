#ifndef DATABASE_H
#define DATABASE_H

#include <QSqlDatabase>

class Database
{
public:
    static Database& instance();
    QSqlDatabase& get();

private:
    Database();
    ~Database();

    QSqlDatabase m_db;
};

#endif // DATABASE_H
