//
//  BoatPosition.swift
//  SeaBattle
//
//  Created by Maks on 30.11.2020.
//

import Foundation

final class BoatPosition: Entity {
    private enum CodingKeys: String, CodingKey {
        case boatId = "boat_id",
        x,
        y,
        isHurt = "is_hurt"
    }
    
    var boatId: String
    var x: Int
    var y: Int
    var isHurt: Bool
    
    init(id: String, boatId: String, x: Int, y: Int, isHurt: Bool) {
        self.x = x
        self.y = y
        self.isHurt = isHurt
        self.boatId = boatId
        
        super.init(id: id)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.x = try container.typelessDecode(forKey: .x)
        self.y = try container.typelessDecode(forKey: .y)
        self.isHurt = try container.typelessDecode(forKey: .isHurt)
        self.boatId = try container.typelessDecode(forKey: .boatId)
        
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.x, forKey: .x)
        try container.encode(self.y, forKey: .y)
        try container.encode(self.isHurt, forKey: .isHurt)
        try container.encode(self.boatId, forKey: .boatId)
        
        try super.encode(to: encoder)
    }
    
    override var description: String {
        "\(x)-\(y)"
    }
}
