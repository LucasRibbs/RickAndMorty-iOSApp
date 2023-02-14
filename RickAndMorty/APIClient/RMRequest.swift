//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by  on 30/01/23.
//

import Foundation

final class RMRequest {
    
    private let httpMethod = "GET"
    private let baseUrl = "https://rickandmortyapi.com/api"
    
    private let endpoint: RMEndpoint
    private let pathComponents: [String]
    private let queryParameters: [URLQueryItem]
    
    private var urlString: String {
        var urlString = baseUrl
        urlString += "/\(endpoint)"
        
        if !pathComponents.isEmpty {
            urlString += "/"
            urlString += pathComponents.joined(separator: "/")
        }
        
        if !queryParameters.isEmpty {
            urlString += "?"
            urlString += queryParameters.compactMap({
                guard let _ = $0.value else { return nil }
                return "\($0.name)=\($0.value!)"
            }).joined(separator: "&")
        }
        
        return urlString
    }
    
    public var url: URL? {
        return URL(string: urlString)
    }
    
    public var urlRequest: URLRequest? {
        guard let url = url else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod
        
        return urlRequest
    }

    init(endpoint: RMEndpoint, pathComponents: [String] = [], queryParameters: [URLQueryItem] = []) {
        
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
}

extension RMRequest {
    
    static let allCharactersRequest = RMRequest(endpoint: .character)
    static let allLocationsRequest = RMRequest(endpoint: .location)
    static let allEpisodesRequest = RMRequest(endpoint: .episode)
}
