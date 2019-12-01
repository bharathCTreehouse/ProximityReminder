//
//  ReminderDateFormatConfigurer.swift
//  ProximityReminder
//
//  Created by Bharath on 30/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation


class ReminderDateFormatConfigurer {
    
    static func dateFormatter(withDateStyle dStyle: DateFormatter.Style, timeStyle tStyle: DateFormatter.Style, locale: Locale = .current, timeZone: TimeZone = .current) -> DateFormatter {
        
        let df: DateFormatter = DateFormatter()
        df.dateStyle = dStyle
        df.timeStyle = tStyle
        df.locale = locale
        df.timeZone = timeZone
        
        return df
    }
    
}
