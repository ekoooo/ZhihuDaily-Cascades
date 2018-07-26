/*
 * WebImageView.hpp
 *
 *  Created on: 2018年7月18日
 *      Author: liuwanlin
 */

#ifndef WEBIMAGEVIEW_HPP_
#define WEBIMAGEVIEW_HPP_

#include <bb/cascades/ImageView>

#include <QObject>
#include <QtCore/QUrl>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkDiskCache>

using namespace bb::cascades;

class WebImageView: public bb::cascades::ImageView {
    Q_OBJECT
    Q_PROPERTY(QUrl url READ url WRITE setUrl NOTIFY urlChanged)
    /**
     * 图片加载失败图片（只能为本地图片）
     */
    Q_PROPERTY(QUrl failImageSource READ failImageSource WRITE setFailImageSource NOTIFY failImageSourceChanged);
    /**
     * 正在加载时显示图片
     */
    Q_PROPERTY(QUrl loadingImageSource READ loadingImageSource WRITE setLoadingImageSource NOTIFY loadingImageSourceChanged);

    public:
        WebImageView();
        virtual ~WebImageView() {};

        static QString CACHE_DIR;

        QUrl url() const;
        QUrl failImageSource() const;
        QUrl loadingImageSource() const;

        Q_INVOKABLE static void clearCache();
        Q_INVOKABLE void invokeViewImage(); // 在设备中预览图片

    public slots:
        void setUrl(const QUrl url);
        void setFailImageSource(const QUrl url);
        void setLoadingImageSource(const QUrl url);

    private:
        static QNetworkAccessManager *qNetworkAccessManager;
        static QNetworkDiskCache *qNetworkDiskCache;
        static qint64 CACHE_SIZE;
        QUrl mUrl;
        QUrl mFailImageSource;
        QUrl mLoadingImageSource;

        QByteArray imageData; // 存储当前图片数据，用于预览

    private slots:
        void replyFinished();
        void downloadProgress(qint64 bytesReceived, qint64 bytesTotal);

    signals:
        void urlChanged();
        void failImageSourceChanged();
        void loadingImageSourceChanged();

        void progressed(qint64 bytesReceived, qint64 bytesTotal);
        void loaded();
        void invokeViewImaged();
};

#endif /* WEBIMAGEVIEW_HPP_ */
