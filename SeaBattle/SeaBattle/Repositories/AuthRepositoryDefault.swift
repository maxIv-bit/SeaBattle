//
//  AuthRepositoryDefault.swift
//  SeaBattle
//
//  Created by Maks on 21.11.2020.
//

import Foundation
import Firebase

final class AuthRepositoryDefault: AuthRepository {
    func signUp(email: String, password: String, completion: ((Result<AuthDataResult, Error>) -> Void)?) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let authResult = authResult {
                completion?(.success(authResult))
                return
            }

            if let error = error {
                completion?(.failure(error))
                return
            }
        }
    }
    
    func signIn(email: String, password: String, completion: ((Result<AuthDataResult, Error>) -> Void)?) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let authResult = authResult {
                completion?(.success(authResult))
                return
            }

            if let error = error {
                completion?(.failure(error))
                return
            }
        }
    }
    
    func logOut(completion: ((Result<Void, Error>) -> Void)?) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError {
            completion?(.failure(signOutError))
            return
        }
        completion?(.success(()))
    }
}
