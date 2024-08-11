//
//  RestApiClient.swift
//  movies
//
//  Created by Александр Крапивин on 21.07.2024.
//

import Foundation

protocol RequestFactory {
    func createRequest() throws -> URLRequest
}

protocol RestApiClientProtocol {
    func performRequest(_ factory: RequestFactory, completion: @escaping (Result<Data, Error>) -> Void)
}

enum NetworkError: Error {
    case unknown
    case invalidMimeType
    case invalidStatusCode
    case client
    case server
    case emptyData
    case invalidURL
}

class RestApiClient: AbstractRestApiClient, RestApiClientProtocol {
    
    override func validate(response: URLResponse?) -> Error? {
        guard let httpResponse = response as? HTTPURLResponse else {
            return NetworkError.unknown
        }
        
        guard httpResponse.mimeType == "application/json" else {
            return NetworkError.invalidMimeType
        }
        
        switch httpResponse.statusCode {
        case 100..<200, 300..<400:
            return NetworkError.invalidStatusCode
        case 400..<500:
            return NetworkError.client
        case 500..<600:
            return NetworkError.server
        default:
            break
        }
        
        return nil
    }
    
    override func handleData(_ data: Data, completion: @escaping (Result<Data, Error>) -> Void) {
        completion(.success(data))
    }
}

