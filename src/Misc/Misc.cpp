/*
 * Misc.cpp
 *
 *  Created on: 2018年7月18日
 *      Author: liuwanlin
 */

#include "Misc.hpp"
#include "../WebImageView/WebImageView.hpp"
#include "../Requester/Requester.hpp"

#include <QObject>
#include <QtCore/QSettings>
#include <QtCore/QDir>

#include <bb/system/InvokeRequest>
#include <bb/system/InvokeTargetReply>
#include <bb/system/InvokeManager>
#include <bb/system/SystemToast>
#include <bb/system/SystemUiPosition>
#include <bb/system/SystemDialog>

#include <bb/cascades/Application>
#include <bb/cascades/ThemeSupport>
#include <bb/cascades/VisualStyle>
#include <bb/cascades/Theme>
#include <bb/cascades/ColorTheme>

using namespace bb::system;
using namespace bb::cascades;

SystemToast *Misc::toast = new SystemToast();

Misc::Misc(): QObject() {
    this->invokeManager = new InvokeManager(this);
}

void Misc::invokeViewIamge(QString path) {
    InvokeRequest request;
    request.setUri(path);
    request.setTarget("sys.pictures.card.previewer");
    request.setAction("bb.action.VIEW");

    InvokeTargetReply *invokeTargetReply = invokeManager->invoke(request);
    Q_UNUSED(invokeTargetReply);
}

void Misc::invokeBrowser(QString url) {
    InvokeRequest request;
    request.setUri(url);
    request.setTarget("sys.browser");
    request.setAction("bb.action.OPEN");

    InvokeTargetReply *invokeTargetReply = invokeManager->invoke(request);
    Q_UNUSED(invokeTargetReply);
}

/**
 * appurl e.g. appworld://content/???
 */
void Misc::invokeBBWorld(QString appurl) {
    InvokeRequest request;
    request.setUri(appurl);
    request.setTarget("sys.appworld");
    request.setAction("bb.action.OPEN");

    InvokeTargetReply *invokeTargetReply = invokeManager->invoke(request);
    Q_UNUSED(invokeTargetReply);
}

void Misc::invokeMail(QString emailTo, QString subject, QString body) {
    InvokeRequest request;
    request.setUri("mailto:" + emailTo + "?subject=" + subject.replace(" ", "%20") + "&body=" + body.replace(" ", "%20"));
    request.setTarget("sys.pim.uib.email.hybridcomposer");
    request.setAction("bb.action.SENDEMAIL");

    InvokeTargetReply *invokeTargetReply = invokeManager->invoke(request);
    Q_UNUSED(invokeTargetReply);
}

QByteArray Misc::toUtf8(QString text) {
    return text.toUtf8();
}

void Misc::clearCache() {
    WebImageView::clearCache();
    Requester::clearCache();
}

void Misc::reset() {
    // 清空缓存
    Misc::clearCache();
    // 清空设置
    QSettings settings;
    settings.clear();
    // 调整主题
    Misc::setTheme("Bright");
}

void Misc::showToast(QString msg) {
    Misc::showToast(msg, SystemUiPosition::BottomCenter);
}

void Misc::showToast(QString msg, SystemUiPosition::Type pos) {
    toast->setBody(msg);
    toast->setPosition(pos);
    toast->show();
}

void Misc::setConfig(const QString &key, const QString &val) {
    QSettings settings;
    settings.setValue(key, QVariant(val));

    qDebug() << "QSettings set:" << key << ":" << val;
}

QString Misc::getConfig(const QString &key, const QString &defaultVal) {
    QSettings settings;
    QString val = settings.value(key, defaultVal).toString();

    qDebug() << "QSettings get:" << key << ":" << val;
    return val;
}

/**
 * 设置主题
 * type == "Dark" 暗色主题
 * type == "Bright" 亮色主题
 */
void Misc::setTheme(QString type) {
    ThemeSupport *themeSupport = Application::instance()->themeSupport();
    VisualStyle::Type style = themeSupport->theme()->colorTheme()->style();

    if (type == "Dark") {
        if (style != VisualStyle::Dark) {
            themeSupport->setVisualStyle(VisualStyle::Dark);
        }
    } else if (type == "Bright") {
        if (style != VisualStyle::Bright) {
            themeSupport->setVisualStyle(VisualStyle::Bright);
        }
    }
}

/**
 * 计算文件夹大小
 */
qint64 Misc::dirSize(QString dirPath) {
    qint64 size = 0;

    QDir dir(dirPath);
    QDir::Filters fileFilters = QDir::Files|QDir::System|QDir::Hidden;
    foreach(QString filePath, dir.entryList(fileFilters)) {
        QFileInfo fi(dir, filePath);
        size+= fi.size();
    }
    QDir::Filters dirFilters = QDir::Dirs|QDir::NoDotAndDotDot|QDir::System|QDir::Hidden;

    foreach(QString childDirPath, dir.entryList(dirFilters)) {
        size += Misc::dirSize(dirPath + QDir::separator() + childDirPath);
    }

    return size;
}

QString Misc::formatSize(qint64 size) {
    QStringList units;
    units << "Bytes" << "KB" << "MB" << "GB" << "TB" << "PB";

    double outputSize = size;
    int i;

    for(i = 0; i < units.size() - 1; i++) {
        if(outputSize < 1024) {
            break;
        }
        outputSize = outputSize / 1024;
    }
    return QString("%0 %1").arg(outputSize, 0, 'f', 2).arg(units[i]);
}

QString Misc::webImageViewCacheSize() {
    return Misc::formatSize(Misc::dirSize(WebImageView::CACHE_DIR));
}

QString Misc::requesterCacheSize() {
    return Misc::formatSize(Misc::dirSize(Requester::CACHE_DIR));
}

void Misc::openDialog(const QString &confirmLabel, const QString &cancelLabel, const QString &title, const QString &body) {
    dialog = new SystemDialog(confirmLabel, cancelLabel);
    dialog->setTitle(title);
    dialog->setBody(body);
    dialog->show();

    QObject::connect(dialog, SIGNAL(finished(bb::system::SystemUiResult::Type)), this, SLOT(onDialogFinished(bb::system::SystemUiResult::Type)));
}

void Misc::onDialogFinished(bb::system::SystemUiResult::Type type) {
    Q_UNUSED(type);
    dialog->deleteLater();
}
