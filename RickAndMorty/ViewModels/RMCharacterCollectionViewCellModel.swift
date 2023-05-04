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
        //
        //TODO: Abstrair método em algum Image Manager
        //
        guard let url = characterImageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            completion(.success(data))
        }
        
        task.resume()
    }
}
