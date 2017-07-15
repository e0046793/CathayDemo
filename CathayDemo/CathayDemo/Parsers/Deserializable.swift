//
//  Deserializable.swift
//  CathayDemo
//
//  Created by Kyle Truong on 12/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation

public protocol Deserializable {
    init(dictionary: [String : AnyObject])
}
