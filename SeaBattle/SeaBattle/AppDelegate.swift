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
    private var gameRepository = GameRepositoryDefault()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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
        roomsViewModel.shouldShowGame = { [weak self, weak navigation] room in
            self?.showGame(room: room, user: user, navigation: navigation)
        }
        window?.rootViewController = navigation
    }
    
    func showGame(room: Room, user: User, navigation: UINavigationController?) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        navigation?.view.layer.add(transition, forKey: nil)
        let gameViewModel = GameViewModel(roomsRepository: roomsRepository, gameRepository: gameRepository, room: room, currentUser: user)
        let gameViewController = GameViewController(viewModel: gameViewModel)
        navigation?.pushViewController(gameViewController, animated: false)
        
//        let rotateHintViewController = RotateHintViewController(viewModel: RotateHintViewModel(boatFrame: CGRect(origin: .zero, size: CGSize(width: 35, height: 100))))
//        rotateHintViewController.modalPresentationStyle = .fullScreen
//        gameViewController.present(rotateHintViewController, animated: false, completion: nil)
    }
}

