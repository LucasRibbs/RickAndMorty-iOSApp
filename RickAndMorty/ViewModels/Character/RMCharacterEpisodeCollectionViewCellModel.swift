//
//  RMCharacterEpisodeCollectionViewCellModel.swift
//  RickAndMorty
//
//  Created by  on 06/05/23.
//

import Foundation

protocol RMEpisodeRender {
    
    var name: String { get }
    var air_date: String { get }
    var episode: String { get }
}

final class RMCharacterEpisodeCollectionViewCellModel {
    
    private let episodeUrl: String
    
    public var cachedEpisode: RMEpisodeRender? = nil
    private var isFetching: Bool = false
    
    init(episodeUrl: String) {
        self.episodeUrl = episodeUrl
    }
    
    public func fetchEpisode(completion: @escaping (RMEpisodeRender) -> Void) {
        guard !isFetching else { return }
        
        if let episode = cachedEpisode {
//            print("Episode loaded from cache")
            completion(episode)
            return
        }
        
        guard let url = URL(string: episodeUrl), let request = RMRequest(url: url) else { return }
        
        isFetching = true
        
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let episode):
                self?.cachedEpisode = episode
                DispatchQueue.main.async {
                    completion(episode)
                    self?.isFetching = false
                }
                break
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
    }
}
