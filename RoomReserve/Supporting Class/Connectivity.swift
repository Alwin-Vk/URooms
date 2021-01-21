
import UIKit
import Alamofire

class Connectivity: NSObject {

    class var isNetworkAvailable:Bool{
        
        let isNetworkAvailable = NetworkReachabilityManager()!.isReachable
        
        if(!isNetworkAvailable){
           //common.showAlert(title: "Netowrk Unavailable", message: "Please check your internet connection and try again!")
        }
        
        return isNetworkAvailable
    }
}
