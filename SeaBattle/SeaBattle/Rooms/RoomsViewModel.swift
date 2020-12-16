//
//  RoomsViewModel.swift
//  SeaBattle
//
//  Created by Maks on 21.11.2020.
//

import Foundation

final class RoomsViewModel: BaseViewModel {
    // MARK: - Properties
    private let currentUser: User
    private let authRepository: AuthRepository
    private let roomsRepository: RoomsRepository
    private lazy var logOutHandler = LogOutChainHandler(authRepository: authRepository)
    private lazy var rooms: [Room] = []
    private lazy var boatDirector = Director(builder: BoatBuilder())
    
    init(currentUser: User,
         authRepository: AuthRepository,
         roomsRepository: RoomsRepository) {
        self.currentUser = currentUser
        self.authRepository = authRepository
        self.roomsRepository = roomsRepository
    }
    
    // MARK: - Bindings
    var onError: ((String) -> Void)?
    var didReceiveRooms: (([Room]) -> Void)?
    
    // MARK: - Callbacks
    var onLogOut: (() -> Void)?
    var shouldShowGame: ((Room) -> Void)?
    
    override func launch() {
        configureBindings()
        
        //        if let room = self.rooms.first,
        //           let position = room.boats[self.currentUser.id]?.values.first?.positions.first?.value {
        //            self.roomsRepository.updateBoatPosition(roomId: room.id, userId: self.currentUser.id, boatId: position.boatId, positionId: position.id)
        //        }
    }
    
    func logOut() {
        logOutHandler.processRequest(parameters: [:])
    }
    
    func createRoom(name: String) {
        roomsRepository.configureRoom(with: name, user: currentUser, boats: boatDirector.constructBoatsOnStart(userId: currentUser.id))
    }
    
    func connectToRoom(at indexPath: IndexPath) {
        if self.rooms[indexPath.row].players.values.contains(currentUser) {
            shouldShowGame?(self.rooms[indexPath.row])
        } else {
            if self.rooms[indexPath.row].players.count < 2 {
                roomsRepository.connectToRoom(self.rooms[indexPath.row], user: currentUser, boats: boatDirector.constructBoatsOnStart(userId: currentUser.id))
            } else {
                onError?("Sorry this room is already full")
            }
        }
    }
}

// MARK: - Private
private extension RoomsViewModel {
    func configureBindings() {
        logOutHandler.onSuccess = { [weak self] in
            self?.onLogOut?()
        }
        
        logOutHandler.onError = { [weak self] error in
            self?.onError?(error.localizedDescription)
        }
        
        roomsRepository.roomAddedObserver { [weak self] room in
            guard let self = self else { return }
            self.rooms.append(room)
            self.didReceiveRooms?(self.rooms)
        }
        
        roomsRepository.roomRemovedObserver { [weak self] room in
            guard let self = self else { return }
            if let index = self.rooms.firstIndex(where: { $0 == room }) {
                self.rooms.remove(at: index)
                self.didReceiveRooms?(self.rooms)
            }
        }
        
        roomsRepository.roomUpdatedObserver { [weak self] room in
            guard let self = self else { return }
            if let index = self.rooms.firstIndex(where: { $0 == room }) {
                self.rooms.remove(at: index)
                self.rooms.insert(room, at: index)
                self.didReceiveRooms?(self.rooms)
            }
        }
    }
}
