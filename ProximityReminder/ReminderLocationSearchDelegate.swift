//
//  ReminderLocationSearchDelegate.swift
//  ProximityReminder
//
//  Created by Bharath on 03/12/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


enum ReminderSearchActionState {
    
    case searchAction(text: String?)
    case searchCancelAction
    case searchTextClearAction
}


class ReminderLocationSearchDelegate: NSObject {
    
    private let searchActionHandler: ((ReminderSearchActionState) -> Void)
    
    
    init(withSearchActionHandler handler: @escaping ((ReminderSearchActionState) -> Void)) {
        
        searchActionHandler = handler
    }
    
}


extension ReminderLocationSearchDelegate: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActionHandler(.searchAction(text: searchBar.text))
    }

   
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActionHandler(.searchCancelAction)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty == true {
            searchActionHandler(.searchTextClearAction)
        }
        
    }
    
}
