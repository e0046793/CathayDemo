//
//  DetailViewController.swift
//  CathayDemo
//
//  Created by Kyle Truong on 12/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

// MARK: - Life cycle methods
class DetailViewController: UIViewController {
    
    @IBOutlet weak var genreTitleLbel: UILabel!
    @IBOutlet weak var languageTitleLbl: UILabel!
    @IBOutlet weak var genresLbl: UILabel!
    @IBOutlet weak var languagesLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var synopsisLbl: UILabel!
    @IBOutlet weak var backdropImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var backgroundNavi: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var selectedMovie: Movie?
    
    fileprivate var movieDetail: MovieDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        if let movie = selectedMovie {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            ClientSession.sharedInstance.tmdbManager.fetchMovieDetail(movie.id!, completion: { (movieDetail, error) in
                self.movieDetail = movieDetail
                self.spinner.stopAnimating()
                self.loadData()
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let photoURL = selectedMovie!.backdropPath {
            let photoURLString = ClientSession.sharedInstance.tmdbManager.photoURLString(.large, photoURL: photoURL)
            ClientSession.sharedInstance.imageManager.downloadImage(urlString: photoURLString, completion: { (image) in
                self.backdropImgView.image = image
            })
        }
    }
    
    @IBAction func didTouchBookTicket(_ sender: Any) {
        
        let webVC = SFSafariViewController(url: URL(string: Constant.BOOK_TICKET_URL)!)
        present(webVC, animated: true, completion: nil)
        
    }
}

extension DetailViewController {
    
    fileprivate func setupView() {
        // Navigation
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = UIColor.white
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: backgroundNavi.bounds.height)
        gradient.colors = [UIColor.black.cgColor, UIColor.white.cgColor]
        backgroundNavi.layer.addSublayer(gradient)
        
        // Spinner
        spinner.startAnimating()
        
        // Title
        self.titleLbl.text = selectedMovie!.title
        
        // Synopsis
        self.synopsisLbl.text = selectedMovie!.synopsis
    }
    
    fileprivate func loadData() {
        MBProgressHUD.hide(for: self.view, animated: true)
        
        if let duration = self.movieDetail?.duration {
            durationLbl.text = String(format:"%d", duration) +  " minutes"
        }
        
        if let languages = self.movieDetail?.languages {
            if (0 == languages.count) {
                languageTitleLbl.isHidden = true
            }
            let languageArray = languages.map({ (language : Language) -> String in
                language.name!
            })
            self.languagesLbl.text = languageArray.joined(separator: ", ")
        } 
        
        if let genres = self.movieDetail?.genres {
            if (0 == genres.count) {
                genreTitleLbel.isHidden = true
            }
            let genresArray = genres.map({ (genre : Genre) -> String in
                genre.name!
            })
            self.genresLbl.text = genresArray.joined(separator: ", ")
        }
    }
}
