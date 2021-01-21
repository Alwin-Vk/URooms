

import Foundation

struct Key {
    
    static let DeviceType = "iOS"
    
    struct Keys {
        static let k_Account_ID              = "account_id"
        static let k_Email                   = "account_email"
       

        static let k_UserName                 = "user_fname"
       
        static let k_User_Token              = "user_token"
        static let k_User_Type               = "user_type"
        static let k_User_Modules            = "user_modules"

        static let k_User_Type_ID            = "User_type_id"
        static let k_Selected_Time           = "selected_Time"
    }
    
    struct ErrorMessage{
        static let listNotFound    = "ERROR_LIST_NOT_FOUND"
        static let validationError = "ERROR_VALIDATION"
    }
  
    static func clearAllValues() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
    }
    
    
    struct Images{
        static let user_Placeholder             = "profile_default.jpg"
        static let bar_Placeholder              = "Griffs.png"
        
    }
    

    // Get User Account ID
    static var accountID:Int{
        
        if let accountID : Int = UserDefaults.standard.integer(forKey: Key.Keys.k_Account_ID){
            return accountID
        }
        else {return 0}
    }

    
    // Get User Email
    static var emailID:String{
    
        if let email : String = UserDefaults.standard.value(forKey: Key.Keys.k_Email) as? String {
            return email
        }
        else {return ""}
    }

 




}
