//
//  GameRepositoryDefault.swift
//  SeaBattle
//
//  Created by Maks on 16.12.2020.
//

import Foundation
import Firebase

final class GameRepositoryDefault: GameRepository {
    private lazy var roomsRef = Database.database().reference(withPath: "rooms")
    
    func updateBoatPositions(roomId: String, userId: String, boats: [Boat], completion: ((Result<Void, Error>) -> Void)?) {
        do {
            var boatsDict = [String: Any]()
            try boats.forEach { boatsDict[$0.id] = try $0.asDictionary() }
            self.roomsRef.child(roomId).child("boats").child(userId).setValue(boatsDict) { error, ref in
                if let error = error {
                    completion?(.failure(error))
                } else {
                    completion?(.success(()))
                }
            }
        } catch {
            completion?(.failure(error))
        }
    }
    
    func setReadyState(roomId: String, userId: String, completion: ((Result<Void, Error>) -> Void)?) {
        self.roomsRef.child(roomId).child("events").child(userId).setValue("Ready") { error, ref in
            if let error = error {
                completion?(.failure(error))
            } else {
                completion?(.success(()))
            }
        }
    }
    
    func disconnectFromRoom(roomId: String, userId: String) {
        self.roomsRef.child(roomId).child("boats").child(userId).removeValue()
        self.roomsRef.child(roomId).child("players").child("user2").removeValue()
        self.roomsRef.child(roomId).child("shotPositions").child(userId).removeValue()
    }
    
    func shootBoat(roomId: String, userId: String, boatId: String, positionId: String, completion: ((Result<Void, Error>) -> Void)?) {
        self.roomsRef.child(roomId).child("boats").child(userId).child(boatId).child("positions").child(positionId).child("is_hurt").setValue(true) { error, ref in
            if let error = error {
                completion?(.failure(error))
            } else {
                completion?(.success(()))
            }
        }
    }
    
    func shootPosition(roomId: String, userId: String, position: String, completion: ((Result<Void, Error>) -> Void)?) {
        self.roomsRef.child(roomId).child("shotPositions").child(userId).child(UUID().uuidString).setValue(position) { error, ref in
            if let error = error {
                completion?(.failure(error))
            } else {
                completion?(.success(()))
            }
        }
    }
}
