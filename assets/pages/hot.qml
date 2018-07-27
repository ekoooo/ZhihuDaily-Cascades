import bb.cascades 1.4
import tech.lwl 1.0
import "asset:///components"
import "asset:///pages/child"

Page {
    id: root
    actionBarVisibility: ChromeVisibility.Compact
    property bool isRefresh: false
    
    titleBar: TitleBar {
        title: qsTr("今日热门")
        scrollBehavior: TitleBarScrollBehavior.Sticky
    }
    
    Container {
        ListView {
            id: lv
            property variant root_: root
            
            scrollRole: ScrollRole.Main
            
            leadingVisual: RefreshHeader {
                id: refreshHeader
                refreshThreshold: 150
                onRefreshTriggered: {
                    isRefresh = true;
                    common.apiNewsHot(listRequester);
                }
            }
            
            dataModel: ArrayDataModel {
                id: dm
            }
            
            onTriggered: {
                if(indexPath.length === 1) {
                    root_.pushToNewsPage(dm.data(indexPath)['news_id']);
                }
            }
            
            listItemComponents: [
                ListItemComponent {
                    type: ""
                    NewsListItem {
                        listItemData: ListItemData
                        imageKey: "thumbnail"
                        isImageList: false
                    }
                }
            ]
            onCreationCompleted: {
                common.apiNewsHot(listRequester);
            }
            onTouch: {
                refreshHeader.onListViewTouch(event);
            }
            
            eventHandlers: [
                TouchKeyboardHandler {
                    onTouch: {
                        refreshHeader.onListViewTouch(event);
                    }
                }
            ]
        }
    }
    
    attachedObjects: [
        Requester {
            id: listRequester
            
            onFinished: {
                var rs = JSON.parse(data);
                var recent = rs['recent'];
                dm.clear();
                dm.insert(0, recent);
                if(isRefresh) {
                    isRefresh = false;
                    refreshHeader.endRefresh();
                    _misc.showToast(qsTr("刷新成功"));
                }
            }
            onError: {
                _misc.showToast(error);
            }
        },
        ComponentDefinition {
            id: newsPage
            source: "asset:///pages/news.qml"
        }
    ]
    
    function pushToNewsPage(newsId) {
        var page = newsPage.createObject();
        page.newsId = newsId;
        
        nav.push(page);
    }
}
