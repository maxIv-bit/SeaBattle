//
//  Field.swift
//  SeaBattle
//
//  Created by Maks on 01.12.2020.
//

import Foundation

final class FieldCell {
    var x: String
    var y: Int
    var isShot: Bool
    var isBoat: Bool
    
    init(x: String, y: Int, isShot: Bool, isBoat: Bool) {
        self.x = x
        self.y = y
        self.isShot = isShot
        self.isBoat = isBoat
    }
}
