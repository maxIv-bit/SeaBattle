//
//  Entity.swift
//  SeaBattle
//
//  Created by Maks on 30.11.2020.
//

import Foundation

class Entity: NSObject, Codable {
    private enum CodingKeys: String, CodingKey {
        case id
    }
    
    var id = String()
    
    init(id: String) {
        self.id = id

        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let intId: Int? = container.optionalDecode(forKey: .id)
        let stringId: String? = container.optionalDecode(forKey: .id)
        self.id = stringId == nil ? String(intId ?? 0) : stringId!
    }
    
    override var hash: Int {
        id.hashValue
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        id == (object as? Entity)?.id
    }
}

extension Entity {
    func asDictionary<T>() throws -> T {
        let data = try JSONEncoder().encode(self)
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            guard let dictionary = json as? T else {
                throw StringError(message: "Unable to encode to dictinary")
            }
            
            return dictionary
        } catch {
            throw error
        }
    }
}
