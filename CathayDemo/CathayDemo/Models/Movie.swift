//
//  Movie.swift
//  CathayDemo
//
//  Created by Kyle Truong on 12/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation

fileprivate struct Key {
    static let Id = "id"
    static let Title = "title"
    static let Popularity = "popularity"
    static let Backdrop_Path = "backdrop_path"
    static let Poster_Path = "poster_path"
    static let Overview = "overview"
}


class Movie: Deserializable {
    
    private(set) var id: String?
    private(set) var title: String?
    private(set) var popularity: Double?
    private(set) var backdropPath: String?
    private(set) var posterPath: String?
    private(set) var synopsis: String?
    
    required init(dictionary: [String : AnyObject]) {
        
        do {
            try id = String.convert(json: dictionary[Key.Id])
            try title = String.convert(json: dictionary[Key.Title])
            try popularity = Double.convert(json: dictionary[Key.Popularity])
            try backdropPath = String.convert(json: dictionary[Key.Backdrop_Path])
            try posterPath = String.convert(json: dictionary[Key.Poster_Path])
            try synopsis = String.convert(json: dictionary[Key.Overview])
        } catch let error as NSError {
            print("Parsing error \(error)")
        }
    }
}
