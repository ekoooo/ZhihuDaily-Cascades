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
    
    attachedObjects: [
        Requester {
            id: listRequester
            onFinished: {
                var rs = JSON.parse(data);
                var themes = rs['others'];
                dm.clear();
                dm.insert(0, themes);
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
