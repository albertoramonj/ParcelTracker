//
//  MyExtensions.swift
//  ParcelTracker
//
//  Created by Alberto Ramon Janez on 18/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import UIKit

extension MainController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterSearch(searchController.searchBar.text!.lowercased())
    }
}

