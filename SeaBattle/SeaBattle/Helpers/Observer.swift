//
//  Observer.swift
//  SeaBattle
//
//  Created by Maks on 25.11.2020.
//

import Foundation

//class Observer<T>: Equatable {
//    var valueChanged: ((T) -> Void)?
//    
//    init() { }
//    
//    init(valueHandler: ((T) -> Void)? = nil) {
//        self.valueChanged = valueHandler
//    }
//    
//    static func == (lhs: Observer<T>, rhs: Observer<T>) -> Bool {
//        <#code#>
//    }
//}
//
//final class ObserverManager<T> {
//    private var observers = [Observer<T>]()
//    
//    func subscribe(_ observer: Observer<T>) {
//        observers.append(observer)
//    }
//    
//    func unsubscribe(_ observer: Observer<T>) {
//        observers.enumerated().first(where: { $1 == observer }).map { observers.remove(at: $0.offset) }
//    }
//    
//    func notify(_ value: T) {
//        observers.forEach { $0.valueChanged?(value) }
//    }
//}
