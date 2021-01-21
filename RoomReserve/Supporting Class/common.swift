
import UIKit
import MBProgressHUD
class common: UIViewController {
   // static var viewError : CustomErrorView? = nil
    static var HUD: MBProgressHUD!

    var errorMessage: String?

    class func getLength(_ string:(String), range:(NSRange), replacementString:(String)) -> NSInteger {
        
        let newLength = string.count + replacementString.count - range.length
        return newLength
    }
  
    class func getScreenSize() -> CGRect {
        let screenSize = UIScreen.main.bounds
            return screenSize
        }
    
    class func numericOnly(_ string: String) -> Bool {
        
        let characterSet = NSCharacterSet(charactersIn:"0123456789").inverted
        return string.rangeOfCharacter(from: characterSet) == nil // True if number
        
    }
    
    class func alphaNumeric(_ string: String) -> Bool {
        
        let characterSet = NSCharacterSet.alphanumerics.inverted
        return string.rangeOfCharacter(from: characterSet) == nil
    }
    
    class func alphabets(_ string: String) -> Bool {
        
        let characterSet = NSCharacterSet.letters.inverted
        return string.rangeOfCharacter(from: characterSet) == nil
        
    }
    
    class func alphabetsAndSpace(_ string: String) -> Bool {
        
        let characterSet = NSCharacterSet.letters.inverted
        return (string.rangeOfCharacter(from: characterSet) == nil) || (string == " ")
        
    }
    
    
    class func showAlert(title: String, message: String){
        let commonAlert = UIAlertController(title:title, message:message, preferredStyle:.alert)
        let okAction = UIAlertAction(title:"OK", style: .cancel)
        commonAlert.addAction(okAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(commonAlert, animated: true, completion: nil)
    }
    struct Version{
        static let SYS_VERSION_FLOAT = (UIDevice.current.systemVersion as NSString).floatValue
        static let iOS7 = (Version.SYS_VERSION_FLOAT < 8.0 && Version.SYS_VERSION_FLOAT >= 7.0)
        static let iOS8 = (Version.SYS_VERSION_FLOAT >= 8.0 && Version.SYS_VERSION_FLOAT < 9.0)
        static let iOS9 = (Version.SYS_VERSION_FLOAT >= 9.0 && Version.SYS_VERSION_FLOAT < 10.0)
    }
    


    class func setUserHomeAsRoot() {
        
        let homeNavigationVC = UIStoryboard.RoomBooking.HomeVC()
        ((UIApplication.shared.delegate)?.window!)!.rootViewController = homeNavigationVC
    }
    
    class func setUserLoginAsRoot() {
        
        let splashNavigationVC = UIStoryboard.RoomBooking.SignInVC()
        ((UIApplication.shared.delegate)?.window!)!.rootViewController = splashNavigationVC
    }
    
    class func showHUD(_ title: String) {
        
        HUD = nil
        if(HUD == nil){
            HUD = MBProgressHUD.showAdded(to: ((UIApplication.shared.delegate)?.window!)!, animated: true)
        }
        HUD.mode = .indeterminate
    //    HUD.contentColor = AppColor.ViewColors.Black
        HUD.label.text = title
    //    HUD.label.textColor = AppColor.ViewColors.Black
        HUD.show(animated: true)
    }
    
    
    class func hideHUD() {
        HUD.hide(animated: true)
    }
    class func timeFormatfromString(dateString : String, dateFormat : String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let taskDate = dateFormatter.date(from: dateString)!
        return taskDate
    }
}


extension String {
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isPassword: Bool {
        return self.count >= 6 ? true : false
    }
    
    var isValidName: Bool {
        let stringRegEx = "^[a-zA-Z]+$"
        let stringTest = NSPredicate(format:"SELF MATCHES %@", stringRegEx)
        return stringTest.evaluate(with: self)
    }
    
    var isValidPhoneNumber: Bool {
       
        let stringRegEx = "^[0-9]{6,14}$"
        let stringTest = NSPredicate(format: "SELF MATCHES %@", stringRegEx)
        return stringTest.evaluate(with: self)
    }
    
    var digits: String {
        
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    
}

extension UIView{
    func animateLabel(_ duration:CFTimeInterval)  {
        let animation: CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.subtype = CATransitionSubtype.fromTop
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
    
    func shadowLeftBottom(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -2, height: 2)
        self.layer.shadowRadius = 2.0
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func shadowRightBottom(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 2
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func shadowRightTop(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 2, height: -2)
        self.layer.shadowRadius = 2
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func shadowLeftTop(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -2, height: -2)
        self.layer.shadowRadius = 2
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func shadowAllSide(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 2.5
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func shadowRight(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowRadius = 10.0
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func shadowBottom(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: -2.5)
        self.layer.shadowRadius = 2.0
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    
    
    func shadowRound() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 1
        
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.frame.size.width/2).cgPath
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    
    func removeShadow () {
        self.layer.shadowPath = nil
    }
    
    func roundCornerView(_ corners: UIRectCorner, radius: CGFloat, borderColor: UIColor?, borderWidth: CGFloat?) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        
        let mask = CAShapeLayer()
        mask.frame = self.bounds
        mask.path = path.cgPath
        self.layer.mask = mask
        
        if borderWidth != nil {
            addBorder(mask, borderWidth: borderWidth!, borderColor: borderColor!)
        }
    }
    
    private func addBorder(_ mask: CAShapeLayer, borderWidth: CGFloat, borderColor: UIColor) {
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
    
    func animationShake (view : UIView) -> CABasicAnimation{
        let midX = view.center.x
        let midY = view.center.y
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.06
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: midX - 10, y: midY)
        animation.toValue = CGPoint(x: midX + 10, y: midY)
        return animation
    }
    
}


extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
