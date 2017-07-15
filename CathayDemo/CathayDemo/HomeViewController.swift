//
//  ViewController.swift
//  CathayDemo
//
//  Created by Kyle Truong on 12/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    // MARK: IBOutlet variable declaration
    @IBOutlet weak var movieTblView: UITableView!
    
    // MARK: Constant declaration
    fileprivate let refreshControl = UIRefreshControl()
    fileprivate let CELL_IDENTIFIER = "MovieCell"
    
    // MARK: Variable declaration
    fileprivate var spinner: UIActivityIndicatorView!
    fileprivate var movieSearchDataHandler: MovieSearchDataHandler!
    fileprivate var tableViewDataSource: TableViewDataSource!
    fileprivate var hasPullRefresh = false
    fileprivate var selectedMovie: Movie?
    fileprivate var progressHUD: MBProgressHUD?

    // MARK: Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        movieSearchDataHandler = MovieSearchDataHandler(movieSearchDataHandlerUpdatable: self)
        
        // Start fetching movie
        movieSearchDataHandler.startFetchingMovies()
        progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // NOT a good place to check, however make it simple
        if !Configuration.sharedInstance.checkConfigurationFullySetup() {
            let alertController = UIAlertController(title: NSLocalizedString("Alert", comment: ""),
                                                    message: "Please config TMDB API Key and Secret in Configuration.plist",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (Constant.SEGUE_TO_MOVIE_DETAILS == segue.identifier!) {
            if let indexPath = movieTblView.indexPathForSelectedRow {
                let detailVC = segue.destination as! DetailViewController
                detailVC.selectedMovie = tableViewDataSource.itemAtIndexPath(indexPath) as? Movie
            }
        }
    }
}



// MARK: - MovieSearchDataHandlerUpdatable
extension HomeViewController: MovieSearchDataHandlerUpdatable {
    
    func updateWithMovieList(_ movies: [Movie]?) {
        DispatchQueue.main.async { [unowned self] in
            // Update UI
            if true == self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            
            self.progressHUD?.hide(animated: true)
            
            if false == self.hasPullRefresh {
                self.tableViewDataSource.insertNewItems(movies)
            } else {
                self.tableViewDataSource.resetWithNewItems(movies)
            }
        }
    }
    
    /// Fetching completed
    func updateDidFinish() {
    }
}

// MARK: - UIScrollViewDelegate
extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentSize.height < scrollView.frame.size.height {
            return
        }
        
        if (scrollView.contentOffset.y + view.frame.size.height > scrollView.contentSize.height * 0.8) {
            movieSearchDataHandler.loadNextPageIfNeeded()
            progressHUD?.show(animated: true)
        }
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie = tableViewDataSource.itemAtIndexPath(indexPath) as? Movie
    }
}

// MARK: - Utility methods
extension HomeViewController {
    
    fileprivate func setupViews() {
        // Initial table view datasource
        tableViewDataSource = TableViewDataSource(movieTblView,
                                                  cellIdentifier: MovieTableViewCell.reusableID)
        
        // Tableview
        movieTblView.addSubview(refreshControl);
        movieTblView.dataSource = tableViewDataSource
        movieTblView.delegate = self
        
        // Dynamic height for UITableViewCell
        movieTblView.rowHeight = UITableViewAutomaticDimension
        movieTblView.estimatedRowHeight = 64
        
        // Refresh control
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh");
        refreshControl.tintColor = UIColor(red:1.00, green:0.21, blue:0.55, alpha:1.0)
        refreshControl.addTarget(self, action: #selector(refreshMovieTable), for: .valueChanged)
        
        // Spinner
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        
        title = "Home"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    @objc fileprivate func refreshMovieTable() {
        hasPullRefresh = !hasPullRefresh
        progressHUD?.show(animated: true)
        movieSearchDataHandler.startFetchingMovies()
    }
}

