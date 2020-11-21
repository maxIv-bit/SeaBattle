//
//  Errors.swift
//  SeaBattle
//
//  Created by Maks on 21.11.2020.
//

import Foundation

enum FlowError: LocalizedError {
    case invalidEmail(String)
    case invalidPassword(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail(let message):
            return message
        case .invalidPassword(let message):
            return message
        }
    }
}

struct StringError: LocalizedError {
    let message: String
    
    var errorDescription: String? { message }
}
