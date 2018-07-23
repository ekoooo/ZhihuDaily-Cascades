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

using namespace bb::system;

Misc::Misc(): QObject() {

}

void Misc::invokeViewIamge(QString path) {
    InvokeRequest request;
    request.setUri(path);
    request.setTarget("sys.pictures.card.previewer");
    request.setAction("bb.action.VIEW");

    InvokeTargetReply *invokeTargetReply = (new InvokeManager(this))->invoke(request);
    Q_UNUSED(invokeTargetReply);
}

void Misc::clearCache() {
    WebImageView().clearCache();
    Requester().clearCache();
}
