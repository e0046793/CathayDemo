//
//  Language.swift
//  CathayDemo
//
//  Created by Kyle Truong on 14/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation

fileprivate struct Key {
    static let Iso_639_1 = "iso_639_1"
    static let Name = "name"
}


class Language: Deserializable {
    
    private(set) var id: String?
    private(set) var name: String?
    
    required init(dictionary: [String : AnyObject]) {
        
        do {
            try id = String.convert(json: dictionary[Key.Iso_639_1])
            try name = String.convert(json: dictionary[Key.Name])
        } catch let error as NSError {
            print("Parsing error \(error)")
        }
    }
}
