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
    
    static private var localSearch: MKLocalSearch!
    
    
    static func initiateSearch(forText text: String, withCompletionHandler completionHandler: @escaping (([MKMapItem], Error?) -> Void)) {
        
        if localSearch.isSearching == true {
            //Cancel existing search.
            cancelSearch()
        }
        
        let searchRequest: MKLocalSearch.Request = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        localSearch = MKLocalSearch.init(request: searchRequest)
        
        localSearch.start { (response: MKLocalSearch.Response?, error: Error?) in
            
            completionHandler(response?.mapItems ?? [], error)
        }
    }
    
    
    static func cancelSearch() {
        localSearch.cancel()
    }
    
}
