//
//  ReminderLocationSelectionViewController.swift
//  ProximityReminder
//
//  Created by Bharath on 01/12/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import UIKit
import MapKit

class ReminderLocationSelectionViewController: UIViewController {
    
    @IBOutlet private(set) var locationSearchBar: UISearchBar!
    @IBOutlet private(set) var notifierTypeSegmentControl: UISegmentedControl!
    var locationSearchBarDelegate: ReminderLocationSearchDelegate!


    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureLocationSearchBar()
    }
    
    
    func configureLocationSearchBar() {
        
        locationSearchBarDelegate = ReminderLocationSearchDelegate(withSearchActionHandler: { [unowned self] (actionState: ReminderSearchActionState) -> Void in
            
            //handle search state.
            self.handle(searchBarActionState: actionState)
            
        })
        
        locationSearchBar.delegate = locationSearchBarDelegate
        
    }
    
    
    func handle(searchBarActionState state: ReminderSearchActionState) {
        
        switch state {
            
            case .searchAction(let searchText):
            initiateSearch(withText: searchText)
            
            case .searchCancelAction:
            locationSearchBar.text = nil
            locationSearchBar.endEditing(true)
            
            case .searchTextClearAction: print("")
            //Clears search results and show only current location.
            
            
        }
    }
    
    
    
    func initiateSearch(withText text: String?) {
        
        if let text = text {
            
            if text.isEmpty == false {
                ReminderLocationSearch.initiateSearch(forText: text, withCompletionHandler: { (mapItems: [MKMapItem], error: Error?) -> Void in
                    
                    //Parse and get the required information out from these map items.
                    if let error = error {
                        print(error)
                    }
                    else {
                        if mapItems.isEmpty == false {
                            
                            //Parse them please.
                            let locations: [ReminderLocation] = mapItems.reminderLocations
                            
                            //Create view models from each one of these locations and pass them onto the UI.
                            let listViewModels: [ReminderLocationListViewModel] = locations.reminderLocationListViewModels
                            
                        }
                    }
                })
            }
        }
        
    }
    
    
    
    
    deinit {
        locationSearchBar = nil
        notifierTypeSegmentControl = nil
    }


    

}
