import bb.cascades 1.4
import tech.lwl 1.0
import "asset:///pages/child"

Page {
    id: root
    property variant newsId // 文章ID（传入）
    property variant selectedValue: "long"
    property bool longCommentsEmpty: true
    property bool shortCommentsEmpty: true
    
    actionBarVisibility: ChromeVisibility.Compact
    
    Container {
        layout: StackLayout {
            
        }
        topPadding: ui.du(1)
        
        SegmentedControl {
            options: [
                Option {
                    text: qsTr("长评")
                    value: "long"
                },
                Option {
                    text: qsTr("短评")
                    value: "short"
                }
            ]
            onSelectedValueChanged: {
                root.selectedValue = selectedValue;
            }
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
                    onAppendData: {
                        longCommentsEmpty = false;
                    }
                }
            }
            
            Container {
                visible: selectedValue === "short"
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                
                CommentList {
                    isActive: selectedValue === "long"
                    commentsApi: api.storyShortComments
                    commentsBeforeApi: api.storyNextShortComments
                    newsId: root.newsId
                    onAppendData: {
                        shortCommentsEmpty = false;
                    }
                }
            }
            
            Container {
                id: tip
                visible: selectedValue === "long" ? longCommentsEmpty : shortCommentsEmpty
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
    
}
