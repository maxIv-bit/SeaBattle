//
//  RoomsRepository.swift
//  SeaBattle
//
//  Created by Maks on 25.11.2020.
//

import Foundation

protocol RoomsRepository {
    func roomAddedObserver(completion: ((Room) -> Void)?)
    func roomUpdatedObserver(completion: ((Room) -> Void)?)
    func roomRemovedObserver(completion: ((Room) -> Void)?)
    func configureRoom(with name: String, user: User, boats: [Boat])
    func connectToRoom(_ room: Room, user: User, boats: [Boat])
    func updateBoatPosition(roomId: String, userId: String, boatId: String, positionId: String)
}
