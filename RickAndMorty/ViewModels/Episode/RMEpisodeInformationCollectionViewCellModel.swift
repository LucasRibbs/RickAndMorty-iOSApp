//
//  RMEpisodeInformationCollectionViewCellModel.swift
//  RickAndMorty
//
//  Created by  on 10/08/23.
//

import UIKit

final class RMEpisodeInformationCollectionViewCellModel {
    
    private let infoType: InfoType
    private let value: String
    
    enum InfoType: String {
        case name
        case airDate
        case episode
        case created
        
        var title: String {
            switch self {
            case .name:
                return "EPISODE TITLE"
            case .airDate:
                return "AIR DATE"
            default:
                return rawValue.uppercased()
            }
        }
        
        var tintColor: UIColor {
            switch self {
            case .name:
                return .systemBlue
            case .airDate:
                return .systemGreen
            case .episode:
                return .systemRed
            case .created:
                return .systemYellow
            }
        }
    }
    
    init(infoType: InfoType, value: String) {
        self.infoType = infoType
        self.value = value
    }
    
    public var infoTitle: String {
        
        return infoType.title
    }
    
    public var infoValue: String? {
        
        if value.isEmpty {
            return nil
        }
        if let date = RMDateFormatter.isoDateFormatter.date(from: value), infoType == .created {
            return RMDateFormatter.dateFormatter.string(from: date)
        }
        return value
    }
    
    public var infoTintColor: UIColor {
        
        return infoType.tintColor
    }
}
