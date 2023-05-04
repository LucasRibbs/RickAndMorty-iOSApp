//
//  RMImageLoader.swift
//  RickAndMorty
//
//  Created by  on 04/05/23.
//

import UIKit

final class RMImageLoader {
    
    public static let shared = RMImageLoader()
    
    private var cache = NSCache<NSString, NSData>()
    
    private init() {}
    
    public func fetchImage(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        
        let key = url.absoluteString as NSString
        if let data = cache.object(forKey: key) {
//            print("Reading image from cache: \(key)")
            completion(.success(data as Data))
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            
            let value = data as NSData
            self?.cache.setObject(value, forKey: key)
            completion(.success(data))
        }
        
        task.resume()
    }
}
