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
    private var infoButton: UIButton! = nil
    private var tapResponderHandler: ((ReminderActivityStatus, ReminderLocationTapType) -> Void)?



    init( withActivityStatusDisplayableDataSource displayable: ReminderActivityStatusDisplayable, activityStatus status: ReminderActivityStatus, tapHandler handler: ((ReminderActivityStatus, ReminderLocationTapType) -> Void)? ) {
        
        displayableDataSource = displayable
        tapResponderHandler = handler
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        changeActivityStatus(to: status)
        configureTapGestureRecognizer()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureTapGestureRecognizer() {
        let tapGestRecog: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(entireViewTapped(_:)))
        addGestureRecognizer(tapGestRecog)
    }
    
    
    @objc private func entireViewTapped(_ sender: UITapGestureRecognizer) {
        tapResponderHandler?(activityStatus, .locationTapped)
    }
    
    
    func changeActivityStatus(to status: ReminderActivityStatus) {
        activityStatus = status
    }
    
    
    private func reactToStatusChange() {
        
        
        if infoButton == nil {
            configureInfoButton()
        }
        
        if activityStatus == .inProgress {
            
            infoButton!.alpha = 0.3
            infoButton!.isEnabled = false
            
            //We do not need the sub title label. So removing it.
            subtitleLabel?.removeFromSuperview()
            subtitleLabel = nil
            
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
            
            infoButton!.alpha = 1.0
            infoButton!.isEnabled = true
            
            //We need both the title and sub title labels.
            //Remove the activity view.
            activityIndicatorView?.removeFromSuperview()
            activityIndicatorView = nil
            
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
            
            infoButton!.alpha = 0.3
            infoButton!.isEnabled = false
            activityIndicatorView?.removeFromSuperview()
            activityIndicatorView = nil
            
            titleLabel?.removeFromSuperview()
            titleLabel = nil
            
            subtitleLabel?.removeFromSuperview()
            subtitleLabel = nil
        }
    }
    
    
    deinit {
        activityIndicatorView  = nil
        titleLabel = nil
        subtitleLabel = nil
        titleLabelLeadingConstraint = nil
        infoButton = nil
    }
    
}


extension ReminderActivityIndicatorTitleSubtitleView {
    
    
    func configureTitleLabel(usingDetail detail: (text: String, attribute: ReminderLabelTextAttribute)) {
        
        if titleLabel == nil {
            
            titleLabel = UILabel()
            titleLabel!.translatesAutoresizingMaskIntoConstraints = false
            titleLabel!.numberOfLines = 1
            addSubview(titleLabel!)
            titleLabel!.trailingAnchor.constraint(equalTo: infoButton.leadingAnchor, constant: -8.0).isActive = true
            titleLabel!.topAnchor.constraint(equalTo: topAnchor, constant: 16.0).isActive = true
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
        activityIndicatorView!.topAnchor.constraint(equalTo: topAnchor, constant: 16.0).isActive = true
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
        subtitleLabel!.trailingAnchor.constraint(equalTo: infoButton.leadingAnchor, constant: -8.0).isActive = true
        subtitleLabel!.topAnchor.constraint(equalTo: titleLabel!.bottomAnchor, constant: 6.0).isActive = true
        subtitleLabel!.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -9.0).isActive = true
        subtitleLabel!.text = detail.text
    }
    
    
    func configureInfoButton() {
        
        infoButton = UIButton.init(type: .infoDark)
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(infoButton)
        infoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0).isActive = true
        infoButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        infoButton!.addTarget(self, action: #selector(infoButtonTapped(_:)), for: .touchUpInside)

    }
    
    
    @objc func infoButtonTapped(_ sender: UIButton) {
        tapResponderHandler?(activityStatus, .locationInfoTapped)
    }
}
