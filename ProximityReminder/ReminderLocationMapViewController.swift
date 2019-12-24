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


class ReminderLocationMapViewController: ReminderLocationMonitoringViewController {
    
    @IBOutlet weak private(set) var mapView: MKMapView!
    @IBOutlet weak private(set) var addressLabel: UILabel!

    let locationCoordinate: CLLocationCoordinate2D
    let locationName: String?
    let locationAddress: String
    
    
    init(withLocationCoordinate location: CLLocationCoordinate2D, nameOfLocation name: String? = nil, addressOfLocation address: String) {
        
        locationCoordinate = location
        locationName = name
        locationAddress = address
        super.init(nibName: "ReminderLocationMapViewController", bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = locationName
        addressLabel.text = locationAddress
        loadLocationAndAnnotate()
        addOverlayCircle()
    }
    
    
    func loadLocationAndAnnotate() {
        
        //Load and zoom into a region.
        let mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: locationCoordinate, latitudinalMeters: 125.0, longitudinalMeters: 125.0)
        mapView.setRegion(mapRegion, animated: true)
        
        //Add the annotation.
        let locationAnnotation: ReminderLocationAnnotation = ReminderLocationAnnotation(withLocationCoordinate: locationCoordinate)
        mapView.addAnnotation(locationAnnotation)
    }
    
    
    func addOverlayCircle() {
        
        let circle: MKCircle = MKCircle.init(center: locationCoordinate, radius: 40.0)
        mapView.addOverlay(circle)
    }


    deinit {
        mapView = nil
        addressLabel = nil
    }
   
}


extension ReminderLocationMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let circle = MKCircleRenderer(overlay: overlay)
        circle.strokeColor = UIColor.blue
        circle.fillColor = UIColor(red: 255.0, green: 0.0, blue: 0.0, alpha: 0.1)
        circle.lineWidth = 1.0
        return circle
    }
}
