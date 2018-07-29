/*
 * Requester.cpp
 *
 *  Created on: 2018年7月18日
 *      Author: liuwanlin
 */

#include "Requester.hpp"

#include <bb/cascades/ImageView>
#include <QObject>
#include <QtCore/QDir>
#include <QtCore/QUrl>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkDiskCache>
#include <QtNetwork/QSslConfiguration>
#include <QtNetwork/QSslSocket>
#include <bb/data/JsonDataAccess>

using namespace bb::data;

QNetworkAccessManager *Requester::qNetworkAccessManager = new QNetworkAccessManager();
QNetworkDiskCache *Requester::qNetworkDiskCache = new QNetworkDiskCache();

QString Requester::CACHE_DIR = QDir::homePath() + "/cache/data";
qint64 Requester::CACHE_SIZE = 100 * 1024 * 1024; // 100M

Requester::Requester() : QObject() {
    this->mMethod = Get;

    QFileInfo cacheDir(Requester::CACHE_DIR);
    if(!cacheDir.exists()) {
        QDir().mkdir(cacheDir.path());
    }

    qNetworkDiskCache->setCacheDirectory(Requester::CACHE_DIR);
    qNetworkDiskCache->setMaximumCacheSize(Requester::CACHE_SIZE);
    qNetworkAccessManager->setCache(qNetworkDiskCache);
}

QUrl Requester::url() const {
    return this->mUrl;
}

Requester::Method Requester::method() const {
    return this->mMethod;
}

QVariant Requester::params() const {
    return this->mParams;
}

QVariant Requester::headers() const {
    return this->mHeaders;
}

void Requester::setUrl(const QUrl url) {
    this->mUrl = url;
    emit urlChanged();
}

void Requester::setMethod(const Method method) {
    this->mMethod = method;
    emit methodChanged();
}

void Requester::setParams(const QVariant params) {
    this->mParams = params;
    emit paramsChanged();
}

void Requester::setHeaders(const QVariant headers) {
    this->mHeaders = headers;
    emit headersChanged();
}

void Requester::clearCache() {
    qNetworkDiskCache->clear();
}

/**
 * 发送请求
 */
void Requester::send() {
    this->send(this->mUrl);
}

void Requester::send(QUrl url) {
    emit beforeSend();

    QNetworkRequest request;
    // 从网络获取优先级大于从缓存获取
    request.setAttribute(QNetworkRequest::CacheLoadControlAttribute, QNetworkRequest::PreferNetwork);
    request.setUrl(url);
    // 默认 header
    request.setRawHeader("Accept", "application/json");
    request.setRawHeader("Content-Type", "application/json");
    // 参数 header
    QMap<QString, QVariant> headers = this->mHeaders.toMap();
    QMapIterator<QString, QVariant> headersIt(headers);
    while(headersIt.hasNext()) {
        headersIt.next();
        request.setRawHeader(headersIt.key().toUtf8(), headersIt.value().toByteArray());
    }
    // SSL handshake failed
    QSslConfiguration config = request.sslConfiguration();
    config.setPeerVerifyMode(QSslSocket::VerifyNone);
    config.setProtocol(QSsl::TlsV1);
    request.setSslConfiguration(config);

    QNetworkReply *reply;

    if(this->mMethod == Get) {
        reply = qNetworkAccessManager->get(request);
    }else if(this->mMethod == Post) {
        QMap<QString, QVariant> params = this->mParams.toMap();
        JsonDataAccess jda;
        QString paramsStr;

        // QT Object convert to JSON string
        jda.saveToBuffer(params, &paramsStr);

        reply = qNetworkAccessManager->post(request, paramsStr.toUtf8());
    }

    connect(reply, SIGNAL(finished()), this, SLOT(replyFinished()));
}

void Requester::replyFinished() {
    QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender());
    QVariant fromCache = reply->attribute(QNetworkRequest::SourceIsFromCacheAttribute);

    qDebug() << "Http:" << reply->url() << "fromCache:" << fromCache.toBool();

    if(reply->error() == QNetworkReply::NoError) {
        QTextCodec *codec = QTextCodec::codecForLocale();
        QString data = codec->toUnicode(reply->readAll());

        emit finished(data);
    }else {
        emit error(reply->errorString());
    }

    reply->deleteLater();
}
