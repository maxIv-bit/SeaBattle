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
        builder.setPositions([BoatPosition(id: UUID().uuidString, boatId: "", x: "A", y: 10, isHurt: false),
                              BoatPosition(id: UUID().uuidString, boatId: "", x: "A", y: 9, isHurt: false),
                              BoatPosition(id: UUID().uuidString, boatId: "", x: "A", y: 8, isHurt: false),
                              BoatPosition(id: UUID().uuidString, boatId: "", x: "A", y: 7, isHurt: false)])
        boats.append(builder.getResult())
        
        builder.reset()
        builder.setUserId(userId)
        builder.setLength(3)
        builder.setPositions([BoatPosition(id: UUID().uuidString, boatId: "", x: "A", y: 6, isHurt: false),
                              BoatPosition(id: UUID().uuidString, boatId: "", x: "A", y: 5, isHurt: false),
                              BoatPosition(id: UUID().uuidString, boatId: "", x: "A", y: 4, isHurt: false)])
        boats.append(builder.getResult())
        
        builder.reset()
        builder.setUserId(userId)
        builder.setLength(3)
        builder.setPositions([BoatPosition(id: UUID().uuidString, boatId: "", x: "B", y: 10, isHurt: false),
                              BoatPosition(id: UUID().uuidString, boatId: "", x: "B", y: 9, isHurt: false),
                              BoatPosition(id: UUID().uuidString, boatId: "", x: "B", y: 8, isHurt: false)])
        boats.append(builder.getResult())
        
        builder.reset()
        builder.setUserId(userId)
        builder.setLength(2)
        builder.setPositions([BoatPosition(id: UUID().uuidString, boatId: "", x: "B", y: 6, isHurt: false),
                              BoatPosition(id: UUID().uuidString, boatId: "", x: "B", y: 7, isHurt: false)])
        boats.append(builder.getResult())
        
        builder.reset()
        builder.setUserId(userId)
        builder.setLength(2)
        builder.setPositions([BoatPosition(id: UUID().uuidString, boatId: "", x: "B", y: 5, isHurt: false),
                              BoatPosition(id: UUID().uuidString, boatId: "", x: "B", y: 4, isHurt: false)])
        boats.append(builder.getResult())
        
        builder.reset()
        builder.setUserId(userId)
        builder.setLength(2)
        builder.setPositions([BoatPosition(id: UUID().uuidString, boatId: "", x: "C", y: 10, isHurt: false),
                              BoatPosition(id: UUID().uuidString, boatId: "", x: "C", y: 9, isHurt: false)])
        boats.append(builder.getResult())
        
        builder.reset()
        builder.setUserId(userId)
        builder.setLength(1)
        builder.setPositions([BoatPosition(id: UUID().uuidString, boatId: "", x: "C", y: 8, isHurt: false)])
        boats.append(builder.getResult())
        
        builder.reset()
        builder.setUserId(userId)
        builder.setLength(1)
        builder.setPositions([BoatPosition(id: UUID().uuidString, boatId: "", x: "C", y: 7, isHurt: false)])
        boats.append(builder.getResult())
        
        builder.reset()
        builder.setUserId(userId)
        builder.setLength(1)
        builder.setPositions([BoatPosition(id: UUID().uuidString, boatId: "", x: "C", y: 6, isHurt: false)])
        boats.append(builder.getResult())
        
        builder.reset()
        builder.setUserId(userId)
        builder.setLength(1)
        builder.setPositions([BoatPosition(id: UUID().uuidString, boatId: "", x: "C", y: 5, isHurt: false)])
        boats.append(builder.getResult())
        return boats
    }
}
