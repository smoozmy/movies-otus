import Foundation

struct User: Codable {
    var name: String
    var login: String
    var password: String
    var favoriteMovies: [Int] = []
    
    init(name: String, login: String, password: String) {
        self.name = name
        self.login = login
        self.password = password
        self.favoriteMovies = []
    }
}
