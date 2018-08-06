import bb.cascades 1.4
import tech.lwl 1.0
import "asset:///pages/child"

Page {
    id: root
    objectName: "sponsorPage"
    
    property bool isLoading: false
    property variant version: ''
    
    actionBarVisibility: ChromeVisibility.Compact
    
    Container {
        Header {
            title: qsTr("致谢") + version
            subtitle: qsTr("我要赞助 ➤")
            mode: HeaderMode.Plain
            onTouch: {
                if(event.isUp()) {
                    nav.push(sponsorInfoPage.createObject());
                }
            }
        }
        Container {
            layout: DockLayout {
                
            }
            ActivityIndicator {
                visible: isLoading
                running: isLoading
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                preferredHeight: ui.du(10)
                preferredWidth: ui.du(10)
            }
            
            ListView {
                bottomPadding: ui.du(14)
                
                scrollRole: ScrollRole.Main
                
                dataModel: ArrayDataModel {
                    id: dm
                }
                // 重写 itemType
                function itemType(data, indexPath) {
                    return data.__type || "item";
                }
                
                listItemComponents: [
                    ListItemComponent {
                        type: "message"
                        Container {
                            layout: DockLayout {}
                            ItemContainer {
                                Label {
                                    text: "　　" + ListItemData['message']
                                    multiline: true
                                }
                                horizontalAlignment: HorizontalAlignment.Fill
                                verticalAlignment: VerticalAlignment.Center
                            }
                            Divider {
                                verticalAlignment: VerticalAlignment.Top
                            }
                            Divider {
                                verticalAlignment: VerticalAlignment.Bottom
                            }
                        }
                    },
                    ListItemComponent {
                        type: "placeholder"
                        CustomListItem {
                            visible: ListItemData['isEmpty']
                            dividerVisible: false
                            
                            Container {
                                horizontalAlignment: HorizontalAlignment.Center
                                topPadding: ui.du(10)
                                bottomPadding: ui.du(10)
                                
                                WebImageView {
                                    url: "asset:///images/comment_empty.png"
                                    preferredWidth: ui.du(30)
                                    scalingMethod: ScalingMethod.AspectFit
                                }
                                Label {
                                    text: qsTr("暂无赞助莓友")
                                    horizontalAlignment: HorizontalAlignment.Center
                                    textStyle {
                                        color: Color.create("#e9e9e9")
                                        base: SystemDefaults.TextStyles.SubtitleText
                                    }
                                }
                            }
                        }
                    },
                    ListItemComponent {
                        type: "item"
                        CustomListItem {
                            dividerVisible: true
                            Container {
                                leftPadding: ui.du(2)
                                rightPadding: ui.du(2)
                                verticalAlignment: VerticalAlignment.Center
                                
                                Container {
                                    layout: StackLayout {
                                        orientation: LayoutOrientation.LeftToRight
                                    }
                                    topPadding: ui.du(1)
                                    bottomPadding: ui.du(1)
                                    Label {
                                        text: qsTr("姓名")
                                        layoutProperties: StackLayoutProperties {
                                            spaceQuota: 1
                                        }
                                    }
                                    Label {
                                        id: nameLabel
                                        text: nameLabel.getText()
                                        textFormat: TextFormat.Html
                                        
                                        function getText() {
                                            var info = ListItemData['name'];
                                            
                                            if(ListItemData['url']) {
                                                var url = ListItemData['url'];
                                                if(url.indexOf('http') === -1) {
                                                    url = 'http://' + url;
                                                }
                                                
                                                return '<a href="' + url + '">' + info + '</a>';
                                            }
                                            return info;
                                        }
                                    }
                                }
                                Container {
                                    layout: StackLayout {
                                        orientation: LayoutOrientation.LeftToRight
                                    }
                                    bottomPadding: ui.du(1)
                                    Label {
                                        text: qsTr("金额")
                                        layoutProperties: StackLayoutProperties {
                                            spaceQuota: 1
                                        }
                                    }
                                    Label {
                                        text: ListItemData['via'] + '￥' + ListItemData['amount']
                                    }
                                }
                                Container {
                                    layout: StackLayout {
                                        orientation: LayoutOrientation.LeftToRight
                                    }
                                    bottomPadding: ui.du(1)
                                    Label {
                                        text: qsTr("日期")
                                        layoutProperties: StackLayoutProperties {
                                            spaceQuota: 1
                                        }
                                    }
                                    Label {
                                        text: ListItemData['date']
                                    }
                                }
                            }
                        }
                    }
                ]
                
                onCreationCompleted: {
                    common.apiSponsor(dataRequester);
                }
            }
        }
    }
    
    attachedObjects: [
        Requester {
            id: dataRequester
            onBeforeSend: {
                root.isLoading = true;
            }
            onFinished: {
                root.isLoading = false;
                
                var obj = JSON.parse(data);
                
                if(obj.code !== 200) {
                    _misc.showToast(obj.message);
                    return;
                }
                
                var rs = obj['info'];
                var list = rs['list'];
                
                list.unshift({
                    "__type": "placeholder",
                    "isEmpty": !list.length
                });
                list.unshift({
                    "__type": "message",
                    "message": rs['developer_message']
                });
                
                dm.clear();
                dm.insert(0, list);
                root.version = ' v' + rs['version'];
            }
            onError: {
                _misc.showToast(qsTr("赞助名单正在更新，马上就好"));
                root.isLoading = false;
            }
        },
        ComponentDefinition {
            id: sponsorInfoPage
            source: "asset:///pages/sponsorInfo.qml"
        }
    ]
}
