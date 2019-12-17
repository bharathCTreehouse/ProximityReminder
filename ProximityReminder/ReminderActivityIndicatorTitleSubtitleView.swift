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
    
    private var displayableDataSource: ReminderActivityStatusDisplayable
    private var activityStatus: ReminderActivityStatus = .notStarted {
        didSet {
            reactToStatusChange()
        }
    }
    private(set) var activityIndicatorView: UIActivityIndicatorView? = nil
    private(set) var titleLabel: UILabel? = nil
    private(set) var subtitleLabel: UILabel? = nil
    private var titleLabelLeadingConstraint: NSLayoutConstraint! = nil
    private var titleLabelBottomConstraint: NSLayoutConstraint! = nil



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
    
    
    func updateDisplayableDataSource(with ds: ReminderActivityStatusDisplayable) {
        
        displayableDataSource = ds
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
            let textAttr: (text: String, attribute: ReminderLabelTextAttribute) = displayableDataSource.statusInProgressDisplayableDetail.textDetail.titleTextDetail
            configureTitleLabel(usingDetail: textAttr)
            
            
        }
        else if activityStatus == .finished {
            //We need both the title and sub title labels.
            //Remove the activity view.
            activityIndicatorView?.removeFromSuperview()
            
            var textAttr: (text: String, attribute: ReminderLabelTextAttribute) = displayableDataSource.statusFinishedDisplayableDetail.titleTextDetail
            configureTitleLabel(usingDetail: textAttr)
            
            textAttr = displayableDataSource.statusFinishedDisplayableDetail.subtitleTextDetail
            if subtitleLabel == nil {
                configureSubtitleLabel(usingDetail: textAttr)
            }
            else {
                subtitleLabel!.text = textAttr.text
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
        
        if titleLabel == nil {
            
            titleLabel = UILabel()
            titleLabel!.translatesAutoresizingMaskIntoConstraints = false
            titleLabel!.numberOfLines = 1
            addSubview(titleLabel!)
            titleLabel!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0).isActive = true
            titleLabel!.topAnchor.constraint(equalTo: topAnchor, constant: 9.0).isActive = true
        }
        
        titleLabelLeadingConstraint?.isActive = false
        titleLabelBottomConstraint?.isActive = false
        
        if activityStatus == .inProgress {
            
            titleLabelLeadingConstraint = titleLabel!.leadingAnchor.constraint(equalTo: activityIndicatorView!.trailingAnchor, constant: 8.0)
            titleLabelBottomConstraint = titleLabel!.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.0)
            titleLabelBottomConstraint.isActive = true
            
        }
        else if activityStatus == .finished {
            
            titleLabelLeadingConstraint = titleLabel!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0)
        }
        titleLabelLeadingConstraint.isActive = true
        
        titleLabel!.font = detail.attribute.labelTextFont
        titleLabel!.textColor = detail.attribute.labelTextColor
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
        subtitleLabel!.topAnchor.constraint(equalTo: titleLabel!.bottomAnchor, constant: 6.0).isActive = true
        subtitleLabel!.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -9.0).isActive = true
        subtitleLabel!.text = detail.text
    }
}
