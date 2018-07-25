import bb.cascades 1.4
import tech.lwl 1.0
import "asset:///components"

ListView {
    id: lv
    property variant common_: common
    property variant commentsApi;
    property variant commentsBeforeApi;
    property variant newsId;
    property bool isActive;
    
    property variant lastCommentId // 最后一个评论ID（用于加载下一页）
    property bool commentsLoadEnd: false // 是否全部加载完毕
    property bool commentsLoading: false
    
    signal appendData();
    
    dataModel: ArrayDataModel {
        id: dm
    }
    listItemComponents: [
        ListItemComponent {
            type: ""
            CustomListItem {
                id: item
                dividerVisible: true

                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    topPadding: ui.du(2)
                    bottomPadding: ui.du(2)
                    leftPadding: ui.du(2)
                    rightPadding: ui.du(2)

                    WebImageView {
                        preferredWidth: ui.du(8)
                        preferredHeight: ui.du(8)

                        url: ListItemData['avatar']
                    }
                    Container {
                        topPadding: ui.du(2)
                        leftPadding: ui.du(2)

                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1
                        }
                        layout: StackLayout {
                            orientation: LayoutOrientation.TopToBottom
                        }
                        Container {
                            rightPadding: ui.du(2)
                            horizontalAlignment: HorizontalAlignment.Fill
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }

                            Label {
                                text: ListItemData['author']
                                layoutProperties: StackLayoutProperties {
                                    spaceQuota: 1
                                }
                                textStyle {
                                    fontWeight: FontWeight.Bold
                                }
                            }
                            Container {
                                layout: StackLayout {
                                    orientation: LayoutOrientation.LeftToRight
                                }
                                WebImageView {
                                    preferredWidth: ui.du(4)
                                    preferredHeight: ui.du(4)
                                    url: "asset:///images/comment_vote.png"
                                }
                                Label {
                                    text: ListItemData['likes']
                                    textStyle {
                                        base: SystemDefaults.TextStyles.SubtitleText
                                        color: Color.Gray
                                    }
                                }
                            }
                        }
                        Label {
                            text: ListItemData['content']
                            multiline: true
                        }
                        Container {
                            id: replyContainer
                            property variant replyInfo: ListItemData['reply_to'] || new Object()

                            visible: !!ListItemData['reply_to']
                            Label {
                                text: "@" + replyContainer.replyInfo['author'] + "："
                                textStyle {
                                    fontWeight: FontWeight.Bold
                                }
                            }
                            Label {
                                text: "　　" + replyContainer.replyInfo['content']
                                multiline: true
                            }
                        }
                        Label {
                            text: item.ListItem.view.common_.formaTtimestamp(ListItemData['time'], 2)
                            textStyle {
                                base: SystemDefaults.TextStyles.SubtitleText
                                color: Color.Gray
                            }
                        }
                    }
                }
            }
        }
    ]
    
    attachedObjects: [
        Requester {
            id: commentsRequester
            onBeforeSend: {
                commentsLoading = true;
            }
            onFinished: {
                commentsLoading = false;
                try {
                    var rs = JSON.parse(data);
                    var comments = rs['comments'];
                    
                    if(!comments || comments.length === 0) {
                        commentsLoadEnd = true;
                    }else {
                        dm.append(comments);
                        // 保存最后一个ID
                        lastCommentId = comments[comments.length - 1]['id'];
                        appendData();
                    }
                }catch(e) {
                    _misc.showToast(qsTr("评论数据格式转换失败"));
                }
            }
            onError: {
                _misc.showToast(error);
                commentsLoading = false;
            }
        },
        ListScrollStateHandler {
             onAtEndChanged: {
                 
             }
        }
    ]
    onNewsIdChanged: {
        if(newsId) {
            // 初始化长评论
            commentsRequester.send(qsTr(commentsApi).arg(newsId.toString()));
        }
    }
    onIsActiveChanged: {
        lv.scrollRole = isActive ? ScrollRole.Main : ScrollRole.None
    }
}
