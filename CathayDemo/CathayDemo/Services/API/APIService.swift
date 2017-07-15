//
//  APIService.swift
//  CathayDemo
//
//  Created by Kyle Truong on 12/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation

let BAD_URL_REQUEST = "Bad URL Request"
let BAD_URL = "Bad URL"

let RESPONSE_DATA_EMPTY = "Response data is empty"

typealias APIServiceParams = [String: String]
typealias APIServiceHeaders = [String: String]

typealias APIServiceDataResponse = APIServiceResponse<Data>

typealias APIServiceResponseBlock = (APIServiceDataResponse) -> ()

struct APIServiceConstants {
    static let defaultTimeoutInterval: TimeInterval = 90
}

class APIService: APIServiceProtocol {
    
    fileprivate var responseMemoryCache: CacheProtocol?
    
    init(memoryCache: CacheProtocol? = nil) {
        if let memoryCache = memoryCache {
            responseMemoryCache = memoryCache
        }
    }
}

// MARK: APIServiceProtocol
extension APIService {
    
    func request(_ method: APIMethod,
                 urlString: String,
                 params: APIServiceParams?,
                 headers: APIServiceHeaders?,
                 encoding: APIEncoding,
                 completion: APIServiceResponseBlock?) {
        
        var queryParams: [String: String]?
        var bodyParams: [String: String]?
        
        switch method {
        case .get:
            queryParams = params
        case .post:
            bodyParams = params
        }
        
        if let url = URL(string: urlString) {
            
            let request = URLRequest.request(url,
                                             method: method.methodString,
                                             queryParams: queryParams,
                                             bodyParams: bodyParams,
                                             headers: headers)
            
            if let request = request {
                
                // Check from Cache first
                if let url = request.url?.absoluteString {
                    let data = checkAndLoadFromCacheIfNeeded(url: url)
                    if let data = data {
                        let response = APIServiceResponse.success(data)
                        completion?(response)
                        
                        return
                    }
                }
                
                // Send request
                let task = URLSession.apiServiceSharedURLSession.dataTask(with: request, completionHandler: {
                    (data, response, error) in
                    self.handleResponse(data: data, response: response, error: error, completion: completion)
                })
                task.resume()
            } else {
                assertionFailure()
                let response = APIServiceDataResponse.failure(APIServiceError.generic(BAD_URL_REQUEST))
                completion?(response)
            }
        } else {
            assertionFailure()
            let response = APIServiceDataResponse.failure(APIServiceError.generic(BAD_URL))
            completion?(response)
        }
    }
    
    private func checkAndLoadFromCacheIfNeeded(url: String) -> Data? {
        if let memoryCache = responseMemoryCache {
            return memoryCache.read(path: url) as? Data
        } else {
            return nil
        }
    }
    
    private func handleResponse(data: Data?, response: URLResponse?, error: Error?, completion: APIServiceResponseBlock?) {
        
        let apiResponse: APIServiceDataResponse
        
        if let error = error, (error as NSError).domain == NSURLErrorDomain {
            apiResponse = APIServiceDataResponse.failure(APIServiceError.networkError(error))
        } else if let error = error {
            apiResponse = APIServiceDataResponse.failure(APIServiceError.unknownError(error))
        } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            let msg = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
            let error = APIServiceError.httpStatus(status: httpResponse.statusCode, msg: msg)
            apiResponse = APIServiceDataResponse.failure(error)
        } else if let data = data, data.count > 0 {
            apiResponse = APIServiceDataResponse.success(data)
            
            // Cache to memory
            if let url = response?.url?.absoluteString {
                if let memoryCache = responseMemoryCache {
                    memoryCache.write(object: data as AnyObject, path: url)
                }
            }
        } else {
            apiResponse = APIServiceDataResponse.failure(APIServiceError.invalidResponse(RESPONSE_DATA_EMPTY))
        }
        
        completion?(apiResponse)
    }
}

// MARK: URLRequest
extension URLRequest {
    
    static func request(_ url: URL,
                        method: String,
                        queryParams: [String: String]?,
                        bodyParams: [String: String]?,
                        headers: [String: String]?) -> URLRequest? {
        
        let actualURL: URL?
        
        if let queryParams = queryParams {
            
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            
            components?.queryItems = queryParams.map({ (key, value) -> URLQueryItem in
                return URLQueryItem(name: key, value: value)
            })
            
            actualURL = components?.url
        } else {
            actualURL = url
        }
        
        if let actualURL = actualURL {
            var request = URLRequest(url: actualURL)
            request.httpMethod = method
            
            if let bodyParams = bodyParams {
                do {
                    try request.httpBody = JSONSerialization.data(withJSONObject: bodyParams, options: JSONSerialization.WritingOptions(rawValue: 0))
                } catch {
                    assertionFailure()
                }
            }
            
            if let headers = headers {
                for (field, value) in headers {
                    request.addValue(value, forHTTPHeaderField: field)
                }
            }
            
            return request
        }
        
        return nil
    }
}

// MARK: URLSession
extension URLSession {
    
    class var apiServiceSharedURLSession: URLSession {
        
        // The session is stored in a nested struct because
        // you can't do a 'static let' singleton in a
        // class extension.
        struct Instance {
            // The singleton URL session, configured
            // to use our custom config and delegate.
            static let session = URLSession(configuration: URLSessionConfiguration.apiServiceDefaultSessionConfiguration())
        }
        
        return Instance.session
    }
}

// MARK: URLSessionConfiguration
extension URLSessionConfiguration {
    
    class func apiServiceDefaultSessionConfiguration() -> URLSessionConfiguration {
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = APIServiceConstants.defaultTimeoutInterval
        
        return config
    }
}

