#include "H/navigationhistory.h"
#include <QDebug>
#include <QVariantMap>

NavigationHistory::NavigationHistory(QObject *parent)
    : QObject(parent), m_initialized(false)
// Обратите внимание: m_properties не инициализируется, QVariantMap по умолчанию пуст
{
}

bool NavigationHistory::canGoBack() const
{
    return !m_backStateStack.isEmpty(); // Изменено
}

bool NavigationHistory::canGoForward() const
{
    return !m_forwardStateStack.isEmpty(); // Изменено
}

QString NavigationHistory::currentPage() const
{
    return m_currentPage;
}

void NavigationHistory::initialize(const QString &initialPage)
{
    if (m_initialized || initialPage.isEmpty()) {
        return;
    }

    m_currentPage = initialPage;
    m_initialized = true;

    qDebug() << "Navigation: initialized with" << initialPage;
}

void NavigationHistory::push(const QString &page, const QVariantMap &properties) // Добавлено/изменено
{
    if (page.isEmpty() || page == m_currentPage) {
        return;
    }

    if (!m_currentPage.isEmpty()) {
        // Сохраняем текущее состояние (имя и свойства) в стек назад
        PageState currentState;
        currentState.page = m_currentPage;
        currentState.properties = m_properties; // Сохраняем текущие свойства
        m_backStateStack.push(currentState);

        if (m_backStateStack.size() > MAX_HISTORY) {
            m_backStateStack.remove(0);
        }
    }

    m_forwardStateStack.clear(); // Изменено
    m_currentPage = page;
    m_properties = properties; // Устанавливаем переданные свойства как текущие

    // emit currentPageChanged(m_currentPage, 1); // Удалено
    // Вызываем изменённый сигнал, передающий свойства
    emit currentPageChanged(m_currentPage, 1, m_properties);
    emit canGoBackChanged();
    emit canGoForwardChanged();

    qDebug() << "Navigation: pushed" << page << "with properties:" << properties; // Изменено
}

void NavigationHistory::goBack()
{
    if (m_backStateStack.isEmpty()) {
        return;
    }

    // Сохраняем текущее состояние (имя и свойства) для возврата вперёд
    PageState currentState;
    currentState.page = m_currentPage;
    currentState.properties = m_properties;
    m_forwardStateStack.push(currentState);

    // Восстанавливаем предыдущее состояние
    PageState previousState = m_backStateStack.pop();
    m_currentPage = previousState.page;
    m_properties = previousState.properties; // Восстанавливаем свойства

    // emit currentPageChanged(m_currentPage, -1); // Удалено
    // Вызываем изменённый сигнал, передающий свойства
    emit currentPageChanged(m_currentPage, -1, m_properties);

    emit canGoBackChanged();
    emit canGoForwardChanged();

    qDebug() << "Navigation: went back to" << m_currentPage << "with properties:" << m_properties; // Изменено
}

void NavigationHistory::goForward()
{
    if (m_forwardStateStack.isEmpty()) {
        return;
    }

    // Сохраняем текущее состояние (имя и свойства) для возврата назад
    PageState currentState;
    currentState.page = m_currentPage;
    currentState.properties = m_properties;
    m_backStateStack.push(currentState);

    // Восстанавливаем следующее состояние
    PageState nextState = m_forwardStateStack.pop();
    m_currentPage = nextState.page;
    m_properties = nextState.properties; // Восстанавливаем свойства

    // emit currentPageChanged(m_currentPage, 1); // Удалено
    // Вызываем изменённый сигнал, передающий свойства
    emit currentPageChanged(m_currentPage, 1, m_properties);

    emit canGoBackChanged();
    emit canGoForwardChanged();

    qDebug() << "Navigation: went forward to" << m_currentPage << "with properties:" << m_properties; // Изменено
}
