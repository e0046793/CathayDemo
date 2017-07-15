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
    
    public struct Dependencies {
        
        public let window: UIWindow
        
        public init(window: UIWindow) {
            self.window = window
        }
    }
    
    /**
     Call this method before using this class. This client session to manage all managers and to take care all of operations within a user's session
     
     - parameter dependencies: All dependencies injected to the class
     
     */
    public static func initialize(with dependencies: Dependencies) {
        
        if sharedInstance != nil {
            assertionFailure()
        }
        
        sharedInstance = ClientSession(dependencies: dependencies)
    }
    
    public static fileprivate(set) var sharedInstance: ClientSession!
    
    public let tmdbManager: TMDBManager
    public var imageManager: ImageManager
    
    private init(dependencies: Dependencies) {
        
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
