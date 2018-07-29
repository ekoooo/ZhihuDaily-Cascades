import bb.cascades 1.4
import tech.lwl 1.0

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
                common.apiSponsor(dataRequester);
            }
        }
    }
    
    attachedObjects: [
        Requester {
            id: dataRequester
            onBeforeSend: {
                isLoading = true;
            }
            onFinished: {
                isLoading = false;
                
                dm.clear();
                dm.insert(0, JSON.parse(data));
            }
            onError: {
                isLoading = false;
                _misc.showToast(error);
                console.log(error);
            }
        }
    ]
    
    onCreationCompleted: {
        
    }
}
