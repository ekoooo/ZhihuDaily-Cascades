import bb.cascades 1.4
import tech.lwl 1.0
import "asset:///pages/child"

Page {
    id: root
    property variant newsId // 文章ID（传入）
    property bool selectedLong: false
    property int longCommentsCount: 0
    property int shortCommentsCount: 0
    property int likesCount: 0
    property bool initTimerRunning: true
    property bool loading: true
    
    actionBarVisibility: ChromeVisibility.Compact
    
    titleBar: TitleBar {
        id: titleBar
        scrollBehavior: TitleBarScrollBehavior.Sticky
        kind: TitleBarKind.Segmented
        options: [
            Option {
                text: qsTr("长评") + (longCommentsCount == 0 ? "" : " - " + longCommentsCount)
                value: true
            },
            Option {
                text: qsTr("短评") + (shortCommentsCount == 0 ? "" : " - " + shortCommentsCount)
                value: false
                selected: true
            }
        ]
        onSelectedValueChanged: {
            root.selectedLong = selectedValue;
        }
    }
    
    shortcuts: [
        Shortcut {
            key: common.shortCutKey.switchCommonType
            onTriggered: {
                titleBar.setSelectedIndex(root.selectedLong ? 1 : 0);
            }
        }
    ]
    
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
        
        Container {
            layout: DockLayout {}
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            
            // 提示
            Container {
                id: tip
                visible: !loading && (selectedLong ? longCommentsCount == 0 : shortCommentsCount == 0)
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                
                layout: StackLayout {
                
                }
                WebImageView {
                    url: "asset:///images/comment_empty.png"
                    preferredWidth: ui.du(30)
                    scalingMethod: ScalingMethod.AspectFit
                }
                Label {
                    text: selectedLong ? qsTr("深度长评虚位以待") : qsTr("短评虚位以待")
                    horizontalAlignment: HorizontalAlignment.Center
                    textStyle {
                        color: Color.create("#e9e9e9")
                        base: SystemDefaults.TextStyles.SubtitleText
                    }
                }
            }
            
            // 短评
            Container {
                visible: !selectedLong
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                
                CommentList {
                    isActive: !selectedLong
                    commentsApi: common.api.storyShortComments
                    commentsBeforeApi: common.api.storyNextShortComments
                    newsId: root.newsId
                    count: root.shortCommentsCount
                }
            }
            
            // 长评
            Container {
                visible: selectedLong
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                
                CommentList {
                    isActive: selectedLong
                    commentsApi: common.api.storyLongComments
                    commentsBeforeApi: common.api.storyNextLongComments
                    newsId: root.newsId
                    count: root.longCommentsCount
                }
            }
        }
    }
    
    attachedObjects: [
        Requester {
            id: storyExtraRequester
            onBeforeSend: {
                root.loading = true;
            }
            onFinished: {
                var rs = JSON.parse(data);
                var count = rs.count;
                
                root.longCommentsCount = count['long_comments'];
                root.shortCommentsCount = count['short_comments'];
                root.likesCount = count['likes'];
                
                root.loading = false;
            }
            onError: {
                root.loading = false;
                _misc.showToast(error);
            }
        },
        QTimer {
            id: initTimer
            interval: 200
            onTimeout: {
                initTimer.stop();
                root.initTimerRunning = false;
                common.apiStoryExtra(storyExtraRequester, storyExtraRequester, newsId);
            }
        }
    ]
    
    onNewsIdChanged: {
        initTimer.start();
    }
}
