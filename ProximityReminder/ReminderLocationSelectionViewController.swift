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
    
    private var locationListTableView: ReminderLocationSelectionTableView!
    
    private var listViewModels: [ReminderLocationListViewModel] = [] {
        didSet {
            locationListTableView.update(withDisplayables: listViewModels)
        }
    }
    
    private var locationSearchBarDelegate: ReminderLocationSearchDelegate!
    
    let reminder: Reminder

    
    init(withReminder reminder: Reminder) {
        
        self.reminder = reminder
        super.init(nibName: "ReminderLocationSelectionViewController", bundle: .main)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureLocationSearchBar()
        configureLocationSearchTableView()
    }
    
    
    func configureLocationSearchBar() {
        
        locationSearchBarDelegate = ReminderLocationSearchDelegate(withSearchActionHandler: { [unowned self] (actionState: ReminderSearchActionState) -> Void in
            
            //handle search state.
            self.handle(searchBarActionState: actionState)
            
        })
        
        locationSearchBar.delegate = locationSearchBarDelegate
        
    }
    
    
    func configureLocationSearchTableView() {
        
        locationListTableView = ReminderLocationSelectionTableView(withListDisplayables: listViewModels, selectionResponder: self)
        view.addSubview(locationListTableView)
        locationListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        locationListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        locationListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        locationListTableView.topAnchor.constraint(equalTo: notifierTypeSegmentControl.bottomAnchor, constant: 8.0).isActive = true
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
                
                ReminderLocationSearch.initiateSearch(forText: text, withCompletionHandler: {  [unowned self] (mapItems: [MKMapItem], error: Error?) -> Void in
                    
                    DispatchQueue.main.async {
                        
                        //Parse and get the required information out from these map items.
                        if let error = error {
                            print(error)
                        }
                        else {
                            if mapItems.isEmpty == false {
                                
                                //Parse them please.
                                let locations: [ReminderLocation] = mapItems.reminderLocations
                                
                                //Create view models from each one of these locations and pass them onto the UI.
                                self.listViewModels = locations.reminderLocationListViewModels
                                
                            }
                        }
                    }
                    
                })
            }
        }
        
    }
    
    
    deinit {
        
        locationSearchBar = nil
        notifierTypeSegmentControl = nil
        locationListTableView = nil
        locationSearchBarDelegate = nil
    }
}



extension ReminderLocationSelectionViewController: ReminderLocationSelectionResponder {
    
    
    func reactTo(tapType type: ReminderLocationCellTapType, atIndexPath idxPath: IndexPath) {
        
        if type == .locationTapped {
            //call a handler and pass the selected location.
            let loc: ReminderLocationListViewModel = listViewModels[idxPath.row]
            //loc.location.locationName
            //loc.formattedAddress
            
        }
        else if type == .locationInfoTapped {
            //push the map view controller along with the selected location.
        }
    }
    
    
}
