//
//  MovieTableViewCell.swift
//  CathayDemo
//
//  Created by Kyle Truong on 13/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation
import UIKit

class MovieTableViewCell: TableViewReusableCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var popularityLbl: UILabel!
    @IBOutlet weak var backdropImgView: UIImageView!
    
    fileprivate var imageFetcher: ImageFetcher!
    fileprivate var photoURLString: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageFetcher = ImageFetcher(placeHolderImage: UIImage(named: "imagePlaceHolder"), imageUpdatable: self)
    }
    
    override func prepareForReuse() {
        photoURLString = nil
        imageFetcher.reset()
        backdropImgView.image = UIImage(named: "imagePlaceHolder")
    }
}

extension MovieTableViewCell {
    
    override func configure(_ item: Any?) {
        
        if let movie = item as? Movie {
            titleLbl.text = movie.title
            popularityLbl.text = "Popularity: " + String(format:"%.3f", movie.popularity!)
            
            if let photoURL = movie.backdropPath {
                
                let photoURLString = ClientSession.sharedInstance.tmdbManager.photoURLString(.small, photoURL: photoURL)
                self.photoURLString = photoURLString
                imageFetcher.fetchImage(photoURLString)
            }
        }
    }
}

extension MovieTableViewCell: ImageFetcherUpdatable {
    
    func updateWithFetchedImage(_ image: UIImage?, url: String?) {
        
        if photoURLString == url {
            backdropImgView.image = image
        }
    }
}
