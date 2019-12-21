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
    private var currentLocationViewModel: ReminderCurrentLocationListViewModel! = nil
    private var locationSearchBarDelegate: ReminderLocationSearchDelegate!
    let reminder: Reminder
    
    private var reminderLocationManager: ReminderLocationManager? = nil
   

    
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
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        reminderLocationManager?.stopFetchingCurrentLocation()
        reminderLocationManager = nil
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        reminderLocationManager = ReminderLocationManager(withDelegate: self)
        
        currentLocationView.changeActivityStatus(to: .inProgress)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { () -> Void in
            self.beginFetchingCurrentLocation()
        })
    }
    
    
    func configureSubViews() {
        
        configureLocationSearchBar()
        configureNotifierSegmentControl()
        
        if currentLocationView == nil {
            configureCurrentLocationSelectionView()
        }
        if locationListTableView == nil {
            configureLocationSearchTableView()
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
        
        currentLocationViewModel = ReminderCurrentLocationListViewModel(withLocation: nil)
        
        currentLocationView = ReminderActivityIndicatorTitleSubtitleView(withActivityStatusDisplayableDataSource: currentLocationViewModel, activityStatus: .notStarted, tapHandler: { [unowned self] (currentActivityStatus: ReminderActivityStatus, tapType: ReminderLocationTapType) -> Void in
            
            if currentActivityStatus == .finished {
                
                if tapType == .locationInfoTapped {
                    //Push the map view controller.
                    self.showMapViewController(forReminderLocationViewModel: self.currentLocationViewModel)
                }
                else if tapType == .locationTapped {
                    self.selectReminderLocation(withViewModel: self.currentLocationViewModel)
                }
            }
        })
        view.addSubview(currentLocationView)
        currentLocationView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        currentLocationView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        currentLocationView.topAnchor.constraint(equalTo: notifierTypeSegmentControl.bottomAnchor, constant: 26.0).isActive = true
        
        currentLocationView.layer.borderWidth = 0.2
        currentLocationView.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    
    private func configureLocationSearchTableView() {
        
        locationListTableView = ReminderLocationSelectionTableView(withListDisplayables: listViewModels, selectionResponder: self)
        view.addSubview(locationListTableView)
        locationListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        locationListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        locationListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        locationListTableView.topAnchor.constraint(equalTo: currentLocationView.bottomAnchor, constant: 8.0).isActive = true
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
        reminderLocationManager = nil
    }
}



extension ReminderLocationSelectionViewController: ReminderLocationSelectionResponder {
    
    
    func reactTo(tapType type: ReminderLocationTapType, atIndexPath idxPath: IndexPath) {
        
        let locationVM: ReminderLocationListViewModel = listViewModels[idxPath.row]
        
        if type == .locationTapped {
            selectReminderLocation(withViewModel: locationVM)
        }
        else if type == .locationInfoTapped {
            
            //Push the map view controller along with the selected location.
            showMapViewController(forReminderLocationViewModel: locationVM)
        }
        
    }
    
    
    func selectReminderLocation(withViewModel locationVM: ReminderLocationListViewModel) {
        
        
        let reminderLocation: ReminderLocation? = locationVM.location
        
        if let reminderLocation = reminderLocation {
            
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
    }
    
    
    func showMapViewController(forReminderLocationViewModel locVM: ReminderLocationListViewModel) {
        
        let remLoc: ReminderLocation? = locVM.location
        
        if let coordinate = remLoc?.placeMark.location?.coordinate {
            
            let mapViewController: ReminderLocationMapViewController = ReminderLocationMapViewController(withLocationCoordinate: coordinate, nameOfLocation: remLoc!.locationName, addressOfLocation: locVM.formattedAddress)
            navigationController?.pushViewController(mapViewController, animated: true)
        }
    }
}


extension ReminderLocationSelectionViewController: ReminderLocationManagerDelegate {
    
    
    func beginFetchingCurrentLocation() {
        reminderLocationManager?.fetchCurrentLocation()
    }
    
    
    func reactToLocationStatus(_ status: ReminderLocationStatus) {
        
        switch status {
            
            case .locationAccessRequested:                      print("locationAccess_requested")
            
            case .locationAccessGranted:
                print("locationAccess_granted")
                beginFetchingCurrentLocation()
            
            case .locationAccessRejected: print("locationAccess_rejected")
            
            case .didStartFetchingCurrentLocation:
                  currentLocationView.changeActivityStatus(to: .inProgress)
            
            case .currentLocationFetched(location: let currLoc):
                  updateCurrentLocationView(withLocation: currLoc)
            
            case .failedToFetchCurrentLocation: print("failedToFetchCurrentLocation")
            
            case .didEndFetchingCurrentLocation: print("didEndFetchingCurrentLocation")
            
            default: break

        }
    }
    
    
    func updateCurrentLocationView(withLocation loc: CLLocation) {
        
        let geoCoder: CLGeocoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(loc) { ( allPlacemarks: [CLPlacemark]?, err: Error?) in
            
            
            guard let _ = self.reminderLocationManager else {
                return
            }
            
            if let allPlacemarks = allPlacemarks {
                
                if allPlacemarks.isEmpty == false {
                    
                    let placemark = allPlacemarks.first!
                    let remLocation: ReminderLocation = ReminderLocation(withPlaceMark: placemark, nameOfTheLocation: placemark.name)
                    
                    if self.currentLocationViewModel == nil {
                        self.currentLocationViewModel = ReminderCurrentLocationListViewModel(withLocation: remLocation)
                    }
                    else {
                        self.currentLocationViewModel.updateLocation(with: remLocation)
                    }
                    self.currentLocationView.changeActivityStatus(to: .finished)
                }
            }
        }
    }
}
