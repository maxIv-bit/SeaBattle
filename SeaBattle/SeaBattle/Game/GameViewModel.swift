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
    private (set) var firstUserBoats = [Boat]()
    private (set) var firstUserPositions = [Position]()
    private (set) var secondUserBoats = [Boat]()
    private (set) var secondUserPositions = [Position]()
    
    init(roomsRepository: RoomsRepository, room: Room) {
        self.room = room
        self.roomsRepository = roomsRepository
    }
    
    // MARK: - Bindings
    var didReceivePositions: (([Position]) -> Void)?
    var didUpdateBoatPositions: ((Boat) -> Void)?
    var didShootBoat: ((Boat) -> Void)?
    
    override func launch() {
        if let userId = room.players["user1"]?.id,
           let boats = room.boats[userId]?.values {
            firstUserBoats = Array(boats)
        }
        
        if let userId = room.players["user2"]?.id,
           let boats = room.boats[userId]?.values {
            secondUserBoats = Array(boats)
        }
        
        for x in 1...10 {
            for y in 1...10 {
                firstUserPositions.append(Position(x: x, y: y, isShot: false))
                secondUserPositions.append(Position(x: x, y: y, isShot: false))
            }
        }
    }
    
    func shoot(at index: Int) {
        let position = firstUserPositions[index]
        
        guard !position.isShot else {
            return
        }
        
        position.isShot = true
        
        didReceivePositions?(firstUserPositions)
    }
    
    func updateBoatPosition(boatId: String, positions: [Position]) {
        guard let boat = firstUserBoats.first(where: { $0.id == boatId }) else { return }
        
        for (index, element) in boat.positions.enumerated() {
            boat.positions[element.key]?.y = positions[index].y
            boat.positions[element.key]?.x = positions[index].x
        }
        didUpdateBoatPositions?(boat)
    }
    
    func shootBoat(boatId: String, position: Position) {
        guard let boat = firstUserBoats.first(where: { $0.id == boatId }) else { return }
        
        guard let boatPosition = boat.positions.values.first(where: { $0.x == position.x && $0.y == position.y }) else { return }
        boatPosition.isHurt = true
        didShootBoat?(boat)
    }
}
