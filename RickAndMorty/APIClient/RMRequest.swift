//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by  on 30/01/23.
//

import Foundation

final class RMRequest {
    
    private static let httpMethod = "GET"
    private static let baseUrl = URL(string: "https://rickandmortyapi.com/api/")!
    
    public let endpoint: RMEndpoint
    private let pathComponents: [String]
    private let queryParameters: [URLQueryItem]
    
    private var urlString: String {
        var urlString = ""
        urlString += "\(endpoint)"
        
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
        return URL(string: urlString, relativeTo: RMRequest.baseUrl)
    }
    
    public var urlRequest: URLRequest? {
        guard let url = url else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = RMRequest.httpMethod
        
        return urlRequest
    }

    init(endpoint: RMEndpoint, pathComponents: [String] = [], queryParameters: [URLQueryItem] = []) {
        
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
    convenience init?(url: URL?) {
        guard var urlString = url?.absoluteString else { return nil }
        guard urlString.starts(with: RMRequest.baseUrl.absoluteString) else { return nil }
        
        urlString = String(urlString.dropFirst(RMRequest.baseUrl.absoluteString.count))
        let url = URL(string: urlString, relativeTo: RMRequest.baseUrl)!
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        let path = urlComponents.path.components(separatedBy: "/").map({ String($0) })
        
        let endpoint = RMEndpoint(rawValue: path[0])!
//        let pathComponents = (path.count > 1) ? [String](path[1...]) : []
        let pathComponents = [String](path[1...])
        let queryParameters: [URLQueryItem] = urlComponents.queryItems ?? []
        
        self.init(endpoint: endpoint, pathComponents: pathComponents, queryParameters: queryParameters)
    }
}

extension RMRequest {
    
    static let allCharactersRequest = RMRequest(endpoint: .character)
    static let allLocationsRequest = RMRequest(endpoint: .location)
    static let allEpisodesRequest = RMRequest(endpoint: .episode)
}
