//
//  ReminderAlertAction.swift
//  ProximityReminder
//
//  Created by Bharath on 29/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class ReminderAlertAction {
    
    private let defaultActionTitles: [String]
    private let destructiveActionTitles: [String]
    private let cancelActionTitle: String?
    
    
    init(withDefaultActionTitles defTitles: [String], destructiveActionTitles dstTitles: [String], cancelTitle: String?) {
        
        defaultActionTitles = defTitles
        destructiveActionTitles = dstTitles
        cancelActionTitle = cancelTitle
    }
}


extension ReminderAlertAction {
    
    
    func allDefaultActions(withTapHandler completionHandler: @escaping ((Int) -> Void)) -> [UIAlertAction] {
        
        var allActions: [UIAlertAction] = []
        
        for title in defaultActionTitles {
            
            let action: UIAlertAction = UIAlertAction.init(title: title, style: .default, handler: { (act: UIAlertAction) -> Void in
                
                completionHandler(allActions.firstIndex(of: act)!)
            })
            
            allActions.append(action)
        }
        
        return allActions
    }
    
    
    func allDestructiveActions(withTapHandler completionHandler: @escaping ((Int) -> Void)) -> [UIAlertAction] {
        
        var allActions: [UIAlertAction] = []
        
        for title in destructiveActionTitles {
            
            let action: UIAlertAction = UIAlertAction.init(title: title, style: .destructive, handler: { [unowned self] (act: UIAlertAction) -> Void in
                
                completionHandler(allActions.firstIndex(of: act)! + self.defaultActionTitles.count)
            })
            
            allActions.append(action)
        }
        
        return allActions
    }
    
    
    func cancelAction(withTapHandler completionHandler: @escaping ((Int) -> Void)) -> UIAlertAction? {
        
        if cancelActionTitle == nil {
            return nil
        }
        else {
            
            return UIAlertAction.init(title: cancelActionTitle!, style: .cancel, handler: { [unowned self] (act: UIAlertAction) -> Void in
                
                completionHandler(self.defaultActionTitles.count + self.destructiveActionTitles.count + 1)
            })
        }
        
    }
}
