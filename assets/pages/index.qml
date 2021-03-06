import bb.cascades 1.4
import tech.lwl 1.0
import "asset:///components"
import "asset:///pages/child"

/**
 * 主页
 */
Page {
    id: root
    property variant currentDate // 最后请求日报日期
    property bool dataLoading: false // 是否正在加载数据
    
    actionBarVisibility: ChromeVisibility.Compact
    
    Container {
        ListView {
            id: lv
            property variant common_: common
            property variant dm_: dm
            property variant root_: root
            
            scrollRole: ScrollRole.Main
            
            attachedObjects: [
                ListScrollStateHandler {
                    onAtEndChanged: {
                        if(atEnd && !dm.isEmpty() && !dataLoading) {
                            common.apiNewsBefore(listRequester, currentDate);
                        }
                    }
                }
            ]
            
            leadingVisual: RefreshHeader {
                id: refreshHeader
                onRefreshTriggered: {
                    common.apiNewsLatest(listRequester);
                }
            }
            
            dataModel: ArrayDataModel {
                id: dm
            }
            
            // 重写 itemType
            function itemType(data, indexPath) {
                return data.__type || "story";
            }
            
            onTriggered: {
                if(indexPath.length === 1) {
                    var itemData = dm.data(indexPath);
                    if(!itemData['__type']) {
                        if(itemData['type'] === 0) {
                            root_.pushToNewsPage(itemData['id']);
                        }else {
                            _misc.showToast(qsTr("未知文章类型"));
                        }
                    }
                }
            }
            
            listItemComponents: [
                ListItemComponent {
                    type: "carousel"
                    Carousel {
                        id: carousel
                        listData: ListItemData['top_stories']
                        onClick: {
                            var story = ListItem.view.dm_.data([0])['top_stories'][index];
                            
                            if(story['type'] === 0) {
                                ListItem.view.root_.pushToNewsPage(story['id']);
                            }else {
                                _misc.showToast(qsTr("未知文章类型"));
                            }
                        }
                    }
                },
                ListItemComponent {
                    type: "date"
                    Header {
                        title: ListItem.view.common_.formatDateStr(ListItemData.date)
                        subtitle: ListItem.view.common_.dateWeek(ListItemData.date)
                    }
                },
                ListItemComponent {
                    type: "story"
                    NewsListItem {
                        listItemData: ListItemData
                    }
                }
            ]
            onCreationCompleted: {
                common.apiNewsLatest(listRequester);
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
            onBeforeSend: {
                root.dataLoading = true;
            }
            onFinished: {
                root.dataLoading = false;
                
                var rtData = JSON.parse(data);
                var date = rtData['date']; // 日报日期
                var stories = rtData['stories']; // 日报列表
                var topStories = rtData['top_stories']; // 轮播图内容
                var isEmptyTopStories = topStories && topStories.length;
                
                if(!stories) {
                    _misc.showToast(qsTr("加载失败，请重新加载"));
                    return;
                }
                
                common.formatFastImageUrl(topStories, 'image');
                common.formatFastImageUrl(stories, 'images', true, true);
                
                // 重新封装数据
                stories.unshift({
                    "__type": "date",
                    "date": date
                });
                
                // 顶部放入轮播图数据
                if(isEmptyTopStories) {
                    if(dm.size()) {
                        dm.clear();
                        refreshHeader.endRefresh();
                        _misc.showToast(qsTr("刷新成功"));
                    }
                    
                    // 如果是刷新，则清空数据
                    stories.unshift({
                        "__type": "carousel",
                        "top_stories": topStories
                    });
                }
                dm.append(stories);
                
                // 保存最后一页的日期
                root.currentDate = date;

                // 如果小于10条，多加载一页
                if(isEmptyTopStories && stories.length < 10) {
                    common.apiNewsBefore(listRequester, root.currentDate);
                }
            }
            onError: {
                _misc.showToast(error);
                root.dataLoading = false;
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
