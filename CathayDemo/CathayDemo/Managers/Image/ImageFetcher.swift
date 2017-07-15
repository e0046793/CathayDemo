//
//  ImageFetcher.swift
//  CathayDemo
//
//  Created by Kyle Truong on 14/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation
import UIKit

protocol ImageFetcherUpdatable: class {
    func updateWithFetchedImage(_ image: UIImage?, url: String?)
}

class ImageFetcher {
    
    fileprivate var imageURLString: String?
    fileprivate var placeHolderImage: UIImage?
    fileprivate weak var imageUpdatable: ImageFetcherUpdatable?
    
    public init(placeHolderImage: UIImage? = nil, imageUpdatable: ImageFetcherUpdatable) {
        self.imageUpdatable = imageUpdatable
        self.placeHolderImage = placeHolderImage
    }
    
    public func fetchImage(_ imageURLString: String) {
        
        guard imageURLString != self.imageURLString else { return }
        
        self.imageURLString = imageURLString
        
        ClientSession.sharedInstance.imageManager.downloadImage(urlString: imageURLString) { [weak self] (image) in
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                strongSelf.imageUpdatable?.updateWithFetchedImage(image, url: imageURLString)
            }
        }
    }
    
    public func reset() {
        imageURLString = nil
        imageUpdatable?.updateWithFetchedImage(placeHolderImage, url: imageURLString)
    }
}

