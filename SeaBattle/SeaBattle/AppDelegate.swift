//
//  AppDelegate.swift
//  SeaBattle
//
//  Created by Maks on 14.11.2020.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = AuthViewController(viewModel: AuthViewModel())
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        return true
    }

}

