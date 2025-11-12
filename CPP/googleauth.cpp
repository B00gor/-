#include "H/googleauth.h"
#include <QDesktopServices>
#include <QJsonDocument>
#include <QJsonObject>
#include <QUrlQuery>
#include <QNetworkReply>
#include <QTcpSocket>
#include <QRegularExpression>
#include <QDebug>

const QString GoogleAuth::GOOGLE_CLIENT_ID = "334166751249-gul52emr9393l57k1ulpp6sm1jvd6tui.apps.googleusercontent.com";
const QString GoogleAuth::GOOGLE_CLIENT_SECRET = "YOUR_CLIENT_SECRET"; // Замените на ваш client_secret

GoogleAuth::GoogleAuth(QObject *parent)
    : QObject(parent)
    , m_network(new QNetworkAccessManager(this))
    , m_tcpServer(new QTcpServer(this))
{
    connect(m_tcpServer, &QTcpServer::newConnection, this, &GoogleAuth::onNewConnection);
}

void GoogleAuth::startAuth()
{
    if (m_authenticated) {
        return;
    }

    startLocalServer();

    QUrl authUrl("https://accounts.google.com/o/oauth2/v2/auth");
    QUrlQuery query;
    query.addQueryItem("client_id", GOOGLE_CLIENT_ID);
    query.addQueryItem("redirect_uri", QString("http://localhost:%1").arg(LOCAL_PORT));
    query.addQueryItem("response_type", "code");
    query.addQueryItem("scope", "openid email profile");
    query.addQueryItem("access_type", "offline");
    query.addQueryItem("prompt", "consent");

    authUrl.setQuery(query);

    qDebug() << "Opening Google Auth URL";
    emit statusMessage("Открытие браузера для авторизации...");
    emit openAuthUrl(authUrl);
}

void GoogleAuth::logout()
{
    m_authenticated = false;
    m_email.clear();
    m_name.clear();
    m_avatarUrl.clear();
    m_accessToken.clear();

    emit authenticatedChanged();
    emit profileUpdated();
    emit statusMessage("Выход выполнен");
}

void GoogleAuth::startLocalServer()
{
    if (m_tcpServer->isListening()) {
        m_tcpServer->close();
    }

    if (!m_tcpServer->listen(QHostAddress::LocalHost, LOCAL_PORT)) {
        emit authError("Failed to start local server: " + m_tcpServer->errorString());
        return;
    }
}

void GoogleAuth::onNewConnection()
{
    QTcpSocket *socket = m_tcpServer->nextPendingConnection();

    connect(socket, &QTcpSocket::readyRead, this, [this, socket]() {
        QByteArray data = socket->readAll();

        QRegularExpression re("GET (/\\?[^ ]*) ");
        QRegularExpressionMatch match = re.match(QString::fromLatin1(data));

        if (match.hasMatch()) {
            QString path = match.captured(1);
            QUrl url("http://localhost" + path);
            QUrlQuery query(url);

            if (query.hasQueryItem("code")) {
                QString code = query.queryItemValue("code");
                qDebug() << "Authorization code received";

                QString html = "<html><body><h2>✅ Авторизация успешна!</h2>"
                               "<p>Закройте это окно.</p>"
                               "<script>setTimeout(() => window.close(), 1500);</script></body></html>";
                sendHttpResponse(socket, html);

                exchangeCodeForToken(code);
                m_tcpServer->close();
            }
            else if (query.hasQueryItem("error")) {
                QString error = query.queryItemValue("error");
                QString desc = query.queryItemValue("error_description");
                QString msg = error + (desc.isEmpty() ? "" : ": " + desc);

                QString html = "<html><body><h2>❌ Ошибка авторизации</h2><p>" + msg + "</p></body></html>";
                sendHttpResponse(socket, html);

                emit authError(msg);
                m_tcpServer->close();
            }
        }

        socket->disconnectFromHost();
        socket->deleteLater();
    });
}

void GoogleAuth::sendHttpResponse(QTcpSocket *socket, const QString &message)
{
    QString response =
        "HTTP/1.1 200 OK\r\n"
        "Content-Type: text/html; charset=utf-8\r\n"
        "Content-Length: " + QString::number(message.toUtf8().size()) + "\r\n"
                                                     "Connection: close\r\n"
                                                     "\r\n" + message;
    socket->write(response.toUtf8());
    socket->flush();
}

void GoogleAuth::exchangeCodeForToken(const QString &code)
{
    emit statusMessage("Получение токена...");

    QNetworkRequest request(QUrl("https://oauth2.googleapis.com/token"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");

    QUrlQuery params;
    params.addQueryItem("code", code);
    params.addQueryItem("client_id", GOOGLE_CLIENT_ID);
    params.addQueryItem("client_secret", GOOGLE_CLIENT_SECRET);
    params.addQueryItem("redirect_uri", QString("http://localhost:%1").arg(LOCAL_PORT));
    params.addQueryItem("grant_type", "authorization_code");

    QNetworkReply *reply = m_network->post(request, params.toString(QUrl::FullyEncoded).toUtf8());
    connect(reply, &QNetworkReply::finished, this, &GoogleAuth::onTokenReceived);
}

void GoogleAuth::onTokenReceived()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender());
    if (!reply) return;

    QByteArray data = reply->readAll();

    if (reply->error() == QNetworkReply::NoError) {
        QJsonDocument doc = QJsonDocument::fromJson(data);
        QJsonObject obj = doc.object();

        if (obj.contains("access_token")) {
            m_accessToken = obj["access_token"].toString();
            qDebug() << "Access token received";
            emit statusMessage("Токен получен. Загрузка профиля...");
            fetchUserInfo();
        } else {
            QString err = obj["error"].toString();
            QString desc = obj["error_description"].toString();
            emit authError(err + ": " + desc);
        }
    } else {
        emit authError("Network error: " + reply->errorString());
    }
    reply->deleteLater();
}

void GoogleAuth::fetchUserInfo()
{
    QNetworkRequest request(QUrl("https://www.googleapis.com/oauth2/v3/userinfo"));
    request.setRawHeader("Authorization", ("Bearer " + m_accessToken).toUtf8());

    QNetworkReply *reply = m_network->get(request);
    connect(reply, &QNetworkReply::finished, this, &GoogleAuth::onUserInfoReceived);
}

void GoogleAuth::onUserInfoReceived()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender());
    if (!reply) return;

    QByteArray data = reply->readAll();

    if (reply->error() == QNetworkReply::NoError) {
        QJsonDocument doc = QJsonDocument::fromJson(data);
        QJsonObject obj = doc.object();

        m_name = obj["name"].toString();
        m_email = obj["email"].toString();
        m_avatarUrl = obj["picture"].toString();
        m_authenticated = true;

        qDebug() << "User info received:" << m_name << m_email;

        emit authenticatedChanged();
        emit profileUpdated();
        emit statusMessage("Профиль загружен!");
    } else {
        emit authError("Failed to get user info: " + reply->errorString());
    }
    reply->deleteLater();
}
