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
    private (set) var firstUserPositions = Set<Position>()
    private (set) var secondUserBoats = [Boat]()
    private (set) var secondUserPositions = Set<Position>()
    
    init(roomsRepository: RoomsRepository, room: Room) {
        self.room = room
        self.roomsRepository = roomsRepository
    }
    
    // MARK: - Bindings
    var didReceivePositions: (([Position]) -> Void)?
    
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
                firstUserPositions.insert(Position(x: x, y: y, isShot: false))
                secondUserPositions.insert(Position(x: x, y: y, isShot: false))
            }
        }
    }
    
    func shoot(x: Int, y: Int) {
        guard let position = firstUserPositions.first(where: { $0.x == x && $0.y == y }) else {
            return
        }
        
        guard !position.isShot else {
            return
        }
        
        position.isShot = true
        
        didReceivePositions?(Array(firstUserPositions))
    }
}
