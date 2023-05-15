//
//  RMEndpoint.swift
//  RickAndMorty
//
//  Created by  on 30/01/23.
//

import Foundation

@frozen enum RMEndpoint: String, CaseIterable, Hashable {
    
    case character // "character"
    case location
    case episode
}
