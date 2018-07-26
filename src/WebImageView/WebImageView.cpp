/*
 * WebImageView.cpp
 *
 *  Created on: 2018年7月18日
 *      Author: liuwanlin
 */

#include "WebImageView.hpp"
#include "../Misc/Misc.hpp"

#include <bb/cascades/ImageView>

#include <QtCore/QUrl>
#include <QtCore/QDir>
#include <QtCore/QFileInfo>

#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkDiskCache>
#include <QtNetwork/QNetworkRequest>
#include <QtNetwork/QNetworkReply>

QNetworkAccessManager *WebImageView::qNetworkAccessManager = new QNetworkAccessManager();
QNetworkDiskCache *WebImageView::qNetworkDiskCache = new QNetworkDiskCache();

QString WebImageView::CACHE_DIR = QDir::homePath() + "/cache/images";
qint64 WebImageView::CACHE_SIZE = 100 * 1024 * 1024; // 100M

WebImageView::WebImageView() : ImageView() {
    QFileInfo cacheDir(WebImageView::CACHE_DIR);
    if(!cacheDir.exists()) {
        QDir().mkdir(cacheDir.path());
    }

    qNetworkDiskCache->setCacheDirectory(WebImageView::CACHE_DIR);
    qNetworkDiskCache->setMaximumCacheSize(WebImageView::CACHE_SIZE);
    qNetworkAccessManager->setCache(qNetworkDiskCache);
}

void WebImageView::setUrl(const QUrl url) {
    this->mUrl = url;
    this->resetImage();
    this->imageData.clear();

    emit urlChanged();

    // 显示 LoadingImage
    if(!this->mLoadingImageSource.isEmpty()) {
        this->setImageSource(this->mLoadingImageSource);
    }

    QString scheme = url.scheme().toLower();

    if(scheme == "") {
        this->setImageSource(this->mFailImageSource);
        emit loaded();
        return;
    }

    if(scheme != "http" && scheme != "https" && scheme != "ftp") {
        this->setImageSource(url);
        emit loaded();
        return;
    }

    QNetworkRequest request;
    request.setAttribute(QNetworkRequest::CacheLoadControlAttribute, QNetworkRequest::PreferCache);
    request.setUrl(url);

    // 发送 GET 请求图片数据
    QNetworkReply *reply = qNetworkAccessManager->get(request);

    connect(reply, SIGNAL(finished()), this, SLOT(replyFinished()));
    connect(reply, SIGNAL(downloadProgress(qint64, qint64)), this, SLOT(downloadProgress(qint64, qint64)));
}

QUrl WebImageView::url() const {
    return this->mUrl;
}

void WebImageView::replyFinished() {
    QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender());
    QVariant fromCache = reply->attribute(QNetworkRequest::SourceIsFromCacheAttribute);

    if(reply->error() == QNetworkReply::NoError) {
        imageData = reply->readAll();
        setImage(Image(imageData));
    }else {
        if(!this->mFailImageSource.isEmpty()) {
            this->setImageSource(this->mFailImageSource);
        }
        qDebug() << "WebImageView reply on error:" << reply->errorString();
    }

    emit loaded();
    reply->deleteLater();
}

void WebImageView::downloadProgress(qint64 bytesReceived, qint64 bytesTotal) {
    emit progressed(bytesReceived, bytesTotal);
}

void WebImageView::clearCache() {
    qNetworkDiskCache->clear();
    // 删除手动生成的图片
    QDir cacheDir(WebImageView::CACHE_DIR);
    cacheDir.setFilter(QDir::NoDotAndDotDot | QDir::Files);

    foreach(const QString& file, cacheDir.entryList()) {
        cacheDir.remove(file);
    }
}

void WebImageView::invokeViewImage() {
    // 1. 手动缓存到文件夹
    // 2. invoke 预览
    if(this->imageData.isEmpty()) {
        qDebug() << "WebImageView invokeViewImage imageData isEmpty";
        return;
    }

    QString filePath = WebImageView::CACHE_DIR + "invoke_pre_image.gif";
    QFile file(filePath);

    if(file.open(QIODevice::WriteOnly)) {
        file.write(this->imageData);
        file.close();
        filePath = "file://" + filePath;

        // invoke
        Misc().invokeViewIamge(filePath);
    }else {
        qDebug() << "WebImageView invokeViewImage open file fail";
    }

    emit invokeViewImaged();
}

void WebImageView::setFailImageSource(const QUrl url) {
    this->mFailImageSource = url;
    emit failImageSourceChanged();
}

QUrl WebImageView::failImageSource() const {
    return this->mFailImageSource;
}

void WebImageView::setLoadingImageSource(const QUrl url) {
    this->mLoadingImageSource = url;
    emit loadingImageSourceChanged();
}

QUrl WebImageView::loadingImageSource() const {
    return this->mLoadingImageSource;
}
