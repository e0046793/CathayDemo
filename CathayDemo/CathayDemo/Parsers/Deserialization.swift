//
//  Deserialization.swift
//  CathayDemo
//
//  Created by Kyle Truong on 12/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation


public enum DeserializationError: Error {
    case parsingError(reason: String)
}

protocol Parsable {
    static func parse<T: Deserializable>(instance: inout T?, jsonData: Data) throws
    static func parse<T: Deserializable>(instance: inout T?, jsonString: String) throws
    static func parse<T: Deserializable>(instance: inout T?, jsonObject: AnyObject) throws
    
    static func parse<T: Deserializable>(array: inout [T]?, jsonData: Data) throws
    static func parse<T: Deserializable>(array: inout [T]?, jsonString: String) throws
    static func parse<T: Deserializable>(array: inout [T]?, jsonArray: [AnyObject]) throws
}

public struct Deserialization {
    
    fileprivate static func convertToNilIfNull(jsonObject: AnyObject?) -> AnyObject? {
        return jsonObject is NSNull ? nil : jsonObject
    }
    
    fileprivate static func dataStringToObject(dataString: String) -> AnyObject? {
        guard let data: Data = dataString.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        return dataToObject(data: data)
    }
    
    static func dataToObject(data: Data) -> AnyObject? {
        var jsonObject: Any?
        do {
            jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))
        } catch {
            print("JSON serialization error")
        }
        
        return jsonObject as AnyObject?
    }
}

// MARK: - Parsable
extension Deserialization: Parsable {
    
    static func parse<T>(instance: inout T?, jsonData: Data) throws where T : Deserializable {
        if let convertedData = convertToNilIfNull(jsonObject: dataToObject(data: jsonData)) {
            if let jsonDictionary = convertedData as? [String : AnyObject] {
                instance = T(dictionary: jsonDictionary)
            }
        } else {
            throw DeserializationError.parsingError(reason: "Data convertion error")
        }
    }
    
    static func parse<T>(instance: inout T?, jsonString: String) throws where T : Deserializable {
        if let convertedData = convertToNilIfNull(jsonObject: dataStringToObject(dataString: jsonString)) as? Data {
            do {
                try Deserialization.parse(instance: &instance, jsonData: convertedData)
            } catch {
                throw DeserializationError.parsingError(reason: "Parsing object error")
            }
        } else {
            throw DeserializationError.parsingError(reason: "Data convertion error")
        }
    }
    
    static func parse<T>(instance: inout T?, jsonObject: AnyObject) throws where T : Deserializable {
        if let jsonDictionary = jsonObject as? [String : AnyObject] {
            instance = T(dictionary: jsonDictionary)
        } else {
            throw DeserializationError.parsingError(reason: "Data convertion error")
        }
    }
    
    static func parse<T>(array: inout [T]?, jsonArray: [AnyObject]) throws where T : Deserializable {
        array = [T]()
        for data in jsonArray {
            if let jsonDictionary = data as? [String : AnyObject] {
                let newValue: T? = T(dictionary: jsonDictionary)
                if let newValue = newValue {
                    array!.append(newValue)
                }
            }
        }
    }
    
    static func parse<T>(array: inout [T]?, jsonData: Data) throws where T : Deserializable {
        if let convertedData = convertToNilIfNull(jsonObject: dataToObject(data: jsonData)) {
            if let dataArray = convertedData as? [AnyObject] {
                do {
                    try Deserialization.parse(array: &array, jsonArray: dataArray)
                } catch {
                    throw DeserializationError.parsingError(reason: "Array parsing object error")
                }
            } else {
                throw DeserializationError.parsingError(reason: "Data convertion error")
            }
        } else {
            throw DeserializationError.parsingError(reason: "Data convertion error")
        }
    }
    
    static func parse<T>(array: inout [T]?, jsonString: String) throws where T : Deserializable {
        if let convertedData = convertToNilIfNull(jsonObject: dataStringToObject(dataString: jsonString)) as? Data {
            do {
                try Deserialization.parse(array: &array, jsonData: convertedData)
            } catch {
                throw DeserializationError.parsingError(reason: "Array parsing object error")
            }
        } else {
            throw DeserializationError.parsingError(reason: "Data convertion error")
        }
    }
}
