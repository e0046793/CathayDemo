//
//  MemoryCache.swift
//  CathayDemo
//
//  Created by Kyle Truong on 12/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation
import UIKit

class MemoryCache: CacheProtocol {
    
    fileprivate let cache = NSCache<AnyObject, AnyObject>()
    
    init(cacheSize: Int = 0) {
        cache.countLimit = cacheSize
    }
}

// MARK: CacheProtocol
extension MemoryCache {
    
    func write(object: AnyObject, path: String) {
        
        cache.setObject(object, forKey: path as AnyObject)
    }
    
    public func read(path: String) -> AnyObject? {
        
        return cache.object(forKey: path as AnyObject)
    }
    
    public func delete(path: String) {
        cache.removeObject(forKey: path as AnyObject)
    }
    
    public func clearCache() {
        cache.removeAllObjects()
    }
    
    public func clearExpiredCache() {
        clearCache()
    }
}

