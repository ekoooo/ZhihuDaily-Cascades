/*
 * Requester.hpp
 *
 *  Created on: 2018年7月18日
 *      Author: liuwanlin
 */

#ifndef REQUESTER_HPP_
#define REQUESTER_HPP_

#include <bb/cascades/ImageView>
#include <QObject>
#include <QtCore/QUrl>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkDiskCache>

class Requester: public QObject {
    Q_OBJECT

    Q_ENUMS(Method)
    Q_PROPERTY(QUrl url READ url WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(Method method READ method WRITE setMethod NOTIFY methodChanged)
    Q_PROPERTY(QVariant params READ params WRITE setParams NOTIFY paramsChanged)
    Q_PROPERTY(QVariant headers READ headers WRITE setHeaders NOTIFY headersChanged)

    public:
        Requester();
        virtual ~Requester() {};

        enum Method {
            Get = 0,
            Post
        };

        static QString CACHE_DIR;

        QUrl url() const;
        Method method() const;
        QVariant params() const;
        QVariant headers() const;

        Q_INVOKABLE static void clearCache();
        Q_INVOKABLE void send();
        Q_INVOKABLE void send(QUrl url);

    public slots:
        void setUrl(const QUrl url);
        void setMethod(const Method method);
        void setParams(const QVariant params);
        void setHeaders(const QVariant headers);
        void replyFinished();

    private:
        static QNetworkAccessManager *qNetworkAccessManager;
        static QNetworkDiskCache *qNetworkDiskCache;
        static qint64 CACHE_SIZE;

        QUrl mUrl;
        Method mMethod;
        QVariant mParams;
        QVariant mHeaders;

    signals:
        void urlChanged();
        void methodChanged();
        void paramsChanged();
        void headersChanged();
        void finished(QString data);
        void error(QString error);
        void beforeSend();
};

#endif /* REQUESTER_HPP_ */
