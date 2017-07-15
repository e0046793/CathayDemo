//
//  TableViewDataSource.swift
//  CathayDemo
//
//  Created by Kyle Truong on 13/07/2017.
//  Copyright © 2017 Kyle Truong. All rights reserved.
//

import Foundation
import UIKit

/// table view data source
class TableViewDataSource: NSObject, UITableViewDataSource {
    
    fileprivate var items = [Any]()
    
    fileprivate var cellIdentifier: String
    
    weak var tableView: UITableView?
    
    init(_ tableView: UITableView, cellIdentifier: String, items: [Any]? = nil) {
        
        self.tableView = tableView
        self.cellIdentifier = cellIdentifier
        
        if let newItems = items, newItems.count > 0 {
            self.items.append(contentsOf: newItems)
        }
    }
}

// MARK: - Public methods
extension TableViewDataSource {
    
    public func resetWithNewItems(_ newItems: [Any]?) {
        
        items.removeAll()
        
        if let newItems = newItems, newItems.count > 0 {
            items.append(contentsOf: newItems)
        }
        tableView?.reloadData()
    }
    
    public func insertNewItems(_ newItems: [Any]?) {
        
        if let newItems = newItems, newItems.count > 0 {
            
            items.append(contentsOf: newItems)
            
            tableView?.reloadData()
        }
    }
    
    public func reset() {
        items.removeAll()
        tableView?.reloadData()
    }
    
    public func itemAtIndexPath(_ indexPath: IndexPath) -> Any? {
        
        let row = indexPath.row
        
        guard row >= 0 && row < items.count  else {
            assertionFailure()
            return nil
        }
        
        return items[indexPath.row]
    }
}

// MARK: - UITableViewDataSource
extension TableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        if let cell = cell as? TableViewReusableCell {
            cell.configure(items[indexPath.row])
        }
        
        return cell
    }
}
