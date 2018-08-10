import bb.cascades 1.4
import bb.device 1.4
import tech.lwl 1.0
import "asset:///components"
import "asset:///pages/child"

Page {
    id: root
    property variant themeId // 主题ID（传入）
    property variant lastNewsId // 最后一条主题 ID
    property bool dataLoading: false // 是否正在加载数据
    property bool initTimerRunning: true
    
    property variant dH: displayInfo.pixelSize.height
    property variant imageHeight: dH / 3
    
    property bool isFastMode: _misc.getConfig(common.settingsKey.fastMode, "0") === "1"
    
    actionBarVisibility: ChromeVisibility.Compact
    
    Container {
        layout: DockLayout {}
        
        // loading box
        Container {
            visible: initTimerRunning
            layout: DockLayout {}
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            background: Color.create(0,0,0,0.2)
            
            ActivityIndicator {
                running: initTimerRunning
                preferredWidth: 100
                preferredHeight: 100
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
            }
        }
        
        ListView {
            property variant root_: root
            property bool isFastMode_: isFastMode
            
            scrollRole: ScrollRole.Main
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill

            attachedObjects: [
                ListScrollStateHandler {
                    onAtEndChanged: {
                        if(atEnd && !dm.isEmpty() && !dataLoading) {
                            common.apiThemeListMore(listRequester, themeId, lastNewsId);
                        }
                    }
                }
            ]
            leadingVisual: RefreshHeader {
                id: refreshHeader
                onRefreshTriggered: {
                    common.apiThemeList(listRequester, themeId);
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
                        root_.pushToNewsPage(itemData['id']);
                    }
                }
            }
            
            listItemComponents: [
                ListItemComponent {
                    id: banner
                    type: "banner"
                    
                    Container {
                        id: bannerSubContainer
                        Divider { opacity: 0 }
                        layout: DockLayout {
                        
                        }
                        horizontalAlignment: HorizontalAlignment.Fill
                        preferredHeight: ListItem.view.root_.imageHeight
                        WebImageView {
                            property variant defaultImg: "asset:///images/image_top_default.png"
                            property variant newImg: (ListItemData['info']['image'] || defaultImg)
                            
                            url: bannerSubContainer.ListItem.view.isFastMode_ ? defaultImg : newImg
                            scalingMethod: ScalingMethod.AspectFill
                            verticalAlignment: VerticalAlignment.Fill
                            horizontalAlignment: HorizontalAlignment.Fill
                            implicitLayoutAnimationsEnabled: false
                            loadingImageSource: "asset:///images/image_top_default.png"
                            failImageSource: "asset:///images/image_top_default.png"
                            onTouch: {
                                if(event.isUp()) {
                                    if(bannerSubContainer.ListItem.view.isFastMode_ && url == defaultImg) {
                                        url = newImg;
                                        return;
                                    }
                                    
                                    invokeViewImage();
                                }
                            }
                        }
                        Container {
                            horizontalAlignment: HorizontalAlignment.Center
                            verticalAlignment: VerticalAlignment.Top
                            
                            margin {
                                topOffset: ui.du(6)
                            }
                            leftPadding: ui.du(2)
                            rightPadding: ui.du(2)
                            
                            Label {
                                text: ListItemData['info']['name']
                                multiline: true
                                
                                textStyle {
                                    base: SystemDefaults.TextStyles.BodyText
                                    color: Color.create("#ffffff")
                                    fontWeight: FontWeight.W500
                                }
                            }
                        }
                        Container {
                            horizontalAlignment: HorizontalAlignment.Center
                            verticalAlignment: VerticalAlignment.Bottom
                            
                            margin {
                                bottomOffset: ui.du(6)
                            }
                            leftPadding: ui.du(2)
                            rightPadding: ui.du(2)
                            
                            Label {
                                text: ListItemData['info']['description']
                                multiline: true
                                
                                textStyle {
                                    base: SystemDefaults.TextStyles.SubtitleText
                                    color: Color.create("#ffffff")
                                    fontWeight: FontWeight.W500
                                }
                            }
                        }
                        Label {
                            visible: !!ListItemData['info']['image_source']
                            horizontalAlignment: HorizontalAlignment.Right
                            verticalAlignment: VerticalAlignment.Bottom
                            text: "图片：" + ListItemData['info']['image_source']
                            
                            margin {
                                bottomOffset: ui.du(1)
                                rightOffset: ui.du(2)
                            }
                            
                            textStyle {
                                base: SystemDefaults.TextStyles.SmallText
                                color: Color.create("#eeeeee")
                                fontWeight: FontWeight.W500
                            }
                        }
                    }
                },
                ListItemComponent {
                    type: "editor"
                    Container {
                        Label {
                            function getEditorsName() {
                                var names = [];
                                var len = ListItemData['info'].length
                                var i;
                                
                                for(i = 0; i < len; i++) {
                                    names.push(ListItemData['info'][i]['name']);
                                }
                                return "编辑：" + names.join('、');
                            }
                            margin {
                                leftOffset: ui.du(2)
                                rightOffset: ui.du(2)
                                topOffset: ui.du(1)
                            }
                            text: getEditorsName()
                            multiline: true
                            textStyle {
                                base: SystemDefaults.TextStyles.SmallText
                            }
                        }
                        Divider {
                            
                        }
                    }
                },
                ListItemComponent {
                    type: "story"
                    NewsListItem {
                        listItemData: ListItemData
                    }
                }
            ]
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
    
    onThemeIdChanged: {
        initTimer.start();
    }
    
    attachedObjects: [
        QTimer {
            id: initTimer
            interval: 200
            onTimeout: {
                initTimer.stop();
                root.initTimerRunning = false;
                common.apiThemeList(listRequester, themeId);
            }
        },
        Requester {
            id: listRequester
            onBeforeSend: {
                root.dataLoading = true;
            }
            onFinished: {
                root.dataLoading = false;
                
                var rtData = JSON.parse(data);
                var isAppend = !rtData['name'];
                var stories = rtData['stories']; // 日报列表
                
                common.formatFastImageUrl(stories, 'images', true, true);
                
                if(isAppend) {
                    dm.append(stories);
                }else {
                    // 如果是刷新
                    if(dm.size()) {
                        refreshHeader.endRefresh();
                        _misc.showToast(qsTr("刷新成功"));
                    }
                    
                    var banner = {
                        background: rtData['background'], // 轮播图内容
                        image: rtData['image'], // 轮播图内容
                        name: rtData['name'], // 主题名字
                        image_source: rtData['image_source'], // 图片来源
                        description: rtData['description'] // 描述
                    };
                    var editors = rtData['editors']; // 编辑
                    var list = stories;
                    
                    // 插入编辑信息
                    list.unshift({
                        __type: "editor",
                        info: editors
                    });
                    // 插入顶部图片信息
                    list.unshift({
                        __type: "banner",
                        info: banner
                    });
                    
                    dm.clear();
                    dm.insert(0, list);
                }
                
                // 保存最后一篇文章的ID
                if(stories.length) {
                    root.lastNewsId = stories[stories.length - 1]['id'];
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
        },
        DisplayInfo {
            id: displayInfo
        }
    ]
    
    function pushToNewsPage(newsId) {
        var page = newsPage.createObject();
        page.newsId = newsId;
        
        nav.push(page);
    }
}
