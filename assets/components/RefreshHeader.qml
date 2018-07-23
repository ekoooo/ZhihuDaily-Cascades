import bb.cascades 1.4
import tech.lwl 1.0

Container {
    property bool refreshing: false
    property int refreshThreshold: 200
    property variant lastY: 0
    
    horizontalAlignment: HorizontalAlignment.Fill
    visible: refreshing
    
    layout: DockLayout {
        
    }

    signal refreshTriggered()

    Container {
        id: container
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        preferredHeight: refreshThreshold
        
        layout: DockLayout {
        
        }

        ActivityIndicator {
            running: true
            visible: true
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
        }
    }
    
    Divider {
        opacity: 0.0
    }

    attachedObjects: [
        LayoutUpdateHandler {
            id: refreshHandler

            onLayoutFrameChanged: {
                if(!refreshing && layoutFrame.y >= 0 && layoutFrame.y > lastY) {
                    refreshing = true;
                }
                
                lastY = layoutFrame.y;
            }
        }
    ]
    
    /**
     * 结束
     */
    function endRefresh() {
        refreshing = false;
    }

    function onListViewTouch(event) {
        if (event.touchType == TouchType.Up) {
            if(refreshing) {
                refreshTriggered()
            }
        }
    }
}
