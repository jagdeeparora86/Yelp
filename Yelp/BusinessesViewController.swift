//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FilterViewControllerDelegate {
    
    @IBOutlet weak var mapBttn: UIButton!
    var businesses: [Business]!
    var searchBar: UISearchBar!
    var currentFilterViewController : FilterViewController!
    var isMoreDataLoading = false
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Restaurants"
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        handleSearch(yelpSearch: YelpSearch.sharedInstance)
        
    }
    
    func handleSearch(yelpSearch: YelpSearch){
        Business.searchWithTerm(term: yelpSearch.businessType!, sort: nil, distance: nil, categories: nil, deals: nil, offSet: yelpSearch.offSet){ (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.isMoreDataLoading = false
            self.tableView.reloadData()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let count = businesses?.count{
            return count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessCell", for: indexPath) as! BusinessCell
        cell.buisness = businesses[indexPath.row]
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationViewController = segue.destination as! UINavigationController
        if(navigationViewController.topViewController is MapViewController){
            let mapViewController = navigationViewController.topViewController as! MapViewController
            mapViewController.businesses = self.businesses
        
        }
        else{
        let filterViewController = navigationViewController.topViewController as! FilterViewController
        filterViewController.delegate = self
        if(currentFilterViewController != nil){
            filterViewController.switchState = currentFilterViewController.switchState
            filterViewController.dealOn = currentFilterViewController.dealOn
            filterViewController.selectedDistance = currentFilterViewController.selectedDistance
            filterViewController.selectedDistanceRow = currentFilterViewController.selectedDistanceRow
            filterViewController.selectedSort = currentFilterViewController.selectedSort
            filterViewController.selectedSortRow = currentFilterViewController.selectedSortRow
        }
        }
        
    }
    
    func filterViewController(filterViewController: FilterViewController, applyFilter filters: YelpSearch) {
        
        let categoriesFilter = filters.categories
        let distanceFilter = filters.distance ?? 4000
        let dealFilter =  filters.deals ?? false
        let sortFilter =  filters.sort ?? YelpSortMode.bestMatched
        print(" Switch states right now is here \(filterViewController.switchState)")
        currentFilterViewController = filterViewController
        Business.searchWithTerm(term: "Restaurants", sort: sortFilter, distance: distanceFilter, categories: categoriesFilter, deals: dealFilter, offSet: 20){ (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }
}



extension BusinessesViewController: UISearchBarDelegate, UIScrollViewDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        YelpSearch.sharedInstance.businessType = searchBar.text
        searchBar.resignFirstResponder()
        handleSearch(yelpSearch: YelpSearch.sharedInstance)
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        return
        if (!isMoreDataLoading) {
            YelpSearch.sharedInstance.offSet = 20 ;
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                print("Going to make a call now")
                handleSearch(yelpSearch: YelpSearch.sharedInstance)
                
                // ... Code to load more results ...
                
            }
        }
    }
    
}
