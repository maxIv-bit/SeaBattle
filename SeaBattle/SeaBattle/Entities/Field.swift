//
//  Field.swift
//  SeaBattle
//
//  Created by Maks on 01.12.2020.
//

import Foundation

final class Position: Hashable, Equatable {
    var x: Int
    var y: Int
    var isShot: Bool
    
    init(x: Int, y: Int, isShot: Bool) {
        self.x = x
        self.y = y
        self.isShot = isShot
    }
    
    static func == (lhs: Position, rhs: Position) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine("\(x)-\(y)")
    }
    
    var description: String {
        "\(x)-\(y)"
    }
}

enum AxisPosition: Int {
    case vertical,
    horizontal
}

final class FieldCell {
    var positions: [Position]
    var axisPosition = AxisPosition.horizontal
    var isShot: Bool
    var isBoat: Bool
    
    init(positions: [Position], isShot: Bool, isBoat: Bool) {
        self.positions = positions
        if positions.count > 1 {
            if Set(positions.map({ $0.x })).count > Set(positions.map({ $0.y })).count {
                axisPosition = .horizontal
            } else {
                axisPosition = .vertical
            }
        }
        self.isShot = isShot
        self.isBoat = isBoat
    }
}
