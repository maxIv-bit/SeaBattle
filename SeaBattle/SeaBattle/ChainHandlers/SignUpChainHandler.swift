//
//  SignUpChainHandler.swift
//  SeaBattle
//
//  Created by Maks on 21.11.2020.
//

import Foundation
import Firebase

final class SignUpChainHandler: BaseChainHandler {
    private let authRepository: AuthRepository
    
    var onSuccess: ((User) -> Void)?
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    override func processRequest(parameters: [String : Any?]) {
        authRepository.signUp(email: parameters[AuthParameters.email] as! String,
                              password: parameters[AuthParameters.password] as! String) { [weak self] result in
            switch result {
            case .success(let authData):
                self?.onSuccess?(User(authData: authData.user))
            case .failure(let error):
                self?.processError(error: error)
            }
        }
    }
}
