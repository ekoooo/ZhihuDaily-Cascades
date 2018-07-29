/*
 * Copyright (c) 2011-2015 BlackBerry Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "applicationui.hpp"
#include "WebImageView/WebImageView.hpp"
#include "Requester/Requester.hpp"

#include <bb/cascades/Application>
#include <bb/cascades/DevelopmentSupport>

#include <QLocale>
#include <QTranslator>
#include <QTimer>

#include <Qt/qdeclarativedebug.h>

using namespace bb::cascades;

Q_DECL_EXPORT int main(int argc, char **argv)
{
    Application app(argc, argv);
    /**
     * To use this feature, you must enable sending QML files to a device.
     * In the Momentics IDE, in Window > Preferences > BlackBerry,
     * select Send QML files to device on save,
     * the application must be built in debug mode
     * and the development support must be installed in valid application instance.
     */
    DevelopmentSupport::install();

    qmlRegisterType<QTimer>("tech.lwl", 1, 0, "QTimer");
    qmlRegisterType<WebImageView>("tech.lwl", 1, 0, "WebImageView");
    qmlRegisterType<Requester>("tech.lwl", 1, 0, "Requester");

    ApplicationUI appui;

    return Application::exec();
}
