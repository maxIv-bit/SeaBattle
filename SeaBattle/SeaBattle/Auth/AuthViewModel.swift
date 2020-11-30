//
//  SignUpViewModel.swift
//  SeaBattle
//
//  Created by Maks on 17.11.2020.
//

import Foundation

struct AuthParameters {
    static var email: String { "email" }
    static var password: String { "password" }
}

final class AuthViewModel: BaseViewModel {
    // MARK: - Properties
    private let authRepository: AuthRepository
    private lazy var emailHandler = EmailChainHandler()
    private lazy var passwordHandler = PasswordChainHandler()
    private lazy var signInHandler = SignInChainHandler(authRepository: authRepository)
    private lazy var signUpHandler = SignUpChainHandler(authRepository: authRepository)
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    // MARK: - Bindings
    var onInvalidEmail: ((String) -> Void)?
    var onInvalidPassword: ((String) -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Callbacks
    var onSuccessfulLogIn: ((User) -> Void)?
    
    override func launch() {
        emailHandler.nextHandler = passwordHandler
        
        signInHandler.onError = { [weak self] error in
            self?.handleError(error)
        }
        signInHandler.onSuccess = onSuccessfulLogIn
        signUpHandler.onError = { [weak self] error in
            self?.handleError(error)
        }
        signUpHandler.onSuccess = onSuccessfulLogIn
    }
    
    func signUp(email: String?, password: String?) {
        passwordHandler.nextHandler = signUpHandler
        emailHandler.processRequest(parameters: [AuthParameters.email: email,
                                                 AuthParameters.password: password])
    }
    
    func signIn(email: String?, password: String?) {
        passwordHandler.nextHandler = signInHandler
        emailHandler.processRequest(parameters: [AuthParameters.email: email,
                                                 AuthParameters.password: password])
    }
}

// MARK: - Private
private extension AuthViewModel {
    func handleError(_ error: Error) {
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
