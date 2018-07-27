import bb.cascades 1.4
import tech.lwl 1.0


CustomListItem {
    property variant listItemData: new Object()
    dividerVisible: true
    
    Container {
        layout: DockLayout {
        
        }
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        WebImageView {
            url: listItemData['thumbnail']
            loadingImageSource: "asset:///images/image_top_default.png"
            failImageSource: "asset:///images/image_top_default.png"
            scalingMethod: ScalingMethod.AspectFit
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            implicitLayoutAnimationsEnabled: false
        }
        Container {
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            background: Color.create(0, 0, 0, 0.2)
            implicitLayoutAnimationsEnabled: false
            layout: StackLayout {
            
            }
            
            Container {
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 2
                }
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                layout: DockLayout {
                
                }
                
                Label {
                    text: listItemData['name']
                    multiline: true
                    implicitLayoutAnimationsEnabled: false
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    
                    textStyle {
                        color: Color.White
                        fontWeight: FontWeight.Bold
                    }
                }
            }
            Container {
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }
                layout: DockLayout {
                
                }
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                background: Color.create(0, 0, 0, 0.5)
                leftPadding: ui.du(1)
                rightPadding: ui.du(1)
                
                Label {
                    text: listItemData['description']
                    multiline: true
                    autoSize.maxLineCount: 2
                    textStyle {
                        base: SystemDefaults.TextStyles.SmallText
                        color: Color.White
                    }
                    verticalAlignment: VerticalAlignment.Center
                }
            }
        }
    }
}