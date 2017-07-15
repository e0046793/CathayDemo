//
//  APIMethod.swift
//  CathayDemo
//
//  Created by Kyle Truong on 12/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation

enum APIMethod {
    case get
    case post
    
    var methodString: String {
        switch self {
        case .get:  return "GET"
        case .post: return "POST"
        }
    }
}

public enum APIEncoding: String {
    case url = "application/x-www-form-urlencoded; charset=UTF-8"
    case json = "application/json"
}

