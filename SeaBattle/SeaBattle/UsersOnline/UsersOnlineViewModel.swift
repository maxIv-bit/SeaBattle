//
//  UsersOnlineViewModel.swift
//  SeaBattle
//
//  Created by Maks on 21.11.2020.
//

import Foundation

final class UsersOnlineViewModel: BaseViewModel {
    // MARK: - Properties
    private let authRepository: AuthRepository
    private lazy var logOutHandler = LogOutChainHandler(authRepository: authRepository)
    private lazy var emails = [String]()
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    // MARK: - Bindings
    var onError: ((String) -> Void)?
    
    // MARK: - Callbacks
    var onLogOut: (() -> Void)?
    
    override func launch() {
        logOutHandler.onSuccess = { [weak self] in
            self?.onLogOut?()
        }
        
        logOutHandler.onError = { [weak self] error in
            self?.onError?(error.localizedDescription)
        }
    }
    
    func logOut() {
        logOutHandler.processRequest(parameters: [:])
    }
}
