//
//  AuthRepository.swift
//  SeaBattle
//
//  Created by Maks on 21.11.2020.
//

import Foundation
import Firebase

protocol AuthRepository {
    func signUp(email: String, password: String, completion: ((Result<AuthDataResult, Error>) -> Void)?)
    func signIn(email: String, password: String, completion: ((Result<AuthDataResult, Error>) -> Void)?)
    func logOut(completion: ((Result<Void, Error>) -> Void)?)
}
