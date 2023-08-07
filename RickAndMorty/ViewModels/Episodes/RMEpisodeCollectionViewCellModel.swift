//
//  RMEpisodeCollectionViewCellModel.swift
//  RickAndMorty
//
//  Created by  on 19/05/23.
//

import Foundation

final class RMEpisodeCollectionViewCellModel {
    
    private let episodeCode: String
    public let episodeName: String
    public let episodeAirDate: String
    
    init(episodeCode: String, episodeName: String, episodeAirDate: String) {
        
        self.episodeCode = episodeCode
        self.episodeName = episodeName
        self.episodeAirDate = episodeAirDate
    }
    
    public var episodeCodeText: String {
        
        return "Episode: \(episodeCode)"
    }
}
