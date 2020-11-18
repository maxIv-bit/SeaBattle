//
//  Validator.swift
//  SeaBattle
//
//  Created by Maks on 18.11.2020.
//

import Foundation

final class Validator {
    static var shared = Validator()
    private init() {}
    
    // MARK: - Regexs
    
    private let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,15}"
    private let passwordRegex = ".{8,}"
    private let hexStringRegex = "^[a-fA-F0-9]+$"
    
    // MARK: - Interface
    
    public enum ValidationRule {
        case email
        case password
        case matchString(String)
        case notEmpty
        case hexString
    }
    
    func isValid(text: String?, by rule: ValidationRule) -> Bool {
        switch rule {
        case .email:
            return evaluate(text: text, with: emailRegex)
        case .password:
            return evaluate(text: text, with: passwordRegex)
        case .matchString(let string):
            return text == string
        case .notEmpty:
            return !(text?.isEmpty ?? true)
        case .hexString:
            return evaluate(text: text, with: hexStringRegex)
        }
    }
    
    func getInvalidText(rule: ValidationRule, textFieldName: String? = nil) -> (title: String, message: String) {
        switch rule {
        case .email:
            return ("Oops", "Please enter valid email address.")
        case .password:
            return ("Oops", "Invalid password. Password should contain at least 8 characters.")
        case .matchString(let string):
            return ("Oops", "\(textFieldName ?? "") doesn't match \(string)")
        case .notEmpty:
            return ("Oops", "Please enter \(textFieldName ?? "")")
        case .hexString:
            return ("Oops", "Please enter valid characters which are: 0123456789ABCDEF")
        }
    }
    
    // MARK: - Private methods
    
    private func evaluate(text: String?, with regex: String) -> Bool {
        guard let text = text, !text.isEmpty else { return false }
        
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return test.evaluate(with: text.trimmingCharacters(in: .whitespaces))
    }
}
