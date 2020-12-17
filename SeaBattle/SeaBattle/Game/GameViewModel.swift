//
//  GameViewModel.swift
//  SeaBattle
//
//  Created by Maks on 01.12.2020.
//

import Foundation
import UIKit

final class GameViewModel: BaseViewModel {
    private let roomsRepository: RoomsRepository
    private let gameRepository: GameRepository
    private var room: Room
    private let currentUser: User
    private var firstUser: User?
    private var secondUser: User?
    private (set) var firstUserBoats = [Boat]()
    private (set) var firstUserPositions = [Position]()
    private (set) var secondUserBoats = [Boat]()
    private (set) var secondUserPositions = [Position]()
    private (set) var isFirstPlayer = false
    private (set) var isFirstPlayerReady = false
    private (set) var isSecondPlayerReady = false
    
    init(roomsRepository: RoomsRepository,
         gameRepository: GameRepository,
         room: Room,
         currentUser: User) {
        self.roomsRepository = roomsRepository
        self.gameRepository = gameRepository
        self.room = room
        self.currentUser = currentUser
    }
    
    // MARK: - Bindings
    var didReceiveFirstUserPositions: (([Position]) -> Void)?
    var didReceiveSecondUserPositions: (([Position]) -> Void)?
    var didUpdateFirstUserBoatPositions: ((Boat, Bool) -> Void)?
    var didUpdateSecondUserBoatPositions: ((Boat, Bool) -> Void)?
    var didShootFirstUserBoat: ((Boat) -> Void)?
    var didShootSecondUserBoat: ((Boat) -> Void)?
    var onError: ((String) -> Void)?
    var onReady: (() -> Void)?
    
    // MARK: - Callbacks
    var shouldShowRotateHint: ((CGRect) -> Void)?
    
    override func launch() {
        if let user = room.players["user1"],
           let boats = room.boats[user.id]?.values {
            firstUser = user
            firstUserBoats = Array(boats)
            isFirstPlayerReady = room.events[user.id]?.values.contains("Ready") ?? false
        }
        
        if let user = room.players["user2"],
           let boats = room.boats[user.id]?.values {
            secondUser = user
            secondUserBoats = Array(boats)
            isSecondPlayerReady = room.events[user.id]?.values.contains("Ready") ?? false
        }
        
        isFirstPlayer = room.players["user1"] == currentUser
        
        var secondUserShotPositions = Set<Position>()
        if let firstUser = self.firstUser {
            room.shotPositions[firstUser.id]?.values.map { position in
                let x = position.split(separator: "-")[0]
                let y = position.split(separator: "-")[1]
                secondUserShotPositions.insert(Position(x: Int(x) ?? 0, y: Int(y) ?? 0, isShot: true))
            }
        }
        
        var firstUserShotPositions = Set<Position>()
        if let secondUser = self.secondUser {
            room.shotPositions[secondUser.id]?.values.map { position in
                let x = position.split(separator: "-")[0]
                let y = position.split(separator: "-")[1]
                firstUserShotPositions.insert(Position(x: Int(x) ?? 0, y: Int(y) ?? 0, isShot: true))
            }
        }
        
        for x in 1...10 {
            for y in 1...10 {
                let firstUserPosition = Position(x: x, y: y, isShot: false)
                if firstUserShotPositions.contains(firstUserPosition) {
                    firstUserPosition.isShot = true
                    self.firstUserPositions.append(firstUserPosition)
                } else {
                    firstUserPosition.isShot = false
                    self.firstUserPositions.append(firstUserPosition)
                }
                
                let secondUserPosition = Position(x: x, y: y, isShot: false)
                if secondUserShotPositions.contains(secondUserPosition) {
                    secondUserPosition.isShot = true
                    self.secondUserPositions.append(secondUserPosition)
                } else {
                    secondUserPosition.isShot = false
                    self.secondUserPositions.append(secondUserPosition)
                }
            }
        }
        
        configureBindings()
    }
    
