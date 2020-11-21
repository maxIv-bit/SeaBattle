//
//  PasswordChainHandler.swift
//  SeaBattle
//
//  Created by Maks on 21.11.2020.
//

import Foundation

final class PasswordChainHandler: BaseChainHandler {
    override func processRequest(parameters: [String : Any?]) {
        guard let password = parameters["password"] as? String, Validator.shared.isValid(text: password, by: .password) else {
            processError(error: StringError(message: Validator.shared.getInvalidText(rule: .password).message))
            return
        }

        nextHandler?.processRequest(parameters: parameters)
    }
}
