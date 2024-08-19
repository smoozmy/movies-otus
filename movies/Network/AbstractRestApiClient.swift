//
//  AbstractRestApiClient.swift
//  movies
//
//  Created by Александр Крапивин on 27.07.2024.
//

import UIKit

class AbstractRestApiClient {
    let urlSession = URLSession.shared
    
    func performRequest(_ factory: RequestFactory, completion: @escaping (Result<Data, Error>) -> Void) {
        do {
            let request = try factory.createRequest()
            urlSession.dataTask(with: request) { [weak self] data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let error = self?.validate(response: response) {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NetworkError.emptyData))
                    return
                }
                
                self?.handleData(data, completion: completion)
                
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
    
    func validate(response: URLResponse?) -> Error? {
        return nil
    }
    
    func handleData(_ data: Data, completion: @escaping (Result<Data, Error>) -> Void) {
        completion(.success(data))
    }
    
}

