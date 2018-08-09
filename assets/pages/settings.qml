import bb.cascades 1.4
import tech.lwl 1.0
import "asset:///pages/child"

Page {
    objectName: "settingsPage"
    
    actionBarVisibility: ChromeVisibility.Compact
    
    property variant imageCacheSize: "calcing"
    property variant requestCacheSize: "calcing"
    
    onCreationCompleted: {
        calcInfo(true);
    }
    
    function calcInfo(init) {
        if(init) {
            newsLargeFontToggleButton.checked = _misc.getConfig(common.settingsKey.newsLargeFont, "0") === "1";
            backButtonVisiableToggleButton.checked = _misc.getConfig(common.settingsKey.backButtonVisiable, "1") === "1";
            fastModeToggleButton.checked = _misc.getConfig(common.settingsKey.fastMode, "0") === "1";
            newsAutoLoadGifToggleButton.checked = _misc.getConfig(common.settingsKey.newsAutoLoadGif, "0") === "1";
            themeToggleButton.checked = _misc.getConfig(common.settingsKey.theme, "Light") === "Dark";
        }
        
        imageCacheSize = _misc.webImageViewCacheSize();
        requestCacheSize = _misc.requesterCacheSize();
    }
    
    ScrollView {
        scrollRole: ScrollRole.Main
        
        Container {
            bottomPadding: ui.du(14)
            // 视觉设置
            Container {
                Header {
                    title: qsTr("视觉设置")
                }
                ItemContainer {
                    Label {
                        verticalAlignment: VerticalAlignment.Center
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1
                        }
                        text: qsTr("应用暗色主题")
                    }
                    
                    ToggleButton {
                        id: themeToggleButton
                        verticalAlignment: VerticalAlignment.Center
                        onCheckedChanged: {
                            if(checked) {
                                _misc.setConfig(common.settingsKey.theme, "Dark");
                                _misc.setTheme("Dark");
                            }else {
                                _misc.setConfig(common.settingsKey.theme, "Bright");
                                _misc.setTheme("Bright");
                            }
                        }
                    }
                }
                ItemContainer {
                    Label {
                        text: qsTr("与文章护眼模式相互独立，护眼模式直接在文章页中可设置")
                        textStyle {
                            base: SystemDefaults.TextStyles.SubtitleText
                            color: Color.Gray
                        }
                        multiline: true
                    }
                }
                Divider {}
            }
            
            // 阅读
            Container {
                Header {
                    title: qsTr("阅读")
                }
                ItemContainer {
                    Label {
                        verticalAlignment: VerticalAlignment.Center
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1
                        }
                        text: qsTr("文章大字体模式")
                    }
                    
                    ToggleButton {
                        id: newsLargeFontToggleButton
                        verticalAlignment: VerticalAlignment.Center
                        onCheckedChanged: {
                            if(checked) {
                                _misc.setConfig(common.settingsKey.newsLargeFont, "1");
                            }else {
                                _misc.setConfig(common.settingsKey.newsLargeFont, "0");
                            }
                        }
                    }
                }
                ItemContainer {
                    Label {
                        text: qsTr("重新进入文章页面生效，如需调整全局字体大小，请前往系统 设置/显示屏/字体大小 处进行设置")
                        textStyle {
                            base: SystemDefaults.TextStyles.SubtitleText
                            color: Color.Gray
                        }
                        multiline: true
                    }
                }
                ItemContainer {
                    Label {
                        verticalAlignment: VerticalAlignment.Center
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1
                        }
                        text: qsTr("无图模式")
                    }
                    
                    ToggleButton {
                        id: fastModeToggleButton
                        verticalAlignment: VerticalAlignment.Center
                        onCheckedChanged: {
                            if(checked) {
                                _misc.setConfig(common.settingsKey.fastMode, "1");
                            }else {
                                _misc.setConfig(common.settingsKey.fastMode, "0");
                            }
                        }
                    }
                }
                ItemContainer {
                    Label {
                        text: qsTr("刷新页面生效，文章图片可点击加载")
                        textStyle {
                            base: SystemDefaults.TextStyles.SubtitleText
                            color: Color.Gray
                        }
                        multiline: true
                    }
                }
                ItemContainer {
                    Label {
                        verticalAlignment: VerticalAlignment.Center
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1
                        }
                        text: qsTr("文章自动加载 gif 图片")
                    }
                    
                    ToggleButton {
                        id: newsAutoLoadGifToggleButton
                        verticalAlignment: VerticalAlignment.Center
                        onCheckedChanged: {
                            if(checked) {
                                _misc.setConfig(common.settingsKey.newsAutoLoadGif, "1");
                            }else {
                                _misc.setConfig(common.settingsKey.newsAutoLoadGif, "0");
                            }
                        }
                    }
                }
                ItemContainer {
                    Label {
                        text: qsTr("如果开启无图模式，开启自动加载将无效")
                        textStyle {
                            base: SystemDefaults.TextStyles.SubtitleText
                            color: Color.Gray
                        }
                        multiline: true
                    }
                }
                Divider {}
            }
            
            // 是否显示返回按钮
            Container {
                Header {
                    title: qsTr("返回按钮")
                }
                ItemContainer {
                    Label {
                        verticalAlignment: VerticalAlignment.Center
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1
                        }
                        text: qsTr("是否显示返回按钮")
                    }
                    
                    ToggleButton {
                        id: backButtonVisiableToggleButton
                        verticalAlignment: VerticalAlignment.Center
                        onCheckedChanged: {
                            if(checked) {
                                _misc.setConfig(common.settingsKey.backButtonVisiable, "1");
                            }else {
                                _misc.setConfig(common.settingsKey.backButtonVisiable, "0");
                            }
                            
                            // 更新主页信息
                            tabbedPane.backButtonVisiable = checked;
                        }
                    }
                }
                Divider {}
            }
            
            // 应用缓存
            Container {
                Header {
                    title: qsTr("应用缓存")
                }
                ItemContainer {
                    Label {
                        verticalAlignment: VerticalAlignment.Bottom
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1
                        }
                        text: qsTr("图片缓存")
                    }
                    
                    Label {
                        verticalAlignment: VerticalAlignment.Bottom
                        text: imageCacheSize
                        implicitLayoutAnimationsEnabled: false
                        textStyle {
                            base: SystemDefaults.TextStyles.SubtitleText
                        }
                    }
                }
                ItemContainer {
                    Label {
                        verticalAlignment: VerticalAlignment.Bottom
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1
                        }
                        text: qsTr("数据缓存")
                    }
                    Label {
                        verticalAlignment: VerticalAlignment.Bottom
                        text:  requestCacheSize
                        implicitLayoutAnimationsEnabled: false
                        textStyle {
                            base: SystemDefaults.TextStyles.SubtitleText
                        }
                    }
                }
                ItemContainer {
                    Label {
                        text: qsTr("图片最大缓存：100MB。数据最大缓存：100MB")
                        textStyle {
                            base: SystemDefaults.TextStyles.SubtitleText
                            color: Color.Gray
                        }
                        multiline: true
                    }
                }
                ItemContainer {
                    layout_: DockLayout {
                    
                    }
                    horizontalAlignment: HorizontalAlignment.Fill
                    Button {
                        text: qsTr("清空缓存")
                        horizontalAlignment: HorizontalAlignment.Center
                        onClicked: {
                            try {
                                _misc.clearCache();
                                calcInfo();
                            }catch(e) {
                                _misc.showToast(e);
                            }
                        }
                    }
                }
                Divider {}
            }

            // 重置应用
            Container {
                Header {
                    title: qsTr("重置应用")
                }
                ItemContainer {
                    Label {
                        text: qsTr("重置应用将恢复默认设置，以及清空缓存")
                        textStyle {
                            base: SystemDefaults.TextStyles.SubtitleText
                            color: Color.Gray
                        }
                        multiline: true
                    }
                }
                ItemContainer {
                    layout_: DockLayout {
                        
                    }
                    horizontalAlignment: HorizontalAlignment.Fill
                    Button {
                        text: qsTr("重置应用")
                        horizontalAlignment: HorizontalAlignment.Center
                        onClicked: {
                            try {
                                _misc.reset();
                                calcInfo(true);
                            }catch(e) {
                                _misc.showToast(e);
                            }
                        }
                    }
                }
            }
        }
    }
}
