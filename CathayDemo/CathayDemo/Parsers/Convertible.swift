//
//  ConversionError.swift
//  CathayDemo
//
//  Created by Kyle Truong on 12/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation

public enum ConversionError: Error {
    case unsupportedType
}

public protocol Convertible {
    static func convert(json: AnyObject?) throws -> Self?
}
