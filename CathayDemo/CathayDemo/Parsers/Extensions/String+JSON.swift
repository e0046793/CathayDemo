//
//  String+JSON.swift
//  CathayDemo
//
//  Created by Kyle Truong on 12/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation

extension String: Convertible {
    
    public static func convert(json: AnyObject?) throws -> String? {
        guard let json = json else {
            return nil
        }
        
        if let stringValue = json as? String {
            return stringValue
        } else if let intValue = json as? Int {
            return "\(intValue)"
        } else if let _ = json as? NSNull {
            return nil
        }
        
        throw ConversionError.unsupportedType
    }
}
