//
//  ReminderLocationMapViewController.swift
//  ProximityReminder
//
//  Created by Bharath on 08/12/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ReminderLocationMapViewController: UIViewController {
    
    @IBOutlet weak private(set) var mapView: MKMapView!
    let location: CLLocationCoordinate2D
    
    
    init(withLocation location: CLLocationCoordinate2D) {
        self.location = location
        super.init(nibName: "ReminderLocationMapViewController", bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLocation()
    }
    
    
    func loadLocation() {
        
        let mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: 125.0, longitudinalMeters: 125.0)
        //location.latitude = 0
        //coordinate.longitude = 0;
        //mapRegion.center = location
        //mapRegion.span.latitudeDelta = 0.2
        //mapRegion.span.longitudeDelta = 0.2
        
        self.mapView.setRegion(mapRegion, animated: true)
        self.mapView.addAnnotation(self)
        
    }


    deinit {
        mapView = nil
    }
   
}


extension ReminderLocationMapViewController: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        return location
    }
}


extension ReminderLocationMapViewController: MKMapViewDelegate {
    
}
