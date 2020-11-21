//
//  LogOutChainHandler.swift
//  SeaBattle
//
//  Created by Maks on 21.11.2020.
//

import Foundation
import Firebase

final class LogOutChainHandler: BaseChainHandler {
    private let authRepository: AuthRepository
    
    var onSuccess: (() -> Void)?
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    override func processRequest(parameters: [String : Any?]) {
        authRepository.logOut { [weak self] result in
            switch result {
            case .success:
                self?.onSuccess?()
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }
}
