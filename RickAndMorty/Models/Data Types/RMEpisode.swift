//
//  RMEpisode.swift
//  RickAndMorty
//
//  Created by  on 30/01/23.
//

import Foundation

struct RMEpisode: Codable, RMEpisodeRender {
    
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}
