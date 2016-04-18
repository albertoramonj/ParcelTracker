//
//  MyExtensions.swift
//  ParcelTracker
//
//  Created by Alberto Ramon Janez on 18/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import UIKit

extension ViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchController.searchBar.text!.lowercaseString
        filterSearch(searchController.searchBar.text!.lowercaseString)
    }
}

