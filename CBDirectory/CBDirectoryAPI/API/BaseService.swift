//
//  BaseService.swift
//  CBDirectory
//
//  Created by Rufus on 28/12/2019.
//  Copyright © 2019 Rufus. All rights reserved.
//

import Foundation

public enum Environment: String {
    case dev = "https://5cc736f4ae1431001472e333.mockapi.io/api/v1"
    case qa
    case prod
    
    public var url: URL {
        return URL(string: self.rawValue)!
    }
}

public class BaseService {
    private let webClient: WebClient
    private let baseURL: URL
    private let decoder = JSONDecoder()
    
    public init(webClient: WebClient = WebClient.shared, baseURL: URL) {
        self.webClient = webClient
        self.baseURL = baseURL
    }
    
    open func get<T: Decodable>(route: String, completion: @escaping (Result<T, Error>)->()) {
        let url = self.baseURL.appendingPathComponent(route)
        
        webClient.get(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedItem = try self.decoder.decode(T.self, from: data)
                    completion(.success(decodedItem))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
