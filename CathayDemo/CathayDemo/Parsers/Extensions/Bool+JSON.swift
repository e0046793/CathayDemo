//
//  Bool+JSON.swift
//  CathayDemo
//
//  Created by Kyle Truong on 12/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation

extension Bool: Convertible {
    
    public static func convert(json: AnyObject?) throws -> Bool? {
        guard let json = json else {
            return nil
        }
        
        if let boolValue = json as? Bool {
            return boolValue
        } else if let intValue = json as? Int {
            return intValue > 0
        }
        
        throw ConversionError.unsupportedType
    }
}

