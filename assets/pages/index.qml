import bb.cascades 1.4
import tech.lwl 1.0
import "asset:///components"

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
            property variant common_: common
            property variant dm_: dm
            property alias root_: root
            
            scrollRole: ScrollRole.Main
            
            attachedObjects: [
                ListScrollStateHandler {
                    onAtEndChanged: {
                        if(atEnd && !dm.isEmpty() && !dataLoading) {
                            listRequester.send(qsTr(api.newsBefore).arg(currentDate));
                        }
                    }
                }
            ]
            
            leadingVisual: RefreshHeader {
                id: refreshHeader
                onRefreshTriggered: {
                    listRequester.send(api.newsLatest);
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
                    CustomListItem {
                        dividerVisible: true
                        highlightAppearance: HighlightAppearance.Default
                        
                        Container {
                            Container {
                                layout: StackLayout {
                                    orientation: LayoutOrientation.LeftToRight
                                }
                                topPadding: ui.du(2)
                                bottomPadding: topPadding
                                leftPadding: ui.du(2)
                                rightPadding: leftPadding
                                
                                Label {
                                    text: ListItemData.title
                                    multiline: true
                                    layoutProperties: StackLayoutProperties {
                                        spaceQuota: 1
                                    }
                                }
                                
                                WebImageView {
                                    url: ListItemData.images[0]
                                    preferredWidth: ui.du(15)
                                    preferredHeight: preferredWidth
                                    scalingMethod: ScalingMethod.AspectFit
                                    implicitLayoutAnimationsEnabled: false
                                }
                            }
                        }
                    }
                }
            ]
            onCreationCompleted: {
                listRequester.send(api.newsLatest);
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
                
                if(!stories) {
                    _misc.showToast(qsTr("加载失败，请重新加载"));
                    return;
                }
                
                // 如果是刷新，则清空数据
                if(dm.size() && topStories && topStories.length) {
                    dm.clear();
                    refreshHeader.endRefresh();
                    _misc.showToast(qsTr("刷新成功"));
                }

                // 重新封装数据
                stories.unshift({
                    "__type": "date",
                    "date": date
                });
                
                // 顶部放入轮播图数据
                if (topStories && topStories.length) {
                    stories.unshift({
                        "__type": "carousel",
                        "top_stories": topStories
                    });
                }
                dm.append(stories);
                
                // 保存
                root.currentDate = date;
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
