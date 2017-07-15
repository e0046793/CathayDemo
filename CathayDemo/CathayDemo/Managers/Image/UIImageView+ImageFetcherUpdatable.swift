//
//  UIImageView+ImageFetcherUpdatable.swift
//  CathayDemo
//
//  Created by Kyle Truong on 14/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView: ImageFetcherUpdatable {
    
    public func updateWithFetchedImage(_ image: UIImage?, url: String?) {
        self.image = image
    }
}
