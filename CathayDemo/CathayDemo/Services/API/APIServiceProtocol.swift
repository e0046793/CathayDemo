//
//  APIServiceProtocol.swift
//  CathayDemo
//
//  Created by Kyle Truong on 12/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation

protocol APIServiceProtocol {
    
    func request(_ method: APIMethod, urlString: String, params: APIServiceParams?, headers: APIServiceHeaders?, encoding: APIEncoding, completion: APIServiceResponseBlock?)
}
