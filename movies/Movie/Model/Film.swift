//
//  Movie.swift
//  movies
//
//  Created by Александр Крапивин on 21.07.2024.
//

import UIKit

struct Film: Codable {
    let kinopoiskId: Int
    let nameRu: String?
    let nameEn: String?
    let nameOriginal: String?
    let posterUrl: String
    let shortDescription: String?
    let description: String?
    let ratingKinopoisk: Double?
    let year: Int?
    let genres: [Genre]?
    let countries: [Country]?
}

struct Genre: Codable {
    let genre: String
}

struct Country: Codable {
    let country: String
}


struct Actor: Codable {
    let staffId: Int
    let nameRu: String?
    let nameEn: String?
    let posterUrl: String?
    let professionText: String
    let professionKey: String
}
