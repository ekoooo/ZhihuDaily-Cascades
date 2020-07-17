import bb.cascades 1.4
import tech.lwl 1.0
import "asset:///pages/child"

Page {
    id: root
    titleBar: TitleBar {
        title: "主题日报"
        scrollBehavior: TitleBarScrollBehavior.NonSticky
    }
    actionBarVisibility: ChromeVisibility.Compact
    
    
    Container {
        Container {
            id: emptyContainer
            property bool display: false
            
            visible: emptyContainer.display
            
            Label {
                text: "　　知乎日报《主题日报》模块已无内容，留个纪念，就不删除了。"
                multiline: true
                horizontalAlignment: HorizontalAlignment.Center
                margin {
                    leftOffset: ui.du(2)
                    rightOffset: ui.du(2)
                    topOffset: ui.du(10)
                }
                textStyle {
                    fontSize: FontSize.Medium
                }
            }
        }
        
        Container {
            ListView {
                id: lv
                leftPadding: ui.du(2)
                rightPadding: ui.du(2)
                topPadding: ui.du(2)
                bottomPadding: ui.du(14)
                
                scrollRole: ScrollRole.Main
                
                layout: GridListLayout {
                
                }
                dataModel: ArrayDataModel {
                    id: dm
                }
                scrollIndicatorMode: ScrollIndicatorMode.None
                
                onTriggered: {
                    root.pushToThemeListPage(dm.data(indexPath)['id'])
                }
                
                listItemComponents: [
                    ListItemComponent {
                        type: ""
                        SectionThemeItem {
                            listItemData: ListItemData
                        }
                    }
                ]
                onCreationCompleted: {
                    common.apiThemes(listRequester);
                }
            }
        }
    }
    
    attachedObjects: [
        Requester {
            id: listRequester
            onFinished: {
                var rs = JSON.parse(data);
                var themes = rs['others'];
                
                common.formatFastImageUrl(themes, 'thumbnail', false);
                
                dm.clear();
                dm.insert(0, themes);
                
                // 如果没有内容则提示
                emptyContainer.display = themes.length === 0;
            }
            onError: {
                _misc.showToast(error)
            }
        },
        ComponentDefinition {
            id: themeListPage
            source: "asset:///pages/themeList.qml"
        }
    ]
    
    function pushToThemeListPage(themeId) {
        var page = themeListPage.createObject();
        page.themeId = themeId;
        
        nav.push(page);
    }
}
