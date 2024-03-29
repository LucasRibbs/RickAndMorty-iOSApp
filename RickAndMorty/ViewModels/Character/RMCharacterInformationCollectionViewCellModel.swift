//
//  RMCharacterInformationCollectionViewCellModel.swift
//  RickAndMorty
//
//  Created by  on 06/05/23.
//

import UIKit

final class RMCharacterInformationCollectionViewCellModel {
    
    private let infoType: InfoType
    private let value: String
    
    enum InfoType: String {
        case status
        case gender
        case species
        case type
        case origin
        case location
        case created
        case totalEpisodes
        
        var title: String {
            switch self {
            case .totalEpisodes:
                return "TOTAL EPISODES"
            default:
                return rawValue.uppercased()
            }
        }
        
        var icon: UIImage? {
            switch self {
            case .status:
                return UIImage(systemName: "bell")
            case .gender:
                return UIImage(systemName: "bell")
            case .species:
                return UIImage(systemName: "bell")
            case .type:
                return UIImage(systemName: "bell")
            case .origin:
                return UIImage(systemName: "bell")
            case .location:
                return UIImage(systemName: "bell")
            case .created:
                return UIImage(systemName: "bell")
            case .totalEpisodes:
                return UIImage(systemName: "bell")
            }
        }
        
        var tintColor: UIColor {
            switch self {
            case .status:
                return .systemBlue
            case .gender:
                return .systemRed
            case .species:
                return .systemPurple
            case .type:
                return .systemGreen
            case .origin:
                return .systemOrange
            case .location:
                return .systemPink
            case .created:
                return .systemYellow
            case .totalEpisodes:
                return .systemIndigo
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
    
    public var infoIcon: UIImage? {
        
        return infoType.icon
    }
    
    public var infoTintColor: UIColor {
        
        return infoType.tintColor
    }
}
