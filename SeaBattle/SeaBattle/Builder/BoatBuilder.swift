//
//  BoatBuilder.swift
//  SeaBattle
//
//  Created by Maks on 01.12.2020.
//

import Foundation

final class BoatBuilder: Builder {
    typealias T = Boat
    
    private var boat = Boat(id: UUID().uuidString, userId: "", positions: [:], length: 0)
    
    func reset() {
        boat = Boat(id: UUID().uuidString, userId: "", positions: [:], length: 0)
    }
    
    func setUserId(_ userId: String) {
        boat.userId = userId
    }
    
    func setLength(_ value: Int) {
        boat.length = value
    }
    
    func setPositions(_ positions: [BoatPosition]) {
        var postionsDict = [String: BoatPosition]()
        positions.forEach { postionsDict[$0.id] = $0 }
        boat.positions = postionsDict
    }
    
    func getResult() -> Boat {
        boat.positions.forEach { $1.boatId = boat.id }
        return boat
    }
}
