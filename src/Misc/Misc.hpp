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

        Q_INVOKABLE void invokeViewIamge(QString path);
        Q_INVOKABLE QByteArray toUtf8(QString text);
        Q_INVOKABLE void clearCache();
        Q_INVOKABLE void showToast(QString msg);
        Q_INVOKABLE void showToast(QString msg, SystemUiPosition::Type pos);

    private:
        static SystemToast *toast;
        InvokeManager *invokeManager;
};

#endif /* MISC_HPP_ */
