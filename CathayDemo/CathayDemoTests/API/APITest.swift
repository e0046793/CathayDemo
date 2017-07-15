//
//  APITest.swift
//  CathayDemo
//
//  Created by Kyle Truong on 13/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import XCTest
import Foundation
@testable import CathayDemo

class APITest: XCTestCase {
    
    private var tmdbManager: TMDBManager!
    private var imageManager: ImageManager!
    
    override func setUp() {
        super.setUp()
        
        tmdbManager = TMDBManager(apiService: APIService(), TMDBAPIConfiguration: TMDBAPIConfiguration(apiKey: Configuration.sharedInstance.TMDBAPIKey ?? ""))
        
        imageManager = ImageManager(apiService: APIService(), cacheConfiguration: ImageCacheConfiguration(storage: .memory, cacheSize: 0))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        tmdbManager = nil
        imageManager = nil
    }
    
    func testSetupSuccess() {
        XCTAssertNotNil(tmdbManager, "TMDB Manager has been set up sucessfully")
        XCTAssertNotNil(imageManager, "Image Manager should not be nil")
    }
    
    func testSearchMovieWithValidParams() {
        
        let expectation = self.expectation(description: "Search Photo")
        
        tmdbManager.fetchMovies(page: 0) { (movieSearchResult, error) in
            
            if let _ = error {
                XCTAssertNil(movieSearchResult, "Error happened, the search result should be nil")
            } else {
                
                XCTAssertNotNil(movieSearchResult, "No error, so expect to have valid result")
                
                XCTAssertNotEqual(movieSearchResult?.results?.count, 0, "Photo list should have elements")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 90) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testFetchImageFromCacheFail() {
        
        let invalidKey = "invalid"
        let image = imageManager.fetchImageFromCache(urlString: invalidKey)
        
        XCTAssertNil(image, "Image is nil because the given key is valid")
    }
    
    func testDownloadImageFromInvalidURL() {
        
        let urlExpectation = expectation(description: "Fetch Image")
        
        let urlString = "123"
        imageManager.downloadImage(urlString: urlString) { (image) in
            
            XCTAssertNil(image, "Image is nil as the given url is invalid")
            
            urlExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 30) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testDownloadImageWithMockImangeManager() {
        
        let urlExpectation = expectation(description: "Fetch Image")
        
        let imageManagerMock = ImageMangerMock(apiService: APIService(), cacheConfiguration: ImageCacheConfiguration(storage: .memory, cacheSize: 0))
        
        imageManagerMock.downloadImage(urlString: "any") { (image) in
            
            XCTAssertNotNil(image, "Load image from mock manager should be sucess")
            
            urlExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 30) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
