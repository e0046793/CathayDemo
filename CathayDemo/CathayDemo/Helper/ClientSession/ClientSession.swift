//
//  ClientSession.swift
//  CathayDemo
//
//  Created by Kyle Truong on 13/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation
import UIKit

/// Takes care of the session operations and operates on managers
class ClientSession {
    
    /**
     Call this method before using this class. This client session to manage all managers and to take care all of operations within a user's session
     
     */
    public static func initialize() {
        
        if sharedInstance != nil {
            assertionFailure()
        }
        
        sharedInstance = ClientSession()
    }
    
    public static fileprivate(set) var sharedInstance: ClientSession!
    
    public let tmdbManager: TMDBManager
    public var imageManager: ImageManager
    
    private init() {
        
        // TMDB Manager
        let tmdbApiService = APIService(memoryCache: MemoryCache(cacheSize: 100 * 1024 * 1024))
        let tmdbAPIConfiguration = TMDBAPIConfiguration(apiKey: Configuration.sharedInstance.TMDBAPIKey ?? "")
        tmdbManager = TMDBManager(apiService: tmdbApiService, TMDBAPIConfiguration: tmdbAPIConfiguration)
        
        // Image Manager
        let apiService = APIService()
        let imageCacheConfiguration = ImageCacheConfiguration(storage: .memory, cacheSize: 100 * 1024 * 1024)
        imageManager = ImageManager(apiService: apiService, cacheConfiguration: imageCacheConfiguration)
    }
}
