//
//  RoomsRepositoryDefault.swift
//  SeaBattle
//
//  Created by Maks on 25.11.2020.
//

import Foundation
import Firebase

final class RoomsRepositoryDefault: RoomsRepository {
    private lazy var roomsRef = Database.database().reference(withPath: "rooms")
    
    func roomAddedObserver(completion: ((Room) -> Void)?) {
        roomsRef.observe(.childAdded) { snap in
            guard let dict = snap.value as? [String: Any] else { return }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let room = try JSONDecoder().decode(Room.self, from: jsonData)
                completion?(room)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func roomRemovedObserver(completion: ((Room) -> Void)?) {
        roomsRef.observe(.childRemoved) { snap in
            guard let dict = snap.value as? [String: Any] else { return }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let room = try JSONDecoder().decode(Room.self, from: jsonData)
                completion?(room)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func configureRoom(with name: String, user: User, boats: [Boat]) {
        if UserDefaultManager.shared.roomId.isEmpty {
            UserDefaultManager.shared.roomId = UUID().uuidString
        }
        let roomRef = self.roomsRef.child(UserDefaultManager.shared.roomId)
        var boatsDict = [String: Boat]()
        boats.forEach { boatsDict[$0.id] = $0 }
        setRoom(name, user: user, boats: [user.id: boatsDict])
        roomRef.onDisconnectRemoveValue()
    }
    
    func setRoom(_ name: String, user: User, boats: [String: [String: Boat]]) {
        let roomId = UserDefaultManager.shared.roomId
        do {
            let room: [String: Any] = try Room(id: roomId,
                                               players: ["user1": user],
                                               name: name,
                                               boats: boats).asDictionary()
            
            roomsRef.child(roomId).setValue(room)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func connectToRoom(_ room: Room, user: User, boats: [Boat]) {
        self.roomsRef.child(room.id).child("players").child("user2").setValue(try? user.asDictionary() as [String: Any])
        var boatsDict = [String: Any]()
        boats.forEach { boatsDict[$0.id] = try? $0.asDictionary() }
        self.roomsRef.child(room.id).child("boats").child(user.id).setValue(boatsDict)
    }
    
    func disconnectFromRoom() {
        
    }
    
    func updateBoatPosition(roomId: String, userId: String, boatId: String, positionId: String) {
        self.roomsRef.child(roomId).child("boats").child(userId).child(boatId).child("positions").child(positionId).setValue(["is_hurt": true])
    }
}
