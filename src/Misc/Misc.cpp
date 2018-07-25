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

#include <bb/system/InvokeRequest>
#include <bb/system/InvokeTargetReply>
#include <bb/system/InvokeManager>
#include <bb/system/SystemToast>
#include <bb/system/SystemUiPosition>

using namespace bb::system;

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

QByteArray Misc::toUtf8(QString text) {
    return text.toUtf8();
}

void Misc::clearCache() {
    WebImageView().clearCache();
    Requester().clearCache();
}

void Misc::showToast(QString msg) {
    this->showToast(msg, SystemUiPosition::BottomCenter);
}

void Misc::showToast(QString msg, SystemUiPosition::Type pos) {
    toast->setBody(msg);
    toast->setPosition(pos);
    toast->show();
}
