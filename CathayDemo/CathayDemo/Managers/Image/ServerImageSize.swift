//
//  ServerImageSize.swift
//  CathayDemo
//
//  Created by Kyle Truong on 13/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation

enum ServerImageSize {
    case small
    case medium
    case large
    case original
    
    var directory: String {
        switch self {
        case .small:        return "small"
        case .medium:       return "medium"
        case .large:        return "large"
        case .original:     return "original"
        }
    }
    
    var cacheKey: String {
        switch self {
        case .small:        return "small"
        case .medium:       return "medium"
        case .large:        return "large"
        case .original:     return "original"
        }
    }
    
    var value: String {
        switch self {
        case .small:        return "w300"
        case .medium:       return "w780"
        case .large:        return "w1280"
        case .original:     return "original"
        }
    }
}
