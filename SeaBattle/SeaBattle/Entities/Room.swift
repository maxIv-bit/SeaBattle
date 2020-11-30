//
//  Room.swift
//  SeaBattle
//
//  Created by Maks on 30.11.2020.
//

import Foundation

final class Room: Entity {
    private enum CodingKeys: String, CodingKey {
        case name,
        players,
        boats
    }
    
    private(set) var players = [String: User]()
    private(set) var name: String
    private(set) var boats = [String: [String: Boat]]()
    
    init(id: String, players: [String: User], name: String, boats: [String: [String: Boat]]) {
        self.players = players
        self.name = name
        self.boats = boats
        super.init(id: id)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.typelessDecode(forKey: .name)
        self.players = container.optionalDefaultDecode(forKey: .players, defaultValue: [:])
        self.boats = container.optionalDefaultDecode(forKey: .boats, defaultValue: [:])
        
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.players, forKey: .players)
        try container.encode(self.boats, forKey: .boats)
        
        try super.encode(to: encoder)
    }
}
