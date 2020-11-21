//
//  EmailChainHandler.swift
//  SeaBattle
//
//  Created by Maks on 21.11.2020.
//

import Foundation

final class EmailChainHandler: BaseChainHandler {
    override func processRequest(parameters: [String : Any?]) {
        guard let email = parameters["email"] as? String, Validator.shared.isValid(text: email, by: .email) else {
            processError(error: StringError(message: Validator.shared.getInvalidText(rule: .email).message))
            return
        }

        nextHandler?.processRequest(parameters: parameters)
    }
}
