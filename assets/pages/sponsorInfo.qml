import bb.cascades 1.4
import tech.lwl 1.0

Page {
    objectName: "sponsorInfoPage"
    actionBarVisibility: ChromeVisibility.Compact
    titleBar: TitleBar {
        title: qsTr("我要赞助")
        scrollBehavior: TitleBarScrollBehavior.NonSticky
    }
    
    ScrollView {
        scrollRole: ScrollRole.Main
        
        Container {
            bottomPadding: ui.du(14)
            topPadding: ui.du(2)
            
            Button {
                text: qsTr("已赞助，发送记录")
                horizontalAlignment: HorizontalAlignment.Center
                onClicked: {
                    var bodyArr = [
                        '　　带 * 为必填项，凭证可截图或流水号等，可备注是否在 APP 赞助人列表中不显示赞助金额。',
                        '赞助人*：',
                        '凭证*：',
                        '金额*：',
                        '网址：',
                        '备注：'
                    ];
                    
                    _misc.invokeMail(common.developerEmail, '《知乎日报》赞助支持', bodyArr.join('\n\n'));
                }
            }
            Divider {}
            Header {
                title: qsTr("微信赞助")
            }
            WebImageView {
                url: "asset:///images/qr_wxpay.png"
                preferredWidth: ui.du(30)
                scalingMethod: ScalingMethod.AspectFit
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
            }
            Divider {}
            Header {
                title: qsTr("支付宝赞助")
            }
            WebImageView {
                url: "asset:///images/qr_alipay.png"
                preferredWidth: ui.du(30)
                scalingMethod: ScalingMethod.AspectFit
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
            }
        }
    }
}
