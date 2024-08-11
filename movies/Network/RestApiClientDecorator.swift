//
//  RestApiClientDecorator.swift
//  movies
//
//  Created by Александр Крапивин on 27.07.2024.
//

import UIKit

class RestApiClientDecorator: RestApiClientProtocol {
    private let wrappee: RestApiClientProtocol
    
    init(wrappee: RestApiClientProtocol) {
        self.wrappee = wrappee
    }
    
    func performRequest(_ factory: RequestFactory, completion: @escaping (Result<Data, Error>) -> Void) {
        print("Request: \(try? factory.createRequest().url?.absoluteString ?? "Invalid URL")")
        wrappee.performRequest(factory, completion: completion)
    }
}
