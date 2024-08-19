import Foundation

struct Premiere: Codable {
    let kinopoiskId: Int
    let nameRu: String
    let nameEn: String?
    let year: Int
    let posterUrl: URL
    let countries: [Country]
    let genres: [Genre]
    let duration: Int?
    let premiereRu: String?

    struct Country: Codable {
        let country: String
    }

    struct Genre: Codable {
        let genre: String
    }
}

struct PremieresResponse: Codable {
    let items: [Premiere]
}
