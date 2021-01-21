//
//  DrawerMenuViewController.swift
//

import UIKit
import Firebase

protocol SlideMenuProtocol: class {
    
    func slideTheMenu()
    func showViewController(_ viewController: UIViewController)
}

class DrawerMenuViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var buttonDismiss: UIButton!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var viewMenuContainer: UIView!
    @IBOutlet weak var tableViewMenu: UITableView!
    @IBOutlet weak var constraintTrailingMenu: NSLayoutConstraint!
    @IBOutlet weak var labelUserType: UILabel!
    
    // MARK: - Variables
    weak var delegate: SlideMenuProtocol!
    private var isMenuOpen: Bool = false
    var menuData = [
        ["icon": "logoutDrawer", "name": "Logout"]
    ]
    
    // MARK: - System Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isHidden = true
        setUserDetails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initialViewSetup()
    }
    
    // MARK: - Functions
    
    func initialViewSetup() {
        self.constraintTrailingMenu.constant = -(self.view.frame.size.width * 0.8)
        self.buttonDismiss.alpha = 0.0
    }
    
    func setUserDetails() {
        if let userEmail = UserDefaults.standard.value(forKey: Key.Keys.k_Email) as? String {
            labelUserName.text = userEmail
        } else {
            labelUserName.text = ""
        }
        if let userType = UserDefaults.standard.value(forKey: Key.Keys.k_User_Type) as? String{
            labelUserType.text = userType
        } else {
            labelUserType.text = ""
        }
    }
    
    func menuTapped() {
        isMenuOpen = !isMenuOpen

        if isMenuOpen {
            self.view.isHidden = !isMenuOpen
            UIView.animate(withDuration: 0.3, animations: {
                self.constraintTrailingMenu.constant = 0
                self.buttonDismiss.alpha = 0.3
                self.view.layoutIfNeeded()
            }) {(_) in
                self.viewMenuContainer.shadowAllSide()
            }
        } else {
            self.viewMenuContainer.removeShadow()
            UIView.animate(withDuration: 0.3, animations: {
                self.constraintTrailingMenu.constant = -(self.view.frame.size.width * 0.8)
                self.buttonDismiss.alpha = 0.0
                self.view.layoutIfNeeded()
            }) { (_) in
                self.view.isHidden = !self.isMenuOpen
            }
        }
    }
    
    func logoutUser() {
        let logoutAlert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { (_) in
            self.callLogoutAPI()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        logoutAlert.addAction(logoutAction)
        logoutAlert.addAction(cancelAction)
        self.present(logoutAlert, animated: true, completion: nil)
    }
    
    func callLogoutAPI() {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            resetDefaults()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }

    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        setSigninScreenAsRoot()
    }

    func setSigninScreenAsRoot() {
        let viewC = UIStoryboard.RoomBooking.SignInVC()
        let navigationController = UINavigationController(rootViewController: viewC)
        navigationController.navigationBar.isTranslucent = false
        navigationController.isNavigationBarHidden = true
        UIApplication.shared.keyWindow?.rootViewController = navigationController
    }

    // MARK: - Button Actions
    
    @IBAction func dismissButtonAction(_ sender: UIButton) {
        menuTapped()
    }
}

extension DrawerMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrawerMenuCell", for: indexPath) as! MenuTableViewCell
        cell.labelName.text = (menuData[indexPath.row]["name"])
        cell.imageViewIcon.image = UIImage(named: menuData[indexPath.row]["icon"] ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        menuTapped()

        switch menuData[indexPath.row]["name"]! {
        case "Logout":
            logoutUser()
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
