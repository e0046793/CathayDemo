//
//  CacheProtocol.swift
//  CathayDemo
//
//  Created by Kyle Truong on 12/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation

protocol CacheProtocol {
    
    func write(object: AnyObject, path: String)
    func read(path: String) -> AnyObject?
    func delete(path: String)
    
    func clearCache()
    func clearExpiredCache()
}
