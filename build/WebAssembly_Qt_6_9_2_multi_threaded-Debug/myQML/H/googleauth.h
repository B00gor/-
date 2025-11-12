#ifndef GOOGLEAUTH_H
#define GOOGLEAUTH_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QTcpServer>
#include <QUrlQuery>

class GoogleAuth : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool authenticated READ authenticated NOTIFY authenticatedChanged)
    Q_PROPERTY(QString email READ email NOTIFY profileUpdated)
    Q_PROPERTY(QString name READ name NOTIFY profileUpdated)
    Q_PROPERTY(QString avatarUrl READ avatarUrl NOTIFY profileUpdated)

public:
    explicit GoogleAuth(QObject *parent = nullptr);

    bool authenticated() const { return m_authenticated; }
    QString email() const { return m_email; }
    QString name() const { return m_name; }
    QString avatarUrl() const { return m_avatarUrl; }

public slots:
    void startAuth();
    void logout();

signals:
    void authenticatedChanged();
    void profileUpdated();
    void authError(const QString &error);
    void statusMessage(const QString &msg);
    void openAuthUrl(const QUrl &url);

private slots:
    void onNewConnection();
    void exchangeCodeForToken(const QString &code);
    void onTokenReceived();
    void fetchUserInfo();
    void onUserInfoReceived();

private:
    void startLocalServer();
    void sendHttpResponse(QTcpSocket *socket, const QString &message);

    QNetworkAccessManager *m_network;
    QTcpServer *m_tcpServer;

    bool m_authenticated = false;
    QString m_email;
    QString m_name;
    QString m_avatarUrl;
    QString m_accessToken;

    static const QString GOOGLE_CLIENT_ID;
    static const QString GOOGLE_CLIENT_SECRET;
    static const int LOCAL_PORT = 12345;
};

#endif // GOOGLEAUTH_H
