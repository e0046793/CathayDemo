//
//  Configuration.swift
//  CathayDemo
//
//  Created by Kyle Truong on 12/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation

private struct Constants {
    static let ConfigurationFileName = "Configuration"
    static let ConfigurationFileExtension = "plist"
    
    struct TMDBKey {
        static let APIKey           = "TMDBAPIKey"
    }
}

class Configuration {
    
    static let sharedInstance = Configuration()
    
    private(set) var TMDBAPIKey: String?
    
    private init() {
        loadConfiguration()
    }
    
    private func loadConfiguration() {
        if let path = Bundle.main.path(forResource: Constants.ConfigurationFileName, ofType: Constants.ConfigurationFileExtension), let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            TMDBAPIKey = dict[Constants.TMDBKey.APIKey] as? String
        } else {
            assertionFailure()
        }
    }
    
    // MARK: - Public method
    public func checkConfigurationFullySetup() -> Bool {
        
        if let apiKey = TMDBAPIKey {
            return !apiKey.isEmpty
        } else {
            return false
        }
    }
}
