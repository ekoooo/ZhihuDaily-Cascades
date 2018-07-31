import bb.cascades 1.4
import tech.lwl 1.0
import "asset:///pages/child"

Page {
    id: root
    titleBar: TitleBar {
        title: "栏目分类"
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
                root.pushToSectionsListPage(dm.data(indexPath)['id'], dm.data(indexPath)['name']);
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
                common.apiSections(listRequester);
            }
        }
    }
    
    attachedObjects: [
        Requester {
            id: listRequester
            onFinished: {
                var rs = JSON.parse(data);
                var themes = rs['data'];
                dm.clear();
                dm.insert(0, themes);
            }
            onError: {
                _misc.showToast(error)
            }
        },
        ComponentDefinition {
            id: sectionListPage
            source: "asset:///pages/sectionList.qml"
        }
    ]
    
    function pushToSectionsListPage(sectionId, sectionName) {
        var page = sectionListPage.createObject();
        page.sectionId = sectionId;
        page.sectionName = sectionName;
        
        nav.push(page);
    }
}
