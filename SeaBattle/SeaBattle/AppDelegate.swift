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
    private var authRepository = AuthRepositoryDefault()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        start()
        
        return true
    }
    
    func start() {
        window = UIWindow(frame: UIScreen.main.bounds)
        Auth.auth().currentUser != nil ? showUsersOnline() : showAuth()
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
    }
    
    func showAuth() {
        let authViewModel = AuthViewModel(authRepository: authRepository)
        let authViewController = AuthViewController(viewModel: authViewModel)
        authViewModel.onSuccessfulLogIn = { [weak self] in
            self?.showUsersOnline()
        }
        window?.rootViewController = authViewController
    }
    
    func showUsersOnline() {
        let usersOnlineViewModel = UsersOnlineViewModel(authRepository: authRepository)
        let usersOnlineViewController = UsersOnlineViewController(viewModel: usersOnlineViewModel)
        let navigation = UINavigationController(rootViewController: usersOnlineViewController)
        usersOnlineViewModel.onLogOut = { [weak self] in
            self?.showAuth()
        }
        window?.rootViewController = navigation
    }
}

