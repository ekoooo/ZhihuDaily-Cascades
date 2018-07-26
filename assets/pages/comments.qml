import bb.cascades 1.4
import tech.lwl 1.0
import "asset:///pages/child"

Page {
    id: root
    property variant newsId // 文章ID（传入）
    property variant selectedValue: "long"
    property int longCommentsCount: 0
    property int shortCommentsCount: 0
    property int likesCount: 0
    
    actionBarVisibility: ChromeVisibility.Compact
    
    titleBar: TitleBar {
        scrollBehavior: TitleBarScrollBehavior.Sticky
        kind: TitleBarKind.Segmented
        options: [
            Option {
                text: qsTr("长评") + (longCommentsCount == 0 ? "" : " - " + longCommentsCount)
                value: "long"
            },
            Option {
                text: qsTr("短评") + (shortCommentsCount == 0 ? "" : " - " + shortCommentsCount)
                value: "short"
            }
        ]
        onSelectedValueChanged: {
            root.selectedValue = selectedValue;
        }
    }
    
    Container {
        layout: StackLayout {
            
        }
        
        Container {
            layout: DockLayout {
                
            }
            
            Container {
                visible: selectedValue === "long"
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                
                CommentList {
                    isActive: selectedValue === "long"
                    commentsApi: api.storyLongComments
                    commentsBeforeApi: api.storyNextLongComments
                    newsId: root.newsId
                    count: root.longCommentsCount
                }
            }
            
            Container {
                visible: selectedValue === "short"
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                
                CommentList {
                    isActive: selectedValue === "short"
                    commentsApi: api.storyShortComments
                    commentsBeforeApi: api.storyNextShortComments
                    newsId: root.newsId
                    count: root.shortCommentsCount
                }
            }
            
            Container {
                id: tip
                visible: selectedValue === "long" ? longCommentsCount == 0 : shortCommentsCount == 0
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
                    text: selectedValue === "long" ? qsTr("深度长评虚位以待") : qsTr("短评虚位以待")
                    horizontalAlignment: HorizontalAlignment.Center
                    textStyle {
                        color: Color.create("#e9e9e9")
                        base: SystemDefaults.TextStyles.SubtitleText
                    }
                }
            }
        }
    }
    
    attachedObjects: [
        Requester {
            id: storyExtraRequester
            onFinished: {
                var rs = JSON.parse(data);
                var count = rs.count;
                
                root.longCommentsCount = count['long_comments'];
                root.shortCommentsCount = count['short_comments'];
                root.likesCount = count['likes'];
            }
            onError: {
                _misc.showToast(error);
            }
        }
    ]
    
    onNewsIdChanged: {
        storyExtraRequester.send(qsTr(api.storyExtra).arg(newsId.toString()));
    }
}
