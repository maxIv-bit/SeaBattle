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
    
    override func launch() {
        var fieldCells = [FieldCell]()
        for y in 1...10 {
            for x in ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"] {
                var isBoat = false
                if let userId = room.players["user1"]?.id, let boats = room.boats[userId]?.values {
                    bootsLoop: for boat in boats {
                        for position in boat.positions.values {
                            if position.x == x && position.y == y {
                                isBoat = true
                                print(x, y)
                                break bootsLoop
                            }
                        }
                    }
                }
                fieldCells.append(FieldCell(x: x, y: y, isShot: false, isBoat: isBoat))
            }
        }
        didReceieveFieldCells?(fieldCells)
    }
}
