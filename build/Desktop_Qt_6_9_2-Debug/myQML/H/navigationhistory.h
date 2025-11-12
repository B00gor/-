#ifndef NAVIGATIONHISTORY_H
#define NAVIGATIONHISTORY_H

#include <QObject>
#include <QStack>
#include <QString>
#include <QVariantMap> // Добавлено

class NavigationHistory : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool canGoBack READ canGoBack NOTIFY canGoBackChanged)
    Q_PROPERTY(bool canGoForward READ canGoForward NOTIFY canGoForwardChanged)
    Q_PROPERTY(QString currentPage READ currentPage NOTIFY currentPageChanged)

public:
    explicit NavigationHistory(QObject *parent = nullptr);

    bool canGoBack() const;
    bool canGoForward() const;
    QString currentPage() const;

    Q_INVOKABLE void initialize(const QString &initialPage);
    Q_INVOKABLE void push(const QString &page, const QVariantMap &properties = QVariantMap()); // Добавлено
    Q_INVOKABLE void goBack();
    Q_INVOKABLE void goForward();

signals:
    void canGoBackChanged();
    void canGoForwardChanged();
    // Изменённая сигнатура сигнала для передачи данных
    void currentPageChanged(const QString &page, int direction, const QVariantMap &properties);

private:
    static const int MAX_HISTORY = 50;

    // Структура для хранения состояния страницы (имя и свойства)
    struct PageState {
        QString page;
        QVariantMap properties;
    };

    QStack<PageState> m_backStateStack;  // Стек для хранения состояний (имя + свойства)
    QStack<PageState> m_forwardStateStack; // Стек для хранения состояний (имя + свойства)
    QString m_currentPage;
    QVariantMap m_properties; // Поле для хранения свойств текущей страницы
    bool m_initialized;
};

#endif // NAVIGATIONHISTORY_H
