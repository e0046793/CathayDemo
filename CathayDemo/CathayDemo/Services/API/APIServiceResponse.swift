//
//  APIServiceResponse.swift
//  CathayDemo
//
//  Created by Kyle Truong on 12/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation

public enum APIServiceResponse<T> {
    
    case success(T)
    case failure(Error)
    
    public var isSuccess: Bool {
        switch self {
            case .success: return true
            case .failure: return false
        }
    }
    
    public var isFailure: Bool {
        return !isSuccess
    }
    
    public var value: T? {
        switch self {
            case .success(let value): return value
            case .failure: return nil
        }
    }
    
    public var error: Error? {
        switch self {
            case .success: return nil
            case .failure(let error): return error
        }
    }
}
