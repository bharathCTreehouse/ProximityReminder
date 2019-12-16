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
    
    private(set) var currentLocationView: ReminderActivityIndicatorTitleSubtitleView! = nil
    
    private var locationListTableView: ReminderLocationSelectionTableView!
    
    private var listViewModels: [ReminderLocationListViewModel] = [] {
        didSet {
            locationListTableView.update(withDisplayables: listViewModels)
        }
    }
    
    private var locationSearchBarDelegate: ReminderLocationSearchDelegate!
    
    let reminder: Reminder
    
    private lazy var reminderLocationManager: ReminderLocationManager = {
        
        return ReminderLocationManager(withDelegate: self)
    }()

    
    init(withReminder reminder: Reminder) {
        
        self.reminder = reminder
        super.init(nibName: "ReminderLocationSelectionViewController", bundle: .main)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureSubViews()
        beginFetchingCurrentLocation()
    }
    
    
    func configureSubViews() {
        
        if locationSearchBar == nil {
            configureLocationSearchBar()
        }
        if locationListTableView == nil {
            configureLocationSearchTableView()
        }
        if notifierTypeSegmentControl == nil {
            configureNotifierSegmentControl()
        }
        if currentLocationView == nil {
            configureCurrentLocationSelectionView()
        }
    }
    
    
    private func configureNotifierSegmentControl() {
        
        let notifier: ReminderNotifier = ReminderNotifier(rawValue: Int(reminder.notifierType)) ?? ReminderNotifier.undecided
        if notifier == .entry || notifier == .exit {
            notifierTypeSegmentControl.selectedSegmentIndex = notifier.rawValue
        }
    }
    
    
    private func configureLocationSearchBar() {
        
        locationSearchBarDelegate = ReminderLocationSearchDelegate(withSearchActionHandler: { [unowned self] (actionState: ReminderSearchActionState) -> Void in
            
            //handle search state.
            self.handle(searchBarActionState: actionState)
            
        })
        locationSearchBar.delegate = locationSearchBarDelegate
        
    }
    
    
    private func configureCurrentLocationSelectionView() {
        
        let currentLocationListVM: ReminderCurrentLocationListViewModel = ReminderCurrentLocationListViewModel(withLocation: nil)
        
        currentLocationView = ReminderActivityIndicatorTitleSubtitleView(withActivityStatusDisplayableDataSource: currentLocationListVM, activityStatus: .notStarted)
        view.addSubview(currentLocationView)
        currentLocationView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        currentLocationView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        currentLocationView.topAnchor.constraint(equalTo: notifierTypeSegmentControl.bottomAnchor, constant: 5.0).isActive = true
        
    }
    
    
    private func configureLocationSearchTableView() {
        
        locationListTableView = ReminderLocationSelectionTableView(withListDisplayables: listViewModels, selectionResponder: self)
        view.addSubview(locationListTableView)
        locationListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        locationListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        locationListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        locationListTableView.topAnchor.constraint(equalTo: currentLocationView.bottomAnchor, constant: 0.0).isActive = true
    }
    
    
    @IBAction func notifierSegmentTapped(_ sender: UISegmentedControl) {
        reminder.notifierType = Int16(sender.selectedSegmentIndex)
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
        currentLocationView = nil
    }
}



extension ReminderLocationSelectionViewController: ReminderLocationSelectionResponder {
    
    
    func reactTo(tapType type: ReminderLocationCellTapType, atIndexPath idxPath: IndexPath) {
        
        let locationVM: ReminderLocationListViewModel = listViewModels[idxPath.row]
        let reminderLocation: ReminderLocation? = locationVM.location
        
        if type == .locationTapped {
            
            //Call a handler and pass the selected location.
            reminder.notifierType = Int16(notifierTypeSegmentControl.selectedSegmentIndex)
            
            if reminder.location == nil {
                
                //Create new location.
                
                let location: Location = Location.init(context: CoreDataContextConfigurer.mainContext())
                location.uniqueIdentifier = "\(reminder.objectID)"
                location.name = reminderLocation.locationName
                location.address = locationVM.formattedAddress
                location.latitude = reminderLocation.placeMark.location?.coordinate.latitude ?? 0.0   //TODO: Have this checked.
                location.longitude = reminderLocation.placeMark.location?.coordinate.longitude ?? 0.0  //TODO: Have this checked.
                reminder.location = location
            }
            else {
                
                //location already present. Just update.
                
                let loc: Location = reminder.location!
                loc.name = reminderLocation.locationName
                loc.address = locationVM.formattedAddress
                loc.latitude = reminderLocation.placeMark.location?.coordinate.latitude ?? 0.0   //TODO: Have this checked.
                loc.longitude = reminderLocation.placeMark.location?.coordinate.longitude ?? 0.0  //TODO: Have this checked.
                reminder.location = loc
            }
            
            navigationController?.popViewController(animated: true)
        }
        else if type == .locationInfoTapped {
            
            //Push the map view controller along with the selected location.
            if let coordinate = reminderLocation?.placeMark.location?.coordinate {
                
                let mapViewController: ReminderLocationMapViewController = ReminderLocationMapViewController(withLocationCoordinate: coordinate, nameOfLocation: reminderLocation.locationName, addressOfLocation: locationVM.formattedAddress)
                navigationController?.pushViewController(mapViewController, animated: true)
            }
        }
    }
}


extension ReminderLocationSelectionViewController: ReminderLocationManagerDelegate {
    
    
    func beginFetchingCurrentLocation() {
        reminderLocationManager.fetchCurrentLocation()
    }
    
    
    func reactToLocationStatus(_ status: ReminderLocationStatus) {
        
        switch status {
            
            case .locationAccessRequested: print("locationAccess_requested")
            case .locationAccessGranted: print("locationAccess_granted")
            case .locationAccessRejected: print("locationAccess_rejected")
            case .didStartFetchingCurrentLocation: print("didStartFetchingCurrentLocation")
            case .currentLocationFetched(location: let currLoc):
                print(currLoc)
            case .failedToFetchCurrentLocation: print("failedToFetchCurrentLocation")
            case .didEndFetchingCurrentLocation: print("didEndFetchingCurrentLocation")
            default: break

        }
    }
    
    
}
