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

import bb.cascades 1.4

TabbedPane {
    property variant nav: activeTab.tabNav // 所以页面可用导航
    activeTab: indexTab // 默认 activeTab 为 主页
    tabs: [
        Tab {
            id: indexTab
            
            property alias tabNav: indexNav
            
            title: qsTr("主页")
            imageSource: "asset:///images/bb10/ic_home.png"
            
            NavigationPane {
                id: indexNav
                onCreationCompleted: {
                    push(indexPage.createObject());
                }
                attachedObjects: [
                    ComponentDefinition {
                        id: indexPage
                        source: "asset:///pages/index.qml"
                    }
                ]
                onPopTransitionEnded: {
                    page.destroy();
                }
            }
        }
    ]
}
