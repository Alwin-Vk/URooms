//
//  Utils.swift

import Foundation
import UIKit

class Utils: NSObject {

    // MARK: - Declarations

    static let sharedInstance = Utils()
    private override init() {} //This prevents others from using the default '()' initializer for this class.

    /**
     To present view controller as pop up view with blured background
     - parameter viewControllerToPresent: View controller need to be presented as pop up.
     - parameter fromViewController: From which view controller it needs to be presented.
     - parameter animated flag: Flag which indicates animation status.
     - parameter completion: Completion block.
     - returns: Completion block.
     */
    func presentAsPopUp(_ viewControllerToPresent: UIViewController, fromViewController: UIViewController, animated flag: Bool, completion: (() -> Swift.Void)?) {

        viewControllerToPresent.providesPresentationContextTransitionStyle = true
        viewControllerToPresent.definesPresentationContext = true
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        viewControllerToPresent.view.backgroundColor = UIColor(white: 0, alpha: 0.25)
        fromViewController.present(viewControllerToPresent, animated: flag, completion: completion)
    }

    /**
     To clear all datas in user defaults
     */
    func clearUserDefaults () {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
    
    /**
     To get a random color
     */
    func randomColor() -> UIColor {
        let arrayColors = [#colorLiteral(red: 0.3764705882, green: 0.4901960784, blue: 0.5450980392, alpha: 1), #colorLiteral(red: 1, green: 0.5960784314, blue: 0, alpha: 1), #colorLiteral(red: 0.2470588235, green: 0.3176470588, blue: 0.7098039216, alpha: 1), #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1), #colorLiteral(red: 0.6117647059, green: 0.1529411765, blue: 0.6901960784, alpha: 1), #colorLiteral(red: 0.4039215686, green: 0.2274509804, blue: 0.7176470588, alpha: 1), #colorLiteral(red: 0.1294117647, green: 0.5882352941, blue: 0.9529411765, alpha: 1), #colorLiteral(red: 1, green: 0.9215686275, blue: 0.231372549, alpha: 1), #colorLiteral(red: 0.2980392157, green: 0.6862745098, blue: 0.3137254902, alpha: 1), #colorLiteral(red: 0, green: 0.5882352941, blue: 0.5333333333, alpha: 1)]
        let randomIndex = Int(arc4random_uniform(UInt32(arrayColors.count)))

        return arrayColors[randomIndex]
    }

    /**
     To check email id string is valid or not
     - parameter emailId: Email Id which needs to be validated.
     - returns: Returns as Bool value. True - Email Id is valid, False - Email Id is invalid.
     */
    func isValidEmail(_ emailStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }

    /**
     To check phone number string is valid or not
     - parameter number: Phone number which needs to be validated.
     - returns: Returns as Bool value. True - Phone number is valid, False - Phone number is invalid.
     */
    func isValidPhone(_ number: String) -> Bool {
        let phoneRegex = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        let result =  phoneTest.evaluate(with: number)
        return result
    }

    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^.{6,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }

    /*
     ^                         Start anchor
     (?=.*[A-Z].*[A-Z])        Ensure string has two uppercase letters.
     (?=.*[!@#$&*])            Ensure string has one special case letter.
     (?=.*[0-9].*[0-9])        Ensure string has two digits.
     (?=.*[a-z].*[a-z].*[a-z]) Ensure string has three lowercase letters.
     .{8}                      Ensure string is of length 8.
     $                         End anchor.
     */

    public func getDateFrom(_ day: String!) -> Date {
        if day != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MM yyyy"
            return dateFormatter.date(from: day) ?? Date()
        }
        return Date()
    }

    func getStringValue(_ key: String, dictionary: [String: AnyObject]) -> String {
        var theValue = ""
        if let stringValue = dictionary[key] as? String {
            theValue = stringValue
        } else if let intValue = dictionary[key] as? Int {
            theValue = String(intValue)
        }

        return theValue
    }

    func getIntegerValue(_ key: String, dictionary: [String: AnyObject]) -> Int {
        var theValue = 0
        if let stringValue = dictionary[key] as? String {
            theValue = Int(stringValue) ?? 0
        } else if let intValue = dictionary[key] as? Int {
            theValue = intValue
        }

        return theValue
    }

    func getDeviceID() -> String {
        var deviceID = ""
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            deviceID = uuid
        }
        return deviceID
    }

    func captureScreenshot() -> UIImage {

        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        // Creates UIImage of same size as view
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        // THIS IS TO SAVE SCREENSHOT TO PHOTOS
        UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)
        return screenshot

    }

    func getFormattedClassString(_ userClass: String) -> NSAttributedString {
        let font: UIFont? = UIFont.systemFont(ofSize: 20)
        let fontSuper: UIFont? = UIFont.systemFont(ofSize: 10)

        if userClass != "" {
            let userClass = userClass
            let attString: NSMutableAttributedString = NSMutableAttributedString(string: "class" + userClass + "th", attributes: [.font: font!])
            attString.setAttributes([.font: fontSuper!, .baselineOffset: 10], range: NSRange(location: 7, length: 2))
            return attString
        } else {
            return NSMutableAttributedString(string: "", attributes: [.font: font!])

        }
    }

}
