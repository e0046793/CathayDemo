//
//  ImageMangerMock.swift
//  CathayDemo
//
//  Created by Nhan Truong on 15/07/2017.
//  Copyright © 2017 Nhan Truong. All rights reserved.
//

import XCTest
@testable import CathayDemo

class ImageMangerMock: ImageManager {
    
    override func downloadImage(urlString: String, completion: ImageResponseBlock?) {
        
        let image =  UIImage(named: "imagePlaceHolder")
        
        completion?(image)
    }
}
