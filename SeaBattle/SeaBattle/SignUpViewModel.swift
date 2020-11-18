//
//  SignUpViewModel.swift
//  SeaBattle
//
//  Created by Maks on 17.11.2020.
//

import Foundation

final class SignUpViewModel: BaseViewModel {
    // MARK: - Properties
    private lazy var handler = SignUpChainHandler()
    
    // MARK: - Bindings
    var onInvalidEmail: ((String) -> Void)?
    var onInvalidPassword: ((String) -> Void)?
    var onError: ((String) -> Void)?
    
    override func launch() {
        handler.onInvalidEmail = onInvalidEmail
        handler.onInvalidPassword = onInvalidPassword
        handler.onError = onError
    }
    
    func signUp(email: String?, password: String?) {
        handler.email = email
        handler.password = password
        
        handler.processRequest()
    }
}

import Firebase

final class SignUpChainHandler: BaseChainHandler {
    // MARK: - Properties
    var email: String?
    var password: String?
    
    // MARK: - Bindings
    var onInvalidEmail: ((String) -> Void)?
    var onInvalidPassword: ((String) -> Void)?
    var onError: ((String) -> Void)?
    
    override func processRequest() {
        super.processRequest()
        
        guard let email = email, Validator.shared.isValid(text: email, by: .email) else {
            onInvalidEmail?(Validator.shared.getInvalidText(rule: .email).message)
            return
        }
        
        guard let password = password, Validator.shared.isValid(text: password, by: .password)  else {
            onInvalidPassword?(Validator.shared.getInvalidText(rule: .password).message)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            print(self)
            if let self = self {
                print(self)
            }
            if authResult != nil {
                self?.nextHandler?.processRequest()
            }
            
            if let error = error {
                self?.onError?(error.localizedDescription)
            }
        }
    }
}
