//
//  Int+JSON.swift
//  CathayDemo
//
//  Created by Kyle Truong on 12/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation

extension Int: Convertible {
    
    public static func convert(json: AnyObject?) throws -> Int? {
        guard let json = json else {
            return nil
        }
        
        if let intValue = json as? Int {
            return intValue
        } else if let stringValue = json as? String {
            return Int(stringValue)
        } else if let doubleValue = json as? Double {
            return Int(doubleValue)
        } else if let floatValue = json as? Float {
            return Int(floatValue)
        }
        
        throw ConversionError.unsupportedType
    }
}
