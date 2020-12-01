//
//  Builder.swift
//  SeaBattle
//
//  Created by Maks on 01.12.2020.
//

import Foundation

protocol Builder: class {
    associatedtype T
    
    func reset()
    func setUserId(_ userId: String)
    func setLength(_ value: Int)
    func setPositions(_ positions: [BoatPosition])
    func getResult() -> T
}
