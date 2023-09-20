//
//  RMSettingsOption.swift
//  RickAndMorty
//
//  Created by  on 19/09/23.
//

import UIKit

enum RMSettingsOption: CaseIterable {
    
    case rateApp
    case contactUs
    case terms
    case privacy
    case apiReference
    case viewSeries
    case viewCode
    
    var title: String {
        switch self {
        case .rateApp:
            return "Rate app"
        case .contactUs:
            return "Contact us"
        case .terms:
            return "Terms of service"
        case .privacy:
            return "Privacy policy"
        case .apiReference:
            return "API reference"
        case .viewSeries:
            return "View video series"
        case .viewCode:
            return "View app code"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .rateApp:
            return UIImage(systemName: "star.fill")
        case .contactUs:
            return UIImage(systemName: "paperplane")
        case .terms:
            return UIImage(systemName: "doc")
        case .privacy:
            return UIImage(systemName: "lock")
        case .apiReference:
            return UIImage(systemName: "list.clipboard")
        case .viewSeries:
            return UIImage(systemName: "tv.fill")
        case .viewCode:
            return UIImage(systemName: "hammer.fill")
        }
    }
    
    var iconContainerColor: UIColor {
        switch self {
        case .rateApp:
            return .systemBlue
        case .contactUs:
            return .systemGreen
        case .terms:
            return .systemRed
        case .privacy:
            return .systemYellow
        case .apiReference:
            return .systemPurple
        case .viewSeries:
            return .systemOrange
        case .viewCode:
            return .systemPink
        }
    }
    
    var targetUrl: URL? {
        switch self {
        case .rateApp:
            return nil
        case .contactUs:
            return URL(string: "https://iosacademy.io/")
        case .terms:
            return URL(string: "https://iosacademy.io/terms")
        case .privacy:
            return URL(string: "https://iosacademy.io/privacy")
        case .apiReference:
            return URL(string: "https://rickandmortyapi.com/")
        case .viewSeries:
            return URL(string: "https://www.youtube.com/playlist?list=PL5PR3UyfTWvdl4Ya_2veOB6TM16FXuv4y")
        case .viewCode:
            return URL(string: "https://github.com/LucasRibbs/RickAndMorty-iOSApp")
        }
    }
}
