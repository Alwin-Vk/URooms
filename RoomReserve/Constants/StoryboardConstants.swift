
import Foundation
import UIKit

protocol StoryboardScene:RawRepresentable {
    
    static var storyboardName : String {get}
}

extension StoryboardScene {
    
    static func storyboard() -> UIStoryboard{
        return UIStoryboard(name: self.storyboardName, bundle:nil)
    }
    
    func viewController() -> UIViewController{
        return Self.storyboard().instantiateViewController(withIdentifier:self.rawValue as! String)
    }
    
}


extension UIStoryboard{
    
    struct RoomBooking {
        
        private enum Identifier : String,StoryboardScene{
            
            static let storyboardName   = "RoomBooking"
            case SignInVC               = "SignInVC"
            case HomeVC                 = "HomeVC"
            case MakeBookingVC          = "MakeBookingViewController"
            case forgotVC               = "ForgotPasswordVC"
            case profileUserVC          = "ProfileUserVC"
            case ChangePasswordVC       = "ChangePasswordVC"
            case EditProfileVC          = "EditProfileVC"
            case BookingDetailsVC       = "BookingDetailsViewController"
            case DrawerMenuVC           = "DrawerMenuViewController"
            case ChooseRoomVC           = "ChooseRoomViewController"
        }
        
      
      
        static func SignInVC() -> UIViewController{
            return Identifier.SignInVC.viewController()
        }
        static func HomeVC() -> UIViewController{
            return Identifier.HomeVC.viewController()
        }
        static func MakeBookingVC() -> UIViewController{
            return Identifier.MakeBookingVC.viewController()
        }
        static func BookingDetailsVC() -> UIViewController{
            return Identifier.BookingDetailsVC.viewController()
        }
        static func profileUserVC() -> UIViewController{
            return Identifier.profileUserVC.viewController()
        }
        static func ChangePasswordVC() -> UIViewController{
            return Identifier.ChangePasswordVC.viewController()
        }
        static func EditProfileVC() -> UIViewController{
            return Identifier.EditProfileVC.viewController()
        }
        static func DrawerMenuVC() -> UIViewController{
            return Identifier.DrawerMenuVC.viewController()
        }
        static func ChooseRoomVC() -> UIViewController{
            return Identifier.ChooseRoomVC.viewController()
        }

    }
    
}
