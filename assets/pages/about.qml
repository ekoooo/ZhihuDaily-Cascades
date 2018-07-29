import bb.cascades 1.4
import bb 1.3
import "asset:///pages/child"

Page {
    objectName: "aboutPage"
    
    actionBarVisibility: ChromeVisibility.Compact
    
    titleBar: TitleBar {
        title: qsTr("关于") + ' v' + applicationInfo.version.split('.').slice(0, 3).join('.')
        scrollBehavior: TitleBarScrollBehavior.NonSticky
    }
    
    attachedObjects: [
        ApplicationInfo {
            id: applicationInfo
        }
    ]
    
    ScrollView {
        Container {
            bottomPadding: ui.du(14)
            Header {
                title: qsTr("项目")
            }
            ItemContainer {
                Label {
                    text: qsTr('开发：<a href="https://github.com/ekoooo">ekoo</a>。<br/>' + 
                    '开源：<a href="https://github.com/ekoooo/l-blog/ZhihuDaily-Cascades">ZhihuDaily-Cascades</a>。<br/>' + 
                    '建议：希望添加的功能或发现的问题可以通过 <a href="https://github.com/ekoooo/ZhihuDaily-Cascades/issues">Issue(推荐)</a> 或 <a href="mailto: 954408050@qq.com">邮件</a> 告知。')
                    textStyle {
                        base: SystemDefaults.TextStyles.SubtitleText
                        color: Color.Gray
                    }
                    multiline: true
                    textFormat: TextFormat.Html
                }
            }
            Divider {}
            Header {
                title: qsTr("初衷")
            }
            ItemContainer {
                Label {
                    text: qsTr('　　最原始版功能相对简单，本人之前开发的 Html5 版性能不足，存在发热情况，故开发此版本。')
                    multiline: true
                }
            }
            Divider {}
            Header {
                title: qsTr("评价")
            }
            ItemContainer {
                Label {
                    text: qsTr('　　煤油的评价是我继续开发的动力，希望使用的煤油可以对本软件进行评价。如果可以，下一个项目将会是《喜马拉雅FM》。')
                    multiline: true
                }
            }
            ItemContainer {
                layout_: DockLayout {
                
                }
                horizontalAlignment: HorizontalAlignment.Fill
                Button {
                    text: qsTr("立即评价")
                    horizontalAlignment: HorizontalAlignment.Center
                    onClicked: {
                        // _misc.invokeBBWorld("appworld://content/12345");
                    }
                }
            }
            Divider {}
            Header {
                title: qsTr("声明")
            }
            ItemContainer {
                Label {
                    text: qsTr('　　本项目文字图片等稿件内容均由 <a href="http://daily.zhihu.com/">知乎</a> 提供。若被告知需停止共享与使用，本人会及时删除整个项目。请您了解相关情况，并遵守知乎协议。')
                    textFormat: TextFormat.Html
                    multiline: true
                }
            }
        }
    }
}