import UIKit


struct PremieresEndpoint: URLRequestConvertible, RequestFactory {
    let year: String
    let month: String
    
    var path: String {
        return "/api/v2.2/films/premieres"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var urlQuery: [String: String] {
        return [
            "year": year,
            "month": month
        ]
    }
    
    func createRequest() throws -> URLRequest {
        return try asRequest()
    }
}

class PremieresService {
    
    private let client: RestApiClientProtocol
    
    init(client: RestApiClientProtocol = RestApiClient()) {
        self.client = RestApiClientDecorator(wrappee: client)
    }
    
    func fetchPremieres(completion: @escaping (Result<[Premiere], Error>) -> Void) {
        let endpoint = PremieresEndpoint(year: "2024", month: "AUGUST")
        client.performRequest(endpoint) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(PremieresResponse.self, from: data)
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
}
