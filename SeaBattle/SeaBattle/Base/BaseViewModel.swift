//
//  BaseViewModel.swift
//  SeaBattle
//
//  Created by Maks on 17.11.2020.
//

import Foundation

class BaseViewModel {    
    // MARK: - Lifecycle
    func launch() {}
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("☠️\(self)☠️")
    }
}
