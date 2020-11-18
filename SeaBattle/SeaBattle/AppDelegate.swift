//
//  AppDelegate.swift
//  SeaBattle
//
//  Created by Maks on 14.11.2020.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = SignUpViewController(viewModel: SignUpViewModel())
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        return true
    }

}

