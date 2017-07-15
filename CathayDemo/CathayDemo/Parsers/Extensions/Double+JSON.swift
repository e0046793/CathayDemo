//
//  Double+JSON.swift
//  CathayDemo
//
//  Created by Kyle Truong on 12/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation

extension Double: Convertible {
    
    public static func convert(json: AnyObject?) throws -> Double? {
        guard let json = json else {
            return nil
        }
        
        if let doubleValue = json as? Double {
            return doubleValue
        } else if let stringValue = json as? String {
            return Double(stringValue)
        } else if let intValue = json as? Int {
            return Double(intValue)
        } else if let floatValue = json as? Float {
            return Double(floatValue)
        }
        
        throw ConversionError.unsupportedType
    }
}
