//
//  ReminderDetailTableView.swift
//  ProximityReminder
//
//  Created by Bharath on 25/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit

enum ReminderDetailTapType {
    case locationSelection
    case displayLocationOnMap
}


class ReminderDetailTableView: UITableView {
    
    private var detailDataSource: ReminderDetailTableViewDataSource! = nil
    private var tapHandler: ((IndexPath?, ReminderDetailTapType) -> Void)? = nil
    private var locationMapButtonView: UIView? = nil
    
    
    init(withDetailSource detailSource: ReminderDetailDisplayable, contentTextViewDelegate txtViewDelegate: UITextViewDelegate?, activationActionDelegate switchActionDelegate: ReminderSwitchActionDelegate, tapCompletion handler:  ((IndexPath?, ReminderDetailTapType) -> Void)?) {
        
        tapHandler = handler
        super.init(frame: .zero, style: .grouped)
        translatesAutoresizingMaskIntoConstraints = false
        
        detailDataSource = ReminderDetailTableViewDataSource(withDetailDataSource: detailSource, contentDelegate: txtViewDelegate, activationDelegate: switchActionDelegate)
        dataSource = detailDataSource
        delegate = self
        
        configure()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        
        //For the content of the reminder
        register(UINib.init(nibName: "ReminderContentTableViewCell", bundle: .main), forCellReuseIdentifier: "reminderContentCell")
        
        //Activation status of the notifier
        register(ReminderSwitchTableViewCell.classForCoder(), forCellReuseIdentifier: "reminderActivationCell")
        
        //location
        register(ReminderLocationTableViewCell.classForCoder(), forCellReuseIdentifier: "locationCell")
        
        //Configure the locationMap button.
        
        if locationMapButtonView == nil {
            
            locationMapButtonView = UIView.init(frame: .init(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 50.0))
            //locationMapButtonView!.backgroundColor = UIColor.yellow
            let locationMapButton: UIButton = UIButton.init(type: .system)
            locationMapButton.translatesAutoresizingMaskIntoConstraints = false
            locationMapButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
            locationMapButton.setTitle("Show location on map", for: .normal)
            locationMapButton.addTarget(self, action: #selector(mapLocationButtonTapped(_:)), for: .touchUpInside)
            locationMapButtonView!.addSubview(locationMapButton)
            locationMapButton.centerXAnchor.constraint(equalTo: locationMapButtonView!.centerXAnchor).isActive = true
            locationMapButton.centerYAnchor.constraint(equalTo: locationMapButtonView!.centerYAnchor).isActive = true
            self.tableFooterView = locationMapButtonView
        }
        //Toggle the state of the button depending on the presence/absence of a location.
    }
    
    
    @objc func mapLocationButtonTapped(_ sender: UIButton) {
        tapHandler?(nil, .displayLocationOnMap)
    }
    
    
    func enableMapLocationView(_ enabled: Bool) {
        
        if enabled == true {
            locationMapButtonView?.alpha = 1.0
        }
        else {
            locationMapButtonView?.alpha = 0.3
        }
        locationMapButtonView!.isUserInteractionEnabled = enabled
    }
    
    
    deinit {
        
        tapHandler = nil
        detailDataSource = nil
        locationMapButtonView = nil
    }
    
}

extension ReminderDetailTableView: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 150.0
        }
        else {
            return UITableView.automaticDimension
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 && indexPath.row == 1 {
            tapHandler?(indexPath, .locationSelection)
        }
    }
}



extension ReminderDetailTableView {
    
    func refreshContentViewAppearance() {
        detailDataSource.updateContentTextViewAppearance(forTableView: self)
    }
    
    func refreshContentTextViewText() {
        detailDataSource.updateContentTextViewText(forTableView: self)
    }
    
    
    func refreshContentView() {
        refreshContentViewAppearance()
        refreshContentTextViewText()
    }
    
    
    func refreshLocationViewAppearance() {
        detailDataSource.updateLocationCellAppearance(inTableView: self)
    }
    
    
    func refreshLocationContent() {
        detailDataSource.updateLocationDetail(inTableView: self)
    }
}