    func shoot(at index: Int) {
        if isFirstPlayer {
            let position = secondUserPositions[index]
            
            guard !position.isShot else { return }
            
            gameRepository.shootPosition(roomId: room.id, userId: currentUser.id, position: "\(position.x)-\(position.y)") { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success:
                    position.isShot = true
                    self.didReceiveSecondUserPositions?(self.secondUserPositions)
                case .failure(let error):
                    self.onError?(error.localizedDescription)
                }
            }
        } else {
            let position = firstUserPositions[index]
            
            guard !position.isShot else { return }
            
            gameRepository.shootPosition(roomId: room.id, userId: currentUser.id, position: "\(position.x)-\(position.y)") { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success:
                    position.isShot = true
                    self.didReceiveFirstUserPositions?(self.firstUserPositions)
                case .failure(let error):
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    func updateBoatPosition(boatId: String, positions: [Position]) {
        if isFirstPlayer {
            guard let boat = firstUserBoats.first(where: { $0.id == boatId }) else { return }
            
            for (index, element) in boat.positions.enumerated() {
                boat.positions[element.key]?.y = positions[index].y
                boat.positions[element.key]?.x = positions[index].x
            }
            
            didUpdateFirstUserBoatPositions?(boat, true)
        } else {
            guard let boat = secondUserBoats.first(where: { $0.id == boatId }) else { return }
            
            for (index, element) in boat.positions.enumerated() {
                boat.positions[element.key]?.y = positions[index].y
                boat.positions[element.key]?.x = positions[index].x
            }
            
            didUpdateSecondUserBoatPositions?(boat, true)
        }
    }
    
    func shootBoat(boatId: String, position: Position) {
        if isFirstPlayer {
            guard let secondUser = secondUser,
                  let boat = secondUserBoats.first(where: { $0.id == boatId }),
                  let boatPosition = boat.positions.values.first(where: { $0.x == position.x && $0.y == position.y }),
                  !boatPosition.isHurt else { return }
            
            gameRepository.shootBoat(roomId: room.id, userId: secondUser.id, boatId: boatId, positionId: boatPosition.id) { [weak self] result in
                switch result {
                case .success:
                    boatPosition.isHurt = true
                    self?.didShootSecondUserBoat?(boat)
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        } else {
            guard let firstUser = firstUser,
                  let boat = firstUserBoats.first(where: { $0.id == boatId }),
                  let boatPosition = boat.positions.values.first(where: { $0.x == position.x && $0.y == position.y }),
                  !boatPosition.isHurt else { return }
            
            gameRepository.shootBoat(roomId: room.id, userId: firstUser.id, boatId: boatId, positionId: boatPosition.id) { [weak self] result in
                switch result {
                case .success:
                    boatPosition.isHurt = true
                    self?.didShootFirstUserBoat?(boat)
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    func isAbleToShoot(_ firstField: Bool) -> Bool {
        return firstField && !isFirstPlayer || !firstField && isFirstPlayer
    }
    
    func isAbleToChangePositions(_ firstField: Bool) -> Bool {
        return firstField && isFirstPlayer || !firstField && !isFirstPlayer
    }
    
    func shouldShowBoats(_ firstField: Bool) -> Bool {
        return firstField && isFirstPlayer || !firstField && !isFirstPlayer
    }
    
    func ready() {
        gameRepository.updateBoatPositions(roomId: room.id, userId: currentUser.id, boats: isFirstPlayer ? firstUserBoats : secondUserBoats, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.gameRepository.setReadyState(roomId: self.room.id, userId: self.currentUser.id) { [weak self] result in
                    switch result {
                    case .success:
                        self?.onReady?()
                    case .failure(let error):
                        self?.onError?(error.localizedDescription)
                    }
                }
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        })
    }
    
    func disconnectFromRoom() {
        guard secondUser == currentUser else { return }
        gameRepository.disconnectFromRoom(roomId: room.id, userId: currentUser.id)
    }
    
    func showRotateHint(firstField: Bool, frame: CGRect) {
        if firstField && isFirstPlayer {
            shouldShowRotateHint?(frame)
        }
        
        if !firstField && !isFirstPlayer {
            shouldShowRotateHint?(frame)
        }
    }
}

//  MARK: - Private
private extension GameViewModel {
    func configureBindings() {
        roomsRepository.roomUpdatedObserver { [weak self] room in
            guard let self = self else { return }
            
            if let user = room.players["user1"],
               let boats = room.boats[user.id]?.values {
                self.firstUser = user
                self.firstUserBoats = Array(boats)
                self.isFirstPlayerReady = room.events[user.id]?.values.contains("Ready") ?? false
                for boat in self.firstUserBoats {
                    self.didUpdateFirstUserBoatPositions?(boat, false)
                }
            } else {
                self.firstUser = nil
                self.firstUserBoats = []
                self.isFirstPlayerReady = false
            }

            if let user = room.players["user2"],
               let boats = room.boats[user.id]?.values {
                self.secondUser = user
                self.secondUserBoats = Array(boats)
                self.isSecondPlayerReady = room.events[user.id]?.values.contains("Ready") ?? false
                for boat in self.secondUserBoats {
                    self.didUpdateSecondUserBoatPositions?(boat, false)
                }
            } else {
                self.secondUser = nil
                self.secondUserBoats = []
                self.isSecondPlayerReady = false
            }

            self.isFirstPlayer = room.players["user1"] == self.currentUser
            
            var secondUserShotPositions = Set<Position>()
            if let firstUser = self.firstUser {
                room.shotPositions[firstUser.id]?.values.map { position in
                    let x = position.split(separator: "-")[0]
                    let y = position.split(separator: "-")[1]
                    secondUserShotPositions.insert(Position(x: Int(x) ?? 0, y: Int(y) ?? 0, isShot: true))
                }
            }
            
            var firstUserShotPositions = Set<Position>()
            if let secondUser = self.secondUser {
                room.shotPositions[secondUser.id]?.values.map { position in
                    let x = position.split(separator: "-")[0]
                    let y = position.split(separator: "-")[1]
                    firstUserShotPositions.insert(Position(x: Int(x) ?? 0, y: Int(y) ?? 0, isShot: true))
                }
            }
            
            self.firstUserPositions = []
            self.secondUserPositions = []
            for x in 1...10 {
                for y in 1...10 {
                    let firstUserPosition = Position(x: x, y: y, isShot: false)
                    if firstUserShotPositions.contains(firstUserPosition) {
                        firstUserPosition.isShot = true
                        self.firstUserPositions.append(firstUserPosition)
                    } else {
                        firstUserPosition.isShot = false
                        self.firstUserPositions.append(firstUserPosition)
                    }
                    
                    let secondUserPosition = Position(x: x, y: y, isShot: false)
                    if secondUserShotPositions.contains(secondUserPosition) {
                        secondUserPosition.isShot = true
                        self.secondUserPositions.append(secondUserPosition)
                    } else {
                        secondUserPosition.isShot = false
                        self.secondUserPositions.append(secondUserPosition)
                    }
                }
            }

            self.didReceiveFirstUserPositions?(self.firstUserPositions)
            self.didReceiveSecondUserPositions?(self.secondUserPositions)
        }
    }
}
