//
//  Boat.swift
//  SeaBattle
//
//  Created by Maks on 30.11.2020.
//

import Foundation

final class Boat: Entity {
    private enum CodingKeys: String, CodingKey {
        case userId = "user_id",
        positions,
        length
    }
    
    private(set) var userId: String
    private(set) var positions = [String: BoatPosition]()
    private(set) var length: Int
    
    init(id: String, userId: String, positions: [String: BoatPosition], length: Int) {
        self.userId = userId
        self.positions = positions
        self.length = length
        super.init(id: id)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.userId = try container.typelessDecode(forKey: .userId)
        self.positions = container.optionalDefaultDecode(forKey: .positions, defaultValue: [:])
        self.length = try container.typelessDecode(forKey: .length)
        
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.positions, forKey: .positions)
        try container.encode(self.length, forKey: .length)
        
        try super.encode(to: encoder)
    }
}
