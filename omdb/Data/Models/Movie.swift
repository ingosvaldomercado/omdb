//
//  Movie.swift
//  omdb
//
//  Created by Osvaldo Mercado on 29/11/24.
//

import Foundation

struct Movie: Codable, Equatable, Identifiable {
    let id = UUID()
    let title: String
    let year: String
    let imdbID: String
    let type: MovieType
    let poster: String?
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
}

enum MovieType: String, Codable {
    case episode
    case game
    case movie
    case series
    case unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = .init(rawValue: rawValue) ?? .unknown
    }
}
