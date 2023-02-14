//
//  RMAllCharactersResponse.swift
//  RickAndMorty
//
//  Created by  on 31/01/23.
//

import Foundation

struct RMAllCharactersResponse: Codable {
    
    struct Info: Codable {
        
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [RMCharacter]
}
