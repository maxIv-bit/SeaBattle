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
    private lazy var fieldCells = [FieldCell]()
    
    init(roomsRepository: RoomsRepository, room: Room) {
        self.room = room
        self.roomsRepository = roomsRepository
    }
    
    // MARK: - Bindings
    var didReceieveFieldCells: (([FieldCell]) -> Void)?
    var didReceieveBoats: (([Boat]) -> Void)?
    
    override func launch() {
        var fieldCells = [FieldCell]()
        for y in 1...10 {
            for x in 1...10 {
                fieldCells.append(FieldCell(positions: [Position(x: x, y: y)], isShot: false, isBoat: false))
            }
        }
        
        if let userId = room.players["user1"]?.id, let boats = room.boats[userId]?.values {
            didReceieveBoats?(Array(boats))
            var positions = [[Position]]()
            for boat in boats.sorted(by: { $0.positions.values.first?.x ?? 0 < $1.positions.values.first?.x ?? 0 }) {
                let boatPositions = boat.positions.values.sorted(by: { $0.x < $1.x || $0.y < $1.y }).map { Position(x: $0.x, y: $0.y) }
                positions.append(boatPositions)
                
                var indecies = [Int]()
                var i = 0
                while i < fieldCells.count {
                    if Set(fieldCells[i].positions).isSubset(of: Set(boatPositions))  {
                        indecies.append(i)
                    }
                    i += 1
                }

                indecies.forEach {
                    fieldCells.remove(at: $0)
                }
            }
            
            var indecies = [(Int, [Position])]()
            for positions in positions {
                var x = 0
                var y = 0
                if let firstPosition = positions.first {
                    x = (firstPosition.x - 1)
                    y = (firstPosition.y - 1) * 10
                }
                indecies.append((x + y, positions))
            }
            
            for i in indecies.sorted(by: { $0.0 < $1.0 }) {
                fieldCells.insert(FieldCell(positions: i.1, isShot: false, isBoat: true), at: i.0)
            }
        }
        
        didReceieveFieldCells?(fieldCells)
    }
}
