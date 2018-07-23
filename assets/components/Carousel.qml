import bb.cascades 1.4
import bb.device 1.4
import tech.lwl 1.0

Container {
    id: lvContainer
    property variant dH: displayInfo.pixelSize.height
    property variant dW: displayInfo.pixelSize.width
    property variant height: dH === dW ? dH / 2.5 : dH / 3
    
    property variant listData: [] // 数据（item key => image, title, id）
    property int itvTime: 5000 // 时间间隔
    
    layout: DockLayout {
    
    }
    preferredHeight: height
    background: Color.create("#eeeeee")
    
    attachedObjects: [
        DisplayInfo {
            id: displayInfo
        }
    ]
    
    ListView {
        id: lv
        property variant layoutFrame
        property variant activeIndex
        property variant height: lvContainer.height
        property variant dir: "right"
        property variant tipObjs
        
        signal change(variant activeIndex);
        
        attachedObjects: [
            LayoutUpdateHandler {
                onLayoutFrameChanged: {
                    lv.layoutFrame = layoutFrame
                }
            },
            ListScrollStateHandler {
                onFirstVisibleItemChanged: {
                    lv.change(firstVisibleItem);
                    lv.activeIndex = firstVisibleItem;
                }
            },
            QTimer{
                id: timer
                interval: lvContainer.itvTime
                onTimeout: {
                    lv.nextPage();
                }
            },
            ComponentDefinition {
                id: tip
                ImageView {
                    id: iv
                    property variant opacityParam: 0.5
                    property variant index
                    signal click(variant index)
                    
                    imageSource: "asset:///images/carousel/round_white.png"
                    preferredWidth: ui.du(2.5)
                    preferredHeight: preferredWidth
                    verticalAlignment: VerticalAlignment.Center
                    opacity: opacityParam
                    margin {
                        leftOffset: ui.du(1)
                        rightOffset: ui.du(1)
                    }
                    function change(activeIndex) {
                        if(index == activeIndex) {
                            opacityParam = 1;
                        }else {
                            opacityParam = 0.5;
                        }
                    }
                    onTouch: {
                        if(event.isDown()) {
                            click(index);
                        }
                    }
                }
            }
        ]
        
        horizontalAlignment: HorizontalAlignment.Fill
        layout: StackListLayout {
            orientation: LayoutOrientation.LeftToRight
            headerMode: ListHeaderMode.None
        }
        dataModel: ArrayDataModel {
            id: dm
        }
        flickMode: FlickMode.SingleItem
        snapMode: SnapMode.LeadingEdge
        scrollIndicatorMode: ScrollIndicatorMode.None
        
        onTouch: {
            if(event.isDown()) {
                timer.stop();
            }else if(event.isUp() || event.isCancel()) {
                timer.start();
            }
        }
        
        listItemComponents: [
            ListItemComponent {
                Container {
                    layout: DockLayout {
                    
                    }
                    preferredWidth: ListItem.view.layoutFrame.width
                    preferredHeight: ListItem.view.height
                    WebImageView {
                        url: ListItemData.image
                        scalingMethod: ScalingMethod.AspectFill
                        verticalAlignment: VerticalAlignment.Fill
                        horizontalAlignment: HorizontalAlignment.Fill
                        implicitLayoutAnimationsEnabled: false
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
                            text: ListItemData.title
                            multiline: true
                            textStyle {
                                base: SystemDefaults.TextStyles.BodyText
                                color: Color.create("#FFFFFF")
                                fontWeight: FontWeight.W500
                            }
                        }
                    }
                }
            }
        ]
        
        function init() {
            var images = lvContainer.listData;
            
            if(images.length < 2) {
                return;
            }
            
            dm.clear(); // 初始化
            dm.insert(0, images);
            
            timer.start();
            
            if(lv.tipObjs) { // 初始化
                for(var i = 0; i < lv.tipObjs.length; i++) {
                    tipsBox.remove(lv.tipObjs[i]);
                }
            }
            
            var tipObjArr = [];
            var tipObj;
            for(var i = 0; i < images.length; i++) {
                tipObj = tip.createObject();
                
                tipObj.index = i;
                if(i === 0) {
                    tipObj.opacityParam = 1;
                }
                
                tipsBox.add(tipObj);
                lv.change.connect(tipObj.change);
                tipObj.click.connect(lv.nextTo);
                tipObjArr.push(tipObj);
            }
            lv.tipObjs = tipObjArr;
        }
        
        function nextTo(index) {
            lv.scrollToItem([index]);
        }
        
        function nextPage() {
            if(dm.size() < 2) {
                return;
            }
            
            var nextIndex;
            var activeIndex = lv.activeIndex[0] || 0;
            
            if(lv.dir === "left") {
                if(activeIndex === 0) {
                    lv.dir = "right";
                    lv.nextPage();
                    return;
                }
                nextIndex = activeIndex - 1;
            }else {
                if(activeIndex >= dm.size() - 1) {
                    lv.dir = "left";
                    lv.nextPage();
                    return;
                }
                nextIndex = activeIndex + 1;
            }
            
            lv.nextTo(nextIndex);
        }
    }
    
    Container {
        preferredHeight: ui.du(6)
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Bottom
        layout: DockLayout {
        
        }
        
        Container {
            id: tipsBox
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Fill
            implicitLayoutAnimationsEnabled: false
            
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
        }
    }
    
    onListDataChanged: {
        lv.init();
    }
}

