//
//  RMCharacterViewModel.swift
//  RickAndMorty
//
//  Created by  on 02/05/23.
//

import Foundation

final class RMCharacterViewModel {
    
    private let character: RMCharacter
    
    init(character: RMCharacter) {
        self.character = character
    }
    
    public var title: String {
        return character.name.uppercased()
    }
}
