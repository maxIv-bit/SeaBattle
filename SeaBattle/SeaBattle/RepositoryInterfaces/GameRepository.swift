//
//  GameRepository.swift
//  SeaBattle
//
//  Created by Maks on 16.12.2020.
//

import Foundation

protocol GameRepository {
    func updateBoatPositions(roomId: String, userId: String, boats: [Boat], completion: ((Result<Void, Error>) -> Void)?)
    func setReadyState(roomId: String, userId: String, completion: ((Result<Void, Error>) -> Void)?)
    func disconnectFromRoom(roomId: String, userId: String)
    func shootBoat(roomId: String, userId: String, boatId: String, positionId: String, completion: ((Result<Void, Error>) -> Void)?)
    func shootPosition(roomId: String, userId: String, position: String, completion: ((Result<Void, Error>) -> Void)?)
}
