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
    
    override func performRequest(_ factory: RequestFactory, completion: @escaping (Result<Data, Error>) -> Void) {
        do {
            let request = try factory.createRequest()
            
            // Логируем запрос
            print("URL: \(request.url?.absoluteString ?? "No URL")")
            print("Method: \(request.httpMethod ?? "No Method")")
            print("Headers: \(request.allHTTPHeaderFields ?? [:])")
            
            let task = urlSession.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let error = self.validate(response: response) {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NetworkError.emptyData))
                    return
                }
                
                // Логируем ответ
                if let httpResponse = response as? HTTPURLResponse {
                    print("Response code: \(httpResponse.statusCode)")
                }
                if let responseData = String(data: data, encoding: .utf8) {
                    print("Response data: \(responseData)")
                }
                
                self.handleData(data, completion: completion)
            }
            task.resume()
        } catch {
            completion(.failure(error))
        }
    }
}

