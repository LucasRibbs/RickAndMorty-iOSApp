//
//  RMEpisodeViewModel.swift
//  RickAndMorty
//
//  Created by  on 10/05/23.
//

import Foundation

final class RMEpisodeViewModel {
    
    private let episode: RMEpisode
    
    init(episode: RMEpisode) {
        self.episode = episode
    }
    
    public var title: String {
        return episode.name.uppercased()
    }
}
