//
//  RMDateFormatter.swift
//  RickAndMorty
//
//  Created by  on 10/08/23.
//

import UIKit

struct RMDateFormatter {
    
    static let dateFormatter: DateFormatter = {
        //4 Nov 2017 18:48
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d yyyy HH:mm"
        formatter.timeZone = .current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    static let isoDateFormatter: ISO8601DateFormatter = {
        //2017-11-04T18:48:46.250Z
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        formatter.timeZone = .current
        return formatter
    }()
}
