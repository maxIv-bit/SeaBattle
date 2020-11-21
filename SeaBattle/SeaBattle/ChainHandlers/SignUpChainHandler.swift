//
//  SignUpChainHandler.swift
//  SeaBattle
//
//  Created by Maks on 21.11.2020.
//

import Foundation
import Firebase

final class SignUpChainHandler: BaseChainHandler {
    var onSuccess: (() -> Void)?
    
    override func processRequest(parameters: [String : Any?]) {
        Auth.auth().createUser(withEmail: parameters["email"] as! String, password: parameters["password"] as! String) { [weak self] authResult, error in
            if authResult != nil {
                self?.onSuccess?()
            }

            if let error = error {
                self?.processError(error: error)
            }
        }
    }
}
