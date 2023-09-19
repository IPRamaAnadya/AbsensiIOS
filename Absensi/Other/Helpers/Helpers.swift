//
//  JsonToModel.swift
//  Absensi
//
//  Created by I putu Rama anadya on 19/09/23.
//

import Foundation


class Helpers {
    
    static let shared = Helpers()
    
    private init() {}
    
    func ParsingJsonToModel<T: Decodable>(_ type: T.Type, from json: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            let data = try decoder.decode(type, from: json)
            
            print("Success parsing Json to model")
            return data
        } catch {
            print("Failed parsing Json to model")
            return nil
        }
    }
    
}
