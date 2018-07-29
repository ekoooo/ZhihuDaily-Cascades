/*
 * Misc.hpp
 *
 *  Created on: 2018年7月18日
 *      Author: liuwanlin
 */

#ifndef MISC_HPP_
#define MISC_HPP_

#include <QObject>
#include <bb/system/SystemUiPosition>
#include <bb/system/SystemToast>
#include <bb/system/InvokeManager>

using namespace bb::system;

class Misc : public QObject {
    Q_OBJECT

    public:
        Misc();
        virtual ~Misc() {};

        Q_INVOKABLE static void setConfig(const QString &key, const QString &val);
        Q_INVOKABLE static QString getConfig(const QString &key, const QString &defaultVal);
        Q_INVOKABLE static void setTheme(QString type);
        Q_INVOKABLE static void reset();
        Q_INVOKABLE static void clearCache();
        Q_INVOKABLE static void showToast(QString msg);
        Q_INVOKABLE static void showToast(QString msg, SystemUiPosition::Type pos);

        Q_INVOKABLE static qint64 dirSize(QString dirPath);
        Q_INVOKABLE static QString formatSize(qint64 size);
        Q_INVOKABLE static QString webImageViewCacheSize();
        Q_INVOKABLE static QString requesterCacheSize();

        Q_INVOKABLE static QByteArray toUtf8(QString text);

        Q_INVOKABLE void invokeViewIamge(QString path);
        Q_INVOKABLE void invokeBrowser(QString url);
        Q_INVOKABLE void invokeBBWorld(QString appurl);
    private:
        static SystemToast *toast;
        InvokeManager *invokeManager;
};

#endif /* MISC_HPP_ */
