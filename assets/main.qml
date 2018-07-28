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
import "asset:///common"
import "asset:///pages" as Page

TabbedPane {
    property variant nav: activeTab.tabNav // 所以页面可用导航

    showTabsOnActionBar: false
    activeTab: indexTab // 默认 activeTab 为 主页

    Menu.definition: MenuDefinition {
        helpAction: HelpActionItem {
            title: qsTr("帮助")
            onTriggered: {
                console.log('帮助');
            }
        }
        settingsAction: SettingsActionItem {
            title: qsTr("设置")
            onTriggered: {
                nav.push(settingsPage.createObject());
            }
        }
        actions: [
            ActionItem {
                title: qsTr("赞助")
                imageSource: "asset:///images/bb10/ic_contact.png"
                onTriggered: {
                    console.log('赞助');
                }
            },
            ActionItem {
                title: qsTr("关于")
                imageSource: "asset:///images/bb10/ic_info.png"
                onTriggered: {
                    console.log('关于');
                }
            }
        ]
    }

    tabs: [
        Tab {
            id: indexTab
            property alias tabNav: indexNav
            title: qsTr("主页")
            imageSource: "asset:///images/bb10/ic_home.png"
            shortcuts: [
                Shortcut {
                    key: common.shortCutKey.indexPage
                    onTriggered: {
                        activeTab = indexTab;
                    }
                }
            ]
            NavigationPane {
                id: indexNav
                Page.index {}
                
                onPopTransitionEnded: {
                    page.destroy();
                }
            }
        },
        // 今日热门
        Tab {
            id: hotTab
            property alias tabNav: hotNav
            title: qsTr("今日热门")
            description: qsTr("每天更新的热门文章")
            imageSource: "asset:///images/bb10/ic_diagnostics.png"
            shortcuts: [
                Shortcut {
                    key: common.shortCutKey.hotPage
                    onTriggered: {
                        activeTab = hotTab;
                    }
                }
            ]
            NavigationPane {
                id: hotNav
                Page.hot {}
                onPopTransitionEnded: {
                    page.destroy();
                }
            }
        },
        // 栏目分类
        Tab {
            id: sectionsTab
            property alias tabNav: sectionsNav
            title: qsTr("栏目分类")
            description: qsTr("一次性过瘾《瞎扯》等系列")
            imageSource: "asset:///images/bb10/ic_deselect_all.png"
            shortcuts: [
                Shortcut {
                    key: common.shortCutKey.sectionsPage
                    onTriggered: {
                        activeTab = sectionsTab;
                    }
                }
            ]
            
            NavigationPane {
                id: sectionsNav
                Page.sections {}
                onPopTransitionEnded: {
                    page.destroy();
                }
            }
        },
        // 主题日报
        Tab {
            id: themesTab
            property alias tabNav: themesNav
            title: qsTr("主题日报")
            description: qsTr("萝卜青菜各有所爱")
            imageSource: "asset:///images/bb10/ic_favorite.png"
            shortcuts: [
                Shortcut {
                    key: common.shortCutKey.themesPage
                    onTriggered: {
                        activeTab = themesTab;
                    }
                }
            ]
            NavigationPane {
                id: themesNav
                Page.themes {}
                onPopTransitionEnded: {
                    page.destroy();
                }
            }
        },
        // 过往文章
        Tab {
            id: beforeTab
            property alias tabNav: beforeNav
            title: qsTr("过往文章")
            description: qsTr("按日期搜索文章")
            imageSource: "asset:///images/bb10/ic_search.png"
            shortcuts: [
                Shortcut {
                    key: common.shortCutKey.beforePage
                    onTriggered: {
                        activeTab = beforeTab;
                    }
                }
            ]
            
            NavigationPane {
                id: beforeNav
                Page.before {}
                onPopTransitionEnded: {
                    page.destroy();
                }
            }
        }
    ]
    attachedObjects: [
        Common {
            id: common
        },
        ComponentDefinition {
            id: settingsPage
            source: "asset:///pages/settings.qml"
        }
    ]
    
    onCreationCompleted: {
         _misc.setTheme(_misc.getConfig(common.settingsKey.theme, "Bright"));
    }
}
