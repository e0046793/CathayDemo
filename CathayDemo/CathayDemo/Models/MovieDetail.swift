//
//  MovieDetail.swift
//  CathayDemo
//
//  Created by Kyle Truong on 14/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation

fileprivate struct Key {
    static let Id = "id"
    static let Original_Title = "original_title"
    static let Genres = "genres"
    static let Spoken_Language = "spoken_languages"
    static let Runtime = "runtime"
}

class MovieDetail: Deserializable {
    
    private(set) var id: String?
    private(set) var title: String?
    private(set) var genres: [Genre]?
    private(set) var languages: [Language]?
    private(set) var duration: Int?
    
    required init(dictionary: [String : AnyObject]) {
        
        do {
            try id = String.convert(json: dictionary[Key.Id])
            try title = String.convert(json: dictionary[Key.Original_Title])
            try duration = Int.convert(json: dictionary[Key.Runtime])
            if let genreJSONarray = dictionary[Key.Genres] as? [AnyObject] {
                try Deserialization.parse(array: &genres, jsonArray: genreJSONarray)
            }
            if let languageJSONarray = dictionary[Key.Spoken_Language] as? [AnyObject] {
                try Deserialization.parse(array: &languages, jsonArray: languageJSONarray)
            }
        } catch let error as NSError {
            print("Parsing error \(error)")
        }
    }
}

