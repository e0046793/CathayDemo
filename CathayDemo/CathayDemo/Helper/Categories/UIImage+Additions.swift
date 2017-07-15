//
//  UIImage+Additions.swift
//  CathayDemo
//
//  Created by Kyle Truong on 14/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    static func imageFromData(_ data: Data) -> UIImage? {
        return UIImage(data: data)
    }
    
    static func dataFromImage(_ image: UIImage) -> Data? {
        return UIImagePNGRepresentation(image)
    }
}
