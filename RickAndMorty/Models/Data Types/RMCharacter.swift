//
//  RMCharacter.swift
//  RickAndMorty
//
//  Created by  on 30/01/23.
//

import Foundation

struct RMCharacter: Codable {
    
    let id: Int
    let name: String
    let status: RMCharacterStatus
    let species: String
    let type: String
    let gender: RMCharacterGender
    let origin: RMCharacterLocation
    let location: RMCharacterLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
    var episodeCount: String {
        return "\(episode.count) \(episode.count>1 ? "episodes" : "episode")"
    }
}

enum RMCharacterStatus: String, Codable {
    
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
    
    var string: String {
        switch self {
        case .unknown:
            return "Unknown"
        default:
            return rawValue
        }
    }
}

enum RMCharacterGender: String, Codable {
    
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"
    
    var string: String {
        switch self {
        case .unknown:
            return "Unknown"
        default:
            return rawValue
        }
    }
}

struct RMCharacterLocation: Codable {
    
    let name: String
    let url: String
}
