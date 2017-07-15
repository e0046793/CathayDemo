//
//  HomeViewHandler.swift
//  CathayDemo
//
//  Created by Kyle Truong on 13/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation

protocol MovieSearchDataHandlerUpdatable: class {
    func updateDidFinish()
    func updateWithMovieList(_ movies: [Movie]?)
}

class MovieSearchDataHandler {
    
    static let DefaultStartPage = 1
    
    fileprivate weak var movieSearchDataHandlerUpdatable: MovieSearchDataHandlerUpdatable?
    
    fileprivate var currentMovieSearchResult: MovieSearchResult?
    
    public var isLoading: Bool = false
    
    init(movieSearchDataHandlerUpdatable: MovieSearchDataHandlerUpdatable?) {
        self.movieSearchDataHandlerUpdatable = movieSearchDataHandlerUpdatable
    }
}

// MARK: - Public methods
extension MovieSearchDataHandler {
    
    /// Perform search movies
    public func startFetchingMovies() {
        reset()
        searchMovie(page: MovieSearchDataHandler.DefaultStartPage)
    }
    
    public func loadNextPageIfNeeded() {
        guard !isLoading else {
            return
        }
        
        if let currentMovieSearchResult = currentMovieSearchResult {
            if let page = currentMovieSearchResult.page, let totalPages = currentMovieSearchResult.totalPages {
                if page < totalPages {
                    searchMovie(page: page + 1)
                }
            }
        }
    }
}

// MARK: - Private methods
extension MovieSearchDataHandler {
    
    fileprivate func reset() {
        currentMovieSearchResult = nil
        isLoading = false
    }
    
    /**
     Start searching movies.
     - parameter page: particular page to search
     */
    fileprivate func searchMovie(page: Int) {
        
        isLoading = true
        
        ClientSession.sharedInstance.tmdbManager.fetchMovies(page: page) { (movieSearchResult, error) in
            self.isLoading = false
            self.currentMovieSearchResult = movieSearchResult
            self.movieSearchDataHandlerUpdatable?.updateWithMovieList(movieSearchResult?.results)
        }
    }
}
