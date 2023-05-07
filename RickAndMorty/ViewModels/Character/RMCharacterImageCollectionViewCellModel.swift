//
//  RMCharacterImageCollectionViewCellModel.swift
//  RickAndMorty
//
//  Created by  on 06/05/23.
//

import UIKit

final class RMCharacterImageCollectionViewCellModel {
    
    private let imageUrl: String
    
    init(imageUrl: String) {
        self.imageUrl = imageUrl
    }
    
    public func fetchCharacterImage(completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: imageUrl) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        RMImageLoader.shared.fetchImage(url, completion: completion)
    }
}
