//
//  Dictionary+Ext.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/19/24.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    func decode<T: Decodable>(to type: T.Type) -> T? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            print("Failed to serialize dictionary to data")
            return nil
        }
        
        let decoder = JSONDecoder()
        do {
            let decodedObject = try decoder.decode(T.self, from: data)
            return decodedObject
        } catch {
            print("Failed to decode dictionary: \(error)")
            return nil
        }
    }
}
