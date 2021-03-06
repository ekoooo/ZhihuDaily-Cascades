import bb.cascades 1.4
import bb.system 1.2
import bb.device 1.4
import tech.lwl 1.0
import "asset:///components"
import "asset:///pages/child"

Page {
    id: root
    actionBarVisibility: ChromeVisibility.Overlay
    property variant currentDate: Qt.formatDate(dateTimePicker.value, "yyyy/MM/dd")
    property variant maximumDate: new Date()
    property variant minimumDate: new Date('2013/05/20')
    property bool expanded: false
    
    titleBar: TitleBar {
        scrollBehavior: TitleBarScrollBehavior.Sticky
        kind: TitleBarKind.FreeForm
        kindProperties: FreeFormTitleBarKindProperties {
            expandableArea.indicatorVisibility: TitleBarExpandableAreaIndicatorVisibility.Visible
            
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                leftPadding: ui.du(2)
                
                Label {
                    text: currentDate
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
                        expanded: root.expanded
                        verticalAlignment: VerticalAlignment.Center
                        title: qsTr("请选择日期")
                        mode: DateTimePickerMode.Date
                        value: { new Date() }
                        maximum: { maximumDate }
                        minimum: { minimumDate }
                        onValueChanged: {
                            root.currentDate = Qt.formatDate(dateTimePicker.value, "yyyy/MM/dd");
                        }
                    }
                }
                
                onExpandedChanged: {
                    root.expanded = expanded;
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
                if(root.currentDate === common.formaTtimestamp(+minimumDate, 4)) {
                    _misc.showToast(qsTr("上一天没有文章了"));
                    return;
                }
                root.changeDate(-1);
            }
            shortcuts: [
                Shortcut {
                    key: common.shortCutKey.beforeNewPreDay
                }
            ]
        },
        ActionItem {
            title: qsTr("下一天")
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/bb10/ic_forward.png"
            onTriggered: {
                if(root.currentDate === common.formaTtimestamp(+maximumDate, 4)) {
                    _misc.showToast(qsTr("下一天没有文章了"));
                    return;
                }
                root.changeDate(1);
            }
            shortcuts: [
                Shortcut {
                    key: common.shortCutKey.beforeNewNextDay
                }
            ]
        }
    ]
    
    Container {
        ListView {
            visible: !root.expanded
            
            property variant root_: root
            property variant crtDate: root.currentDate
            
            bottomPadding: ui.du(14)
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
                    NewsListItem {
                        listItemData: ListItemData
                    }
                }
            ]
            onCrtDateChanged: {
                // 应该+1天才是获取当前天的日报
                common.apiNewsBefore(listRequester, common.getNextDateStr(root.currentDate));
            }
        }
    }
    
    attachedObjects: [
        Requester {
            id: listRequester
            onBeforeSend: {
                
            }
            onFinished: {
                var rs = JSON.parse(data);
                var recent = rs['stories'];
                
                common.formatFastImageUrl(recent, 'images', true, true);
                
                dm.clear();
                dm.insert(0, recent);
            }
            onError: {
                _misc.showToast(error);
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
        dateTimePicker.value = common.formaTtimestamp(+new Date(root.currentDate) + (length * 86400000), 4);
    }
    
    function pushToNewsPage(newsId) {
        var page = newsPage.createObject();
        page.newsId = newsId;
        
        nav.push(page);
    }
}
