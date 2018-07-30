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
        Container {
            bottomPadding: ui.du(14)
            topPadding: ui.du(2)
            
            Button {
                text: qsTr("已赞助，发送记录")
                horizontalAlignment: HorizontalAlignment.Center
                onClicked: {
                    var bodyArr = [
                        '赞助人：\n\n',
                        '金额：\n\n',
                        '网址（可选）：\n\n',
                        '备注（可选）：\n\n',
                        '凭证（建议直接截图）：\n\n'
                    ];
                    
                    _misc.invokeMail(common.developerEmail, '《知乎日报》赞助支持', bodyArr.join(''));
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
