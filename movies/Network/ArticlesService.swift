import UIKit


class ArticlesService {
    
    private let client: RestApiClientProtocol
    
    init(client: RestApiClientProtocol = RestApiClient()) {
        self.client = RestApiClientDecorator(wrappee: client)
    }
    
    func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        let endpoint = ArticlesEndpoint.articles
        client.performRequest(endpoint) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(ArticlesResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(response.items))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    enum ArticlesEndpoint: URLRequestConvertible, RequestFactory {
        case articles
        
        var path: String {
            switch self {
            case .articles:
                return "/api/v1/media_posts"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .articles:
                return .get
            }
        }
        
        var urlQuery: [String: String] {
            switch self {
            case .articles:
                return ["page": "43"]
            }
        }
        
        func createRequest() throws -> URLRequest {
            return try asRequest()
        }
    }
}
