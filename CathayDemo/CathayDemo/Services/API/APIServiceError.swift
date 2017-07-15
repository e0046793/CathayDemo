//
//  APIServiceError.swift
//  CathayDemo
//
//  Created by Kyle Truong on 12/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation

public enum APIServiceError: Error {
    case invalidResponse(String)
    case httpStatus(status: Int, msg: String)
    case networkError(Error)
    case serverError(domain: String, status: Int?, msg: String?)
    case unknownError(Error)
    case unknown(String)
    case generic(String)
}
