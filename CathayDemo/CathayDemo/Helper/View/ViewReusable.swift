//
//  ViewUsable.swift
//  CathayDemo
//
//  Created by Kyle Truong on 13/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation

protocol ViewReusable {
    
}

extension ViewReusable {
    
    public static var reusableID: String {
        return String(describing: self)
    }
    
    public static var nibName: String {
        return String(describing: self)
    }
}

