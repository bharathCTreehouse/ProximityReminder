//
//  ReminderSwitchTableViewCell.swift
//  ProximityReminder
//
//  Created by Bharath on 25/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


protocol ReminderSwitchActionDelegate: AnyObject {
    func dualModeSwitchDidEndToggle(withCurrentState state: Bool)
}


class ReminderSwitchTableViewCell: UITableViewCell {
    
    let dualModeSwitch: UISwitch!
    weak private(set) var switchActionDelegate: ReminderSwitchActionDelegate!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        dualModeSwitch = UISwitch()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryView = dualModeSwitch
        dualModeSwitch.addTarget(self, action: #selector(dualModeSwitchToggled(_:)), for: .valueChanged)
        selectionStyle = .none
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func update(withDualModeDisplayableData data: ReminderDualModeDisplayable) {
        
        textLabel?.font = data.dualModeDescription.attribute.labelTextFont
        textLabel?.textColor = data.dualModeDescription.attribute.labelTextColor
        textLabel?.text = data.dualModeDescription.text
        
        dualModeSwitch.onTintColor = data.activationDetail.selectionColor
        dualModeSwitch.isOn = data.activationDetail.isActive
    }
    
    
    func assignSwitchActionDelegate(to delegate: ReminderSwitchActionDelegate) {
        
        switchActionDelegate = delegate
    }
    
    
    @objc func dualModeSwitchToggled(_ sender: UISwitch) {
        switchActionDelegate.dualModeSwitchDidEndToggle(withCurrentState: sender.isOn)
    }
    
    
    deinit {
        switchActionDelegate = nil
    }
}
