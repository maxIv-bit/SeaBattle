//
//  Reusable.swift
//  SeaBattle
//
//  Created by Maks on 21.11.2020.
//

import Foundation

protocol Reusable: class {
    // MARK: - Properties
    static var reuseIdentifier: String { get }
}

extension Reusable {
    // MARK: - Properties
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
