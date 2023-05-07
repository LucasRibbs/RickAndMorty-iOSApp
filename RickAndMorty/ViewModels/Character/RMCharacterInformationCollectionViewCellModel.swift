//
//  RMCharacterInformationCollectionViewCellModel.swift
//  RickAndMorty
//
//  Created by  on 06/05/23.
//

import Foundation

final class RMCharacterInformationCollectionViewCellModel {
    
    public let title: String
    public let value: String
    
    init(title: String, value: String) {
        self.title = title
        self.value = value
    }
}
