//
//  yelpSearch.swift
//  Yelp
//
//  Created by Singh, Jagdeep on 10/23/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import Foundation

class YelpSearch {

    static let sharedInstance = YelpSearch(categories: [], deals: false, distance: 40000, searchString: "Restaurants", sort: YelpSortMode.bestMatched, offSet: 0)
    
    var categories: [String]!
    var deals: Bool?
    var distance: Int?
    var businessType: String?
    var sort: YelpSortMode?
    var offSet = 0
    
    init(categories: [String]!, deals: Bool!, distance: Int!, searchString: String!, sort: YelpSortMode!, offSet: Int!) {
        self.categories = categories
        self.deals = deals
        self.distance = distance
        self.businessType = searchString
        self.sort = sort
        self.offSet = offSet
    }
    
}
