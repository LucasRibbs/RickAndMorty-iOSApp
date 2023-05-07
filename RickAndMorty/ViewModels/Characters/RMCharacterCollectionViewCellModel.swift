//
//  RMCharacterCollectionViewCellModel.swift
//  RickAndMorty
//
//  Created by  on 01/02/23.
//

import Foundation

final class RMCharacterCollectionViewCellModel {

    private let characterImageUrl: URL?
    public let characterName: String
    public let characterStatus: RMCharacterStatus
    
    init(characterName: String, characterStatus: RMCharacterStatus, characterImageUrl: URL?) {
        
        self.characterImageUrl = characterImageUrl
        self.characterName = characterName
        self.characterStatus = characterStatus
    }
    
    public var characterStatusText: String {
        
        return "Status: \(characterStatus.string)"
    }
    
    public func fetchCharacterImage(completion: @escaping (Result<Data,Error>) -> Void) {

        guard let url = characterImageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        RMImageLoader.shared.fetchImage(url, completion: completion)
    }
}
