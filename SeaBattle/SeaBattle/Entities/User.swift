//
//  User.swift
//  SeaBattle
//
//  Created by Maks on 21.11.2020.
//

import Foundation
import Firebase

final class User: Entity {
    private enum CodingKeys: String, CodingKey {
        case email
    }
    
    var email: String
    
    init(authData: Firebase.User) {
        email = authData.email ?? ""
        super.init(id: authData.uid)
    }
    
    init(id: String, email: String) {
        self.email = email
        super.init(id: id)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.email = try container.typelessDecode(forKey: .email)
        
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.email, forKey: .email)
        
        try super.encode(to: encoder)
    }
}
