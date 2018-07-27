import bb.cascades 1.4
import tech.lwl 1.0


CustomListItem {
    property variant listItemData: new Object()
    property variant titleKey: "title"
    property variant imageKey: "images"
    property bool isImageList: true
    property variant desc: ""
    
    dividerVisible: true
    
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        topPadding: ui.du(2)
        bottomPadding: topPadding
        leftPadding: ui.du(2)
        rightPadding: leftPadding
        
        Label {
            text: listItemData[titleKey] + (desc == "" ? "" : " - " + desc)
            multiline: true
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
        }
        
        WebImageView {
            function getUrl() {
                var rt;
                var defaultUrl = "asset:///images/image_small_default.png";
                
                if(isImageList) {
                    rt = (listItemData[imageKey] || [])[0] || defaultUrl;
                }else {
                    rt = listItemData[imageKey] || defaultUrl;
                }
                
                return rt;
            }
            
            url: getUrl()
            preferredWidth: ui.du(15)
            preferredHeight: preferredWidth
            scalingMethod: ScalingMethod.AspectFit
            implicitLayoutAnimationsEnabled: false
            loadingImageSource: "asset:///images/image_small_default.png"
            failImageSource: "asset:///images/image_small_default.png"
        }
    }
}
