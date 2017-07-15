//
//  ImageManager.swift
//  CathayDemo
//
//  Created by Kyle Truong on 14/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation
import UIKit

typealias ImageResponseBlock = (UIImage?) -> ()

enum ImageManagerCacheStorage {
    case memory
}

struct ImageCacheConfiguration {
    let storage: ImageManagerCacheStorage
    let cacheSize: Int?
}

/// Image Manager takes care of image operations including downloading, caching images
class ImageManager: Manager {
    
    fileprivate let apiService: APIServiceProtocol
    fileprivate let cacheConfiguration: ImageCacheConfiguration
    fileprivate var imageMemoryCache: CacheProtocol
    
    init(apiService: APIServiceProtocol, cacheConfiguration: ImageCacheConfiguration) {
        
        self.apiService = apiService
        self.cacheConfiguration = cacheConfiguration
        
        switch cacheConfiguration.storage {
        case .memory:
            if let cacheSize = cacheConfiguration.cacheSize {
                imageMemoryCache = MemoryCache(cacheSize: cacheSize)
            } else {
                imageMemoryCache = MemoryCache()
            }
        }
    }
}

extension ImageManager {
    
    func fetchImageFromCache(urlString: String) -> UIImage? {
        switch cacheConfiguration.storage {
        case .memory:
            return imageMemoryCache.read(path: urlString) as? UIImage
        }
    }
    
    func downloadImage(urlString: String, completion: ImageResponseBlock?) {
        
        let image = fetchImageFromCache(urlString: urlString)
        
        if let image = image {
            completion?(image)
            return
        }
        
        apiService.request(.get, urlString: urlString, params: nil, headers: nil, encoding: .json) { (dataResponse) in
            if dataResponse.isFailure {
                completion?(nil)
            } else if let data = dataResponse.value {
                let image = UIImage.imageFromData(data)
                if let image = image {
                    self.cacheImage(image: image, urlString: urlString)
                }
                
                DispatchQueue.main.async {
                    completion?(image)
                }
            } else {
                assertionFailure()
                DispatchQueue.main.async {
                    completion?(nil)
                }
            }
        }
    }
    
    private func cacheImage(image: UIImage, urlString: String) {
        switch cacheConfiguration.storage {
        case .memory:
            imageMemoryCache.write(object: image, path: urlString)
        }
    }
}

