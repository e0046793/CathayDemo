//
//  TMDBManager.swift
//  CathayDemo
//
//  Created by Kyle Truong on 12/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation

typealias SearchMovieCompletionBlock
    = (_ movieSearchResult: MovieSearchResult?, _ error: Error?) -> ()

typealias ParserServerErrorCompletionBlock
    = (_ jsonObject: AnyObject?, _ error: Error?) -> ()

typealias MovieInfoCompletionBlock
    = (_ photoInfo: MovieDetail?, _ error: Error?) -> ()


// MARK: TMDBAPIConfiguration
struct TMDBAPIConfiguration {
    let apiKey: String
}

// MARK: Param Key
fileprivate struct Key {
    
    struct Params {
        static let APIKey                       = "api_key"
        static let SortBy                       = "sort_by"
        static let Page                         = "page"
        static let PrimaryReleaseDateLessThan   = "primary_release_date.lte"
    }
    
    struct ParamDefaultValues {
        static let SortByValue                      = "popularity.desc"
        static let PrimaryReleaseDateLessThanValue  = "2016-12-31"
    }
    
    struct PhotoSource {
        static let Size             = "{size}"
        static let BackdropPath     = "{poster_path}"
    }
}

// MARK: Server Constants
fileprivate struct ServerConstants {
    
    struct Key {
        static let StatusCode       = "status_code"
        static let StatusMessage    = "status_message"
        static let Success          = "success"
        static let Results          = "results"
    }
}

// MARK: TMDB API Method
fileprivate struct TMDBURL {
    static let Base         = "https://api.themoviedb.org/3"
    static let PhotoSource  = "https://image.tmdb.org/t/p/{size}{poster_path}"
    static let Discover     = "/discover"
    static let Movie        = "/movie"
}

/// TMDB Manager to mange operations related to TMDB API
class TMDBManager: Manager {
    
    fileprivate let apiService: APIServiceProtocol
    fileprivate let TMDBAPIConfiguration: TMDBAPIConfiguration
    
    init(apiService: APIServiceProtocol, TMDBAPIConfiguration: TMDBAPIConfiguration) {
        self.apiService = apiService
        self.TMDBAPIConfiguration = TMDBAPIConfiguration
    }
}

extension TMDBManager {
    
    public func fetchMovies(page: Int, completion: SearchMovieCompletionBlock?) {
        
        let params: [String: String] = [
            Key.Params.APIKey: TMDBAPIConfiguration.apiKey,
            Key.Params.Page: String(page),
            Key.Params.SortBy: Key.ParamDefaultValues.SortByValue,
//            Key.Params.PrimaryReleaseDateLessThan: Key.ParamDefaultValues.PrimaryReleaseDateLessThanValue
        ]
        
        apiService.request(.get,
                           urlString: TMDBURL.Base + TMDBURL.Discover + TMDBURL.Movie,
                           params: params,
                           headers: nil,
                           encoding: .json) { (apiResponse) in
            self.parseServerError(response: apiResponse, completion: { (jsonObject, error) in
                
                if let error = error {
                    DispatchQueue.main.async {
                        completion?(nil, error)
                    }
                
                } else {
                    if let jsonObject = jsonObject {
                        
                        do {
                            var movieSearchResult: MovieSearchResult?
                            try Deserialization.parse(instance: &movieSearchResult, jsonObject: jsonObject)
                            
                            DispatchQueue.main.async {
                                completion?(movieSearchResult, error)
                            }
                        } catch let error {
                            assertionFailure()
                            DispatchQueue.main.async {
                                completion?(nil, error)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion?(nil, error)
                        }
                    }
                }
            })
        }
    }
    
    public func fetchMovieDetail(_ movieId: String, completion: MovieInfoCompletionBlock?) {
        
        
        let params: [String: String] = [
            Key.Params.APIKey: TMDBAPIConfiguration.apiKey
        ]
        
        apiService.request(.get, urlString: TMDBURL.Base + TMDBURL.Movie + "/\(movieId)", params: params, headers: nil, encoding: .json) { (apiResponse) in
            self.parseServerError(response: apiResponse, completion: { (jsonObject, error) in
                
                if let error = error {
                    DispatchQueue.main.async {
                        completion?(nil, error)
                    }
                    
                } else {
                    if let jsonObject = jsonObject {
                        
                        do {
                            var movieDetail: MovieDetail?
                            try Deserialization.parse(instance: &movieDetail, jsonObject: jsonObject)
                            
                            DispatchQueue.main.async {
                                completion?(movieDetail, error)
                            }
                        } catch let error {
                            assertionFailure()
                            DispatchQueue.main.async {
                                completion?(nil, error)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion?(nil, error)
                        }
                    }
                }
            })
        }
    }
    
    public func photoURLString(_ imageSize: ServerImageSize, photoURL: String) -> String {
        
        let photoURLString = TMDBURL.PhotoSource
            .replacingOccurrences(of: Key.PhotoSource.Size, with: imageSize.value)
            .replacingOccurrences(of: Key.PhotoSource.BackdropPath, with: photoURL)
        
        return photoURLString
    }
}

extension TMDBManager {
    
    fileprivate func parseServerError(response: APIServiceDataResponse,
                                      completion: ParserServerErrorCompletionBlock) {
        if response.isFailure {
            completion(nil, response.error)
       
        } else {
            
            if let data = response.value {
                
                let jsonObject = Deserialization.dataToObject(data: data)
                
                if let jsonDictionary = jsonObject as? [String: AnyObject] {
                    completion(jsonDictionary as AnyObject, nil)
                } else {
                    assertionFailure()
                    completion(nil, response.error)
                }
            
            } else {
                assertionFailure()
                completion(nil, response.error)
            }
        }
    }
}
