//
//  SignUpViewModel.swift
//  SeaBattle
//
//  Created by Maks on 17.11.2020.
//

import Foundation

final class AuthViewModel: BaseViewModel {
    // MARK: - Properties
    private lazy var emailHandler = EmailChainHandler()
    private lazy var passwordHandler = PasswordChainHandler()
    private lazy var signInHandler = SignInChainHandler()
    private lazy var signUpHandler = SignUpChainHandler()
    
    // MARK: - Bindings
    var onInvalidEmail: ((String) -> Void)?
    var onInvalidPassword: ((String) -> Void)?
    var onError: ((String) -> Void)?
    var onSuccessfulLogIn: (() -> Void)?
    
    override func launch() {
        emailHandler.nextHandler = passwordHandler
        
        signInHandler.onError = handleError
        signInHandler.onSuccess = onSuccessfulLogIn
        signUpHandler.onError = handleError
        signUpHandler.onSuccess = onSuccessfulLogIn
    }
    
    func signUp(email: String?, password: String?) {
        passwordHandler.nextHandler = signUpHandler
        emailHandler.processRequest(parameters: ["email": email,
                                                 "password": password])
    }
    
    func signIn(email: String?, password: String?) {
        passwordHandler.nextHandler = signInHandler
        emailHandler.processRequest(parameters: ["email": email,
                                                 "password": password])
    }
}

// MARK: - Private
private extension AuthViewModel {
    func handleError(error: Error) {
        if let flowError = error as? FlowError {
            switch flowError {
            case .invalidEmail(let message):
                self.onInvalidEmail?(message)
            case .invalidPassword(let message):
                self.onInvalidPassword?(message)
            }
        } else {
            self.onError?(error.localizedDescription)
        }
    }
}
