import bb.cascades 1.4

Page {
    objectName: "sponsorPage"
    
    property bool isLoading: false
    
    actionBarVisibility: ChromeVisibility.Compact
    
    Container {
        Header {
            title: qsTr("以下为赞助名单，感谢你们的支持！")
        }
        
        ListView {
            dataModel: ArrayDataModel {
                id: dm
            }
            
            onCreationCompleted: {
                // common.api.sponsor
                common.httpGetAsync("https://api.github.com/user", function(isOk, data) {
                        _misc.showToast(isOk + ":::" + data);
                });
            }
        }
    }
    
    onCreationCompleted: {
        
    }
}
