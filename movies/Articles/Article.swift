//
//  News.swift
//  movies
//
//  Created by Александр Крапивин on 21.07.2024.
//

import Foundation

struct Article: Codable {
    let title: String
    let description: String
    let imageUrl: URL
    let url: URL

    enum CodingKeys: String, CodingKey {
        case title
        case description
        case imageUrl = "imageUrl"
        case url
    }
}

struct ArticlesResponse: Codable {
    let items: [Article]
}
