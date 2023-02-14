//
//  RMService.swift
//  RickAndMorty
//
//  Created by  on 30/01/23.
//

import Foundation

final class RMService {
    
    enum RMServiceError: Error {
        
        case failedToCreateRequest
        case failedToGetData
    }
    
    static let shared = RMService()
    
    private init() {}
    
    public func execute<T: Codable>(_ request: RMRequest, expecting type: T.Type, completion: @escaping (Result<T,Error>) -> Void) {
        
        guard let urlRequest = request.urlRequest else {
            completion(.failure(RMServiceError.failedToCreateRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? RMServiceError.failedToGetData))
                return
            }
            
            do {
                let json = try JSONDecoder().decode(type, from: data)
                completion(.success(json))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
