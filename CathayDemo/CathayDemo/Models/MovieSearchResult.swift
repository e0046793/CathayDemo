//
//  MovieSearchResult.swift
//  CathayDemo
//
//  Created by Kyle Truong on 12/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation

fileprivate struct Key {
    static let Page = "page"
    static let Total_Results = "total_results"
    static let Total_Pages = "total_pages"
    static let Results = "results"
}

class MovieSearchResult: Deserializable {
    
    private(set) var page: Int?
    private(set) var totalResults: Int?
    private(set) var totalPages: Int?
    private(set) var results: [Movie]?
    
    required init(dictionary: [String : AnyObject]) {
        
        do {
            try page = Int.convert(json: dictionary[Key.Page])
            try totalResults = Int.convert(json: dictionary[Key.Total_Results])
            try totalPages = Int.convert(json: dictionary[Key.Total_Pages])
            if let movieJSONarray = dictionary[Key.Results] as? [AnyObject] {
                try Deserialization.parse(array: &results, jsonArray: movieJSONarray)
            }
        } catch let error as NSError {
            print("Parsing error \(error)")
        }
    }
}
