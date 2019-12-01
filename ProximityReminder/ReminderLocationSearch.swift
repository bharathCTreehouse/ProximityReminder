//
//  ReminderLocationSearch.swift
//  ProximityReminder
//
//  Created by Bharath on 02/12/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import MapKit


class ReminderLocationSearch {
    
    private let queryString: String
    private var localSearch: MKLocalSearch!
    
    
    init(withQueryString query: String) {
        queryString = query
    }
    
    
    func initiateSearch(withCompletionHandler completionHandler: @escaping (([MKMapItem], Error?) -> Void)) {
        
        if localSearch.isSearching == true {
            //Cancel existing search.
            cancelSearch()
        }
        
        let searchRequest: MKLocalSearch.Request = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = queryString
        localSearch = MKLocalSearch.init(request: searchRequest)
        
        localSearch.start { (response: MKLocalSearch.Response?, error: Error?) in
            
            completionHandler(response?.mapItems ?? [], error)
        }
    }
    
    
    func cancelSearch() {
        localSearch.cancel()
    }
    
}
