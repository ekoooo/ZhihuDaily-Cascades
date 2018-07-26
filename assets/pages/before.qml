import bb.cascades 1.4
import bb.system 1.2
import bb.device 1.4
import tech.lwl 1.0
import "asset:///components"

Page {
    id: root
    actionBarVisibility: ChromeVisibility.Overlay
    property variant currentDate: Qt.formatDate(dateTimePicker.value, "yyyy/MM/dd")
    property bool dataLoading: false
    property bool isChangeDateRequest: false
    
    titleBar: TitleBar {
        scrollBehavior: TitleBarScrollBehavior.NonSticky
        kind: TitleBarKind.FreeForm
        kindProperties: FreeFormTitleBarKindProperties {
            expandableArea.indicatorVisibility: TitleBarExpandableAreaIndicatorVisibility.Visible
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                leftPadding: ui.du(2)
                
                Label {
                    text: Qt.formatDate(dateTimePicker.value, "yyyy/MM/dd")
                    verticalAlignment: VerticalAlignment.Center
                    textStyle.base: SystemDefaults.TextStyles.TitleText
                }
            }
            expandableArea {
                expanded: false
                toggleArea: TitleBarExpandableAreaToggleArea.EntireTitleBar
                
                content: Container {
                    preferredHeight: displayInfo.pixelSize.height
                    leftPadding: ui.du(2)
                    rightPadding: ui.du(2)
                    
                    layout: DockLayout {
                        
                    }
                    
                    DateTimePicker {
                        id: dateTimePicker
                        verticalAlignment: VerticalAlignment.Center
                        
                        title: qsTr("请选择日期")
                        mode: DateTimePickerMode.Date
                        value: { new Date() }
                        expanded: true
                        onValueChanged: {
                            root.currentDate = Qt.formatDate(dateTimePicker.value, "yyyy/MM/dd");
                        }
                    }
                }
            }
        }
    }
    
    actions: [
        ActionItem {
            title: qsTr("上一天")
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/bb10/ic_reply.png"
            onTriggered: {
                root.changeDate(-1);
            }
        },
        ActionItem {
            title: qsTr("下一天")
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/bb10/ic_forward.png"
            onTriggered: {
                root.changeDate(1);
            }
        }
    ]
    
    Container {
        ListView {
            id: lv
            property variant common_: common
            property variant dm_: dm
            property variant root_: root
            property variant crtDate: root.currentDate
            
            bottomPadding: ui.du(12)
            scrollRole: ScrollRole.Main
            
            dataModel: ArrayDataModel {
                id: dm
            }
            
            onTriggered: {
                if(indexPath.length === 1) {
                    var item = dm.data(indexPath);
                    if(item['type'] == 0) {
                        root_.pushToNewsPage(item['id']);
                    }else {
                        _misc.showToast(qsTr("未知文章类型"));
                    }
                }
            }
            
            listItemComponents: [
                ListItemComponent {
                    type: ""
                    CustomListItem {
                        dividerVisible: true
                        
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
            ]
            onCreationCompleted: {
                listRequester.send(qsTr(api.newsBefore).arg(common.getPreDateStr(root.currentDate)));
            }
            onCrtDateChanged: {
                if(api) {
                    listRequester.send(qsTr(api.newsBefore).arg(common.getPreDateStr(lv.crtDate)));
                }
            }
        }
    }
    
    attachedObjects: [
        Requester {
            id: listRequester
            onBeforeSend: {
                root.dataLoading = true;
            }
            onFinished: {
                var rs = JSON.parse(data);
                var recent = rs['stories'];
                dm.clear();
                dm.insert(0, recent);
                
                if(isChangeDateRequest) {
                    _misc.showToast("加载成功");
                    isChangeDateRequest = false;
                }
                
                root.dataLoading = false;
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
    
    function changeDate(length) {
        if(root.dataLoading) {
            _misc.showToast(qsTr("正在加载数据，别急"));
            return;
        }
        dateTimePicker.value = common.formaTtimestamp(+new Date(root.currentDate) + (length * 86400000), 4);
    }
    
    function pushToNewsPage(newsId) {
        var page = newsPage.createObject();
        page.newsId = newsId;
        
        nav.push(page);
    }
}
