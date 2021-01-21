//
//  AppDelegate.swift
//  RoomReserve
//
//  Created by ALWIN VARGHESE K on 09/08/2020.
//  Copyright © 2020 ALWIN VARGHESE K. All rights reserved.
//
//Key : 1Mg1_jBgtB_QncH621U4
//passphrase : alwinasd123##

import UIKit
import CoreData
import IQKeyboardManagerSwift
import CalendarKit
import Firebase
import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = true
        FirebaseApp.configure()
        if UserDefaults.standard.value(forKey: Key.Keys.k_Account_ID) != nil{
            // User account
            let viewC = UIStoryboard.RoomBooking.HomeVC()
            let navigationController = UINavigationController(rootViewController: viewC)
            navigationController.navigationBar.isTranslucent = false
            navigationController.isNavigationBarHidden = true
            self.window?.rootViewController = navigationController

        }
        else {
            let viewC = UIStoryboard.RoomBooking.SignInVC()
            let navigationController = UINavigationController(rootViewController: viewC)
            navigationController.navigationBar.isTranslucent = false
            navigationController.isNavigationBarHidden = true
            self.window?.rootViewController = navigationController
        }

        return true
    }



    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "RoomReserve")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

