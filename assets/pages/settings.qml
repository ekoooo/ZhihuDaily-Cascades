import bb.cascades 1.4
import tech.lwl 1.0
import "asset:///pages/child"

Page {
    objectName: "settingsPage"
    
    actionBarVisibility: ChromeVisibility.Compact
    
    property bool isLargeFont: false;
    property variant imageCacheSize: "calcing";
    property variant requestCacheSize: "calcing";
    
    onCreationCompleted: {
        calcInfo(true);
    }
    
    function calcInfo(updateLargeFont) {
        if(updateLargeFont) {
            isLargeFont = _misc.getConfig(common.settingsKey.newsLargeFont, "0") === "1";
            newsLargeFontToggleButton.checked = isLargeFont;
        }
        
        imageCacheSize = _misc.webImageViewCacheSize();
        requestCacheSize = _misc.requesterCacheSize();
    }
    
    ScrollView {
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
                        verticalAlignment: VerticalAlignment.Center
                        checked: Application.themeSupport.theme.colorTheme.style === VisualStyle.Dark
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
            
            // 字体
            Container {
                Header {
                    title: qsTr("文章字体")
                }
                ItemContainer {
                    Label {
                        verticalAlignment: VerticalAlignment.Center
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1
                        }
                        text: qsTr("大字体模式")
                    }
                    
                    ToggleButton {
                        id: newsLargeFontToggleButton
                        verticalAlignment: VerticalAlignment.Center
                        checked: isLargeFont
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
