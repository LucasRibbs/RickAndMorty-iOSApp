//
//  RMService.swift
//  RickAndMorty
//
//  Created by  on 30/01/23.
//

import Foundation

final class RMService {
    
    static let shared = RMService()
    
    enum RMServiceError: Error {
        
        case failedToCreateRequest
        case failedToGetData
    }
        
    private let cacheManager = RMAPICacheManager()
    
    private init() {}
    
    public func execute<T: Codable>(_ request: RMRequest, expecting type: T.Type, completion: @escaping (Result<T,Error>) -> Void) {
        
        if let cachedData = cacheManager.cachedResponse(for: request.endpoint, url: request.url) {
            do {
                let json = try JSONDecoder().decode(type, from: cachedData)
                print("Data recovered from cache!")
                completion(.success(json))
            } catch {
                completion(.failure(error))
            }
            return
        }
        
        guard let urlRequest = request.urlRequest else {
            completion(.failure(RMServiceError.failedToCreateRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? RMServiceError.failedToGetData))
                return
            }
            
            do {
                let json = try JSONDecoder().decode(type, from: data)
                self?.cacheManager.setCache(for: request.endpoint, url: request.url, data: data)
                completion(.success(json))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
