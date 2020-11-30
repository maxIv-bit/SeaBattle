//
//  KeyDecodingContainerExtension.swift
//  SeaBattle
//
//  Created by Maks on 30.11.2020.
//

import Foundation

extension KeyedDecodingContainer {
    public func typelessDecode<T: Decodable>(forKey key: KeyedDecodingContainer<K>.Key) throws -> T {
        return try self.decode(T.self, forKey: key)
    }
    
    public func optionalDecode<T: Decodable>(forKey key: KeyedDecodingContainer<K>.Key) -> T? {
        return try? self.decodeIfPresent(T.self, forKey: key)
    }
    
    public func optionalDefaultDecode<T: Decodable>(forKey key: KeyedDecodingContainer<K>.Key, defaultValue: T) -> T {
        return (try? self.decodeIfPresent(T.self, forKey: key)) ?? defaultValue
    }
}
