//
//  UserDefaultsWrapper.swift
//  SeaBattle
//
//  Created by Maks on 25.11.2020.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            let val = UserDefaults.standard.object(forKey: key) as? T
            return  val ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

final class UserDefaultManager {
    static let shared = UserDefaultManager()
    private init() {}
    
    func executeFirstTime(_ f: (Bool) -> ()) {
        defer { firstTime = false }
        f(firstTime)
    }

    @UserDefault("firstTime", defaultValue: true)
    var firstTime: Bool
    @UserDefault("roomId", defaultValue: "")
    var roomId: String
}
