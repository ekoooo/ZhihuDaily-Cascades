import bb.cascades 1.4
import bb.device 1.4
import tech.lwl 1.0

/**
 * 文章页
 */
Page {
    id: root
    property variant newsId // 文章ID（传入）
    property variant newsData; // 文章内容（从接口中获取）
    
    property variant dH: displayInfo.pixelSize.height
    property variant imageHeight: dH / 3 
    property bool loading: false
    property bool isNewsEyeProtectionModel: _misc.getConfig(common.settingsKey.newsEyeProtectionModel, "0") == "1"
    property bool isNewsLargeFont: _misc.getConfig(common.settingsKey.newsLargeFont, "0") == "1"
    
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    actionBarVisibility: ChromeVisibility.Overlay
    
    
    shortcuts: [
        Shortcut {
            key: common.shortCutKey.commonPage
            onTriggered: {
                root.goCommentsPage();
            }
        }
    ]
    
    actions: [
        ActionItem {
            title: qsTr("评论")
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///images/bb10/ic_textmessage_dk.png"
            
            onTriggered: {
                root.goCommentsPage();
            }
        },
        ActionItem {
            title: qsTr("护眼")
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: isNewsEyeProtectionModel ? "asset:///images/bb10/ic_enable.png" : "asset:///images/bb10/ic_disable.png"
            onTriggered: {
                if(isNewsEyeProtectionModel) {
                    _misc.setConfig(common.settingsKey.newsEyeProtectionModel, "0");
                    isNewsEyeProtectionModel = false;
                }else {
                    _misc.setConfig(common.settingsKey.newsEyeProtectionModel, "1");
                    isNewsEyeProtectionModel = true;
                }
            }
        },
        InvokeActionItem {
            title: qsTr("分享")
            ActionBar.placement: ActionBarPlacement.Signature
            query {
                mimeType: "text/plain"
                invokeActionId: "bb.action.SHARE"
            }
            onTriggered: {
                var shareText = qsTr('%1（分享自 @知乎日报）%2');
                
                data = _misc.toUtf8(shareText.arg(newsData['title']).arg(newsData['share_url']));
            }
        }
    ]
    
    Container {
        layout: DockLayout {
            
        }
        
        ScrollView {
            id: sv
            scrollRole: ScrollRole.Main
            
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            
            content: containerDelegate.object
        }
        
        Container {
            visible: loading
            
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            layout: DockLayout {
            
            }
            background: Color.create(0, 0, 0, 0.2)
            
            ActivityIndicator {
                running: true
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                preferredHeight: ui.du(10)
                preferredWidth: ui.du(10)
            }
        }
    }

    attachedObjects: [
        Requester {
            id: newsRequester
            onBeforeSend: {
                root.loading = true;
            }
            onFinished: {
                try {
                    root.newsData = JSON.parse(data);
                    containerDelegate.active = true;
                }catch(e) {
                    _misc.showToast(qsTr("文章数据格式转换失败"));
                    root.loading = false;
                }
            }
            onError: {
                _misc.showToast(error);
                root.loading = false;
            }
        },
        DisplayInfo {
            id: displayInfo
        },
        Delegate {
            id: containerDelegate

            Container {
                horizontalAlignment: HorizontalAlignment.Fill
                
                WebImageView {
                    id: invokeImage
                    visible: false
                    onLoaded: {
                        invokeViewImage();
                    }
                }
                Container {
                    visible: !!newsData.image
                    layout: DockLayout {

                    }
                    horizontalAlignment: HorizontalAlignment.Fill
                    preferredHeight: imageHeight

                    WebImageView {
                        url: newsData.image || "asset:///images/image_top_default.png"
                        scalingMethod: ScalingMethod.AspectFill
                        verticalAlignment: VerticalAlignment.Fill
                        horizontalAlignment: HorizontalAlignment.Fill
                        implicitLayoutAnimationsEnabled: false
                        loadingImageSource: "asset:///images/image_top_default.png"
                        failImageSource: "asset:///images/image_top_default.png"
                        onTouch: {
                            if(event.isUp()) {
                                invokeViewImage();
                            }
                        }
                    }
                    Container {
                        horizontalAlignment: HorizontalAlignment.Center
                        verticalAlignment: VerticalAlignment.Bottom

                        margin {
                            bottomOffset: ui.du(6)
                        }
                        leftPadding: ui.du(2)
                        rightPadding: ui.du(2)

                        Label {
                            text: newsData.title
                            multiline: true

                            textStyle {
                                base: SystemDefaults.TextStyles.BodyText
                                color: Color.create("#ffffff")
                                fontWeight: FontWeight.W500
                            }
                        }
                    }
                    Label {
                        visible: !!newsData['image_source']
                        horizontalAlignment: HorizontalAlignment.Right
                        verticalAlignment: VerticalAlignment.Bottom
                        text: "图片：" + newsData['image_source']
                        
                        margin {
                            bottomOffset: ui.du(1)
                            rightOffset: ui.du(2)
                        }
                        
                        textStyle {
                            base: SystemDefaults.TextStyles.SmallText
                            color: Color.create("#eeeeee")
                            fontWeight: FontWeight.W500
                        }
                    }
                }
                
                WebView {
                    id: webView
                    property variant eyeProtectionModel: root.isNewsEyeProtectionModel
                    property variant templateHtml: '<html>
                        <head id="head">
                            <meta charset="utf-8">
                            <meta name="viewport" content="width=device-width,user-scalable=no">
                            <link href="local:///assets/source/news_qa.min.css" rel="stylesheet">
                            <script src="local:///assets/source/zepto.min.js"></script>
                        </head>
                        <body id="body" class="%2">
                            %1
                            <script src="local:///assets/source/newsInjector.js"></script>
                        </body>
                    </html>';
                    
                    html: qsTr(templateHtml)
                            .arg(root.newsData['body'])
                            .arg(isNewsLargeFont ? 'large' : '')
                    onLoadingChanged: {
                        if(loadRequest.status === WebLoadStatus.Started) {
                            webView.eyeProtectionModel && webView.evaluateJavaScript('setNightMode(true)');
                        }else if(loadRequest.status === WebLoadStatus.Succeeded) {
                            // 继续设置（防止上面未执行成功）
                            webView.eyeProtectionModel && webView.evaluateJavaScript('setNightMode(true)');
                            root.loading = false;
                        }
                    }
                    onMessageReceived: {
                        var msg = JSON.parse(message.data);
                        
                        if(msg.event === 'invokeImage') {
                            invokeImage.url = msg.url;
                        }else if(msg.event === 'invokeLink') {
                            _misc.invokeBrowser(msg.url);
                        }
                    }
                    onEyeProtectionModelChanged: {
                        // 切换护眼模式
                        webView.evaluateJavaScript(webView.eyeProtectionModel ? 'setNightMode(true)' : 'setNightMode(false)');
                    }
                }
            }
        }, // containerDelegate end
        ComponentDefinition {
            id: commentsPage
            source: "asset:///pages/comments.qml"
        }
    ]
    
    // 拉取文章信息
    onNewsIdChanged: {
        common.apiNews(newsRequester, newsId);
    }
    
    function goCommentsPage() {
        var page = commentsPage.createObject();
        page.newsId = newsId;
        nav.push(page);
    }
}
