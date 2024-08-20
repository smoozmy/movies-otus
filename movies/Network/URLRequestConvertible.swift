//
//  URLRequestConvertible.swift
//  movies
//
//  Created by Александр Крапивин on 21.07.2024.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    
}

protocol URLRequestConvertible {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var urlQuery: [String: String] { get }
    var headers: [String: String] { get }
    var body: [String: Any] { get }
    var method: HTTPMethod { get }
}

extension URLRequestConvertible {
    
    var scheme: String {
        return "https"
    }

    var host: String {
        return "kinopoiskapiunofficial.tech"
    }
    
    var headers: [String: String] {
        return ["X-API-KEY": "\(Constants.standart.apiKey)"]
    }
    
    var urlQuery: [String: String] {
        return [:]
    }
    
    var body: [String: Any] {
        return [:]
    }
    
    func asRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = urlQuery.map {URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        if !body.isEmpty {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        
        return request
    }
}
