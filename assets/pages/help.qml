import bb.cascades 1.4
import tech.lwl 1.0
import "asset:///pages/child"

Page {
    objectName: "helpPage"
    
    actionBarVisibility: ChromeVisibility.Compact
    
    ScrollView {
        Container {
            bottomPadding: ui.du(14)
            Header {
                title: qsTr("模块")
            }
            ItemContainer {
                layout_: StackLayout {
                    orientation: LayoutOrientation.TopToBottom
                }
                Label {
                    text: qsTr("主页、今日热门、栏目分类、主题日报、过往文章。")
                    multiline: true
                }
                Label {
                    text: qsTr("文章阅读、评论查看。")
                    multiline: true
                }
                Label {
                    text: qsTr("帮助、赞助、关于、设置。")
                    multiline: true
                }
            }
            Divider {}
            Header {
                title: qsTr("提示")
            }
            ItemContainer {
                layout_: StackLayout {
                    orientation: LayoutOrientation.TopToBottom
                }
                Label {
                    text: qsTr("一、文章图片可点击预览，可保持到本地。")
                    multiline: true
                }
                Label {
                    text: qsTr("二、被回复长评默认显示两行，点击可显示全部。")
                    multiline: true
                }
                Label {
                    text: qsTr("三、部分列表可下拉刷新。")
                    multiline: true
                }
                Label {
                    text: qsTr("四、帮助、赞助、关于、设置 被禁止打开菜单。")
                    multiline: true
                }
            }
            Divider {}
            Header {
                title: qsTr("快捷键")
            }
            Container {
                id: c
                
                onCreationCompleted: {
                    var shortCutKey = common.shortCutKey;
                    var shortCutList = shortCutKey['shortCutList'];
                    var key, label, i, length = shortCutList.length, labelKey;
                    
                    for(i = 0; i < length; i++) {
                        key = shortCutKey[shortCutList[i]];
                        label = shortCutKey[shortCutList[i] + 'Label'];
                        
                        var item = shortCutKeyItem.createObject();
                        item.key = key;
                        item.label = label;
                        
                        c.add(item);
                    }
                }
            }
            ItemContainer {
                Label {
                    text: qsTr("为保证不与系统快自带捷键冲突，有的快捷键是根据拼音首字母指定的。")
                    textStyle {
                        base: SystemDefaults.TextStyles.SubtitleText
                        color: Color.Gray
                    }
                    multiline: true
                }
            }
        }
    }
    
    attachedObjects: [
        ComponentDefinition {
            id: shortCutKeyItem
            ItemContainer {
                property variant key;
                property variant label;
                Label {
                    text: label
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1
                    }
                }
                Label {
                    text: key
                }
            }
        }
    ]
}
