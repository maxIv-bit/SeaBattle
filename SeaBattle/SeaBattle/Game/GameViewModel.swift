//
//  GameViewModel.swift
//  SeaBattle
//
//  Created by Maks on 01.12.2020.
//

import Foundation

final class GameViewModel: BaseViewModel {
    private let roomsRepository: RoomsRepository
    private var room: Room
    private let currentUser: User
    private (set) var firstUserBoats = [Boat]()
    private (set) var firstUserPositions = [Position]()
    private (set) var secondUserBoats = [Boat]()
    private (set) var secondUserPositions = [Position]()
    private (set) var isFirstPlayer = false
    
    init(roomsRepository: RoomsRepository,
         room: Room,
         currentUser: User) {
        self.room = room
        self.roomsRepository = roomsRepository
        self.currentUser = currentUser
    }
    
    // MARK: - Bindings
    var didReceiveFirstUserPositions: (([Position]) -> Void)?
    var didReceiveSecondUserPositions: (([Position]) -> Void)?
    var didUpdateFirstUserBoatPositions: ((Boat) -> Void)?
    var didUpdateSecondUserBoatPositions: ((Boat) -> Void)?
    var didShootFirstUserBoat: ((Boat) -> Void)?
    var didShootSecondUserBoat: ((Boat) -> Void)?
    
    override func launch() {
        if let userId = room.players["user1"]?.id,
           let boats = room.boats[userId]?.values {
            firstUserBoats = Array(boats)
        }
        
        if let userId = room.players["user2"]?.id,
           let boats = room.boats[userId]?.values {
            secondUserBoats = Array(boats)
        }
        
        isFirstPlayer = room.players["user1"] == currentUser
        
        for x in 1...10 {
            for y in 1...10 {
                firstUserPositions.append(Position(x: x, y: y, isShot: false))
                secondUserPositions.append(Position(x: x, y: y, isShot: false))
            }
        }
    }
    
    func shoot(at index: Int) {
        if isFirstPlayer {
            let position = secondUserPositions[index]
            
            guard !position.isShot else { return }
            
            position.isShot = true
            
            didReceiveSecondUserPositions?(secondUserPositions)
        } else {
            let position = firstUserPositions[index]
            
            guard !position.isShot else { return }
            
            position.isShot = true
            
            didReceiveFirstUserPositions?(firstUserPositions)
        }
    }
    
    func updateBoatPosition(boatId: String, positions: [Position]) {
        if isFirstPlayer {
            guard let boat = firstUserBoats.first(where: { $0.id == boatId }) else { return }
            
            for (index, element) in boat.positions.enumerated() {
                boat.positions[element.key]?.y = positions[index].y
                boat.positions[element.key]?.x = positions[index].x
            }
            
            didUpdateFirstUserBoatPositions?(boat)
        } else {
            guard let boat = secondUserBoats.first(where: { $0.id == boatId }) else { return }
            
            for (index, element) in boat.positions.enumerated() {
                boat.positions[element.key]?.y = positions[index].y
                boat.positions[element.key]?.x = positions[index].x
            }
            
            didUpdateSecondUserBoatPositions?(boat)
        }
    }
    
    func shootBoat(boatId: String, position: Position) {
        if isFirstPlayer {
            guard let boat = secondUserBoats.first(where: { $0.id == boatId }) else { return }
            
            guard let boatPosition = boat.positions.values.first(where: { $0.x == position.x && $0.y == position.y }),
                  !boatPosition.isHurt else { return }
            
            boatPosition.isHurt = true
            didShootSecondUserBoat?(boat)
        } else {
            guard let boat = firstUserBoats.first(where: { $0.id == boatId }) else { return }
            
            guard let boatPosition = boat.positions.values.first(where: { $0.x == position.x && $0.y == position.y }),
                  !boatPosition.isHurt else { return }
            
            boatPosition.isHurt = true
            didShootFirstUserBoat?(boat)
        }
    }
    
    func isAbleToShoot(_ firstField: Bool) -> Bool {
        return firstField && !isFirstPlayer || !firstField && isFirstPlayer
    }
    
    func isAbleToChangePositions(_ firstField: Bool) -> Bool {
        return firstField && isFirstPlayer || !firstField && !isFirstPlayer
    }
}
