//
//  ViewController.swift
//  RoomReserve
//
//  Created by ALWIN VARGHESE K on 09/08/2020.
//  Copyright © 2020 ALWIN VARGHESE K. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SkyFloatingLabelTextField
import SCLAlertView

class SignInVC: UIViewController {
    var handle: AuthStateDidChangeListenerHandle?

    @IBOutlet weak var userNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var signInButton: UIButton!
    
  var ref: DatabaseReference!
  var databaseHandle : DatabaseHandle!
  var roomTypesRef: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        userNameTextField.styleField()
        passwordTextField.styleField()
        ref = Database.database().reference()
        roomTypesRef  = Database.database().reference().child("users")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            Auth.auth().removeStateDidChangeListener(self.handle!)
        }
    }

    // MARK: - Functions
    func validateFields() -> Bool {
        self.dismissKeyboard()
        var validation = true
        if ((userNameTextField.text?.isEmpty)!) {
            userNameTextField.setError("Please enter email")
            validation = false
        }
        if (!(userNameTextField.text?.isEmail)!) {
            userNameTextField.setError("Please enter valid email")
            validation = false
        }
         
        if !(passwordTextField.text?.isPassword)! || ((passwordTextField.text?.count)! < 6){
            passwordTextField.setError("Password must contain 6 characters")
            validation = false
        }
        return validation
    }
    
    func getUserDetails(_ userId: String, email: String) {
        var handle: UInt = 0
        handle =  roomTypesRef.observe(.value, with: { snapshot in
            if let datas = snapshot.value as? [String: [String: AnyObject]] {
                for data in datas {
                    if userId == data.key {
                        
                        if let userType = data.value["type"] as? String, let name = data.value["name"], let typeID = data.value["codeName"] {
                            UserDefaults.standard.setValue(email, forKey: Key.Keys.k_Email)
                            UserDefaults.standard.setValue(userId, forKey: Key.Keys.k_Account_ID)
                            UserDefaults.standard.setValue(userType, forKey: Key.Keys.k_User_Type)
                            UserDefaults.standard.setValue(typeID, forKey: Key.Keys.k_User_Type_ID)
                            UserDefaults.standard.setValue(name, forKey: Key.Keys.k_UserName)
                            if let userModules = data.value["modules"] {
                                UserDefaults.standard.set(userModules, forKey: Key.Keys.k_User_Modules)
                            }
                            let homeVC = UIStoryboard.RoomBooking.HomeVC()
                            self.navigationController?.pushViewController(homeVC, animated: true)
                            SwiftLoader.hide()
                        }
                    }
//                    else{
//                        SwiftLoader.hide()
//                        SCLAlertView().showError("Error", subTitle: "User access denied",closeButtonTitle: "Ok")
//                    }
                }
            }

            self.roomTypesRef.removeObserver(withHandle: handle)
        }) { (error) in
            SwiftLoader.hide()
            SCLAlertView().showError("Error", subTitle: error.localizedDescription, closeButtonTitle: "Ok")
             print(error.localizedDescription)
        }
    }

    
    // MARK: - Button Actions
     
    @IBAction func buttonSignIn_pressed(_ sender: Any) {
          if(Connectivity.isNetworkAvailable){
              if validateFields() {

                SwiftLoader.show(animated: true)
                Auth.auth().signIn(withEmail: userNameTextField.text!, password: passwordTextField.text!) {( result, error) in
                    if let error = error{
                        SCLAlertView().showError("Error", subTitle: error.localizedDescription, closeButtonTitle: "Ok")
                        SwiftLoader.hide()
                        return
                    }
                    print("successfully logged in")
                    
                    let userInfo = Auth.auth().currentUser
                    print(userInfo as Any)
                    let email = userInfo?.email ?? ""
                    let userId = userInfo?.uid ?? ""
                    self.getUserDetails(userId, email: email)
                }
            }
        }
    }
}


// MARK: - TextField Delegates

extension SignInVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let myField = textField as? SkyFloatingLabelTextField {
            myField.setError("")
        }
    }
}

