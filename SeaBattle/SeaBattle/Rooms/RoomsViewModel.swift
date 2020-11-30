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
    
    override func launch() {
        configureBindings()
    }
    
    func logOut() {
        logOutHandler.processRequest(parameters: [:])
    }
    
    func createRoom(name: String) {
        let boatId = UUID().uuidString
        let boatPositionId = UUID().uuidString
        roomsRepository.configureRoom(with: name, user: currentUser, boats: [Boat(id: boatId, userId: currentUser.id, positions: [boatPositionId: BoatPosition(id: boatPositionId, boatId: boatId, x: "A", y: 1, isHurt: false)], length: 1)])
    }
    
    func connectToRoom(at indexPath: IndexPath) {
        let boatId = UUID().uuidString
        let boatPositionId = UUID().uuidString
        roomsRepository.connectToRoom(self.rooms[indexPath.row], user: currentUser, boats: [Boat(id: boatId, userId: currentUser.id, positions: [boatPositionId: BoatPosition(id: boatPositionId, boatId: boatId, x: "A", y: 1, isHurt: false)], length: 1)])
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
    }
}
