//
//  ReminderAlertController.swift
//  ProximityReminder
//
//  Created by Bharath on 29/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    
    func displayAlertController(withStyle preferredStyle: UIAlertController.Style, alertHeading heading: ReminderAlertHeading, alertAction action: ReminderAlertAction, actionTapHandler handler: @escaping ((Int) -> Void)) {
        
        
        let alertController = UIAlertController.init(title: heading.alertTitle, message: heading.alertMessage, preferredStyle: preferredStyle)
        
        let defActions: [UIAlertAction] = action.allDefaultActions(withTapHandler: { (actionIndex: Int) -> Void in
            
            handler(actionIndex)
        })
        let _ = defActions.compactMap({ return alertController.addAction($0)})
        
        
        let dstActions: [UIAlertAction] = action.allDestructiveActions(withTapHandler: { (actionIndex: Int) -> Void in
            
            handler(actionIndex)
        })
        let _ = dstActions.compactMap({ return alertController.addAction($0)})
        
        
        if let cancelAct = action.cancelAction(withTapHandler: { (actIndex: Int) -> Void in
            
            handler(actIndex)
            
        }) {
            alertController.addAction(cancelAct)
        }
        
        present(alertController, animated: true, completion: nil)
        
    }
}
