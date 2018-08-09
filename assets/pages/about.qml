import bb.cascades 1.4
import "asset:///pages/child"

Page {
    objectName: "aboutPage"
    actionBarVisibility: ChromeVisibility.Compact
    
    Container {
        Header {
            title: qsTr("关于") + ' v' + common.version
        }
        ScrollView {
            scrollRole: ScrollRole.Main
            
            Container {
                bottomPadding: ui.du(14)
                ItemContainer {
                    Label {
                        text: qsTr('开发：<a href="https://github.com/ekoooo">ekoo</a>。<br/>' + 
                        '开源：<a href="https://github.com/ekoooo/ZhihuDaily-Cascades">ZhihuDaily-Cascades</a>。<br/>' + 
                        '建议：希望添加的功能或发现的问题可以通过 <a href="https://github.com/ekoooo/ZhihuDaily-Cascades/issues">Issue(推荐)</a> 或 <a href="mailto: ' + common.developerEmail + '">邮件</a> 告知。')
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
                        text: qsTr('　　莓友的评价是我继续开发的动力，希望使用的莓友可以对本软件进行评价。如果可以，下一个项目将会是《喜马拉雅FM》。')
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
                            _misc.invokeBBWorld(common.bbwAddr);
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
}
