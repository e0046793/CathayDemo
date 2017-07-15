//
//  Genre.swift
//  CathayDemo
//
//  Created by Kyle Truong on 14/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation

fileprivate struct Key {
    static let Id = "id"
    static let Name = "name"
}


class Genre: Deserializable {
    
    private(set) var id: String?
    private(set) var name: String?
    
    required init(dictionary: [String : AnyObject]) {
        
        do {
            try id = String.convert(json: dictionary[Key.Id])
            try name = String.convert(json: dictionary[Key.Name])
        } catch let error as NSError {
            print("Parsing error \(error)")
        }
    }
}
