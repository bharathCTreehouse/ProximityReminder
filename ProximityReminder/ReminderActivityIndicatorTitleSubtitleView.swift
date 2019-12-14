//
//  ReminderActivityIndicatorTitleSubtitleView.swift
//  ProximityReminder
//
//  Created by Bharath on 08/12/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class ReminderActivityIndicatorTitleSubtitleView: UIView {
    
    let displayableDataSource: ReminderActivityStatusDisplayable
    private var activityStatus: ReminderActivityStatus = .notStarted {
        didSet {
            reactToStatusChange()
        }
    }
    private(set) var activityIndicatorView: UIActivityIndicatorView? = nil
    private(set) var titleLabel: UILabel? = nil
    private(set) var subtitleLabel: UILabel? = nil
    private var titleLabelLeadingConstraint: NSLayoutConstraint! = nil


    init(withActivityStatusDisplayableDataSource displayable: ReminderActivityStatusDisplayable, activityStatus status: ReminderActivityStatus) {
        
        displayableDataSource = displayable
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        changeActivityStatus(to: status)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func changeActivityStatus(to status: ReminderActivityStatus) {
        activityStatus = status
    }
    
    
    private func reactToStatusChange() {
        
        if activityStatus == .inProgress {
            
            //We do not need the sub title label. So removing it.
            subtitleLabel?.removeFromSuperview()
            
            if activityIndicatorView == nil {
                
                let activityIndAttr: ReminderActivityIndicatorInfo? = displayableDataSource.statusInProgressDisplayableDetail.activityIndicatorAttribute
                
                //Do we need the activity indicator?
                if let activityIndAttr = activityIndAttr {
                    
                    configureActivityIndicatorView(usingIndicatorInfo: activityIndAttr)
                }
            }
            
            //Add the in-progress label if not already added.
            if titleLabel == nil {
                let textAttr: (text: String, attribute: ReminderLabelTextAttribute) = displayableDataSource.statusInProgressDisplayableDetail.textDetail.titleTextDetail
                configureTitleLabel(usingDetail: textAttr)
            }
        }
        else if activityStatus == .finished {
            //We need both the title and sub title labels.
            //Remove the activity view.
            activityIndicatorView?.removeFromSuperview()
            
            if titleLabel == nil {
                let textAttr: (text: String, attribute: ReminderLabelTextAttribute) = displayableDataSource.statusFinishedDisplayableDetail.titleTextDetail
                configureTitleLabel(usingDetail: textAttr)
            }
            if subtitleLabel == nil {
                let textAttr: (text: String, attribute: ReminderLabelTextAttribute) = displayableDataSource.statusFinishedDisplayableDetail.subtitleTextDetail
                configureSubtitleLabel(usingDetail: textAttr)
                
            }
        }
        else if activityStatus == .notStarted {
            activityIndicatorView?.removeFromSuperview()
            titleLabel?.removeFromSuperview()
            subtitleLabel?.removeFromSuperview()
        }
    }
    
    
    deinit {
        activityIndicatorView  = nil
        titleLabel = nil
        subtitleLabel = nil
        titleLabelLeadingConstraint = nil
    }
    
}


extension ReminderActivityIndicatorTitleSubtitleView {
    
    
    func configureTitleLabel(usingDetail detail: (text: String, attribute: ReminderLabelTextAttribute)) {
        
        titleLabel = UILabel()
        titleLabel!.translatesAutoresizingMaskIntoConstraints = false
        titleLabel!.numberOfLines = 1
        titleLabel!.font = detail.attribute.labelTextFont
        titleLabel!.textColor = detail.attribute.labelTextColor
        addSubview(titleLabel!)
        titleLabelLeadingConstraint.isActive = false
        if activityStatus == .inProgress {
            titleLabelLeadingConstraint = titleLabel!.leadingAnchor.constraint(equalTo: activityIndicatorView!.trailingAnchor, constant: 8.0)
        }
        else if activityStatus == .finished {
            titleLabelLeadingConstraint = titleLabel!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0)
        }
        titleLabelLeadingConstraint.isActive = true
        titleLabel!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0).isActive = true
        titleLabel!.topAnchor.constraint(equalTo: topAnchor, constant: 9.0).isActive = true
        titleLabel!.text = detail.text
    }
    
    
    func configureActivityIndicatorView(usingIndicatorInfo info: ReminderActivityIndicatorInfo) {
        
        activityIndicatorView = UIActivityIndicatorView.init(style: info.activityIndicatorStyle)
        activityIndicatorView!.color = info.backgroundColor
        activityIndicatorView!.hidesWhenStopped = info.shouldHideWhenStopped
        activityIndicatorView!.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicatorView!)
        activityIndicatorView!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0).isActive = true
        activityIndicatorView!.topAnchor.constraint(equalTo: topAnchor, constant: 8.0).isActive = true
        activityIndicatorView!.startAnimating()
    }
    
    
    func configureSubtitleLabel(usingDetail detail: (text: String, attribute: ReminderLabelTextAttribute)) {
        
        subtitleLabel = UILabel()
        subtitleLabel!.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel!.numberOfLines = 0
        subtitleLabel!.font = detail.attribute.labelTextFont
        subtitleLabel!.textColor = detail.attribute.labelTextColor
        addSubview(subtitleLabel!)
        subtitleLabel!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0).isActive = true
        subtitleLabel!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0).isActive = true
        subtitleLabel!.topAnchor.constraint(equalTo: topAnchor, constant: 9.0).isActive = true
        subtitleLabel!.text = detail.text
    }
}
