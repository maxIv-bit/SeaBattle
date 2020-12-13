//
//  Director.swift
//  SeaBattle
//
//  Created by Maks on 01.12.2020.
//

import Foundation

final class Director<T: Builder> {
    private var builder: T
    
    init(builder: T) {
        self.builder = builder
    }
    
    func constructBoatsOnStart(userId: String) -> [T.T] {
        var boats = [T.T]()
        
        builder.setUserId(userId)
        builder.setLength(4)
        builder.setPositions([BoatPosition(id: UUID().uuidString, boatId: "", x: 1, y: 10, isHurt: false),
                              BoatPosition(id: UUID().uuidString, boatId: "", x: 1, y: 9, isHurt: false),
                              BoatPosition(id: UUID().uuidString, boatId: "", x: 1, y: 8, isHurt: false),
                              BoatPosition(id: UUID().uuidString, boatId: "", x: 1, y: 7, isHurt: false)])
        boats.append(builder.getResult())
        
        builder.reset()
        builder.setUserId(userId)
        builder.setLength(3)
        builder.setPositions([BoatPosition(id: UUID().uuidString, boatId: "", x: 1, y: 6, isHurt: false),
                              BoatPosition(id: UUID().uuidString, boatId: "", x: 1, y: 5, isHurt: false),
                              BoatPosition(id: UUID().uuidString, boatId: "", x: 1, y: 4, isHurt: false)])
        boats.append(builder.getResult())
        
        builder.reset()
        builder.setUserId(userId)
        builder.setLength(3)
        builder.setPositions([BoatPosition(id: UUID().uuidString, boatId: "", x: 2, y: 10, isHurt: false),
                              BoatPosition(id: UUID().uuidString, boatId: "", x: 2, y: 9, isHurt: false),
                              BoatPosition(id: UUID().uuidString, boatId: "", x: 2, y: 8, isHurt: false)])
        boats.append(builder.getResult())
        
        builder.reset()
        builder.setUserId(userId)
        builder.setLength(2)
        builder.setPositions([BoatPosition(id: UUID().uuidString, boatId: "", x: 2, y: 6, isHurt: false),
                              BoatPosition(id: UUID().uuidString, boatId: "", x: 2, y: 7, isHurt: false)])
        boats.append(builder.getResult())
        
        builder.reset()
        builder.setUserId(userId)
        builder.setLength(2)
        builder.setPositions([BoatPosition(id: UUID().uuidString, boatId: "", x: 2, y: 5, isHurt: false),
                              BoatPosition(id: UUID().uuidString, boatId: "", x: 2, y: 4, isHurt: false)])
        boats.append(builder.getResult())
        
        builder.reset()
        builder.setUserId(userId)
        builder.setLength(2)
        builder.setPositions([BoatPosition(id: UUID().uuidString, boatId: "", x: 3, y: 10, isHurt: false),
                              BoatPosition(id: UUID().uuidString, boatId: "", x: 3, y: 9, isHurt: false)])
        boats.append(builder.getResult())
        
        builder.reset()
        builder.setUserId(userId)
        builder.setLength(1)
        builder.setPositions([BoatPosition(id: UUID().uuidString, boatId: "", x: 3, y: 8, isHurt: false)])
        boats.append(builder.getResult())
        
        builder.reset()
        builder.setUserId(userId)
        builder.setLength(1)
        builder.setPositions([BoatPosition(id: UUID().uuidString, boatId: "", x: 3, y: 7, isHurt: false)])
        boats.append(builder.getResult())
        
        builder.reset()
        builder.setUserId(userId)
        builder.setLength(1)
        builder.setPositions([BoatPosition(id: UUID().uuidString, boatId: "", x: 3, y: 6, isHurt: false)])
        boats.append(builder.getResult())
        
        builder.reset()
        builder.setUserId(userId)
        builder.setLength(1)
        builder.setPositions([BoatPosition(id: UUID().uuidString, boatId: "", x: 3, y: 5, isHurt: false)])
        boats.append(builder.getResult())
        return boats
    }
}
