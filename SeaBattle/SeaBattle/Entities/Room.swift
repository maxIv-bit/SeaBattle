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
        boats,
        events,
        shotPositions
    }
    
    var players = [String: User]()
    var name: String
    var boats = [String: [String: Boat]]()
    var events = [String: [String: String]]()
    var shotPositions = [String: [String: String]]()
    
    init(id: String, players: [String: User], name: String, boats: [String: [String: Boat]], events: [String: [String: String]], shotPositions: [String: [String: String]]) {
        self.players = players
        self.name = name
        self.boats = boats
        self.events = events
        self.shotPositions = shotPositions
        super.init(id: id)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.typelessDecode(forKey: .name)
        self.players = container.optionalDefaultDecode(forKey: .players, defaultValue: [:])
        self.boats = container.optionalDefaultDecode(forKey: .boats, defaultValue: [:])
        self.events = container.optionalDefaultDecode(forKey: .events, defaultValue: [:])
        self.shotPositions = container.optionalDefaultDecode(forKey: .shotPositions, defaultValue: [:])
        
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.players, forKey: .players)
        try container.encode(self.boats, forKey: .boats)
        try container.encode(self.events, forKey: .events)
        try container.encode(self.shotPositions, forKey: .shotPositions)
        
        try super.encode(to: encoder)
    }
}
