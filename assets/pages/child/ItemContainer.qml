import bb.cascades 1.4

Container {
    property variant layout_: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }
    
    leftPadding: ui.du(2)
    rightPadding: ui.du(2)
    topPadding: ui.du(2)
    bottomPadding: ui.du(2)
    
    layout: layout_
}