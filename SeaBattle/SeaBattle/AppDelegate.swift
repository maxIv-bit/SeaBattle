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
    private var roomsRepository = RoomsRepositoryDefault()
    
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
        if let user = authRepository.getCurrentUser() {
            showRooms(user: user)
        } else {
            showAuth()
        }
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
    }
    
    func showAuth() {
        let authViewModel = AuthViewModel(authRepository: authRepository)
        let authViewController = AuthViewController(viewModel: authViewModel)
        authViewModel.onSuccessfulLogIn = { [weak self] user in
            self?.showRooms(user: user)
        }
        window?.rootViewController = authViewController
    }
    
    func showRooms(user: User) {
        let roomsViewModel = RoomsViewModel(currentUser: user, authRepository: authRepository, roomsRepository: roomsRepository)
        let roomsViewController = RoomsViewController(viewModel: roomsViewModel)
        let navigation = UINavigationController(rootViewController: roomsViewController)
        roomsViewModel.onLogOut = { [weak self] in
            self?.showAuth()
        }
        window?.rootViewController = navigation
    }
}

